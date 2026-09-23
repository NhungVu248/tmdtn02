import crypto from 'crypto'
import { prisma } from './prisma.js'
import { createAndSendReviewInvite } from './review-token.js'
import { getSystemConfig } from './config.js'

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

// UC-15 – Chuyển trạng thái "chờ cọc/đã cọc/đã xác nhận" -> "hoàn tất" khi kỳ lưu trú/chuyến đi
// đã kết thúc (giả thuyết UC-15: trạng thái đơn được cập nhật đúng khi kết thúc lưu trú/chuyến đi).
// Hệ thống chưa có tác vụ nền định kỳ nên kiểm tra "lười" mỗi khi đơn được xem (UC-13).
// Lần đầu chuyển sang "hoàn tất": nếu Guest thì sinh token + gửi email mời đánh giá (BR-64).
export async function maybeCompleteBooking(booking) {
  if (booking.status !== 'DEPOSITED' && booking.status !== 'CONFIRMED') return booking
  const eventEnd = booking.type === 'HOMESTAY' ? booking.checkOut : booking.checkIn
  if (!eventEnd || eventEnd >= new Date()) return booking

  const updated = await prisma.booking.update({ where: { id: booking.id }, data: { status: 'COMPLETED' } })

  if (!booking.userId) {
    // Guest: gửi lời mời đánh giá kèm token dùng một lần (bỏ qua nếu đã có/gửi lỗi, không chặn luồng xem đơn).
    createAndSendReviewInvite(booking).catch((e) => console.error('Gửi lời mời đánh giá thất bại:', e))
  }
  return { ...booking, ...updated }
}

// BR-32: giải phóng các chỗ giữ tạm đã quá hạn của một tour (trả lại số chỗ chuyến).
export async function releaseExpiredTourHolds(productId) {
  const expired = await prisma.booking.findMany({
    where: {
      productId,
      type: 'TOUR',
      status: 'PENDING_DEPOSIT',
      heldUntil: { lt: new Date() },
    },
  })
  for (const b of expired) {
    const seats = (b.guests || 0) + (b.children || 0)
    const departure = b.checkIn
      ? await prisma.tourDeparture.findFirst({ where: { productId, date: b.checkIn } })
      : null
    await prisma.$transaction([
      ...(departure
        ? [
            prisma.tourDeparture.update({
              where: { id: departure.id },
              data: { bookedSeats: { decrement: Math.min(seats, departure.bookedSeats) } },
            }),
          ]
        : []),
      prisma.booking.update({ where: { id: b.id }, data: { status: 'CANCELLED' } }),
    ])
  }
}

// BR-25: giải phóng các chỗ giữ tạm đã quá hạn của một homestay (trả lại tồn phòng).
export async function releaseExpiredHomestayHolds(productId) {
  const expired = await prisma.booking.findMany({
    where: {
      productId,
      type: 'HOMESTAY',
      status: 'PENDING_DEPOSIT',
      heldUntil: { lt: new Date() },
    },
  })
  for (const b of expired) {
    const nights = b.checkIn && b.checkOut ? nightsBetween(b.checkIn.toISOString(), b.checkOut.toISOString()) : []
    await prisma.$transaction([
      ...nights.map((d) =>
        prisma.homestayAvailability.updateMany({
          where: { productId, date: d, bookedRooms: { gt: 0 } },
          data: { bookedRooms: { decrement: 1 } },
        }),
      ),
      prisma.booking.update({ where: { id: b.id }, data: { status: 'CANCELLED' } }),
    ])
  }
}
