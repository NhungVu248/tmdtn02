import { Router } from 'express'
import {
  createDiscount,
  getDiscount,
  listDiscounts,
  setDiscountActive,
  updateDiscount,
} from '../../controllers/admin/discounts.controller.js'
import { requireAdmin } from '../../middleware/adminAuth.middleware.js'

const router = Router()

// UC-20 «include» UC-24: mọi route bên dưới yêu cầu đã đăng nhập quản trị (BR-102).
router.use(requireAdmin)

router.get('/', listDiscounts)
router.post('/', createDiscount)
router.get('/:id', getDiscount)
router.put('/:id', updateDiscount)
router.patch('/:id/active', setDiscountActive)

export default router
