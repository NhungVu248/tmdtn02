import { prisma } from '../../lib/prisma.js'
import { logAdminAction } from '../../lib/auditLog.js'
import { publicUploadUrl } from '../../lib/uploads.js'
import { nightsBetween, parseUtcDate } from '../../lib/booking.js'

const ACTIVE_STATUSES = ['PENDING_DEPOSIT', 'DEPOSITED', 'CONFIRMED']
// Lưu ý: 'slug' KHÔNG bắt buộc — tự sinh từ 'name' nếu bỏ trống (xem createHomestay).
const REQUIRED_FIELDS = ['name', 'location', 'price']

function slugify(s) {
  return String(s)
    .toLowerCase()
    .normalize('NFD')
    .replace(/[̀-ͯ]/g, '')
    .replace(/đ/g, 'd')
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/(^-|-$)/g, '')
}

// UC-16 – Danh sách homestay (mọi trạng thái, kể cả đã ẩn) cho khu vực quản trị.
export async function listHomestays(req, res, next) {
  try {
    const { status, search } = req.query
    const where = { type: 'HOMESTAY' }
    if (status === 'VISIBLE' || status === 'HIDDEN') where.status = status
    if (search) where.name = { contains: String(search) }

    const items = await prisma.product.findMany({
      where,
      select: {
        id: true,
        name: true,
        slug: true,
        status: true,
        location: true,
        price: true,
        thumbnail: true,
        categoryId: true,
        category: { select: { name: true } },
        updatedAt: true,
      },
      orderBy: { updatedAt: 'desc' },
    })
    res.json({ items })
  } catch (err) {
    next(err)
  }
}

// UC-16 – Chi tiết một homestay (đầy đủ trường để chỉnh sửa).
export async function getHomestay(req, res, next) {
  try {
    const id = Number(req.params.id)
    const product = await prisma.product.findUnique({
      where: { id },
      include: { images: { orderBy: { order: 'asc' } }, category: true },
    })
    if (!product || product.type !== 'HOMESTAY') {
      return res.status(404).json({ message: 'Không tìm thấy homestay' })
    }
    res.json({ product })
  } catch (err) {
    next(err)
  }
}

function validatePayload(body) {
  for (const f of REQUIRED_FIELDS) {
    if (body[f] === undefined || body[f] === null || String(body[f]).trim() === '') {
      return `Thiếu trường bắt buộc: ${f}` // 5a
    }
  }
  if (Number.isNaN(Number(body.price)) || Number(body.price) < 0) {
    return 'Giá cơ bản không hợp lệ'
  }
  if (body.categoryId != null && Number.isNaN(Number(body.categoryId))) {
    return 'Danh mục không hợp lệ'
  }
  return null
}

// UC-16 – Tạo homestay mới.
export async function createHomestay(req, res, next) {
  try {
    const issue = validatePayload(req.body)
    if (issue) return res.status(400).json({ message: issue })

    const { name, description, location, price, categoryId, amenities, cancellationPolicy, thumbnail } = req.body
    let slug = req.body.slug ? slugify(req.body.slug) : slugify(name)
    if (!slug) return res.status(400).json({ message: 'Không tạo được đường dẫn (slug) hợp lệ từ tên' })

    const dup = await prisma.product.findUnique({ where: { slug } })
    if (dup) return res.status(409).json({ message: 'Đường dẫn (slug) đã tồn tại, vui lòng đổi tên hoặc slug khác' })

    const product = await prisma.product.create({
      data: {
        type: 'HOMESTAY',
        status: 'HIDDEN', // BR-73: mặc định ẩn, admin bật hiển thị sau khi kiểm tra xong
        name,
        slug,
        description: description || null,
        location,
        price: Number(price),
        categoryId: categoryId != null ? Number(categoryId) : null,
        amenities: Array.isArray(amenities) ? amenities.join(',') : amenities || null,
        cancellationPolicy: cancellationPolicy || null,
        thumbnail: thumbnail || null,
      },
    })

    await logAdminAction(req.admin.sub, 'product.create', {
      entityType: 'Product',
      entityId: product.id,
      detail: { name: product.name, slug: product.slug },
    })

    res.status(201).json({ product })
  } catch (err) {
    next(err)
  }
}

