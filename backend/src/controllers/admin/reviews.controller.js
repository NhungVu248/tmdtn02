import { prisma } from '../../lib/prisma.js'
import { logAdminAction } from '../../lib/auditLog.js'

// UC-21 – Danh sách đánh giá kèm bộ lọc trạng thái kiểm duyệt.
// PENDING (chờ kiểm duyệt) = approved:false & rejected:false (mặc định khi gửi từ UC-15).
export async function listReviews(req, res, next) {
  try {
    const { status, productId } = req.query
    const where = {}
    if (status === 'PENDING') {
      where.approved = false
      where.rejected = false
    } else if (status === 'APPROVED') {
      where.approved = true
    } else if (status === 'REJECTED') {
      where.rejected = true
    }
    if (productId) where.productId = Number(productId)

    const items = await prisma.review.findMany({
      where,
      include: { product: { select: { name: true, slug: true } } },
      orderBy: { createdAt: 'desc' },
      take: 300,
    })
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
    await logAdminAction(req.admin.sub, 'review.approve', {
      entityType: 'Review',
      entityId: id,
      detail: { productId: existing.productId },
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
    await logAdminAction(req.admin.sub, wasApproved ? 'review.hide' : 'review.reject', {
      entityType: 'Review',
      entityId: id,
      detail: { productId: existing.productId },
    })
    res.json({ item })
  } catch (err) {
    next(err)
  }
}
