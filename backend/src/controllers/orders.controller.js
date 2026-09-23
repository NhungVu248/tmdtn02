import { prisma } from '../lib/prisma.js'
import { hashPin, maybeCompleteBooking, nightsBetween } from '../lib/booking.js'
import { computeRefund } from '../lib/cancellation.js'
import { sendCancellationEmail } from '../lib/mailer.js'

// UC-15 – Áp dụng chuyển trạng thái "hoàn tất" lười (nếu đủ điều kiện) trước khi hiển thị,
// giữ lại `product` đã include vì prisma.update() không trả kèm quan hệ.
async function withCompletion(booking) {
  const updated = await maybeCompleteBooking(booking)
  return { ...booking, ...updated, product: booking.product }
}

const MAX_LOOKUP_ATTEMPTS = 5 // BR-51
const LOOKUP_LOCK_MINUTES = 15

// BR-52: thao tác khả dụng theo đúng trạng thái đơn hiện tại.
function availableActions(status) {
  return {
    canCancel: status === 'PENDING_DEPOSIT' || status === 'DEPOSITED' || status === 'CONFIRMED',
    canReview: status === 'COMPLETED',
  }
}

function orderSummary(b) {
  return {
    code: b.code,
    type: b.type,
    status: b.status,
    productName: b.product.name,
    productSlug: b.product.slug,
    thumbnail: b.product.thumbnail,
    checkIn: b.checkIn,
    checkOut: b.checkOut,
    nights: b.nights,
    guests: b.guests,
    children: b.children,
    totalPrice: b.totalPrice,
    depositAmount: b.depositAmount,
    remainingAmount: b.remainingAmount,
    createdAt: b.createdAt,
  }
}

async function orderDetail(b) {
  return {
    ...orderSummary(b),
    guestName: b.guestName,
    guestEmail: b.guestEmail,
    guestPhone: b.guestPhone,
    discountCode: b.discountCode,
    discountAmount: b.discountAmount,
    paymentMethod: b.paymentMethod,
    depositPaidAt: b.depositPaidAt,
    cancelledAt: b.cancelledAt,
    cancellationPolicy: b.product.cancellationPolicy,
    actions: availableActions(b.status),
    // UC-14 – mức hoàn tiền dự kiến nếu hủy ngay bây giờ (chỉ để hiển thị, chưa thực hiện).
    cancelPreview: await computeRefund(b),
  }
}

// UC-13 – Customer: danh sách đơn của tài khoản (BR-49: chỉ đơn của chính mình).
export async function listMyOrders(req, res, next) {
  try {
    const bookings = await prisma.booking.findMany({
      where: { userId: req.user.sub },
      include: { product: { select: { name: true, slug: true, thumbnail: true, cancellationPolicy: true } } },
      orderBy: { createdAt: 'desc' },
    })
    const updated = await Promise.all(bookings.map(withCompletion))
    res.json({ orders: updated.map(orderSummary) })
  } catch (err) {
    next(err)
  }
}

// UC-13 – Customer: chi tiết một đơn của chính mình (BR-49/2a-1: chống IDOR).
export async function getMyOrder(req, res, next) {
  try {
    const booking = await prisma.booking.findUnique({
      where: { code: req.params.code },
      include: { product: true },
    })
    if (!booking || booking.userId !== req.user.sub) {
      // Không tiết lộ đơn có tồn tại hay không — cùng thông báo cho cả 2 trường hợp.
      return res.status(404).json({ message: 'Không tìm thấy đơn' })
    }
    res.json({ order: await orderDetail(await withCompletion(booking)) })
  } catch (err) {
    next(err)
  }
}

// UC-13 – Guest: tra cứu bằng mã đơn + PIN (hoặc email). BR-50/51/3a/3b.
export async function lookupOrder(req, res, next) {
  try {
    const { code, pin, email } = req.body
    const trimmedCode = String(code || '').trim().toUpperCase()

    if (!trimmedCode || (!pin && !email)) {
      return res.status(400).json({ message: 'Vui lòng nhập mã đơn và PIN hoặc email' }) // BR-50
    }

    const generic = { message: 'Mã đơn hoặc thông tin xác thực không đúng' } // BR-51: không tiết lộ tồn tại

    const booking = await prisma.booking.findUnique({
      where: { code: trimmedCode },
      include: { product: true },
    })

    const logAttempt = (success) =>
      prisma.lookupAttempt.create({ data: { code: trimmedCode, ip: req.ip, success } }).catch(() => {})

    if (!booking) {
      await logAttempt(false)
      return res.status(404).json(generic)
    }

    // BR-51/3b: đơn đang bị tạm khóa tra cứu do sai quá nhiều lần.
    if (booking.lookupLockedUntil && booking.lookupLockedUntil > new Date()) {
      await logAttempt(false)
      const mins = Math.ceil((booking.lookupLockedUntil - new Date()) / 60000)
      return res.status(423).json({ message: `Tra cứu tạm khóa do sai quá nhiều lần. Thử lại sau ${mins} phút.` })
    }

    const pinOk = pin && booking.pinHash && hashPin(String(pin)) === booking.pinHash
    const emailOk = email && booking.guestEmail.toLowerCase() === String(email).trim().toLowerCase()

    if (!pinOk && !emailOk) {
      await registerGuestFailure(booking)
      await logAttempt(false)
      const fresh = await prisma.booking.findUnique({ where: { id: booking.id } })
      if (fresh.lookupLockedUntil) {
        return res.status(423).json({
          message: `Sai quá ${MAX_LOOKUP_ATTEMPTS} lần. Tra cứu đơn này tạm khóa ${LOOKUP_LOCK_MINUTES} phút.`,
        })
      }
      return res.status(404).json(generic) // 3a
    }

    // Thành công: reset bộ đếm.
    await prisma.booking.update({ where: { id: booking.id }, data: { lookupFailCount: 0, lookupLockedUntil: null } })
    await logAttempt(true)

    res.json({ order: await orderDetail(await withCompletion(booking)) })
  } catch (err) {
    next(err)
  }
}

