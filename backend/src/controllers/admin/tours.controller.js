import { prisma } from '../../lib/prisma.js'
import { logAdminAction } from '../../lib/auditLog.js'
import { publicUploadUrl } from '../../lib/uploads.js'
import { parseUtcDate } from '../../lib/booking.js'

const ACTIVE_STATUSES = ['PENDING_DEPOSIT', 'DEPOSITED', 'CONFIRMED']
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

// UC-17 – Danh sách tour (mọi trạng thái) cho khu vực quản trị.
export async function listTours(req, res, next) {
  try {
    const { status, search } = req.query
    const where = { type: 'TOUR' }
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
        priceChild: true,
        durationDays: true,
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

export async function getTour(req, res, next) {
  try {
    const id = Number(req.params.id)
    const product = await prisma.product.findUnique({
      where: { id },
      include: {
        images: { orderBy: { order: 'asc' } },
        category: true,
        departures: { orderBy: { date: 'asc' } },
      },
    })
    if (!product || product.type !== 'TOUR') {
      return res.status(404).json({ message: 'Không tìm thấy tour' })
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
    return 'Giá người lớn không hợp lệ'
  }
  if (body.priceChild != null && (Number.isNaN(Number(body.priceChild)) || Number(body.priceChild) < 0)) {
    return 'Giá trẻ em không hợp lệ'
  }
  if (body.durationDays != null && (!Number.isInteger(Number(body.durationDays)) || Number(body.durationDays) < 1)) {
    return 'Thời lượng (số ngày) không hợp lệ'
  }
  return null
}

// UC-17 – Tạo tour mới.
export async function createTour(req, res, next) {
  try {
    const issue = validatePayload(req.body)
    if (issue) return res.status(400).json({ message: issue })

    const {
      name,
      description,
      location,
      price,
      priceChild,
      durationDays,
      categoryId,
      itinerary,
      included,
      excluded,
      cancellationPolicy,
      thumbnail,
    } = req.body
    let slug = req.body.slug ? slugify(req.body.slug) : slugify(name)
    if (!slug) return res.status(400).json({ message: 'Không tạo được đường dẫn (slug) hợp lệ từ tên' })

    const dup = await prisma.product.findUnique({ where: { slug } })
    if (dup) return res.status(409).json({ message: 'Đường dẫn (slug) đã tồn tại, vui lòng đổi tên hoặc slug khác' })

    const product = await prisma.product.create({
      data: {
        type: 'TOUR',
        status: 'HIDDEN', // BR-79: mặc định ẩn, admin bật hiển thị sau khi kiểm tra xong
        name,
        slug,
        description: description || null,
        location,
        price: Number(price),
        priceChild: priceChild != null && priceChild !== '' ? Number(priceChild) : null,
        durationDays: durationDays != null && durationDays !== '' ? Number(durationDays) : null,
        categoryId: categoryId != null ? Number(categoryId) : null,
        itinerary: itinerary || null,
        included: included || null,
        excluded: excluded || null,
        cancellationPolicy: cancellationPolicy || null,
        thumbnail: thumbnail || null,
      },
    })

    await logAdminAction(req.admin.sub, 'tour.create', {
      entityType: 'Product',
      entityId: product.id,
      detail: { name: product.name, slug: product.slug },
    })

    res.status(201).json({ product })
  } catch (err) {
    next(err)
  }
}

// UC-17 – Cập nhật thông tin tour.
export async function updateTour(req, res, next) {
  try {
    const id = Number(req.params.id)
    const existing = await prisma.product.findUnique({ where: { id } })
    if (!existing || existing.type !== 'TOUR') {
      return res.status(404).json({ message: 'Không tìm thấy tour' })
    }

    const merged = { ...existing, ...req.body }
    const issue = validatePayload(merged)
    if (issue) return res.status(400).json({ message: issue })

    const data = {
      name: req.body.name,
      description: req.body.description ?? null,
      location: req.body.location,
      price: Number(req.body.price),
      priceChild: req.body.priceChild != null && req.body.priceChild !== '' ? Number(req.body.priceChild) : null,
      durationDays: req.body.durationDays != null && req.body.durationDays !== '' ? Number(req.body.durationDays) : null,
      categoryId: req.body.categoryId != null ? Number(req.body.categoryId) : null,
      itinerary: req.body.itinerary ?? null,
      included: req.body.included ?? null,
      excluded: req.body.excluded ?? null,
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
    await logAdminAction(req.admin.sub, 'tour.update', { entityType: 'Product', entityId: id, detail: data })

    res.json({ product })
  } catch (err) {
    next(err)
  }
}

// UC-17 (2a) – Hiển thị/gỡ hiển thị (không xóa, giữ lịch sử đơn — BR-79).
// BR-81: nếu gỡ hiển thị mà còn chuyến tương lai có đơn hợp lệ, vẫn cho phép nhưng CẢNH BÁO admin.
export async function setTourVisibility(req, res, next) {
  try {
    const id = Number(req.params.id)
    const { status } = req.body
    if (status !== 'VISIBLE' && status !== 'HIDDEN') {
      return res.status(400).json({ message: 'Trạng thái không hợp lệ' })
    }
    const existing = await prisma.product.findUnique({ where: { id } })
    if (!existing || existing.type !== 'TOUR') {
      return res.status(404).json({ message: 'Không tìm thấy tour' })
    }

    let warning = null
    if (status === 'HIDDEN') {
      const today = new Date(Date.UTC(new Date().getUTCFullYear(), new Date().getUTCMonth(), new Date().getUTCDate()))
      const futureBookings = await prisma.booking.findMany({
        where: { productId: id, type: 'TOUR', status: { in: ACTIVE_STATUSES }, checkIn: { gte: today } },
        select: { code: true, checkIn: true },
      })
      if (futureBookings.length) {
        warning = {
          message: `Tour vẫn còn ${futureBookings.length} đơn hợp lệ trên các chuyến sắp tới. Các đơn này không bị ảnh hưởng, nhưng tour sẽ không còn hiển thị để đặt mới.`,
          bookings: futureBookings,
        }
      }
    }

    const product = await prisma.product.update({ where: { id }, data: { status } })
    await logAdminAction(req.admin.sub, status === 'HIDDEN' ? 'tour.hide' : 'tour.show', {
      entityType: 'Product',
      entityId: id,
    })

    res.json({ product, warning })
  } catch (err) {
    next(err)
  }
}

export async function addImage(req, res, next) {
  try {
    const id = Number(req.params.id)
    const { filename, order } = req.body
    const product = await prisma.product.findUnique({ where: { id } })
    if (!product || product.type !== 'TOUR') {
      return res.status(404).json({ message: 'Không tìm thấy tour' })
    }
    if (!filename) return res.status(400).json({ message: 'Thiếu tên tệp ảnh' })

    const url = publicUploadUrl(filename)
    const image = await prisma.productImage.create({ data: { productId: id, url, order: order ?? 0 } })
    if (!product.thumbnail) {
      await prisma.product.update({ where: { id }, data: { thumbnail: url } })
    }
    await logAdminAction(req.admin.sub, 'tour.image.add', { entityType: 'Product', entityId: id, detail: { url } })

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
    await logAdminAction(req.admin.sub, 'tour.image.remove', { entityType: 'Product', entityId: id, detail: { imageId } })
    res.json({ ok: true })
  } catch (err) {
    next(err)
  }
}

// ---------- Ngày khởi hành (BR-80) ----------

// UC-17 – Thêm một chuyến khởi hành mới.
export async function createDeparture(req, res, next) {
  try {
    const id = Number(req.params.id)
    const { date, totalSeats, priceAdultOverride, priceChildOverride } = req.body
    const product = await prisma.product.findUnique({ where: { id } })
    if (!product || product.type !== 'TOUR') {
      return res.status(404).json({ message: 'Không tìm thấy tour' })
    }
    const day = parseUtcDate(date)
    if (!day) return res.status(400).json({ message: 'Ngày khởi hành không hợp lệ' })
    const seats = Number(totalSeats)
    if (!Number.isInteger(seats) || seats <= 0) {
      return res.status(400).json({ message: 'Số chỗ tối đa phải lớn hơn 0' }) // 5a
    }

    const departure = await prisma.tourDeparture.create({
      data: {
        productId: id,
        date: day,
        totalSeats: seats,
        priceAdultOverride: priceAdultOverride != null && priceAdultOverride !== '' ? Number(priceAdultOverride) : null,
        priceChildOverride: priceChildOverride != null && priceChildOverride !== '' ? Number(priceChildOverride) : null,
      },
    })

    await logAdminAction(req.admin.sub, 'departure.create', {
      entityType: 'TourDeparture',
      entityId: departure.id,
      detail: { productId: id, date, totalSeats: seats },
    })

    res.status(201).json({ departure })
  } catch (err) {
    next(err)
  }
}

// UC-17 – Cập nhật số chỗ/giá của một chuyến. BR-81/4a-2: không giảm dưới số đã bán.
export async function updateDeparture(req, res, next) {
  try {
    const id = Number(req.params.id)
    const depId = Number(req.params.depId)
    const departure = await prisma.tourDeparture.findFirst({ where: { id: depId, productId: id } })
    if (!departure) return res.status(404).json({ message: 'Không tìm thấy chuyến khởi hành' })

    const data = {}
    if (req.body.totalSeats !== undefined) {
      const seats = Number(req.body.totalSeats)
      if (!Number.isInteger(seats) || seats <= 0) {
        return res.status(400).json({ message: 'Số chỗ tối đa phải lớn hơn 0' }) // 5a
      }
      if (seats < departure.bookedSeats) {
        return res.status(409).json({
          message: `Không thể giảm số chỗ xuống ${seats} vì đã bán ${departure.bookedSeats} chỗ cho chuyến này.`, // 4a-2
          bookedSeats: departure.bookedSeats,
        })
      }
      data.totalSeats = seats
    }
    if (req.body.priceAdultOverride !== undefined) {
      data.priceAdultOverride =
        req.body.priceAdultOverride === '' || req.body.priceAdultOverride == null ? null : Number(req.body.priceAdultOverride)
    }
    if (req.body.priceChildOverride !== undefined) {
      data.priceChildOverride =
        req.body.priceChildOverride === '' || req.body.priceChildOverride == null ? null : Number(req.body.priceChildOverride)
    }

    const updated = await prisma.tourDeparture.update({ where: { id: depId }, data })
    await logAdminAction(req.admin.sub, 'departure.update', { entityType: 'TourDeparture', entityId: depId, detail: data })

    res.json({ departure: updated })
  } catch (err) {
    next(err)
  }
}

// UC-17 (4a) – Đóng/hủy một chuyến khởi hành. BR-81/4a-1: chặn nếu còn đơn hợp lệ trên chuyến đó.
export async function closeDeparture(req, res, next) {
  try {
    const id = Number(req.params.id)
    const depId = Number(req.params.depId)
    const departure = await prisma.tourDeparture.findFirst({ where: { id: depId, productId: id } })
    if (!departure) return res.status(404).json({ message: 'Không tìm thấy chuyến khởi hành' })
    if (departure.closed) return res.status(409).json({ message: 'Chuyến này đã được đóng trước đó' })

    if (departure.bookedSeats > 0) {
      const nextDay = new Date(departure.date.getTime() + 86400000)
      const bookings = await prisma.booking.findMany({
        where: { productId: id, type: 'TOUR', status: { in: ACTIVE_STATUSES }, checkIn: { gte: departure.date, lt: nextDay } },
        select: { code: true, guests: true, children: true, status: true },
      })
      return res.status(409).json({
        message: 'Không thể đóng chuyến vì đang có đơn hợp lệ. Vui lòng xử lý các đơn liên quan trước (UC-18).', // 4a-1
        bookings,
      })
    }

    const updated = await prisma.tourDeparture.update({ where: { id: depId }, data: { closed: true } })
    await logAdminAction(req.admin.sub, 'departure.close', { entityType: 'TourDeparture', entityId: depId })

    res.json({ departure: updated })
  } catch (err) {
    next(err)
  }
}
