import { prisma } from './prisma.js'

// BR-78 (Nhóm D) – Ghi vết mọi thao tác quản trị. Không chặn luồng chính nếu ghi log lỗi.
export async function logAdminAction(adminId, action, { entityType, entityId, detail } = {}) {
  try {
    await prisma.adminAuditLog.create({
      data: {
        adminId,
        action,
        entityType,
        entityId,
        detail: detail ? (typeof detail === 'string' ? detail : JSON.stringify(detail)) : null,
      },
    })
  } catch (e) {
    console.error('Ghi nhật ký quản trị thất bại:', e)
  }
}
