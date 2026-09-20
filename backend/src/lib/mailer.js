import nodemailer from 'nodemailer'

// Mailer cho UC-05. Nếu có cấu hình SMTP (SMTP_HOST...) thì gửi thật;
// nếu không (môi trường học tập/dev) thì log ra console và không gửi.
let transporter = null
const smtpConfigured = Boolean(process.env.SMTP_HOST)

if (smtpConfigured) {
  transporter = nodemailer.createTransport({
    host: process.env.SMTP_HOST,
    port: Number(process.env.SMTP_PORT || 587),
    secure: process.env.SMTP_SECURE === 'true',
    auth: process.env.SMTP_USER
      ? { user: process.env.SMTP_USER, pass: process.env.SMTP_PASS }
      : undefined,
    // Thất bại nhanh thay vì treo request khi SMTP chậm/không phản hồi.
    connectionTimeout: 10000,
    greetingTimeout: 8000,
    socketTimeout: 12000,
  })
}

export function isEmailConfigured() {
  return smtpConfigured
}

// Gửi email xác thực. Trả về true nếu gửi được (hoặc dev-log), ném lỗi nếu SMTP lỗi.
export async function sendVerificationEmail(to, verifyUrl) {
  const from = process.env.MAIL_FROM || 'StayTour <no-reply@staytour.example>'
  const subject = 'Xác thực tài khoản StayTour'
  const html = `
    <p>Chào bạn,</p>
    <p>Cảm ơn bạn đã đăng ký StayTour. Vui lòng bấm liên kết dưới đây để kích hoạt tài khoản:</p>
    <p><a href="${verifyUrl}">Kích hoạt tài khoản</a></p>
    <p>Liên kết có hiệu lực trong 24 giờ. Nếu bạn không đăng ký, hãy bỏ qua email này.</p>
  `

  if (!transporter) {
    // Dev: không có SMTP -> log liên kết để hoàn tất luồng.
    console.log(`[MAILER dev] Gửi xác thực tới ${to}: ${verifyUrl}`)
    return true
  }

  await transporter.sendMail({ from, to, subject, html })
  return true
}

// Gửi email đặt lại mật khẩu (UC-06 1a).
export async function sendPasswordResetEmail(to, resetUrl) {
  const from = process.env.MAIL_FROM || 'StayTour <no-reply@staytour.example>'
  const subject = 'Đặt lại mật khẩu StayTour'
  const html = `
    <p>Chào bạn,</p>
    <p>Bạn (hoặc ai đó) đã yêu cầu đặt lại mật khẩu. Bấm liên kết dưới đây để đặt mật khẩu mới:</p>
    <p><a href="${resetUrl}">Đặt lại mật khẩu</a></p>
    <p>Liên kết có hiệu lực trong 1 giờ. Nếu bạn không yêu cầu, hãy bỏ qua email này.</p>
  `

  if (!transporter) {
    console.log(`[MAILER dev] Gửi đặt lại mật khẩu tới ${to}: ${resetUrl}`)
    return true
  }

  await transporter.sendMail({ from, to, subject, html })
  return true
}
