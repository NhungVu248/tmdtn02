import { Router } from 'express'
import {
  addImage,
  closeDeparture,
  createDeparture,
  createTour,
  getTour,
  listTours,
  removeImage,
  setTourVisibility,
  tourCategories,
  updateDeparture,
  updateTour,
} from '../../controllers/admin/tours.controller.js'
import { uploadFile } from '../../controllers/admin/uploads.controller.js'
import { requireAdmin } from '../../middleware/adminAuth.middleware.js'
import { uploadImage } from '../../lib/uploads.js'

const router = Router()

// UC-17 «include» UC-24: mọi route bên dưới yêu cầu đã đăng nhập quản trị.
router.use(requireAdmin)

// Upload ảnh (BR-82) — đặt trước các route /:id để tránh nhầm "uploads" thành id.
router.post('/uploads/image', uploadImage.single('file'), uploadFile)
// Danh mục region/theme/duration + chính sách hủy cho form tour.
router.get('/categories', tourCategories)

router.get('/', listTours)
router.post('/', createTour)
router.get('/:id', getTour)
router.put('/:id', updateTour)
router.patch('/:id/visibility', setTourVisibility)

router.post('/:id/images', addImage)
router.delete('/:id/images/:imageId', removeImage)

router.post('/:id/departures', createDeparture)
router.put('/:id/departures/:depId', updateDeparture)
router.patch('/:id/departures/:depId/close', closeDeparture)

export default router
