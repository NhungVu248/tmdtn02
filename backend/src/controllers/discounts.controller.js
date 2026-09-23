import { prisma } from '../lib/prisma.js'
import { validateDiscount } from '../lib/discount.js'

// UC-12 – Xem trước hiệu lực + số tiền được giảm cho một mã (bước tính tiền trong luồng đặt).
export async function applyDiscount(req, res, next) {
  try {
    const { code, type, subtotal, productId, slug } = req.body

    if ((type !== 'HOMESTAY' && type !== 'TOUR') || !Number.isFinite(Number(subtotal))) {
      return res.status(400).json({ message: 'Thiếu thông tin tính tiền để áp dụng mã' })
    }

    let pid = productId ? Number(productId) : null
    if (!pid && slug) {
      const product = await prisma.product.findUnique({ where: { slug }, select: { id: true } })
      pid = product?.id ?? null
    }

    const result = await validateDiscount({
      code,
      type,
      productId: pid,
      subtotal: Number(subtotal),
      userId: req.user?.sub ?? null,
    })

    if (!result.ok) {
      return res.status(400).json({ applied: false, message: result.message, code: result.code })
    }

    res.json({
      applied: true,
      code: result.discountCode.code,
      discount: result.discount,
      newTotal: Number(subtotal) - result.discount,
    })
  } catch (err) {
    next(err)
  }
}
