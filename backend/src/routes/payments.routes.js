import { Router } from 'express'
import {
  createPayment,
  getPaymentStatus,
  paymentConfig,
  vnpayReturn,
} from '../controllers/payments.controller.js'
import { optionalAuth } from '../middleware/auth.middleware.js'

const router = Router()

// UC-11 – công khai (hỗ trợ guest); VNPAY return là callback từ cổng.
router.get('/config', paymentConfig)
router.get('/vnpay-return', vnpayReturn)
router.get('/status/:code', getPaymentStatus)
router.post('/create', optionalAuth, createPayment)

export default router
