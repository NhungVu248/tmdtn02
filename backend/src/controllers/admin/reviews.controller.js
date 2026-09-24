import { prisma } from '../../lib/prisma.js'
import { logAdminAction } from '../../lib/auditLog.js'

// BR-105: chỉ đánh giá đã duyệt mới tính vào điểm & số lượt (Tour/Property có trường denormalized).
async function recomputeTourRating(tourId) {
  if (!tourId) return
  const approved = await prisma.review.findMany({ where: { tourId, approved: true }, select: { rating: true } })
  const count = approved.length
  const avg = count ? approved.reduce((s, r) => s + r.rating, 0) / count : 0
  await prisma.tour.update({ where: { id: tourId }, data: { reviewCount: count, avgRating: Math.round(avg * 10) / 10 } })
}
async function recomputePropertyRating(propertyId) {
  if (!propertyId) return
  const approved = await prisma.review.findMany({ where: { propertyId, approved: true }, select: { rating: true } })
  const count = approved.length
  const avg = count ? approved.reduce((s, r) => s + r.rating, 0) / count : 0
  await prisma.property.update({ where: { id: propertyId }, data: { reviewCount: count, avgRating: Math.round(avg * 10) / 10 } })
}

// UC-21 – Danh sách đánh giá kèm bộ lọc trạng thái kiểm duyệt.
// PENDING (chờ kiểm duyệt) = approved:false & rejected:false (mặc định khi gửi từ UC-15).
export async function listReviews(req, res, next) {
  try {
    const { status } = req.query
    const where = {}
    if (status === 'PENDING') {
      where.approved = false
      where.rejected = false
    } else if (status === 'APPROVED') {
      where.approved = true
    } else if (status === 'REJECTED') {
      where.rejected = true
    }

    const rows = await prisma.review.findMany({
      where,
      include: { property: { select: { name: true, slug: true } }, tour: { select: { title: true, slug: true } } },
      orderBy: { createdAt: 'desc' },
      take: 300,
    })
    // Chuẩn hóa: product hiển thị thống nhất cho cả homestay lẫn tour.
    const items = rows.map((r) => ({
      ...r,
      product: r.tour ? { name: r.tour.title, slug: r.tour.slug } : r.property,
    }))
    res.json({ items })
  } catch (err) {
    next(err)
  }
}

// UC-21 (3) – Duyệt đánh giá cho hiển thị công khai (BR-103/105).
export async function approveReview(req, res, next) {
  try {
    const id = Number(req.params.id)
    const existing = await prisma.review.findUnique({ where: { id } })
    if (!existing) return res.status(404).json({ message: 'Không tìm thấy đánh giá' })

    const item = await prisma.review.update({ where: { id }, data: { approved: true, rejected: false } })
    await recomputeTourRating(existing.tourId); await recomputePropertyRating(existing.propertyId)
    await logAdminAction(req.admin.sub, 'review.approve', {
      entityType: 'Review',
      entityId: id,
      detail: { propertyId: existing.propertyId, tourId: existing.tourId },
    })
    res.json({ item })
  } catch (err) {
    next(err)
  }
}

// UC-21 (3/3a) – Từ chối/ẩn đánh giá (BR-104/106): áp dụng cho cả đánh giá đang chờ
// (từ chối, không cho hiển thị) lẫn đánh giá đã duyệt trước đó (gỡ khỏi trang công khai).
export async function rejectReview(req, res, next) {
  try {
    const id = Number(req.params.id)
    const existing = await prisma.review.findUnique({ where: { id } })
    if (!existing) return res.status(404).json({ message: 'Không tìm thấy đánh giá' })

    const wasApproved = existing.approved
    const item = await prisma.review.update({ where: { id }, data: { approved: false, rejected: true } })
    await recomputeTourRating(existing.tourId); await recomputePropertyRating(existing.propertyId)
    await logAdminAction(req.admin.sub, wasApproved ? 'review.hide' : 'review.reject', {
      entityType: 'Review',
      entityId: id,
      detail: { propertyId: existing.propertyId, tourId: existing.tourId },
    })
    res.json({ item })
  } catch (err) {
    next(err)
  }
}
