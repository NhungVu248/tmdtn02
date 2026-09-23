import bcrypt from 'bcryptjs'
import jwt from 'jsonwebtoken'
import { prisma } from '../lib/prisma.js'
import {
  createResetToken,
  createAndSendVerification,
  devVerifyUrl,
  hashToken,
  sendReset,
} from '../lib/verification.js'
import { verifyGoogleIdToken } from '../lib/google.js'

const MAX_ATTEMPTS = 5 // BR-16
const LOCK_MINUTES = 15
const REQUIRE_VERIFICATION = process.env.REQUIRE_EMAIL_VERIFICATION !== 'false'

async function logLoginAttempt(email, req, success) {
  try {
    await prisma.loginAttempt.create({ data: { email, ip: req.ip, success } })
  } catch {
    // không để lỗi ghi log ảnh hưởng luồng đăng nhập
  }
}

const publicUser = (u) => ({
  id: u.id,
  email: u.email,
  name: u.name,
  phone: u.phone,
  address: u.address,
  avatar: u.avatar,
  emailVerified: u.emailVerified,
})

const PHONE_RE = /^[0-9+\-\s().]{8,15}$/

function signToken(user) {
  return jwt.sign(
    { sub: user.id, email: user.email },
    process.env.JWT_SECRET,
    { expiresIn: process.env.JWT_EXPIRES_IN || '7d' },
  )
}

const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/

// BR-13/3b: kiểm tra độ mạnh mật khẩu (>=8 ký tự, có chữ và số).
function passwordIssue(password) {
  if (!password || password.length < 8) return 'Mật khẩu phải có ít nhất 8 ký tự'
  if (!/[a-zA-Z]/.test(password) || !/[0-9]/.test(password)) {
    return 'Mật khẩu phải gồm cả chữ và số'
  }
  return null
}

// UC-05 – Đăng ký tài khoản.
export async function register(req, res, next) {
  try {
    const { email, password, confirmPassword, name, acceptedTerms } = req.body

    // Kiểm tra hợp lệ (bước 3).
    if (!email || !password) {
      return res.status(400).json({ message: 'Email và mật khẩu là bắt buộc' })
    }
    if (!EMAIL_RE.test(email)) {
      return res.status(400).json({ message: 'Định dạng email không hợp lệ' })
    }
    const pwIssue = passwordIssue(password) // 3b
    if (pwIssue) {
      return res.status(400).json({ message: pwIssue })
    }
    if (confirmPassword !== undefined && confirmPassword !== password) {
      return res.status(400).json({ message: 'Xác nhận mật khẩu không khớp' }) // 3b
    }
    if (!acceptedTerms) {
      return res
        .status(400)
        .json({ message: 'Bạn cần đồng ý điều khoản sử dụng và chính sách bảo vệ dữ liệu cá nhân' }) // BR-14
    }

    // BR-12: mỗi email một tài khoản. Ngoại lệ 3a.
    const existing = await prisma.user.findUnique({ where: { email } })
    if (existing) {
      return res.status(409).json({
        message: 'Email đã được sử dụng. Vui lòng đăng nhập hoặc khôi phục mật khẩu.',
        code: 'EMAIL_EXISTS',
      })
    }

    // BR-13: băm mật khẩu bằng bcrypt.
    const hashed = await bcrypt.hash(password, 10)
    const user = await prisma.user.create({
      data: { email, password: hashed, name, acceptedTerms: true, emailVerified: false },
    })

    // Gửi email xác thực (bước 4). Ngoại lệ 4a: gửi lỗi -> vẫn tạo tài khoản, cho gửi lại.
    try {
      const url = await createAndSendVerification(user)
      return res.status(201).json({
        message: 'Đăng ký thành công. Vui lòng kiểm tra email để kích hoạt tài khoản.',
        emailSent: true,
        email: user.email,
        devVerifyUrl: devVerifyUrl(url),
      })
    } catch (mailErr) {
      console.error('Gửi email xác thực thất bại:', mailErr)
      return res.status(201).json({
        message: 'Tạo tài khoản thành công nhưng chưa gửi được email xác thực. Vui lòng thử gửi lại.',
        emailSent: false,
        email: user.email,
      })
    }
  } catch (err) {
    next(err)
  }
}

