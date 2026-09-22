import crypto from 'crypto'
import { prisma } from './prisma.js'

export const DEPOSIT_RATE = Number(process.env.DEPOSIT_RATE || 0.3) // BR-26: tỷ lệ cọc
export const HOLD_MINUTES = Number(process.env.HOLD_MINUTES || 15) // BR-25: hạn giữ chỗ
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
