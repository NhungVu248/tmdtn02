import { prisma } from '../../lib/prisma.js'
import { logAdminAction } from '../../lib/auditLog.js'

// Quản lý chương trình khuyến mại (banner hiển thị ở trang chủ).

export async function listPromotions(req, res, next) {
  try {
    const { status } = req.query
    const where = {}
    if (status === 'ACTIVE') where.active = true
    if (status === 'INACTIVE') where.active = false

    const items = await prisma.promotion.findMany({
      where,
      orderBy: { createdAt: 'desc' },
    })
    res.json({ items })
  } catch (err) {
    next(err)
  }
}

export async function getPromotion(req, res, next) {
  try {
    const id = Number(req.params.id)
    const item = await prisma.promotion.findUnique({ where: { id } })
    if (!item) return res.status(404).json({ message: 'Không tìm thấy chương trình khuyến mại' })
    res.json({ item })
  } catch (err) {
    next(err)
  }
}

function parseBody(body) {
  const title = typeof body.title === 'string' ? body.title.trim() : ''
  const description = typeof body.description === 'string' ? body.description.trim() : ''
  const image = typeof body.image === 'string' ? body.image.trim() : ''
  return {
    title,
    description: description || null,
    image: image || null,
    active: body.active === undefined ? true : Boolean(body.active),
  }
}

export async function createPromotion(req, res, next) {
  try {
    const data = parseBody(req.body)
    if (!data.title) return res.status(400).json({ message: 'Vui lòng nhập tiêu đề chương trình' })

    const item = await prisma.promotion.create({ data })
    await logAdminAction(req.admin.sub, 'CREATE_PROMOTION', {
      entityType: 'Promotion',
      entityId: item.id,
      detail: item.title,
    })
    res.status(201).json({ item })
  } catch (err) {
    next(err)
  }
}

export async function updatePromotion(req, res, next) {
  try {
    const id = Number(req.params.id)
    const existing = await prisma.promotion.findUnique({ where: { id } })
    if (!existing) return res.status(404).json({ message: 'Không tìm thấy chương trình khuyến mại' })

    const data = parseBody(req.body)
    if (!data.title) return res.status(400).json({ message: 'Vui lòng nhập tiêu đề chương trình' })

    const item = await prisma.promotion.update({ where: { id }, data })
    await logAdminAction(req.admin.sub, 'UPDATE_PROMOTION', {
      entityType: 'Promotion',
      entityId: id,
      detail: item.title,
    })
    res.json({ item })
  } catch (err) {
    next(err)
  }
}

export async function setPromotionActive(req, res, next) {
  try {
    const id = Number(req.params.id)
    const active = Boolean(req.body.active)
    const existing = await prisma.promotion.findUnique({ where: { id } })
    if (!existing) return res.status(404).json({ message: 'Không tìm thấy chương trình khuyến mại' })

    const item = await prisma.promotion.update({ where: { id }, data: { active } })
    await logAdminAction(req.admin.sub, active ? 'ACTIVATE_PROMOTION' : 'DEACTIVATE_PROMOTION', {
      entityType: 'Promotion',
      entityId: id,
      detail: item.title,
    })
    res.json({ item })
  } catch (err) {
    next(err)
  }
}

export async function deletePromotion(req, res, next) {
  try {
    const id = Number(req.params.id)
    const existing = await prisma.promotion.findUnique({ where: { id } })
    if (!existing) return res.status(404).json({ message: 'Không tìm thấy chương trình khuyến mại' })

    await prisma.promotion.delete({ where: { id } })
    await logAdminAction(req.admin.sub, 'DELETE_PROMOTION', {
      entityType: 'Promotion',
      entityId: id,
      detail: existing.title,
    })
    res.json({ ok: true })
  } catch (err) {
    next(err)
  }
}
