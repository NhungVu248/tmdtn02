import { Router } from 'express'
import { getOrder, listOrders, processRefund, updateOrderStatus } from '../../controllers/admin/orders.controller.js'
import { requireAdmin } from '../../middleware/adminAuth.middleware.js'

const router = Router()

// UC-18 «include» UC-24: mọi route bên dưới yêu cầu đã đăng nhập quản trị (BR-89).
router.use(requireAdmin)

router.get('/', listOrders)
router.get('/:code', getOrder)
router.patch('/:code/status', updateOrderStatus)
router.post('/:code/refunds/:refundId/process', processRefund)

export default router
