import crypto from 'crypto'
import { prisma } from './prisma.js'
import { sendPasswordResetEmail, sendVerificationEmail } from './mailer.js'

const OTP_TTL_MS = 10 * 60 * 1000 // 10 phút (mã OTP xác thực email)
const RESET_TTL_MS = 60 * 60 * 1000 // 1 giờ (đặt lại mật khẩu)

export function hashToken(token) {
  return crypto.createHash('sha256').update(token).digest('hex')
}

// Sinh mã OTP 6 chữ số (không có tiền tố '0' bị mất vì luôn 6 ký tự).
function generateOtp() {
  return String(crypto.randomInt(0, 1_000_000)).padStart(6, '0')
}

// UC-05 – Tạo mã OTP mới cho user, lưu BẢN BĂM (không lưu mã thô), gửi mã về email.
// Vô hiệu mọi mã cũ chưa dùng của user để tránh nhầm lẫn khi gửi lại.
export async function createAndSendOtp(user) {
  await prisma.emailVerificationToken.deleteMany({ where: { userId: user.id, usedAt: null } })
  const code = generateOtp()
  await prisma.emailVerificationToken.create({
    data: {
      userId: user.id,
      tokenHash: hashToken(code),
      expiresAt: new Date(Date.now() + OTP_TTL_MS),
    },
  })
  await sendVerificationEmail(user.email, code) // gửi mã OTP về email thật (SMTP)
  return code
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
