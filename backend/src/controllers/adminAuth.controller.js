import bcrypt from 'bcryptjs'
import jwt from 'jsonwebtoken'
import { prisma } from '../lib/prisma.js'

const MAX_ATTEMPTS = 5 // BR-70
const LOCK_MINUTES = 15

function signAdminToken(admin) {
  return jwt.sign(
    { sub: admin.id, username: admin.username, role: admin.role, aud: 'admin' },
    process.env.ADMIN_JWT_SECRET || process.env.JWT_SECRET,
    { expiresIn: process.env.ADMIN_JWT_EXPIRES_IN || '8h' }, // phiên quản trị ngắn hơn Customer
  )
}

async function logAttempt(username, adminId, req, success, reason) {
  try {
    await prisma.adminLoginAttempt.create({ data: { username, adminId, ip: req.ip, success, reason } })
  } catch {
    // không để lỗi ghi log ảnh hưởng luồng đăng nhập
  }
}

// UC-24 – Đăng nhập quản trị. BR-67/68/69/70.
export async function adminLogin(req, res, next) {
  try {
    const { username, password } = req.body
    if (!username || !password) {
      return res.status(400).json({ message: 'Vui lòng nhập tài khoản và mật khẩu' })
    }

    const admin = await prisma.admin.findUnique({ where: { username } })

    // Không tồn tại: báo lỗi chung, không tiết lộ trường nào sai (BR như UC-06/BR-17 tương ứng).
    if (!admin) {
      await logAttempt(username, null, req, false, 'not_found')
      return res.status(401).json({ message: 'Sai tài khoản hoặc mật khẩu' }) // 3a
    }

    // BR-70/3c: đang bị tạm khóa.
    if (admin.lockedUntil && admin.lockedUntil > new Date()) {
      await logAttempt(username, admin.id, req, false, 'locked')
      const mins = Math.ceil((admin.lockedUntil - new Date()) / 60000)
      return res.status(423).json({
        message: `Tài khoản tạm khóa do đăng nhập sai nhiều lần. Vui lòng thử lại sau ${mins} phút.`,
        code: 'LOCKED',
      })
    }

    const valid = await bcrypt.compare(password, admin.password)
    if (!valid) {
      const attempts = admin.failedLoginAttempts + 1
      const data = { failedLoginAttempts: attempts }
      let locked = false
      if (attempts >= MAX_ATTEMPTS) {
        data.lockedUntil = new Date(Date.now() + LOCK_MINUTES * 60000)
        data.failedLoginAttempts = 0
        locked = true
      }
      await prisma.admin.update({ where: { id: admin.id }, data })
      await logAttempt(username, admin.id, req, false, 'wrong_password')
      if (locked) {
        return res.status(423).json({
          message: `Sai quá ${MAX_ATTEMPTS} lần. Tài khoản tạm khóa ${LOCK_MINUTES} phút.`,
          code: 'LOCKED',
        })
      }
      return res.status(401).json({ message: 'Sai tài khoản hoặc mật khẩu' }) // 3a
    }

    // BR-68/3b: tài khoản bị vô hiệu hóa (không còn quyền quản trị hoạt động).
    if (!admin.active) {
      await logAttempt(username, admin.id, req, false, 'inactive')
      return res.status(403).json({ message: 'Tài khoản không có quyền truy cập khu vực quản trị' }) // 3b
    }

    // Thành công: xóa bộ đếm, ghi vết (BR-78).
    await prisma.admin.update({ where: { id: admin.id }, data: { failedLoginAttempts: 0, lockedUntil: null } })
    await logAttempt(username, admin.id, req, true, null)

    const token = signAdminToken(admin)
    res.json({ token, admin: { id: admin.id, username: admin.username, name: admin.name, role: admin.role } })
  } catch (err) {
    next(err)
  }
}

// Thông tin quản trị viên hiện tại (khôi phục phiên khi tải lại trang /admin).
export async function adminMe(req, res, next) {
  try {
    const admin = await prisma.admin.findUnique({
      where: { id: req.admin.sub },
      select: { id: true, username: true, name: true, role: true, active: true },
    })
    if (!admin || !admin.active) {
      return res.status(401).json({ message: 'Phiên quản trị không hợp lệ' })
    }
    res.json({ admin })
  } catch (err) {
    next(err)
  }
}
