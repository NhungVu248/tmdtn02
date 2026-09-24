import crypto from 'crypto'
import { prisma } from './prisma.js'
import { createAndSendReviewInvite } from './review-token.js'
import { getSystemConfig } from './config.js'
import { sendReviewThankYouEmail } from './mailer.js'

export const HOLD_MINUTES = Number(process.env.HOLD_MINUTES || 15) // BR-25: hạn giữ chỗ

// BR-26/BR-113: tỷ lệ cọc do UC-23 cấu hình (mặc định 30% nếu chưa từng cấu hình).
export async function getDepositRate() {
  const cfg = await getSystemConfig()
  return cfg.depositRatePercent / 100
}
const DAY_MS = 86400000

// ----- Ngày (UTC midnight, khớp cột @db.Date) -----
export function parseUtcDate(str) {
  const d = new Date(str)
  return isNaN(d) ? null : new Date(Date.UTC(d.getUTCFullYear(), d.getUTCMonth(), d.getUTCDate()))
}
export function nightsBetween(from, to) {
  const a = parseUtcDate(from)
  const b = parseUtcDate(to)
  if (!a || !b) return null
  const nights = []
  for (let t = a.getTime(); t < b.getTime(); t += DAY_MS) nights.push(new Date(t))
  return nights
}

// ----- Sinh mã đơn khó đoán + PIN (BR-29) -----
export function generateOrderCode() {
  const alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789' // bỏ ký tự dễ nhầm
  let s = ''
  const bytes = crypto.randomBytes(9)
  for (const b of bytes) s += alphabet[b % alphabet.length]
  return `BK-${s}`
}
export function generatePin() {
  return String(crypto.randomInt(0, 1_000_000)).padStart(6, '0')
}
export function hashPin(pin) {
  return crypto.createHash('sha256').update(pin).digest('hex')
}

// UC-15 – Thời điểm KẾT THÚC trải nghiệm của một đơn:
// - Homestay: ngày trả phòng (checkOut) — khách rời đi trong ngày đó.
// - Tour: cuối ngày về (returnDate của chuyến); hoàn tất khi đã sang ngày hôm sau (BR-64: "cuối ngày về").
async function experienceEndedAt(booking) {
  if (booking.type === 'HOMESTAY') return booking.checkOut ? new Date(booking.checkOut) : null
  // Tour: lấy returnDate của chuyến; fallback checkIn (ngày khởi hành).
  let end = booking.checkIn ? new Date(booking.checkIn) : null
  if (booking.tourDepartureId) {
    const dep = await prisma.tourDeparture.findUnique({ where: { id: booking.tourDepartureId }, select: { returnDate: true, departureDate: true } })
    end = dep?.returnDate ? new Date(dep.returnDate) : dep?.departureDate ? new Date(dep.departureDate) : end
  }
  if (!end) return null
  // "Cuối ngày về": hoàn tất khi đã qua hết ngày về (tức sang 00:00 ngày hôm sau).
  return new Date(end.getTime() + DAY_MS)
}

// Tên sản phẩm cho email (homestay -> Property, tour -> Tour).
async function bookingProductName(booking) {
  if (booking.tourId) return (await prisma.tour.findUnique({ where: { id: booking.tourId }, select: { title: true } }))?.title ?? ''
  if (booking.propertyId) return (await prisma.property.findUnique({ where: { id: booking.propertyId }, select: { name: true } }))?.name ?? ''
  return ''
}

