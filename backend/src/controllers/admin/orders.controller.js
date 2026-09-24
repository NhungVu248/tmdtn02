import { prisma } from '../../lib/prisma.js'
import { logAdminAction } from '../../lib/auditLog.js'
import { nightsBetween } from '../../lib/booking.js'
import { sendOrderStatusEmail, sendRefundProcessedEmail } from '../../lib/mailer.js'

// BR-85: vòng đời đơn — mọi chuyển trạng thái không có trong danh sách đều bị từ chối.
const TRANSITIONS = {
  PENDING_DEPOSIT: ['DEPOSITED', 'CANCELLED'],
  DEPOSITED: ['CONFIRMED', 'COMPLETED', 'CANCELLED'],
  CONFIRMED: ['COMPLETED', 'CANCELLED'],
  COMPLETED: [],
  CANCELLED: [],
}

function summary(b) {
  return {
    code: b.code,
    type: b.type,
    status: b.status,
    productName: b.tour?.title ?? b.property?.name ?? "",
    productSlug: b.tour?.slug ?? b.property?.slug ?? "",
    guestName: b.guestName,
    guestEmail: b.guestEmail,
    guestPhone: b.guestPhone,
    checkIn: b.checkIn,
    checkOut: b.checkOut,
    guests: b.guests,
    children: b.children,
    totalPrice: b.totalPrice,
    depositAmount: b.depositAmount,
    remainingAmount: b.remainingAmount,
    paymentMethod: b.paymentMethod,
    createdAt: b.createdAt,
  }
}

// UC-18 – Danh sách đơn (mọi trạng thái) kèm bộ lọc theo trạng thái/loại/thời gian/tìm kiếm.
export async function listOrders(req, res, next) {
  try {
    const { status, type, from, to, search } = req.query
    const where = {}
    if (status) where.status = String(status)
    if (type === 'HOMESTAY' || type === 'TOUR') where.type = type
    if (from || to) {
      where.createdAt = {}
      if (from) where.createdAt.gte = new Date(String(from))
      if (to) where.createdAt.lte = new Date(new Date(String(to)).getTime() + 86400000)
    }
    if (search) {
      const s = String(search).trim()
      where.OR = [
        { code: { contains: s } },
        { guestEmail: { contains: s } },
        { guestName: { contains: s } },
      ]
    }

    const bookings = await prisma.booking.findMany({
      where,
      include: { property: { select: { name: true, slug: true } }, tour: { select: { title: true, slug: true } } },
      orderBy: { createdAt: 'desc' },
      take: 300,
    })
    res.json({ items: bookings.map(summary) })
  } catch (err) {
    next(err)
  }
}

// UC-18 – Chi tiết đơn: sản phẩm, khách, lịch sử thanh toán, yêu cầu hoàn tiền.
export async function getOrder(req, res, next) {
  try {
    const code = String(req.params.code || '').trim().toUpperCase()
    const booking = await prisma.booking.findUnique({
      where: { code },
      include: {
        property: { select: { name: true, slug: true } },
        tour: { select: { title: true, slug: true } },
        payments: { orderBy: { createdAt: 'desc' } },
        refundRequests: { orderBy: { createdAt: 'desc' } },
      },
    })
    if (!booking) return res.status(404).json({ message: 'Không tìm thấy đơn' })

    res.json({
      order: {
        ...summary(booking),
        nights: booking.nights,
        note: booking.note,
        discountCode: booking.discountCode,
        discountAmount: booking.discountAmount,
        transactionId: booking.transactionId,
        depositPaidAt: booking.depositPaidAt,
        cancelledAt: booking.cancelledAt,
        allowedTransitions: TRANSITIONS[booking.status] || [],
      },
      payments: booking.payments,
      refundRequests: booking.refundRequests,
    })
  } catch (err) {
    next(err)
  }
}

// Giải phóng tồn kho/số chỗ khi admin chuyển đơn sang "đã hủy" trực tiếp (không qua UC-14).
async function releaseInventoryOps(booking) {
  const ops = []
  if (booking.type === 'HOMESTAY' && booking.checkIn && booking.checkOut) {
    const nights = nightsBetween(booking.checkIn.toISOString(), booking.checkOut.toISOString())
    if (nights?.length && booking.roomTypeId) {
      ops.push(
        prisma.roomInventory.updateMany({
          where: { roomTypeId: booking.roomTypeId, date: { in: nights }, bookedRooms: { gt: 0 } },
          data: { bookedRooms: { decrement: 1 } },
        }),
      )
    }
  } else if (booking.type === 'TOUR') {
    const departure = booking.tourDepartureId
      ? await prisma.tourDeparture.findUnique({ where: { id: booking.tourDepartureId } })
      : null
    if (departure) {
      const seats = (booking.guests || 0) + (booking.children || 0)
      ops.push(
        prisma.tourDeparture.update({
          where: { id: departure.id },
          data: { bookedSlots: { decrement: Math.min(seats, departure.bookedSlots) } },
        }),
      )
    }
  }
  return ops
}

