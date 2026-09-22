import { Router } from 'express'
import { bookingConfig, createHomestayBooking } from '../controllers/bookings.controller.js'
import { optionalAuth } from '../middleware/auth.middleware.js'

const router = Router()

// UC-09 – hỗ trợ cả guest checkout lẫn thành viên (optionalAuth).
router.get('/config', bookingConfig)
router.post('/homestay', optionalAuth, createHomestayBooking)

export default router