// UC-15 – Chuyển "đã cọc/đã xác nhận" -> "hoàn tất" khi kỳ lưu trú/chuyến đi đã kết thúc.
// Chạy cả "lười" (khi xem đơn) lẫn theo tác vụ nền định kỳ (xem sweepCompletedBookings).
// Lần đầu hoàn tất: gửi thư cảm ơn — Guest kèm token đánh giá, Customer kèm link "Đơn của tôi" (BR-64).
export async function maybeCompleteBooking(booking) {
  if (booking.status !== 'DEPOSITED' && booking.status !== 'CONFIRMED') return booking
  const endAt = await experienceEndedAt(booking)
  if (!endAt || endAt >= new Date()) return booking

  const updated = await prisma.booking.update({ where: { id: booking.id }, data: { status: 'COMPLETED' } })

  if (booking.userId) {
    // Customer đã đăng nhập: đánh giá ngay trong "Đơn của tôi" — gửi thư cảm ơn kèm link.
    const clientUrl = process.env.CLIENT_URL || 'http://localhost:5173'
    Promise.resolve()
      .then(async () => {
        const productName = await bookingProductName(booking)
        await sendReviewThankYouEmail(booking.guestEmail, { code: booking.code, productName, reviewUrl: `${clientUrl}/orders/${booking.code}` })
      })
      .catch((e) => console.error('Gửi thư cảm ơn (customer) thất bại:', e))
  } else {
    // Guest: gửi thư cảm ơn + token đánh giá dùng một lần.
    createAndSendReviewInvite(booking).catch((e) => console.error('Gửi lời mời đánh giá (guest) thất bại:', e))
  }
  return { ...booking, ...updated }
}

// UC-15 (BR-64) – Tác vụ nền: quét các đơn đã cọc/xác nhận mà kỳ trải nghiệm đã kết thúc,
// chuyển sang "hoàn tất" và gửi thư cảm ơn/mời đánh giá — KHÔNG cần khách phải mở đơn.
export async function sweepCompletedBookings() {
  const candidates = await prisma.booking.findMany({
    where: { status: { in: ['DEPOSITED', 'CONFIRMED'] } },
    select: { id: true, code: true, type: true, checkIn: true, checkOut: true, userId: true, guestEmail: true, tourId: true, tourDepartureId: true, propertyId: true, status: true },
  })
  let completed = 0
  for (const b of candidates) {
    const before = b.status
    const after = await maybeCompleteBooking(b)
    if (after.status === 'COMPLETED' && before !== 'COMPLETED') completed++
  }
  if (completed > 0) console.log(`[UC-15 sweep] Đã hoàn tất ${completed} đơn + gửi thư mời đánh giá.`)
  return completed
}

// BR-32: giải phóng các chỗ giữ tạm đã quá hạn của một tour (trả lại số chỗ chuyến).
export async function releaseExpiredTourHolds(tourId) {
  const expired = await prisma.booking.findMany({
    where: {
      tourId,
      type: 'TOUR',
      status: 'PENDING_DEPOSIT',
      heldUntil: { lt: new Date() },
    },
  })
  for (const b of expired) {
    const seats = (b.guests || 0) + (b.children || 0)
    const departure = b.tourDepartureId
      ? await prisma.tourDeparture.findUnique({ where: { id: b.tourDepartureId } })
      : null
    await prisma.$transaction([
      ...(departure
        ? [
            prisma.tourDeparture.update({
              where: { id: departure.id },
              data: { bookedSlots: { decrement: Math.min(seats, departure.bookedSlots) } },
            }),
          ]
        : []),
      prisma.booking.update({ where: { id: b.id }, data: { status: 'CANCELLED' } }),
    ])
  }
}

// BR-25: giải phóng các chỗ giữ tạm đã quá hạn của một chỗ nghỉ (trả lại tồn phòng theo loại phòng).
export async function releaseExpiredHomestayHolds(propertyId) {
  const expired = await prisma.booking.findMany({
    where: {
      propertyId,
      type: 'HOMESTAY',
      status: 'PENDING_DEPOSIT',
      heldUntil: { lt: new Date() },
    },
  })
  for (const b of expired) {
    const nights = b.checkIn && b.checkOut ? nightsBetween(b.checkIn.toISOString(), b.checkOut.toISOString()) : []
    await prisma.$transaction([
      ...nights.map((d) =>
        prisma.roomInventory.updateMany({
          where: { roomTypeId: b.roomTypeId, date: d, bookedRooms: { gt: 0 } },
          data: { bookedRooms: { decrement: 1 } },
        }),
      ),
      prisma.booking.update({ where: { id: b.id }, data: { status: 'CANCELLED' } }),
    ])
  }
}