// UC-05 – Xác thực email qua token (bước 5-6).
export async function verifyEmail(req, res, next) {
  try {
    const token = (req.body && req.body.token) || req.query.token
    if (!token) {
      return res.status(400).json({ message: 'Thiếu mã xác thực' })
    }

    const record = await prisma.emailVerificationToken.findUnique({
      where: { tokenHash: hashToken(String(token)) },
      include: { user: true },
    })
    if (!record || record.usedAt || record.expiresAt < new Date()) {
      return res.status(400).json({ message: 'Liên kết xác thực không hợp lệ hoặc đã hết hạn' })
    }

    await prisma.$transaction([
      prisma.user.update({ where: { id: record.userId }, data: { emailVerified: true } }),
      prisma.emailVerificationToken.update({ where: { id: record.id }, data: { usedAt: new Date() } }),
    ])

    res.json({ message: 'Xác thực email thành công. Bạn có thể đăng nhập.', email: record.user.email })
  } catch (err) {
    next(err)
  }
}

// UC-05 – Gửi lại email xác thực (5a / 4a). Không tiết lộ email có tồn tại hay không.
export async function resendVerification(req, res, next) {
  try {
    const { email } = req.body
    if (!email || !EMAIL_RE.test(email)) {
      return res.status(400).json({ message: 'Định dạng email không hợp lệ' })
    }

    const user = await prisma.user.findUnique({ where: { email } })
    const generic = { message: 'Nếu email hợp lệ và chưa xác thực, chúng tôi đã gửi lại liên kết kích hoạt.' }

    if (!user || user.emailVerified) {
      return res.json(generic)
    }

    try {
      const url = await createAndSendVerification(user)
      return res.json({ ...generic, devVerifyUrl: devVerifyUrl(url) })
    } catch (mailErr) {
      console.error('Gửi lại email xác thực thất bại:', mailErr)
      return res.status(502).json({ message: 'Không gửi được email xác thực. Vui lòng thử lại sau.' })
    }
  } catch (err) {
    next(err)
  }
}

// UC-05 (1a) / UC-06 (1b) – Đăng ký/đăng nhập bằng Google (một nút gộp).
export async function googleAuth(req, res, next) {
  try {
    const { credential } = req.body
    if (!credential) {
      return res.status(400).json({ message: 'Thiếu Google credential' })
    }

    const profile = await verifyGoogleIdToken(credential)
    if (!profile.email) {
      return res.status(400).json({ message: 'Không lấy được email từ tài khoản Google' })
    }

    // Tìm theo googleId, sau đó theo email để liên kết tài khoản sẵn có.
    let user = await prisma.user.findUnique({ where: { googleId: profile.googleId } })
    let isNew = false

    if (!user) {
      const byEmail = await prisma.user.findUnique({ where: { email: profile.email } })
      if (byEmail) {
        // Liên kết tài khoản email hiện có với Google.
        user = await prisma.user.update({
          where: { id: byEmail.id },
          data: {
            googleId: profile.googleId,
            avatar: byEmail.avatar || profile.avatar,
            emailVerified: byEmail.emailVerified || profile.emailVerified,
          },
        })
      } else {
        // Tạo tài khoản mới qua Google (không mật khẩu, email đã xác thực bởi Google).
        user = await prisma.user.create({
          data: {
            email: profile.email,
            name: profile.name,
            avatar: profile.avatar,
            googleId: profile.googleId,
            emailVerified: profile.emailVerified,
            acceptedTerms: true, // đồng ý điều khoản qua luồng đăng ký Google (BR-14)
          },
        })
        isNew = true
      }
    }

    // UC-19/BR-95: tài khoản bị quản trị viên khóa cũng không được đăng nhập qua Google.
    if (user.disabled) {
      return res.status(423).json({ message: 'Tài khoản đã bị khóa. Vui lòng liên hệ hỗ trợ.', code: 'DISABLED' })
    }

    const token = signToken(user)
    res.json({ token, user: publicUser(user), isNew })
  } catch (err) {
    if (err.status) return res.status(err.status).json({ message: err.message })
    return res.status(401).json({ message: 'Xác thực Google thất bại' })
  }
}