// UC-18 (3/3a) – Chuyển trạng thái đơn theo đúng vòng đời (BR-85).
// Ngoại lệ 3a: chuyển trạng thái không hợp lệ (vd "đã hủy" -> "hoàn tất") -> từ chối.
export async function updateOrderStatus(req, res, next) {
  try {
    const code = String(req.params.code || '').trim().toUpperCase()
    const { status } = req.body
    const booking = await prisma.booking.findUnique({ where: { code }, include: { property: true, tour: true } })
    if (!booking) return res.status(404).json({ message: 'Không tìm thấy đơn' })

    const allowed = TRANSITIONS[booking.status] || []
    if (!allowed.includes(status)) {
      return res.status(409).json({
        message: `Không thể chuyển đơn từ "${booking.status}" sang "${status}" (trái vòng đời đơn — BR-85)`,
      }) // 3a
    }

    const ops = []
    if (status === 'CANCELLED') {
      ops.push(...(await releaseInventoryOps(booking)))
    }
    const bookingUpdateIndex = ops.length
    ops.push(
      prisma.booking.update({
        where: { id: booking.id },
        data: { status, ...(status === 'CANCELLED' ? { cancelledAt: new Date() } : {}) },
      }),
    )

    const results = await prisma.$transaction(ops)
    const updated = results[bookingUpdateIndex]

    await logAdminAction(req.admin.sub, 'order.status', {
      entityType: 'Booking',
      entityId: booking.id,
      detail: { from: booking.status, to: status },
    })

    // BR-90: thông báo cho người dùng khi trạng thái đơn thay đổi (gửi nền, không chặn response).
    sendOrderStatusEmail(booking.guestEmail, { code: booking.code, productName: booking.tour?.title ?? booking.property?.name ?? "", status }).catch(
      (e) => console.error('Gửi email cập nhật đơn thất bại:', e),
    )

    res.json({ order: { ...summary({ ...booking, ...updated, property: booking.property, tour: booking.tour }), allowedTransitions: TRANSITIONS[updated.status] || [] } })
  } catch (err) {
    next(err)
  }
}

// UC-18 (4/4a) – Xác nhận thực hiện hoàn tiền cho một yêu cầu đang chờ (từ UC-14).
// BR-86: không tính lại mức hoàn, chỉ đối chiếu & xác nhận. BR-87: chỉ sandbox/ghi nhận thủ công.
export async function processRefund(req, res, next) {
  try {
    const code = String(req.params.code || '').trim().toUpperCase()
    const refundId = Number(req.params.refundId)
    const { amount, referenceCode } = req.body || {}

    const booking = await prisma.booking.findUnique({ where: { code }, include: { property: true, tour: true } })
    if (!booking) return res.status(404).json({ message: 'Không tìm thấy đơn' })

    const refund = await prisma.refundRequest.findFirst({ where: { id: refundId, bookingId: booking.id } })
    if (!refund) return res.status(404).json({ message: 'Không tìm thấy yêu cầu hoàn tiền' })
    if (refund.status !== 'PENDING') {
      return res.status(409).json({ message: 'Yêu cầu hoàn tiền này đã được xử lý trước đó' })
    }

    // 4a: số tiền đối soát không khớp mức đã ghi nhận -> tạm dừng, yêu cầu đối soát.
    if (amount !== undefined && amount !== null && Number(amount) !== refund.amount) {
      return res.status(409).json({
        message: `Số tiền hoàn (${Number(amount).toLocaleString('vi-VN')}đ) không khớp mức đã ghi nhận (${refund.amount.toLocaleString('vi-VN')}đ). Vui lòng đối soát trước khi xác nhận.`,
      })
    }

    const updated = await prisma.refundRequest.update({
      where: { id: refund.id },
      data: { status: 'PROCESSED' },
    })

    await logAdminAction(req.admin.sub, 'order.refund.process', {
      entityType: 'RefundRequest',
      entityId: refund.id,
      detail: { bookingCode: booking.code, amount: refund.amount, referenceCode: referenceCode || null },
    })

    sendRefundProcessedEmail(booking.guestEmail, {
      code: booking.code,
      productName: booking.tour?.title ?? booking.property?.name ?? '',
      amount: refund.amount,
      referenceCode: referenceCode || null,
    }).catch((e) => console.error('Gửi email hoàn tiền thất bại:', e))

    res.json({ refund: updated })
  } catch (err) {
    next(err)
  }
}
