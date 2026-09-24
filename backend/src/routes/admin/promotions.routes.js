import { Router } from 'express'
import {
  createPromotion,
  deletePromotion,
  getPromotion,
  listPromotions,
  setPromotionActive,
  updatePromotion,
} from '../../controllers/admin/promotions.controller.js'
import { uploadFile } from '../../controllers/admin/uploads.controller.js'
import { requireAdmin } from '../../middleware/adminAuth.middleware.js'
import { uploadImage } from '../../lib/uploads.js'

const router = Router()

// Mọi route yêu cầu đã đăng nhập quản trị.
router.use(requireAdmin)

// Upload ảnh — đặt trước /:id để tránh nhầm "uploads" thành id.
router.post('/uploads/image', uploadImage.single('file'), uploadFile)

router.get('/', listPromotions)
router.post('/', createPromotion)
router.get('/:id', getPromotion)
router.put('/:id', updatePromotion)
router.patch('/:id/active', setPromotionActive)
router.delete('/:id', deletePromotion)

export default router