// UC-16 – Cập nhật thông tin homestay.
export async function updateHomestay(req, res, next) {
  try {
    const id = Number(req.params.id)
    const existing = await prisma.product.findUnique({ where: { id } })
    if (!existing || existing.type !== 'HOMESTAY') {
      return res.status(404).json({ message: 'Không tìm thấy homestay' })
    }

    const merged = { ...existing, ...req.body }
    const issue = validatePayload(merged)
    if (issue) return res.status(400).json({ message: issue })

    const data = {
      name: req.body.name,
      description: req.body.description ?? null,
      location: req.body.location,
      price: Number(req.body.price),
      categoryId: req.body.categoryId != null ? Number(req.body.categoryId) : null,
      amenities: Array.isArray(req.body.amenities) ? req.body.amenities.join(',') : req.body.amenities ?? null,
      cancellationPolicy: req.body.cancellationPolicy ?? null,
    }
    if (req.body.thumbnail !== undefined) data.thumbnail = req.body.thumbnail

    if (req.body.slug) {
      const slug = slugify(req.body.slug)
      if (slug !== existing.slug) {
        const dup = await prisma.product.findUnique({ where: { slug } })
        if (dup) return res.status(409).json({ message: 'Đường dẫn (slug) đã tồn tại' })
        data.slug = slug
      }
    }

    const product = await prisma.product.update({ where: { id }, data })
    await logAdminAction(req.admin.sub, 'product.update', { entityType: 'Product', entityId: id, detail: data })

    res.json({ product })
  } catch (err) {
    next(err)
  }
}

// UC-16 (2a) – Hiển thị/gỡ hiển thị (không xóa, giữ lịch sử đơn — BR-73).
// BR-75: nếu gỡ hiển thị mà còn đơn tương lai hợp lệ, vẫn cho phép nhưng CẢNH BÁO admin.
export async function setVisibility(req, res, next) {
  try {
    const id = Number(req.params.id)
    const { status } = req.body
    if (status !== 'VISIBLE' && status !== 'HIDDEN') {
      return res.status(400).json({ message: 'Trạng thái không hợp lệ' })
    }
    const existing = await prisma.product.findUnique({ where: { id } })
    if (!existing || existing.type !== 'HOMESTAY') {
      return res.status(404).json({ message: 'Không tìm thấy homestay' })
    }

    let warning = null
    if (status === 'HIDDEN') {
      const today = new Date(Date.UTC(new Date().getUTCFullYear(), new Date().getUTCMonth(), new Date().getUTCDate()))
      const futureBookings = await prisma.booking.findMany({
        where: { productId: id, type: 'HOMESTAY', status: { in: ACTIVE_STATUSES }, checkOut: { gte: today } },
        select: { code: true, checkIn: true, checkOut: true },
      })
      if (futureBookings.length) {
        warning = {
          message: `Homestay vẫn còn ${futureBookings.length} đơn hợp lệ trong tương lai. Các đơn này không bị ảnh hưởng, nhưng homestay sẽ không còn hiển thị để đặt mới.`,
          bookings: futureBookings,
        }
      }
    }

    const product = await prisma.product.update({ where: { id }, data: { status } })
    await logAdminAction(req.admin.sub, status === 'HIDDEN' ? 'product.hide' : 'product.show', {
      entityType: 'Product',
      entityId: id,
    })

    res.json({ product, warning })
  } catch (err) {
    next(err)
  }
}

// UC-16 – Gắn ảnh đã tải lên (upload trước qua /api/admin/uploads) vào homestay.
export async function addImage(req, res, next) {
  try {
    const id = Number(req.params.id)
    const { filename, order } = req.body
    const product = await prisma.product.findUnique({ where: { id } })
    if (!product || product.type !== 'HOMESTAY') {
      return res.status(404).json({ message: 'Không tìm thấy homestay' })
    }
    if (!filename) return res.status(400).json({ message: 'Thiếu tên tệp ảnh' })

    const url = publicUploadUrl(filename)
    const image = await prisma.productImage.create({ data: { productId: id, url, order: order ?? 0 } })
    if (!product.thumbnail) {
      await prisma.product.update({ where: { id }, data: { thumbnail: url } })
    }
    await logAdminAction(req.admin.sub, 'product.image.add', { entityType: 'Product', entityId: id, detail: { url } })

    res.status(201).json({ image })
  } catch (err) {
    next(err)
  }
}

export async function removeImage(req, res, next) {
  try {
    const id = Number(req.params.id)
    const imageId = Number(req.params.imageId)
    await prisma.productImage.deleteMany({ where: { id: imageId, productId: id } })
    await logAdminAction(req.admin.sub, 'product.image.remove', { entityType: 'Product', entityId: id, detail: { imageId } })
    res.json({ ok: true })
  } catch (err) {
    next(err)
  }
}

