import { prisma } from '../lib/prisma.js'
import { validateDiscount } from '../lib/discount.js'

// UC-12 – Xem trước hiệu lực + số tiền được giảm cho một mã (bước tính tiền trong luồng đặt).
export async function applyDiscount(req, res, next) {
  try {
    const { code, type, subtotal, productId, slug } = req.body

    if ((type !== 'HOMESTAY' && type !== 'TOUR') || !Number.isFinite(Number(subtotal))) {
      return res.status(400).json({ message: 'Thiếu thông tin tính tiền để áp dụng mã' })
    }

    // Homestay -> propertyId (Property); Tour -> tourId (Tour). Cho phép truyền slug để tự tra.
    let propId = null
    let tid = null
    if (type === 'TOUR') {
      tid = productId ? Number(productId) : null
      if (!tid && slug) {
        const tour = await prisma.tour.findUnique({ where: { slug }, select: { id: true } })
        tid = tour?.id ?? null
      }
    } else {
      propId = productId ? Number(productId) : null
      if (!propId && slug) {
        const property = await prisma.property.findUnique({ where: { slug }, select: { id: true } })
        propId = property?.id ?? null
      }
    }

    const result = await validateDiscount({
      code,
      type,
      propertyId: propId,
      tourId: tid,
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