export async function login(req, res, next) {
  try {
    const { email, password } = req.body

    if (!email || !password) {
      return res.status(400).json({ message: 'Email và mật khẩu là bắt buộc' })
    }

    const user = await prisma.user.findUnique({ where: { email } })

    // Không tồn tại, hoặc tài khoản Google (không có mật khẩu): báo lỗi chung (BR-17).
    if (!user || !user.password) {
      await logLoginAttempt(email, req, false)
      return res.status(401).json({ message: 'Sai email hoặc mật khẩu' })
    }

    // UC-19/BR-95: tài khoản bị quản trị viên khóa (khác với tạm khóa tự động do sai mật khẩu).
    if (user.disabled) {
      await logLoginAttempt(email, req, false)
      return res.status(423).json({ message: 'Tài khoản đã bị khóa. Vui lòng liên hệ hỗ trợ.', code: 'DISABLED' })
    }

    // BR-16/2b: đang bị tạm khóa.
    if (user.lockedUntil && user.lockedUntil > new Date()) {
      await logLoginAttempt(email, req, false)
      const mins = Math.ceil((user.lockedUntil - new Date()) / 60000)
      return res.status(423).json({
        message: `Tài khoản tạm khóa do đăng nhập sai nhiều lần. Vui lòng thử lại sau ${mins} phút.`,
        code: 'LOCKED',
      })
    }

    const valid = await bcrypt.compare(password, user.password)
    if (!valid) {
      const attempts = user.failedLoginAttempts + 1
      const data = { failedLoginAttempts: attempts }
      let locked = false
      if (attempts >= MAX_ATTEMPTS) {
        data.lockedUntil = new Date(Date.now() + LOCK_MINUTES * 60000)
        data.failedLoginAttempts = 0
        locked = true
      }
      await prisma.user.update({ where: { id: user.id }, data })
      await logLoginAttempt(email, req, false)
      if (locked) {
        return res.status(423).json({
          message: `Bạn đã đăng nhập sai quá ${MAX_ATTEMPTS} lần. Tài khoản tạm khóa ${LOCK_MINUTES} phút.`,
          code: 'LOCKED',
        })
      }
      return res.status(401).json({ message: 'Sai email hoặc mật khẩu' }) // BR-17
    }

    // 2c: chưa xác thực email (tùy cấu hình BR-15).
    if (REQUIRE_VERIFICATION && !user.emailVerified) {
      await logLoginAttempt(email, req, false)
      return res.status(403).json({
        message: 'Tài khoản chưa xác thực email. Vui lòng kiểm tra email hoặc gửi lại liên kết xác thực.',
        code: 'EMAIL_NOT_VERIFIED',
        email: user.email,
      })
    }

    // Thành công: xóa bộ đếm/khóa.
    await prisma.user.update({
      where: { id: user.id },
      data: { failedLoginAttempts: 0, lockedUntil: null },
    })
    await logLoginAttempt(email, req, true)

    const token = signToken(user)
    res.json({ token, user: publicUser(user) })
  } catch (err) {
    next(err)
  }
}

// UC-06 (1a) – Quên mật khẩu: gửi email đặt lại. Không tiết lộ email có tồn tại hay không.
export async function forgotPassword(req, res, next) {
  try {
    const { email } = req.body
    if (!email || !EMAIL_RE.test(email)) {
      return res.status(400).json({ message: 'Định dạng email không hợp lệ' })
    }
    const user = await prisma.user.findUnique({ where: { email } })
    const generic = { message: 'Nếu email tồn tại, chúng tôi đã gửi liên kết đặt lại mật khẩu.' }

    // Chỉ gửi cho tài khoản có mật khẩu (tài khoản Google không đặt lại tại đây).
    if (!user || !user.password) {
      return res.json(generic)
    }
    // Tạo token nhanh (DB), phản hồi ngay; gửi email ở nền để không treo request.
    const url = await createResetToken(user)
    sendReset(user.email, url).catch((e) => console.error('Gửi email đặt lại thất bại:', e))
    return res.json({ ...generic, devResetUrl: devVerifyUrl(url) })
  } catch (err) {
    next(err)
  }
}

