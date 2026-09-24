import { Router } from 'express'
import { createGuestReview, createMyReview, getReviewContext, uploadReviewImages } from '../controllers/reviews.controller.js'
import { authenticate } from '../middleware/auth.middleware.js'
import { uploadImages } from '../lib/uploads.js'

const router = Router()

// UC-15 – Tải ảnh đính kèm đánh giá (dùng cho cả guest & customer, tối đa 6 ảnh).
router.post('/upload', uploadImages.array('files', 6), uploadReviewImages)

// UC-15 – Guest qua token trong email mời đánh giá (BR-62/64).
router.get('/token/:token', getReviewContext)
router.post('/guest', createGuestReview)

// UC-15 – Customer từ "Đơn của tôi" (yêu cầu đăng nhập).
router.post('/my', authenticate, createMyReview)

export default router