// ---------- Lịch tồn phòng (BR-74) ----------

// Xem lịch tồn phòng trong khoảng ngày; điền mặc định cho ngày chưa có bản ghi (chưa lưu).
export async function getAvailability(req, res, next) {
  try {
    const id = Number(req.params.id)
    const { from, to } = req.query
    const product = await prisma.product.findUnique({ where: { id } })
    if (!product || product.type !== 'HOMESTAY') {
      return res.status(404).json({ message: 'Không tìm thấy homestay' })
    }
    const days = nightsBetween(from, to)
    if (!days || !days.length) return res.status(400).json({ message: 'Khoảng ngày không hợp lệ' })

    const rows = await prisma.homestayAvailability.findMany({
      where: { productId: id, date: { gte: days[0], lte: days[days.length - 1] } },
    })
    const byTime = new Map(rows.map((r) => [new Date(r.date).getTime(), r]))

    const calendar = days.map((d) => {
      const row = byTime.get(d.getTime())
      return {
        date: d,
        totalRooms: row?.totalRooms ?? 0,
        bookedRooms: row?.bookedRooms ?? 0,
        priceOverride: row?.priceOverride ?? null,
        saved: Boolean(row),
      }
    })
    res.json({ basePrice: product.price, calendar })
  } catch (err) {
    next(err)
  }
}

// Kiểm tra xung đột: ngày nào trong danh sách sẽ có totalRooms mới < số đang giữ (BR-75/2a-1).
async function findConflicts(productId, dates, newTotalRooms) {
  const rows = await prisma.homestayAvailability.findMany({ where: { productId, date: { in: dates } } })
  const conflictDates = rows.filter((r) => r.bookedRooms > newTotalRooms).map((r) => new Date(r.date))
  if (!conflictDates.length) return null

  const minD = new Date(Math.min(...conflictDates.map((d) => d.getTime())))
  const maxD = new Date(Math.max(...conflictDates.map((d) => d.getTime())) + 86400000)
  const bookings = await prisma.booking.findMany({
    where: {
      productId,
      type: 'HOMESTAY',
      status: { in: ACTIVE_STATUSES },
      checkOut: { gt: minD },
      checkIn: { lt: maxD },
    },
    select: { code: true, checkIn: true, checkOut: true, status: true },
  })
  return { conflictDates, bookings }
}

// UC-16 (4a) – Thiết lập lịch tồn phòng cho một khoảng ngày: mở/chặn + giá riêng.
// BR-75/2a-1: từ chối nếu làm mất hiệu lực đơn đang giữ chỗ hợp lệ trong khoảng đó.
export async function setAvailability(req, res, next) {
  try {
    const id = Number(req.params.id)
    const { from, to, totalRooms, priceOverride } = req.body
    const product = await prisma.product.findUnique({ where: { id } })
    if (!product || product.type !== 'HOMESTAY') {
      return res.status(404).json({ message: 'Không tìm thấy homestay' })
    }
    const days = nightsBetween(from, to)
    if (!days || !days.length) return res.status(400).json({ message: 'Khoảng ngày không hợp lệ' })
    const rooms = Number(totalRooms)
    if (!Number.isInteger(rooms) || rooms < 0) {
      return res.status(400).json({ message: 'Số phòng không hợp lệ' }) // 5a
    }

    const conflict = await findConflicts(id, days, rooms)
    if (conflict) {
      return res.status(409).json({
        message: 'Không thể áp dụng: một số ngày trong khoảng này đang có đơn hợp lệ vượt quá số phòng mới. Vui lòng xử lý các đơn liên quan trước (UC-18).',
        conflictDates: conflict.conflictDates,
        bookings: conflict.bookings,
      })
    }

    const price = priceOverride === '' || priceOverride == null ? null : Number(priceOverride)
    await prisma.$transaction(
      days.map((d) =>
        prisma.homestayAvailability.upsert({
          where: { productId_date: { productId: id, date: d } },
          create: { productId: id, date: d, totalRooms: rooms, priceOverride: price },
          update: { totalRooms: rooms, priceOverride: price },
        }),
      ),
    )

    await logAdminAction(req.admin.sub, 'availability.set', {
      entityType: 'Product',
      entityId: id,
      detail: { from, to, totalRooms: rooms, priceOverride: price },
    })

    res.json({ ok: true, days: days.length })
  } catch (err) {
    next(err)
  }
}
