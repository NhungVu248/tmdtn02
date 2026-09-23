import { prisma } from '../../lib/prisma.js'

// UC-23 (4) – Nhật ký hệ thống: CHỈ ĐỌC (BR-116, không có route sửa/xóa nào được khai báo).
// Lọc theo loại sự kiện (tiền tố action, vd "order.", "config.") và khoảng thời gian.
export async function listAuditLogs(req, res, next) {
  try {
    const { action, from, to } = req.query
    const where = {}
    if (action) where.action = { startsWith: String(action) }
    if (from || to) {
      where.createdAt = {}
      if (from) where.createdAt.gte = new Date(String(from))
      if (to) where.createdAt.lte = new Date(new Date(String(to)).getTime() + 86400000)
    }

    const items = await prisma.adminAuditLog.findMany({
      where,
      include: { admin: { select: { username: true } } },
      orderBy: { createdAt: 'desc' },
      take: 300,
    })
    // BR-116: cũng liệt kê sự kiện đăng nhập (thành công/thất bại) bên cạnh nhật ký thao tác.
    const loginAttempts = await prisma.adminLoginAttempt.findMany({
      where: from || to ? { createdAt: where.createdAt } : {},
      orderBy: { createdAt: 'desc' },
      take: 100,
    })

    res.json({
      items: items.map((l) => ({
        id: l.id,
        type: 'ACTION',
        action: l.action,
        adminUsername: l.admin?.username,
        entityType: l.entityType,
        entityId: l.entityId,
        detail: l.detail,
        createdAt: l.createdAt,
      })),
      loginAttempts: loginAttempts.map((a) => ({
        id: a.id,
        type: 'LOGIN',
        username: a.username,
        success: a.success,
        reason: a.reason,
        ip: a.ip,
        createdAt: a.createdAt,
      })),
    })
  } catch (err) {
    next(err)
  }
}
