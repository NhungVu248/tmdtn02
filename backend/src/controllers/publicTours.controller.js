import { prisma } from '../lib/prisma.js'
import { tourToCard } from './catalog.controller.js'

const DAY_MS = 86400000
function startOfToday() {
  const n = new Date()
  return new Date(Date.UTC(n.getUTCFullYear(), n.getUTCMonth(), n.getUTCDate()))
}
function parseUtcDate(str) {
  const d = new Date(str)
  return isNaN(d) ? null : new Date(Date.UTC(d.getUTCFullYear(), d.getUTCMonth(), d.getUTCDate()))
}
function availableSlots(dep) {
  return dep.totalSlots - dep.bookedSlots - dep.heldSlots
}

// UC-01/02 – Danh sách tour (thẻ), lọc theo region/theme/thời lượng + tìm kiếm + sắp xếp.
export async function listTours(req, res, next) {
  try {
    const { regionId, themeId, duration, search, sort } = req.query
    const where = { status: 'VISIBLE' }
    if (regionId) where.regionId = Number(regionId)
    if (themeId) where.themeId = Number(themeId)
    if (duration) where.durationDays = Number(duration)
    if (search) where.title = { contains: String(search) }

    const orderBy =
      sort === 'price_asc' ? { basePrice: 'asc' } : sort === 'price_desc' ? { basePrice: 'desc' } : sort === 'rating_desc' ? { avgRating: 'desc' } : { createdAt: 'desc' }

    const tours = await prisma.tour.findMany({ where, orderBy })
    res.json({ count: tours.length, items: tours.map(tourToCard) })
  } catch (err) {
    next(err)
  }
}

// UC-03 – Chi tiết tour đầy đủ (ảnh, lịch trình, bao gồm/không bao gồm, ghi chú, chuyến + giá, đánh giá, gợi ý).
export async function getTourDetail(req, res, next) {
  try {
    const { slug } = req.params
    const tour = await prisma.tour.findUnique({
      where: { slug },
      include: {
        images: { orderBy: { sortOrder: 'asc' } },
        region: true,
        theme: true,
        cancellationPolicy: { include: { milestones: { orderBy: { daysBefore: 'desc' } } } },
        itinerary: { orderBy: { dayNumber: 'asc' } },
        inclusions: { orderBy: { sortOrder: 'asc' } },
        notes: { orderBy: { sortOrder: 'asc' } },
        reviews: { where: { approved: true }, orderBy: { createdAt: 'desc' }, include: { images: { orderBy: { sortOrder: 'asc' } } } },
        departures: {
          where: { departureDate: { gte: startOfToday() }, status: { in: ['OPEN', 'FULL'] } },
          orderBy: { departureDate: 'asc' },
          include: { prices: true },
        },
      },
    })
    if (!tour || tour.status !== 'VISIBLE') {
      return res.status(404).json({ message: 'Tour không còn khả dụng' })
    }

    const departures = tour.departures.map((d) => ({
      id: d.id,
      departureDate: d.departureDate,
      returnDate: d.returnDate,
      totalSlots: d.totalSlots,
      slotsLeft: availableSlots(d),
      status: d.status,
      guideName: d.guideName,
      prices: d.prices.map((p) => ({ paxType: p.paxType, price: p.price, description: p.description, requiresProof: p.requiresProof })),
    }))

    const included = tour.inclusions.filter((i) => i.type === 'INCLUDED')
    const excluded = tour.inclusions.filter((i) => i.type === 'EXCLUDED')

    // Gợi ý tour tương tự cùng vùng.
    const similar = await prisma.tour.findMany({
      where: { status: 'VISIBLE', id: { not: tour.id }, regionId: tour.regionId ?? undefined },
      take: 4,
    })

    const { departures: _d, inclusions: _i, reviews, ...rest } = tour
    res.json({
      tour: { ...rest, departures, included, excluded },
      reviews,
      similar: similar.map(tourToCard),
    })
  } catch (err) {
    next(err)
  }
}

// UC-03 – Kiểm tra còn chỗ + giá tạm tính cho một chuyến (theo departureId hoặc ngày).
export async function checkTourAvailability(req, res, next) {
  try {
    const { slug } = req.params
    const { departureId, date } = req.query
    const adults = req.query.adults ? Number(req.query.adults) : req.query.guests ? Number(req.query.guests) : 1
    const children = req.query.children ? Number(req.query.children) : 0
    const infants = req.query.infants ? Number(req.query.infants) : 0
    if (!Number.isInteger(adults) || adults < 1) {
      return res.status(400).json({ message: 'Cần ít nhất 1 người lớn' })
    }
    if (children < 0 || infants < 0) {
      return res.status(400).json({ message: 'Số khách không hợp lệ' })
    }

    const tour = await prisma.tour.findUnique({ where: { slug } })
    if (!tour || tour.status !== 'VISIBLE') {
      return res.status(404).json({ message: 'Tour không còn khả dụng' })
    }

    let departure
    if (departureId) {
      departure = await prisma.tourDeparture.findFirst({ where: { id: Number(departureId), tourId: tour.id }, include: { prices: true } })
    } else if (date) {
      const day = parseUtcDate(date)
      if (!day) return res.status(400).json({ message: 'Ngày khởi hành không hợp lệ' })
      const nextDay = new Date(day.getTime() + DAY_MS)
      departure = await prisma.tourDeparture.findFirst({ where: { tourId: tour.id, departureDate: { gte: day, lt: nextDay } }, include: { prices: true } })
    } else {
      return res.status(400).json({ message: 'Vui lòng chọn chuyến khởi hành' })
    }

    if (!departure || departure.status === 'CLOSED' || departure.status === 'CANCELLED') {
      return res.json({ type: 'TOUR', available: false, slotsLeft: 0, tentativePrice: null, message: 'Không có chuyến khởi hành phù hợp' })
    }

    const slotsLeft = availableSlots(departure)
    const totalGuests = adults + children + infants // BR-31: hạ tầng ghế; infant có thể tính suất riêng
    const available = slotsLeft >= totalGuests
    const priceOf = (t) => departure.prices.find((p) => p.paxType === t)?.price ?? tour.basePrice
    const tentativePrice = available ? priceOf('ADULT') * adults + priceOf('CHILD') * children + priceOf('INFANT') * infants : null
    res.json({
      type: 'TOUR',
      departureId: departure.id,
      available,
      slotsLeft,
      tentativePrice,
      message: available ? null : 'Không còn đủ chỗ cho chuyến đã chọn',
    })
  } catch (err) {
    next(err)
  }
}
