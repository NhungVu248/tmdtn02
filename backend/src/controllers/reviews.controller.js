import { prisma } from '../lib/prisma.js'
import { maybeCompleteBooking } from '../lib/booking.js'
import { hashReviewToken } from '../lib/review-token.js'

function validateRatingComment(rating, comment) {
  const r = Number(rating)
  if (!Number.isInteger(r) || r < 1 || r > 5) return 'Vui lòng chọn số sao từ 1 đến 5'
  if (comment && String(comment).length > 2000) return 'Nhận xét quá dài'
  return null
}

// UC-15 (1a) – Guest: lấy thông tin đơn qua token để hiển thị form đánh giá (không tiêu thụ token).
export async function getReviewContext(req, res, next) {
  try {
    const token = String(req.params.token || '')
    const row = await prisma.reviewToken.findUnique({
      where: { tokenHash: hashReviewToken(token) },
      include: { booking: { include: { product: { select: { name: true, slug: true, thumbnail: true } } } } },
    })
    if (!row) {
      return res.status(404).json({ message: 'Liên kết đánh giá không hợp lệ' }) // 4b
    }
    if (row.usedAt || row.expiresAt < new Date()) {
      return res.status(410).json({ message: 'Liên kết đánh giá đã hết hạn hoặc đã được sử dụng' }) // 4b
    }
    const existing = await prisma.review.findUnique({ where: { bookingId: row.bookingId } })
    if (existing) {
      return res.status(409).json({ message: 'Đơn này đã được đánh giá trước đó' }) // 4a
    }
    res.json({
      productName: row.booking.product.name,
      productSlug: row.booking.product.slug,
      thumbnail: row.booking.product.thumbnail,
      bookingCode: row.booking.code,
    })
  } catch (err) {
    next(err)
  }
}

// UC-15 – Guest gửi đánh giá qua token dùng một lần (BR-62).
export async function createGuestReview(req, res, next) {
  try {
    const { token, rating, comment } = req.body
    const issue = validateRatingComment(rating, comment)
    if (issue) return res.status(400).json({ message: issue })
    if (!token) return res.status(400).json({ message: 'Thiếu mã đánh giá' })

    const row = await prisma.reviewToken.findUnique({
      where: { tokenHash: hashReviewToken(String(token)) },
      include: { booking: true },
    })
    if (!row || row.usedAt || row.expiresAt < new Date()) {
      return res.status(410).json({ message: 'Liên kết đánh giá đã hết hạn hoặc đã được sử dụng' }) // 4b
    }

    // BR-61: chỉ đánh giá đơn "hoàn tất" và chưa đánh giá — kiểm tra lại (đề phòng trạng thái đổi).
    const booking = await maybeCompleteBooking(row.booking)
    if (booking.status !== 'COMPLETED') {
      return res.status(409).json({ message: 'Đơn chưa hoàn tất, chưa thể đánh giá' }) // 4a
    }
    const existing = await prisma.review.findUnique({ where: { bookingId: booking.id } })
    if (existing) {
      return res.status(409).json({ message: 'Đơn này đã được đánh giá trước đó' }) // 4a
    }

    // BR-63: mọi đánh giá ở trạng thái "chờ kiểm duyệt" (approved: false mặc định).
    await prisma.$transaction([
      prisma.review.create({
        data: {
          productId: booking.productId,
          bookingId: booking.id,
          authorName: booking.guestName,
          rating: Number(rating),
          comment: comment || null,
        },
      }),
      prisma.reviewToken.update({ where: { id: row.id }, data: { usedAt: new Date() } }), // BR-62: vô hiệu sau khi dùng
    ])

    res.status(201).json({ message: 'Cảm ơn bạn đã gửi đánh giá! Đánh giá đang chờ kiểm duyệt.' })
  } catch (err) {
    next(err)
  }
}

// UC-15 – Customer gửi đánh giá cho đơn của chính mình (từ "Đơn của tôi").
export async function createMyReview(req, res, next) {
  try {
    const { code, rating, comment } = req.body
    const issue = validateRatingComment(rating, comment)
    if (issue) return res.status(400).json({ message: issue })

    const booking = await prisma.booking.findUnique({ where: { code } })
    if (!booking || booking.userId !== req.user.sub) {
      return res.status(404).json({ message: 'Không tìm thấy đơn' }) // BR-49: chống IDOR
    }

    const completed = await maybeCompleteBooking(booking)
    if (completed.status !== 'COMPLETED') {
      return res.status(409).json({ message: 'Đơn chưa hoàn tất, chưa thể đánh giá' }) // 4a
    }
    const existing = await prisma.review.findUnique({ where: { bookingId: completed.id } })
    if (existing) {
      return res.status(409).json({ message: 'Đơn này đã được đánh giá trước đó' }) // 4a
    }

    const user = await prisma.user.findUnique({ where: { id: req.user.sub }, select: { name: true, email: true } })
    await prisma.review.create({
      data: {
        productId: completed.productId,
        bookingId: completed.id,
        authorName: user?.name || completed.guestName,
        rating: Number(rating),
        comment: comment || null,
      },
    })

    res.status(201).json({ message: 'Cảm ơn bạn đã gửi đánh giá! Đánh giá đang chờ kiểm duyệt.' })
  } catch (err) {
    next(err)
  }
}
