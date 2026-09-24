import { Router } from 'express'
import {
  addImage,
  createHomestay,
  createRoomType,
  deleteRoomType,
  getHomestay,
  getInventory,
  homestayMeta,
  listHomestays,
  removeImage,
  setInventory,
  setVisibility,
  updateHomestay,
  updateRoomType,
} from '../../controllers/admin/homestays.controller.js'
import { uploadFile } from '../../controllers/admin/uploads.controller.js'
import { requireAdmin } from '../../middleware/adminAuth.middleware.js'
import { uploadImage } from '../../lib/uploads.js'

const router = Router()

// UC-16 «include» UC-24: mọi route bên dưới yêu cầu đã đăng nhập quản trị.
router.use(requireAdmin)

// Upload ảnh (BR-76) — đặt trước các route /:id để tránh nhầm "uploads" thành id.
router.post('/uploads/image', uploadImage.single('file'), uploadFile)
router.get('/meta', homestayMeta)

router.get('/', listHomestays)
router.post('/', createHomestay)
router.get('/:id', getHomestay)
router.put('/:id', updateHomestay)
router.patch('/:id/visibility', setVisibility)

router.post('/:id/images', addImage)
router.delete('/:id/images/:imageId', removeImage)

// Loại phòng
router.post('/:id/room-types', createRoomType)
router.put('/:id/room-types/:rtId', updateRoomType)
router.delete('/:id/room-types/:rtId', deleteRoomType)

// Lịch tồn phòng theo loại phòng
router.get('/:id/room-types/:rtId/inventory', getInventory)
router.put('/:id/room-types/:rtId/inventory', setInventory)

export default router
