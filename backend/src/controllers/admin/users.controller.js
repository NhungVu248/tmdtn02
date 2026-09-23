import bcrypt from 'bcryptjs'
import { prisma } from '../../lib/prisma.js'
import { logAdminAction } from '../../lib/auditLog.js'

const ACTIVE_BOOKING_STATUSES = ['PENDING_DEPOSIT', 'DEPOSITED', 'CONFIRMED']

// ---------- Khách hàng (User) — BR-95 khóa/mở khóa ----------

// UC-19 – Danh sách tài khoản khách hàng, lọc theo trạng thái.
export async function listCustomers(req, res, next) {
  try {
    const { status, search } = req.query
    const where = {}
    if (status === 'DISABLED') where.disabled = true
    if (status === 'ACTIVE') where.disabled = false
    if (search) {
      const s = String(search).trim()
      where.OR = [{ email: { contains: s } }, { name: { contains: s } }]
    }
    const items = await prisma.user.findMany({
      where,
      select: {
        id: true,
        email: true,
        name: true,
        phone: true,
        disabled: true,
        emailVerified: true,
        createdAt: true,
        _count: { select: { bookings: true } },
      },
      orderBy: { createdAt: 'desc' },
      take: 300,
    })
    res.json({ items })
  } catch (err) {
    next(err)
  }
}

// UC-19 – Chi tiết tài khoản khách hàng (kèm số đơn đang xử lý — dữ liệu cho 3a-1).
export async function getCustomer(req, res, next) {
  try {
    const id = Number(req.params.id)
    const user = await prisma.user.findUnique({
      where: { id },
      select: {
        id: true,
        email: true,
        name: true,
        phone: true,
        address: true,
        disabled: true,
        emailVerified: true,
        googleId: true,
        createdAt: true,
      },
    })
    if (!user) return res.status(404).json({ message: 'Không tìm thấy tài khoản' })

    const activeBookings = await prisma.booking.findMany({
      where: { userId: id, status: { in: ACTIVE_BOOKING_STATUSES } },
      select: { code: true, status: true, type: true },
    })
    res.json({ user, activeBookings })
  } catch (err) {
    next(err)
  }
}

// UC-19 (3/3a) – Khóa/mở khóa tài khoản khách hàng.
// Ngoại lệ 3a-1: đang có đơn xử lý -> chỉ cảnh báo, không tự động hủy đơn, vẫn cho khóa.
export async function setCustomerLock(req, res, next) {
  try {
    const id = Number(req.params.id)
    const { disabled } = req.body
    if (typeof disabled !== 'boolean') {
      return res.status(400).json({ message: 'Thiếu trạng thái khóa hợp lệ' })
    }
    const user = await prisma.user.findUnique({ where: { id } })
    if (!user) return res.status(404).json({ message: 'Không tìm thấy tài khoản' })

    let warning = null
    if (disabled) {
      const activeBookings = await prisma.booking.findMany({
        where: { userId: id, status: { in: ACTIVE_BOOKING_STATUSES } },
        select: { code: true, status: true },
      })
      if (activeBookings.length) {
        warning = {
          message: `Tài khoản đang có ${activeBookings.length} đơn đang xử lý. Đơn KHÔNG bị hủy tự động — vui lòng xử lý riêng nếu cần (UC-18).`,
          bookings: activeBookings,
        } // 3a-1
      }
    }

    const updated = await prisma.user.update({ where: { id }, data: { disabled } })
    await logAdminAction(req.admin.sub, disabled ? 'user.lock' : 'user.unlock', {
      entityType: 'User',
      entityId: id,
      detail: { email: user.email },
    })

    res.json({ user: { id: updated.id, disabled: updated.disabled }, warning })
  } catch (err) {
    next(err)
  }
}

// ---------- Quản trị viên (Admin) — BR-91/92/93/94 phân quyền ----------

function adminSummary(a) {
  return { id: a.id, username: a.username, name: a.name, role: a.role, active: a.active, createdAt: a.createdAt }
}

async function activeAdminCount(excludeId) {
  return prisma.admin.count({ where: { active: true, id: excludeId ? { not: excludeId } : undefined } })
}

// UC-19 – Danh sách tài khoản quản trị.
export async function listAdmins(req, res, next) {
  try {
    const { role, status, search } = req.query
    const where = {}
    if (role === 'SUPER_ADMIN' || role === 'MANAGER') where.role = role
    if (status === 'ACTIVE') where.active = true
    if (status === 'LOCKED') where.active = false
    if (search) where.username = { contains: String(search) }
    const items = await prisma.admin.findMany({ where, orderBy: { createdAt: 'asc' } })
    res.json({ items: items.map(adminSummary) })
  } catch (err) {
    next(err)
  }
}

