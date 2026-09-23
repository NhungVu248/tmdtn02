import { Router } from 'express'
import { applyDiscount } from '../controllers/discounts.controller.js'
import { optionalAuth } from '../middleware/auth.middleware.js'

const router = Router()

// UC-12 – công khai, hỗ trợ cả guest (optionalAuth để kiểm tra "đối tượng" CUSTOMER).
router.post('/apply', optionalAuth, applyDiscount)

export default router
