import { prisma } from '../lib/prisma.js'
import { propertyToCard } from './catalog.controller.js'

const DAY_MS = 86400000
function parseUtcDate(str) {
  const d = new Date(str)
  return isNaN(d) ? null : new Date(Date.UTC(d.getUTCFullYear(), d.getUTCMonth(), d.getUTCDate()))
}
function nightsBetween(from, to) {
  const a = parseUtcDate(from)
  const b = parseUtcDate(to)
  if (!a || !b) return null
  const dates = []
  for (let t = a.getTime(); t < b.getTime(); t += DAY_MS) dates.push(new Date(t))
  return dates
}

// UC-01/02 – Danh sách chỗ nghỉ (thẻ).
export async function listProperties(req, res, next) {
  try {
    const { provinceId, areaId, search, sort } = req.query
    const where = { status: 'VISIBLE' }
    if (provinceId) where.provinceId = Number(provinceId)
    if (areaId) where.areaId = Number(areaId)
    if (search) where.name = { contains: String(search) }
    const orderBy = sort === 'price_asc' ? { basePrice: 'asc' } : sort === 'price_desc' ? { basePrice: 'desc' } : sort === 'rating_desc' ? { avgRating: 'desc' } : { createdAt: 'desc' }
    const props = await prisma.property.findMany({ where, orderBy })
    res.json({ count: props.length, items: props.map(propertyToCard) })
  } catch (err) {
    next(err)
  }
}

// UC-03 – Chi tiết chỗ nghỉ: loại phòng, tiện nghi, nội quy, ảnh, chính sách hủy, đánh giá, gợi ý.
export async function getPropertyDetail(req, res, next) {
  try {
    const { slug } = req.params
    const property = await prisma.property.findUnique({
      where: { slug },
      include: {
        images: { orderBy: { sortOrder: 'asc' } },
        province: true,
        area: true,
        cancellationPolicy: { include: { milestones: { orderBy: { daysBefore: 'desc' } } } },
        amenities: { include: { amenity: true } },
        policies: { orderBy: { sortOrder: 'asc' } },
        roomTypes: { include: { images: { orderBy: { sortOrder: 'asc' } } } },
        reviews: { where: { approved: true }, orderBy: { createdAt: 'desc' } },
      },
    })
    if (!property || property.status !== 'VISIBLE') {
      return res.status(404).json({ message: 'Chỗ nghỉ không còn khả dụng' })
    }

    const roomTypes = property.roomTypes.map((rt) => ({
      id: rt.id,
      name: rt.name,
      roomSize: rt.roomSize,
      bedType: rt.bedType,
      maxOccupancy: rt.maxOccupancy,
      totalRooms: rt.totalRooms,
      breakfastIncluded: rt.breakfastIncluded,
      smokingAllowed: rt.smokingAllowed,
      basePricePerNight: rt.basePricePerNight,
      description: rt.description,
      images: rt.images,
    }))

    const similar = await prisma.property.findMany({
      where: { status: 'VISIBLE', id: { not: property.id }, provinceId: property.provinceId ?? undefined },
      take: 4,
    })

    const { roomTypes: _r, amenities, reviews, ...rest } = property
    res.json({
      property: { ...rest, roomTypes, amenities: amenities.map((a) => a.amenity) },
      reviews,
      similar: similar.map(propertyToCard),
    })
  } catch (err) {
    next(err)
  }
}

// UC-03 – Kiểm tra còn phòng + giá tạm tính cho một loại phòng theo khoảng ngày (BR-24/74).
export async function checkPropertyAvailability(req, res, next) {
  try {
    const { slug } = req.params
    const { from, to, roomTypeId } = req.query
    const property = await prisma.property.findUnique({ where: { slug }, include: { roomTypes: true } })
    if (!property || property.status !== 'VISIBLE') {
      return res.status(404).json({ message: 'Chỗ nghỉ không còn khả dụng' })
    }
    if (!from || !to) return res.status(400).json({ message: 'Vui lòng chọn ngày nhận và trả phòng' })
    const nights = nightsBetween(from, to)
    if (!nights) return res.status(400).json({ message: 'Ngày không hợp lệ' })
    if (nights.length === 0) return res.status(400).json({ message: 'Ngày trả phòng phải sau ngày nhận phòng' })

    // Loại phòng: chỉ định, hoặc mặc định loại phòng đầu tiên.
    const rt = roomTypeId ? property.roomTypes.find((r) => r.id === Number(roomTypeId)) : property.roomTypes[0]
    if (!rt) return res.status(404).json({ message: 'Không tìm thấy loại phòng' })

    const rows = await prisma.roomInventory.findMany({
      where: { roomTypeId: rt.id, date: { gte: nights[0], lte: nights[nights.length - 1] } },
    })
    const byTime = new Map(rows.map((r) => [new Date(r.date).getTime(), r]))

    let minRooms = Infinity
    for (const night of nights) {
      const row = byTime.get(night.getTime())
      const free = row && !row.isBlocked ? row.totalRooms - row.bookedRooms - row.heldRooms : 0
      minRooms = Math.min(minRooms, free)
    }
    const available = minRooms >= 1
    const tentativePrice = available
      ? nights.reduce((sum, night) => {
          const row = byTime.get(night.getTime())
          return sum + (row?.priceOverride ?? rt.basePricePerNight)
        }, 0)
      : null
    res.json({
      type: 'HOMESTAY',
      roomTypeId: rt.id,
      available,
      nights: nights.length,
      roomsLeft: available ? minRooms : 0,
      tentativePrice, // BR-09/BR-26
      message: available ? null : 'Không còn phòng trống trong khoảng ngày đã chọn',
    })
  } catch (err) {
    next(err)
  }
}
