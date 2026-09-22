import { prisma } from '../lib/prisma.js'

const productCardSelect = {
  id: true,
  name: true,
  slug: true,
  type: true,
  location: true,
  price: true,
  rating: true,
  thumbnail: true,
  isFeatured: true,
  categoryId: true,
  amenities: true,
  durationDays: true,
}

// UC-08 – Danh sách yêu thích của tài khoản (BR-22).
export async function listFavorites(req, res, next) {
  try {
    const favorites = await prisma.favorite.findMany({
      where: { userId: req.user.sub },
      orderBy: { createdAt: 'desc' },
      include: { product: { select: productCardSelect } },
    })
    res.json({ items: favorites.map((f) => f.product) })
  } catch (err) {
    next(err)
  }
}

// Danh sách id để hiển thị trạng thái tim trên các trang.
export async function listFavoriteIds(req, res, next) {
  try {
    const favorites = await prisma.favorite.findMany({
      where: { userId: req.user.sub },
      select: { productId: true },
    })
    res.json({ ids: favorites.map((f) => f.productId) })
  } catch (err) {
    next(err)
  }
}

// UC-08 – Thêm vào yêu thích. BR-23/2a: chỉ sản phẩm đang hiển thị.
export async function addFavorite(req, res, next) {
  try {
    const productId = Number(req.body.productId)
    if (!Number.isInteger(productId)) {
      return res.status(400).json({ message: 'productId không hợp lệ' })
    }

    const product = await prisma.product.findUnique({ where: { id: productId } })
    if (!product || product.status !== 'VISIBLE') {
      return res.status(404).json({ message: 'Sản phẩm không còn khả dụng' }) // 2a
    }

    // Idempotent: đã có thì bỏ qua (BR-22 gắn theo user).
    await prisma.favorite.upsert({
      where: { userId_productId: { userId: req.user.sub, productId } },
      create: { userId: req.user.sub, productId },
      update: {},
    })
    res.status(201).json({ favorited: true, productId })
  } catch (err) {
    next(err)
  }
}

// UC-08 – Bỏ yêu thích.
export async function removeFavorite(req, res, next) {
  try {
    const productId = Number(req.params.productId)
    if (!Number.isInteger(productId)) {
      return res.status(400).json({ message: 'productId không hợp lệ' })
    }
    await prisma.favorite.deleteMany({ where: { userId: req.user.sub, productId } })
    res.json({ favorited: false, productId })
  } catch (err) {
    next(err)
  }
}
