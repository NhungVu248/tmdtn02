import crypto from 'crypto'
import { prisma } from './prisma.js'
import { sendPasswordResetEmail, sendVerificationEmail } from './mailer.js'

const TOKEN_TTL_MS = 24 * 60 * 60 * 1000 // 24 giờ (xác thực email)
const RESET_TTL_MS = 60 * 60 * 1000 // 1 giờ (đặt lại mật khẩu)

export function hashToken(token) {
  return crypto.createHash('sha256').update(token).digest('hex')
}

// Tạo token xác thực mới cho user, lưu bản băm, gửi email. Trả về verifyUrl (để dev dùng).
export async function createAndSendVerification(user) {
  const rawToken = crypto.randomBytes(32).toString('hex')
  await prisma.emailVerificationToken.create({
    data: {
      userId: user.id,
      tokenHash: hashToken(rawToken),
      expiresAt: new Date(Date.now() + TOKEN_TTL_MS),
    },
  })

  const clientUrl = process.env.CLIENT_URL || 'http://localhost:5173'
  const verifyUrl = `${clientUrl}/verify-email?token=${rawToken}`
  await sendVerificationEmail(user.email, verifyUrl)
  return verifyUrl
}

// Tạo token đặt lại mật khẩu (không gửi). Trả về resetUrl.
export async function createResetToken(user) {
  const rawToken = crypto.randomBytes(32).toString('hex')
  await prisma.passwordResetToken.create({
    data: {
      userId: user.id,
      tokenHash: hashToken(rawToken),
      expiresAt: new Date(Date.now() + RESET_TTL_MS),
    },
  })
  const clientUrl = process.env.CLIENT_URL || 'http://localhost:5173'
  return `${clientUrl}/reset-password?token=${rawToken}`
}

// Gửi email đặt lại (dùng để gửi nền, không chặn response).
export function sendReset(email, resetUrl) {
  return sendPasswordResetEmail(email, resetUrl)
}

// Ở môi trường không phải production, trả kèm link để hoàn tất luồng khi chưa có SMTP.
export function devVerifyUrl(url) {
  return process.env.NODE_ENV === 'production' ? undefined : url
}
