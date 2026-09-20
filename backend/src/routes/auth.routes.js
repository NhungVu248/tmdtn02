import { Router } from 'express'
import {
  changePassword,
  forgotPassword,
  googleAuth,
  login,
  me,
  register,
  resendVerification,
  resetPassword,
  updateProfile,
  verifyEmail,
} from '../controllers/auth.controller.js'
import { authenticate } from '../middleware/auth.middleware.js'
import { isGoogleConfigured } from '../lib/google.js'

const router = Router()

router.post('/register', register)
router.post('/verify-email', verifyEmail)
router.get('/verify-email', verifyEmail)
router.post('/resend-verification', resendVerification)
router.post('/forgot-password', forgotPassword)
router.post('/reset-password', resetPassword)
router.post('/google', googleAuth)
router.post('/login', login)
router.get('/me', authenticate, me)
router.put('/profile', authenticate, updateProfile)
router.put('/password', authenticate, changePassword)

// Cho frontend biết Google đã bật hay chưa để hiện/ẩn nút.
router.get('/config', (req, res) => {
  res.json({ googleEnabled: isGoogleConfigured() })
})

export default router
