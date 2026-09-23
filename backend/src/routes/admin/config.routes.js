import { Router } from 'express'
import { getConfig, updateConfig } from '../../controllers/admin/config.controller.js'
import { listAuditLogs } from '../../controllers/admin/auditLogs.controller.js'
import { requireAdmin, requireRole } from '../../middleware/adminAuth.middleware.js'

const router = Router()

// UC-23 «include» UC-24: yêu cầu đã đăng nhập quản trị (BR-118).
router.use(requireAdmin)

// BR-117: chỉ SUPER_ADMIN được cấu hình hệ thống và xem nhật ký (dữ liệu nhạy cảm — lộ mọi
// thao tác của các quản trị viên khác); MANAGER vẫn xem được giá trị cấu hình hiện tại (tham chiếu).
router.get('/', getConfig)
router.put('/', requireRole('SUPER_ADMIN'), updateConfig)

router.get('/audit-logs', requireRole('SUPER_ADMIN'), listAuditLogs)

export default router
