import { prisma } from '../../lib/prisma.js'
import { logAdminAction } from '../../lib/auditLog.js'

// UC-14/UC-23 – Quản lý Chính sách hủy dùng chung (CancellationPolicy + PolicyMilestone).
// Mỗi chính sách: miễn phí hủy trong freeHours giờ đầu, sau đó hoàn theo các mốc
// (hủy trước >= daysBefore ngày -> hoàn refundRate%). Tour/Homestay gắn 1 chính sách;
// không gắn (null) thì dùng cấu hình mặc định ở trang Phương thức thanh toán & phí.

const str = (v) => (v != null && String(v).trim() !== '' ? String(v).trim() : null)
const clampRate = (v) => Math.max(0, Math.min(100, Math.round(Number(v) || 0)))

// Chuẩn hóa + sắp xếp mốc hoàn tiền (daysBefore giảm dần), loại mốc không hợp lệ, gộp trùng ngày.
function normalizeMilestones(input) {
  if (!Array.isArray(input)) return []
  const byDays = new Map()
  for (const m of input) {
    const days = Math.max(0, Math.round(Number(m?.daysBefore) || 0))
    const rate = clampRate(m?.refundRate)
    byDays.set(days, rate) // mốc sau ghi đè mốc trước nếu trùng số ngày
  }
  return [...byDays.entries()]
    .map(([daysBefore, refundRate]) => ({ daysBefore, refundRate }))
    .sort((a, b) => b.daysBefore - a.daysBefore)
}

function shape(p) {
  return {
    id: p.id,
    name: p.name,
    isRefundable: p.isRefundable,
    freeHours: p.freeHours,
    milestones: (p.milestones ?? []).map((m) => ({ daysBefore: m.daysBefore, refundRate: m.refundRate })),
    usage: p._count ? p._count.tours + p._count.properties + p._count.products : undefined,
    createdAt: p.createdAt,
    updatedAt: p.updatedAt,
  }
}

// Danh sách chính sách + số dịch vụ đang dùng mỗi chính sách.
export async function listPolicies(req, res, next) {
  try {
    const rows = await prisma.cancellationPolicy.findMany({
      orderBy: { id: 'asc' },
      include: {
        milestones: { orderBy: { daysBefore: 'desc' } },
        _count: { select: { tours: true, properties: true, products: true } },
      },
    })
    res.json({ items: rows.map(shape) })
  } catch (err) {
    next(err)
  }
}

export async function createPolicy(req, res, next) {
  try {
    const name = str(req.body.name)
    if (!name) return res.status(400).json({ message: 'Thiếu tên chính sách' })
    const isRefundable = req.body.isRefundable !== false
    const freeHours = Math.max(0, Math.round(Number(req.body.freeHours) || 0))
    const milestones = isRefundable ? normalizeMilestones(req.body.milestones) : []

    const policy = await prisma.cancellationPolicy.create({
      data: { name, isRefundable, freeHours, milestones: { create: milestones } },
      include: { milestones: { orderBy: { daysBefore: 'desc' } } },
    })
    await logAdminAction(req.admin.sub, 'cancellationPolicy.create', { entityType: 'CancellationPolicy', entityId: policy.id, detail: { name } })
    res.status(201).json({ policy: shape(policy) })
  } catch (err) {
    next(err)
  }
}

export async function updatePolicy(req, res, next) {
  try {
    const id = Number(req.params.id)
    const existing = await prisma.cancellationPolicy.findUnique({ where: { id } })
    if (!existing) return res.status(404).json({ message: 'Không tìm thấy chính sách' })

    const data = {}
    if (req.body.name !== undefined) {
      const name = str(req.body.name)
      if (!name) return res.status(400).json({ message: 'Tên chính sách không được trống' })
      data.name = name
    }
    if (req.body.isRefundable !== undefined) data.isRefundable = req.body.isRefundable !== false
    if (req.body.freeHours !== undefined) data.freeHours = Math.max(0, Math.round(Number(req.body.freeHours) || 0))

    const willRefund = data.isRefundable ?? existing.isRefundable
    // Thay toàn bộ mốc khi gửi kèm milestones (hoặc khi chuyển sang không hoàn tiền -> xóa hết mốc).
    const replaceMilestones = req.body.milestones !== undefined || data.isRefundable === false
    const milestones = willRefund && req.body.milestones !== undefined ? normalizeMilestones(req.body.milestones) : []

    await prisma.$transaction(async (tx) => {
      await tx.cancellationPolicy.update({ where: { id }, data })
      if (replaceMilestones) {
        await tx.policyMilestone.deleteMany({ where: { policyId: id } })
        if (milestones.length) await tx.policyMilestone.createMany({ data: milestones.map((m) => ({ ...m, policyId: id })) })
      }
    })

    const policy = await prisma.cancellationPolicy.findUnique({ where: { id }, include: { milestones: { orderBy: { daysBefore: 'desc' } } } })
    await logAdminAction(req.admin.sub, 'cancellationPolicy.update', { entityType: 'CancellationPolicy', entityId: id })
    res.json({ policy: shape(policy) })
  } catch (err) {
    next(err)
  }
}

// Xóa chính sách: gỡ gắn kết khỏi tour/homestay/sản phẩm (chuyển về cấu hình mặc định) rồi xóa.
export async function deletePolicy(req, res, next) {
  try {
    const id = Number(req.params.id)
    if (!(await prisma.cancellationPolicy.findUnique({ where: { id } }))) return res.status(404).json({ message: 'Không tìm thấy chính sách' })

    const [tours, props, products] = await prisma.$transaction([
      prisma.tour.updateMany({ where: { cancellationPolicyId: id }, data: { cancellationPolicyId: null } }),
      prisma.property.updateMany({ where: { cancellationPolicyId: id }, data: { cancellationPolicyId: null } }),
      prisma.product.updateMany({ where: { cancellationPolicyId: id }, data: { cancellationPolicyId: null } }),
    ])
    await prisma.cancellationPolicy.delete({ where: { id } }) // milestones cascade theo schema

    const detached = tours.count + props.count + products.count
    await logAdminAction(req.admin.sub, 'cancellationPolicy.delete', { entityType: 'CancellationPolicy', entityId: id, detail: { detached } })
    res.json({ ok: true, detached })
  } catch (err) {
    next(err)
  }
}
