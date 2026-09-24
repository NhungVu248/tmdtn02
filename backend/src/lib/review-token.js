import crypto from 'crypto'
import { prisma } from './prisma.js'
import { sendReviewInviteEmail } from './mailer.js'

const TOKEN_TTL_DAYS = 30 // BR-62: token đánh giá có hạn dùng

export function hashReviewToken(token) {
  return crypto.createHash('sha256').update(token).digest('hex')
}

// UC-15 (BR-64) – Sinh token đánh giá dùng một lần cho Guest + gửi email mời đánh giá.
// Bỏ qua nếu đơn đã có token (chỉ gửi một lần) hoặc đã có đánh giá.
export async function createAndSendReviewInvite(booking) {
  const existing = await prisma.reviewToken.findUnique({ where: { bookingId: booking.id } })
  if (existing) return null

  // Đơn homestay -> Property; đơn tour -> Tour (bảng riêng).
  const productName = booking.tourId
    ? (await prisma.tour.findUnique({ where: { id: booking.tourId }, select: { title: true } }))?.title
    : (await prisma.property.findUnique({ where: { id: booking.propertyId }, select: { name: true } }))?.name
  const rawToken = crypto.randomBytes(32).toString('hex')
  await prisma.reviewToken.create({
    data: {
      bookingId: booking.id,
      tokenHash: hashReviewToken(rawToken),
      expiresAt: new Date(Date.now() + TOKEN_TTL_DAYS * 86400000),
    },
  })

  const clientUrl = process.env.CLIENT_URL || 'http://localhost:5173'
  const reviewUrl = `${clientUrl}/review?token=${rawToken}`
  await sendReviewInviteEmail(booking.guestEmail, {
    code: booking.code,
    productName: productName ?? '',
    reviewUrl,
  })
  return reviewUrl
}
