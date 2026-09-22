import { prisma } from '../lib/prisma.js'
import { sendBookingEmail } from '../lib/mailer.js'
import {
  DEPOSIT_RATE,
  HOLD_MINUTES,
  generateOrderCode,
  generatePin,
  hashPin,
  nightsBetween,
  parseUtcDate,
  releaseExpiredHomestayHolds,
} from '../lib/booking.js'

const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/

// Cấu hình công khai cho luồng đặt (tỷ lệ cọc, hạn giữ chỗ).
export function bookingConfig(req, res) {
  res.json({ depositRate: DEPOSIT_RATE, holdMinutes: HOLD_MINUTES })
}

function publicBooking(b, productName, productSlug) {
  return {
    code: b.code,
    type: b.type,
    status: b.status,
    productName,
    productSlug,
    guestName: b.guestName,
    guestEmail: b.guestEmail,
    guestPhone: b.guestPhone,
    checkIn: b.checkIn,
    checkOut: b.checkOut,
    nights: b.nights,
    guests: b.guests,
    totalPrice: b.totalPrice,
    depositAmount: b.depositAmount,
    remainingAmount: b.remainingAmount,
    heldUntil: b.heldUntil,
    createdAt: b.createdAt,
  }
}

// UC-09 – Đặt homestay: giữ chỗ tạm + tạo đơn "chờ cọc". Hỗ trợ guest checkout.
export async function createHomestayBooking(req, res, next) {
  try {
    const { slug, checkIn, checkOut, guests, guestName, guestEmail, guestPhone, acceptedTerms } = req.body

    // BR-28 / 5a: bắt buộc đồng ý điều khoản.
    if (!acceptedTerms) {
      return res.status(400).json({ message: 'Vui lòng đồng ý điều khoản và chính sách trước khi đặt' })
    }
    if (!guestName || !guestEmail || !guestPhone) {
      return res.status(400).json({ message: 'Vui lòng nhập đầy đủ họ tên, email và số điện thoại' })
    }
    if (!EMAIL_RE.test(guestEmail)) {
      return res.status(400).json({ message: 'Email không hợp lệ' })
    }
    const numGuests = Number(guests) || 0
    if (numGuests < 1) {
      return res.status(400).json({ message: 'Số khách phải ≥ 1' })
    }
    const nights = nightsBetween(checkIn, checkOut)
    if (!nights || nights.length === 0) {
      return res.status(400).json({ message: 'Khoảng ngày không hợp lệ' })
    }

    const product = await prisma.product.findUnique({ where: { slug } })
    if (!product || product.status !== 'VISIBLE' || product.type !== 'HOMESTAY') {
      return res.status(404).json({ message: 'Homestay không còn khả dụng' }) // 1a
    }

    // BR-25: giải phóng chỗ giữ tạm đã quá hạn trước khi kiểm tra.
    await releaseExpiredHomestayHolds(product.id)

    // BR-24 / 1a: kiểm tra còn trống theo thời gian thực cho từng đêm.
    const rows = await prisma.homestayAvailability.findMany({
      where: { productId: product.id, date: { gte: nights[0], lte: nights[nights.length - 1] } },
    })
    const byTime = new Map(rows.map((r) => [new Date(r.date).getTime(), r]))
    for (const d of nights) {
      const row = byTime.get(d.getTime())
      if (!row || row.totalRooms - row.bookedRooms < 1) {
        return res.status(409).json({ message: 'Không còn phòng trống trong khoảng ngày đã chọn', code: 'SOLD_OUT' })
      }
    }

    // Tính tiền (BR-26).
    const totalPrice = product.price * nights.length
    const depositAmount = Math.round(totalPrice * DEPOSIT_RATE)
    const remainingAmount = totalPrice - depositAmount

    // Mã đơn + PIN (BR-29: PIN chỉ cho guest).
    const userId = req.user?.sub ?? null
    const code = generateOrderCode()
    const pin = userId ? null : generatePin()

    // Giữ chỗ (tăng bookedRooms cho từng đêm) + tạo đơn trong một transaction.
    const [, created] = await prisma.$transaction([
      prisma.homestayAvailability.updateMany({
        where: { productId: product.id, date: { in: nights } },
        data: { bookedRooms: { increment: 1 } },
      }),
      prisma.booking.create({
        data: {
          code,
          pinHash: pin ? hashPin(pin) : null,
          type: 'HOMESTAY',
          status: 'PENDING_DEPOSIT',
          productId: product.id,
          userId,
          guestName,
          guestEmail,
          guestPhone,
          checkIn: parseUtcDate(checkIn),
          checkOut: parseUtcDate(checkOut),
          nights: nights.length,
          guests: numGuests,
          totalPrice,
          depositAmount,
          remainingAmount,
          heldUntil: new Date(Date.now() + HOLD_MINUTES * 60000),
        },
      }),
    ])

    // Gửi email xác nhận (nền, không chặn response).
    sendBookingEmail(guestEmail, {
      code,
      pin,
      productName: product.name,
      totalPrice,
      depositAmount,
      remainingAmount,
    }).catch((e) => console.error('Gửi email đặt chỗ thất bại:', e))

    res.status(201).json({ booking: publicBooking(created, product.name, product.slug), pin })
  } catch (err) {
    next(err)
  }
}