// UC-06 (1a) – Đặt lại mật khẩu bằng token.
export async function resetPassword(req, res, next) {
  try {
    const { token, password } = req.body
    if (!token) {
      return res.status(400).json({ message: 'Thiếu mã đặt lại mật khẩu' })
    }
    const issue = passwordIssue(password)
    if (issue) {
      return res.status(400).json({ message: issue })
    }

    const record = await prisma.passwordResetToken.findUnique({
      where: { tokenHash: hashToken(String(token)) },
    })
    if (!record || record.usedAt || record.expiresAt < new Date()) {
      return res.status(400).json({ message: 'Liên kết đặt lại không hợp lệ hoặc đã hết hạn' })
    }

    const hashed = await bcrypt.hash(password, 10)
    await prisma.$transaction([
      prisma.user.update({
        where: { id: record.userId },
        data: { password: hashed, failedLoginAttempts: 0, lockedUntil: null },
      }),
      prisma.passwordResetToken.update({ where: { id: record.id }, data: { usedAt: new Date() } }),
    ])

    res.json({ message: 'Đặt lại mật khẩu thành công. Bạn có thể đăng nhập.' })
  } catch (err) {
    next(err)
  }
}

export async function me(req, res, next) {
  try {
    const user = await prisma.user.findUnique({
      where: { id: req.user.sub },
      select: {
        id: true,
        email: true,
        name: true,
        phone: true,
        address: true,
        avatar: true,
        emailVerified: true,
        createdAt: true,
      },
    })
    if (!user) {
      return res.status(404).json({ message: 'Không tìm thấy người dùng' })
    }
    res.json({ user })
  } catch (err) {
    next(err)
  }
}

// UC-07 – Cập nhật hồ sơ cá nhân (BR-20: chỉ chủ tài khoản đã đăng nhập).
export async function updateProfile(req, res, next) {
  try {
    const { name, phone, address } = req.body

    if (phone && !PHONE_RE.test(phone)) {
      return res.status(400).json({ message: 'Số điện thoại không hợp lệ (8–15 chữ số)' }) // 3a
    }

    const data = {}
    if (name !== undefined) data.name = name || null
    if (phone !== undefined) data.phone = phone || null
    if (address !== undefined) data.address = address || null

    const user = await prisma.user.update({ where: { id: req.user.sub }, data })
    res.json({ user: publicUser(user) })
  } catch (err) {
    next(err)
  }
}

// UC-07 (2a) – Đổi mật khẩu (BR-21: xác minh mật khẩu hiện tại; băm mật khẩu mới).
export async function changePassword(req, res, next) {
  try {
    const { currentPassword, newPassword } = req.body

    const issue = passwordIssue(newPassword)
    if (issue) {
      return res.status(400).json({ message: issue })
    }

    const user = await prisma.user.findUnique({ where: { id: req.user.sub } })
    if (!user) {
      return res.status(404).json({ message: 'Không tìm thấy người dùng' })
    }
    // Tài khoản Google chưa có mật khẩu: dùng "quên mật khẩu" để tạo mật khẩu.
    if (!user.password) {
      return res.status(400).json({
        message: 'Tài khoản đăng nhập bằng Google. Dùng "Quên mật khẩu" để đặt mật khẩu.',
      })
    }

    const ok = await bcrypt.compare(currentPassword || '', user.password)
    if (!ok) {
      return res.status(400).json({ message: 'Mật khẩu hiện tại không đúng' }) // 2a-1
    }

    const hashed = await bcrypt.hash(newPassword, 10)
    await prisma.user.update({ where: { id: user.id }, data: { password: hashed } })
    res.json({ message: 'Đổi mật khẩu thành công' })
  } catch (err) {
    next(err)
  }
}
