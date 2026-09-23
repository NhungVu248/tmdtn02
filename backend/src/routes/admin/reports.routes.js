import { Router } from 'express'
import { getReports } from '../../controllers/admin/reports.controller.js'
import { requireAdmin } from '../../middleware/adminAuth.middleware.js'

const router = Router()

// UC-22 «include» UC-24: yêu cầu đã đăng nhập quản trị (BR-112). Chỉ đọc (BR-108).
router.use(requireAdmin)

router.get('/', getReports)

export default router
