import { Router } from 'express'
import { adminLogin, adminMe } from '../controllers/adminAuth.controller.js'
import { requireAdmin } from '../middleware/adminAuth.middleware.js'

const router = Router()

// UC-24 – Đăng nhập quản trị, hoàn toàn tách biệt khỏi /api/auth (Customer).
router.post('/login', adminLogin)
router.get('/me', requireAdmin, adminMe)
// Đăng xuất: JWT không trạng thái, phía client chỉ cần xóa token (giống UC-06).

export default router
