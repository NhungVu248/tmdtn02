import { prisma } from '../lib/prisma.js'
import { propertyToCard } from './catalog.controller.js'

const propertyCardSelect = {
  id: true,
  name: true,
  slug: true,
  address: true,
  basePrice: true,
  avgRating: true,
  thumbnail: true,
  isFeatured: true,
  provinceId: true,
  areaId: true,
}

// UC-08 – Danh sách yêu thích của tài khoản (BR-22). Hiện áp dụng cho chỗ nghỉ (Property).
// Lưu ý: tham số `productId` từ frontend chính là id của Property (thẻ homestay).
export async function listFavorites(req, res, next) {
  try {
    const favorites = await prisma.favorite.findMany({
      where: { userId: req.user.sub, propertyId: { not: null } },
      orderBy: { createdAt: 'desc' },
      include: { property: { select: propertyCardSelect } },
    })
    res.json({ items: favorites.filter((f) => f.property).map((f) => propertyToCard(f.property)) })
  } catch (err) {
    next(err)
  }
}

export async function listFavoriteIds(req, res, next) {
  try {
    const favorites = await prisma.favorite.findMany({
      where: { userId: req.user.sub, propertyId: { not: null } },
      select: { propertyId: true },
    })
    res.json({ ids: favorites.map((f) => f.propertyId) })
  } catch (err) {
    next(err)
  }
}

// UC-08 – Thêm vào yêu thích. BR-23/2a: chỉ chỗ nghỉ đang hiển thị.
export async function addFavorite(req, res, next) {
  try {
    const propertyId = Number(req.body.productId)
    if (!Number.isInteger(propertyId)) {
      return res.status(400).json({ message: 'id không hợp lệ' })
    }
    const property = await prisma.property.findUnique({ where: { id: propertyId } })
    if (!property || property.status !== 'VISIBLE') {
      return res.status(404).json({ message: 'Chỗ nghỉ không còn khả dụng' }) // 2a
    }
    await prisma.favorite.upsert({
      where: { userId_propertyId: { userId: req.user.sub, propertyId } },
      create: { userId: req.user.sub, propertyId },
      update: {},
    })
    res.status(201).json({ favorited: true, productId: propertyId })
  } catch (err) {
    next(err)
  }
}

export async function removeFavorite(req, res, next) {
  try {
    const propertyId = Number(req.params.productId)
    if (!Number.isInteger(propertyId)) {
      return res.status(400).json({ message: 'id không hợp lệ' })
    }
    await prisma.favorite.deleteMany({ where: { userId: req.user.sub, propertyId } })
    res.json({ favorited: false, productId: propertyId })
  } catch (err) {
    next(err)
  }
}