// Tăng bộ đếm sai của một đơn, khóa tạm nếu vượt ngưỡng (dùng chung cho tra cứu + hủy đơn Guest).
async function registerGuestFailure(booking) {
  const attempts = booking.lookupFailCount + 1
  const data = { lookupFailCount: attempts }
  if (attempts >= MAX_LOOKUP_ATTEMPTS) {
    data.lookupLockedUntil = new Date(Date.now() + LOOKUP_LOCK_MINUTES * 60000)
    data.lookupFailCount = 0
  }
  await prisma.booking.update({ where: { id: booking.id }, data })
}

// UC-14 – Hủy đơn & nhận hoàn tiền.
// Customer: xác thực qua đăng nhập (BR-49). Guest: bắt buộc mã đơn + PIN/email như UC-13 (BR-58).
export async function cancelOrder(req, res, next) {
  try {
    const code = String(req.params.code || '').trim().toUpperCase()
    const { pin, email } = req.body || {}

    const booking = await prisma.booking.findUnique({ where: { code }, include: { product: true } })
    if (!booking) {
      return res.status(404).json({ message: 'Không tìm thấy đơn' })
    }

    // BR-58: nếu có PIN/email kèm theo, xác thực theo lối Guest (như UC-13) — ưu tiên trước session
    // đăng nhập, vì trang tra cứu Guest có thể được dùng bất kể người dùng có đang đăng nhập hay không.
    // Chỉ khi KHÔNG có PIN/email mới xét theo tài khoản đã đăng nhập (BR-49, chống IDOR).
    if (pin || email) {
      if (booking.lookupLockedUntil && booking.lookupLockedUntil > new Date()) {
        const mins = Math.ceil((booking.lookupLockedUntil - new Date()) / 60000)
        return res.status(423).json({ message: `Thao tác tạm khóa do sai quá nhiều lần. Thử lại sau ${mins} phút.` })
      }
      const pinOk = pin && booking.pinHash && hashPin(String(pin)) === booking.pinHash
      const emailOk = email && booking.guestEmail.toLowerCase() === String(email).trim().toLowerCase()
      if (!pinOk && !emailOk) {
        await registerGuestFailure(booking)
        return res.status(404).json({ message: 'Mã đơn hoặc thông tin xác thực không đúng' })
      }
      await prisma.booking.update({ where: { id: booking.id }, data: { lookupFailCount: 0, lookupLockedUntil: null } })
    } else if (req.user) {
      // Customer: chống IDOR — không tiết lộ đơn tồn tại nếu không phải chủ.
      if (booking.userId !== req.user.sub) {
        return res.status(404).json({ message: 'Không tìm thấy đơn' })
      }
    } else {
      return res.status(400).json({ message: 'Vui lòng đăng nhập hoặc nhập mã đơn kèm PIN/email' }) // BR-50
    }

    // BR-54/2a: kiểm tra đơn đủ điều kiện hủy.
    const refund = await computeRefund(booking)
    if (!refund.eligible) {
      return res.status(409).json({ message: refund.reason })
    }

    // BR-57: giải phóng chỗ/số phòng trong cùng transaction với cập nhật trạng thái (6a: rollback nếu lỗi).
    const ops = []
    if (booking.type === 'HOMESTAY' && booking.checkIn && booking.checkOut) {
      const nights = nightsBetween(booking.checkIn.toISOString(), booking.checkOut.toISOString())
      if (nights?.length) {
        ops.push(
          prisma.homestayAvailability.updateMany({
            where: { productId: booking.productId, date: { in: nights }, bookedRooms: { gt: 0 } },
            data: { bookedRooms: { decrement: 1 } },
          }),
        )
      }
    } else if (booking.type === 'TOUR' && booking.checkIn) {
      const nextDay = new Date(booking.checkIn.getTime() + 86400000)
      const departure = await prisma.tourDeparture.findFirst({
        where: { productId: booking.productId, date: { gte: booking.checkIn, lt: nextDay } },
      })
      if (departure) {
        const seats = (booking.guests || 0) + (booking.children || 0)
        ops.push(
          prisma.tourDeparture.update({
            where: { id: departure.id },
            data: { bookedSeats: { decrement: Math.min(seats, departure.bookedSeats) } },
          }),
        )
      }
    }

    const bookingUpdateIndex = ops.length
    ops.push(
      prisma.booking.update({
        where: { id: booking.id },
        data: { status: 'CANCELLED', cancelledAt: new Date() },
      }),
    )
    if (refund.refundAmount > 0) {
      ops.push(
        prisma.refundRequest.create({
          data: { bookingId: booking.id, amount: refund.refundAmount, ratio: refund.ratio },
        }),
      )
    }

    const results = await prisma.$transaction(ops) // 6a: toàn bộ thất bại cùng nhau nếu có lỗi
    const updated = results[bookingUpdateIndex]

    // BR-60: email xác nhận hủy, nêu rõ mức hoàn tiền (gửi nền, không chặn response).
    sendCancellationEmail(booking.guestEmail, {
      code: booking.code,
      productName: booking.product.name,
      refundAmount: refund.refundAmount,
      ratio: refund.ratio,
    }).catch((e) => console.error('Gửi email hủy đơn thất bại:', e))

    res.json({
      order: await orderDetail({ ...booking, ...updated, product: booking.product }),
      refund,
    })
  } catch (err) {
    next(err)
  }
}
