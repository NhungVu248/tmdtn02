import { Router } from 'express'
import {
  createGuide,
  deleteGuide,
  getGuide,
  guideMeta,
  listGuides,
  setGuideVisibility,
  updateGuide,
} from '../../controllers/admin/travelGuides.controller.js'
import { uploadFile } from '../../controllers/admin/uploads.controller.js'
import { requireAdmin } from '../../middleware/adminAuth.middleware.js'
import { uploadImage } from '../../lib/uploads.js'

const router = Router()

// Mọi route yêu cầu đăng nhập quản trị.
router.use(requireAdmin)

router.post('/uploads/image', uploadImage.single('file'), uploadFile)
router.get('/meta', guideMeta)

router.get('/', listGuides)
router.post('/', createGuide)
router.get('/:id', getGuide)
router.put('/:id', updateGuide)
router.patch('/:id/visibility', setGuideVisibility)
router.delete('/:id', deleteGuide)

export default router
