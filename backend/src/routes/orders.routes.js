import { Router } from 'express'
import { cancelOrder, getMyOrder, listMyOrders, lookupOrder } from '../controllers/orders.controller.js'
import { authenticate, optionalAuth } from '../middleware/auth.middleware.js'

const router = Router()

// UC-13 – Customer: "Đơn của tôi" (yêu cầu đăng nhập, BR-49).
router.get('/my', authenticate, listMyOrders)
router.get('/my/:code', authenticate, getMyOrder)

// UC-13 – Guest: tra cứu bằng mã đơn + PIN/email (công khai, BR-50/51).
router.post('/lookup', lookupOrder)

// UC-14 – Hủy đơn & hoàn tiền. Customer (đăng nhập) hoặc Guest (mã+PIN/email trong body).
router.post('/:code/cancel', optionalAuth, cancelOrder)

export default router
