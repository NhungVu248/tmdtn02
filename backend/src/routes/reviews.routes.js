import { Router } from 'express'
import { createGuestReview, createMyReview, getReviewContext } from '../controllers/reviews.controller.js'
import { authenticate } from '../middleware/auth.middleware.js'

const router = Router()

// UC-15 – Guest qua token trong email mời đánh giá (BR-62/64).
router.get('/token/:token', getReviewContext)
router.post('/guest', createGuestReview)

// UC-15 – Customer từ "Đơn của tôi" (yêu cầu đăng nhập).
router.post('/my', authenticate, createMyReview)

export default router