// UC-19 (3b) – Tạo tài khoản quản trị mới (BR-93: nâng một người dùng lên vai trò quản trị
// bằng cách cấp một tài khoản quản trị riêng — khớp kiến trúc tách biệt User/Admin của UC-24/BR-67).
export async function createAdmin(req, res, next) {
  try {
    const { username, password, name, role } = req.body
    if (!username || !password) {
      return res.status(400).json({ message: 'Thiếu tài khoản hoặc mật khẩu' }) // 5a
    }
    if (role !== 'SUPER_ADMIN' && role !== 'MANAGER') {
      return res.status(400).json({ message: 'Vai trò không hợp lệ' })
    }
    if (String(password).length < 8) {
      return res.status(400).json({ message: 'Mật khẩu phải có ít nhất 8 ký tự' })
    }
    const dup = await prisma.admin.findUnique({ where: { username } })
    if (dup) return res.status(409).json({ message: 'Tài khoản quản trị đã tồn tại' })

    const admin = await prisma.admin.create({
      data: { username, password: await bcrypt.hash(password, 10), name: name || null, role },
    })
    await logAdminAction(req.admin.sub, 'admin.create', {
      entityType: 'Admin',
      entityId: admin.id,
      detail: { username, role },
    })
    res.status(201).json({ admin: adminSummary(admin) })
  } catch (err) {
    next(err)
  }
}

// UC-19 (3) – Thay đổi vai trò một tài khoản quản trị.
export async function updateAdminRole(req, res, next) {
  try {
    const id = Number(req.params.id)
    const { role } = req.body
    if (role !== 'SUPER_ADMIN' && role !== 'MANAGER') {
      return res.status(400).json({ message: 'Vai trò không hợp lệ' })
    }
    const admin = await prisma.admin.findUnique({ where: { id } })
    if (!admin) return res.status(404).json({ message: 'Không tìm thấy tài khoản quản trị' })

    // BR-94/4a: nếu đây là SUPER_ADMIN đang hoạt động cuối cùng bị hạ quyền, phải còn admin khác thay thế.
    if (admin.role === 'SUPER_ADMIN' && role !== 'SUPER_ADMIN' && admin.active) {
      const otherSuperAdmins = await prisma.admin.count({
        where: { role: 'SUPER_ADMIN', active: true, id: { not: id } },
      })
      if (otherSuperAdmins === 0) {
        return res.status(409).json({
          message: 'Không thể hạ quyền: đây là quản trị viên toàn quyền (SUPER_ADMIN) đang hoạt động cuối cùng.',
        }) // 4a
      }
    }

    const updated = await prisma.admin.update({ where: { id }, data: { role } })
    await logAdminAction(req.admin.sub, 'admin.role', {
      entityType: 'Admin',
      entityId: id,
      detail: { from: admin.role, to: role },
    })
    res.json({ admin: adminSummary(updated) })
  } catch (err) {
    next(err)
  }
}

// UC-19 (3a) – Khóa/mở khóa tài khoản quản trị.
// Ngoại lệ 4a: thao tác dẫn tới không còn quản trị viên nào đang hoạt động -> từ chối.
export async function setAdminActive(req, res, next) {
  try {
    const id = Number(req.params.id)
    const { active } = req.body
    if (typeof active !== 'boolean') {
      return res.status(400).json({ message: 'Thiếu trạng thái hợp lệ' })
    }
    const admin = await prisma.admin.findUnique({ where: { id } })
    if (!admin) return res.status(404).json({ message: 'Không tìm thấy tài khoản quản trị' })

    if (!active && admin.active) {
      // BR-94: luôn phải còn ít nhất 1 admin hoạt động (kể cả khi tự khóa chính mình).
      const others = await activeAdminCount(id)
      if (others === 0) {
        return res.status(409).json({
          message: 'Không thể khóa: đây là tài khoản quản trị đang hoạt động duy nhất còn lại.',
        }) // 4a
      }
    }

    const updated = await prisma.admin.update({ where: { id }, data: { active } })
    await logAdminAction(req.admin.sub, active ? 'admin.unlock' : 'admin.lock', {
      entityType: 'Admin',
      entityId: id,
      detail: { username: admin.username },
    })
    res.json({ admin: adminSummary(updated) })
  } catch (err) {
    next(err)
  }
}
