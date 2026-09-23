import { prisma } from '../lib/prisma.js'

// Chỉ chọn các trường cần cho danh sách/thẻ sản phẩm.
const productCardSelect = {
  id: true,
  name: true,
  slug: true,
  type: true,
  location: true,
  price: true,
  rating: true,
  thumbnail: true,
  isFeatured: true,
  categoryId: true,
  amenities: true,
  durationDays: true,
}

// UC-01 – Dữ liệu trang chủ: nổi bật, khu vực phổ biến, khuyến mại.
// BR-01: chỉ hiển thị sản phẩm trạng thái VISIBLE. Khuyến mại: chỉ active.
export async function getHome(req, res, next) {
  try {
    const [featured, areas, promotions] = await Promise.all([
      prisma.product.findMany({
        where: { status: 'VISIBLE', isFeatured: true },
        select: productCardSelect,
        orderBy: { rating: 'desc' },
        take: 8,
      }),
      prisma.area.findMany({ orderBy: { order: 'asc' } }),
      prisma.promotion.findMany({
        where: { active: true },
        orderBy: { createdAt: 'desc' },
      }),
    ])

    res.json({
      featured,
      areas,
      promotions,
    })
  } catch (err) {
    next(err)
  }
}

// Dựng cây danh mục nhiều cấp từ danh sách phẳng. BR-02.
function buildTree(categories) {
  const byId = new Map()
  categories.forEach((c) => byId.set(c.id, { ...c, children: [] }))

  const roots = []
  for (const node of byId.values()) {
    if (node.parentId && byId.has(node.parentId)) {
      byId.get(node.parentId).children.push(node)
    } else {
      roots.push(node)
    }
  }
  return roots
}

// UC-01 – Cây danh mục (lọc theo loại nếu có ?type=HOMESTAY|TOUR).
export async function getCategories(req, res, next) {
  try {
    const { type } = req.query
    const where = {}
    if (type === 'HOMESTAY' || type === 'TOUR') where.type = type

    const categories = await prisma.category.findMany({
      where,
      orderBy: [{ order: 'asc' }, { name: 'asc' }],
    })

    res.json({ categories: buildTree(categories) })
  } catch (err) {
    next(err)
  }
}

// Thu thập id của một danh mục và toàn bộ danh mục con (đệ quy).
async function collectCategoryIds(rootId) {
  const all = await prisma.category.findMany({ select: { id: true, parentId: true } })
  const childrenOf = new Map()
  for (const c of all) {
    if (!childrenOf.has(c.parentId)) childrenOf.set(c.parentId, [])
    childrenOf.get(c.parentId).push(c.id)
  }
  const result = []
  const stack = [rootId]
  while (stack.length) {
    const id = stack.pop()
    result.push(id)
    for (const child of childrenOf.get(id) || []) stack.push(child)
  }
  return result
}

// UC-01/UC-02 – Danh sách sản phẩm theo danh mục / loại / khu vực.
// BR-01: chỉ trả về sản phẩm VISIBLE. Danh mục cha bao gồm cả sản phẩm ở danh mục con.
export async function getProducts(req, res, next) {
  try {
    const { categoryId, categorySlug, type, location } = req.query
    const where = { status: 'VISIBLE' }

    if (type === 'HOMESTAY' || type === 'TOUR') where.type = type
    if (location) where.location = { contains: String(location) }

    let category = null
    if (categoryId || categorySlug) {
      category = await prisma.category.findUnique({
        where: categoryId ? { id: Number(categoryId) } : { slug: String(categorySlug) },
      })
      if (!category) {
        return res.status(404).json({ message: 'Không tìm thấy danh mục' })
      }
      const ids = await collectCategoryIds(category.id)
      where.categoryId = { in: ids }
    }

    const items = await prisma.product.findMany({
      where,
      select: productCardSelect,
      orderBy: { createdAt: 'desc' },
    })

    res.json({ category, count: items.length, items })
  } catch (err) {
    next(err)
  }
}

// Số đêm giữa hai ngày (YYYY-MM-DD). Trả null nếu không hợp lệ.
function diffNights(from, to) {
  const a = new Date(from)
  const b = new Date(to)
  if (isNaN(a) || isNaN(b)) return null
  const nights = Math.round((b - a) / 86400000)
  return nights
}

// UC-03 – Chi tiết sản phẩm + đánh giá + gợi ý tương tự.
// Ngoại lệ 1a: sản phẩm không tồn tại hoặc đã bị gỡ (HIDDEN) -> không còn khả dụng.
export async function getProductDetail(req, res, next) {
  try {
    const { slug } = req.params
    const product = await prisma.product.findUnique({
      where: { slug },
      include: {
        images: { orderBy: { order: 'asc' } },
        category: true,
        reviews: {
          where: { approved: true }, // BR-08
          orderBy: { createdAt: 'desc' },
        },
        departures: {
          where: { date: { gte: startOfToday() } },
          orderBy: { date: 'asc' },
        },
      },
    })

    if (!product || product.status !== 'VISIBLE') {
      return res.status(404).json({ message: 'Sản phẩm không còn khả dụng' })
    }

    // Tour: kèm số chỗ còn của mỗi chuyến (BR-07).
    const departures = product.departures.map((d) => ({
      id: d.id,
      date: d.date,
      totalSeats: d.totalSeats,
      seatsLeft: d.totalSeats - d.bookedSeats,
    }))

    // AF-07: gợi ý sản phẩm tương tự cùng loại & khu vực.
    const similar = await prisma.product.findMany({
      where: {
        status: 'VISIBLE',
        type: product.type,
        id: { not: product.id },
        ...(product.location ? { location: { contains: product.location.split(',')[0] } } : {}),
      },
      select: productCardSelect,
      take: 4,
    })

    const { reviews, departures: _omit, ...rest } = product
    res.json({ product: { ...rest, departures }, reviews, similar })
  } catch (err) {
    next(err)
  }
}

const DAY_MS = 86400000

// UTC midnight của hôm nay (khớp cột @db.Date của Prisma).
function startOfToday() {
  const n = new Date()
  return new Date(Date.UTC(n.getUTCFullYear(), n.getUTCMonth(), n.getUTCDate()))
}

// Chuỗi 'YYYY-MM-DD' -> Date tại UTC midnight (new Date('YYYY-MM-DD') đã là UTC).
function parseUtcDate(str) {
  const d = new Date(str)
  return isNaN(d) ? null : new Date(Date.UTC(d.getUTCFullYear(), d.getUTCMonth(), d.getUTCDate()))
}

// Liệt kê các đêm (UTC midnight) trong khoảng [from, to).
function nightsBetween(from, to) {
  const a = parseUtcDate(from)
  const b = parseUtcDate(to)
  if (!a || !b) return null
  const dates = []
  for (let t = a.getTime(); t < b.getTime(); t += DAY_MS) dates.push(new Date(t))
  return dates
}

// UC-03 – Kiểm tra tình trạng còn trống + giá tạm tính (BR-07, BR-09).
export async function checkAvailability(req, res, next) {
  try {
    const { slug } = req.params
    const product = await prisma.product.findUnique({ where: { slug } })
    if (!product || product.status !== 'VISIBLE') {
      return res.status(404).json({ message: 'Sản phẩm không còn khả dụng' })
    }

    const guests = req.query.guests ? Number(req.query.guests) : 1
    if (!Number.isInteger(guests) || guests < 1) {
      return res.status(400).json({ message: 'Số khách phải là số nguyên ≥ 1' })
    }

    if (product.type === 'HOMESTAY') {
      const { from, to } = req.query
      if (!from || !to) {
        return res.status(400).json({ message: 'Vui lòng chọn ngày nhận và trả phòng' })
      }
      const nights = nightsBetween(from, to)
      if (!nights) return res.status(400).json({ message: 'Ngày không hợp lệ' })
      if (nights.length === 0) {
        return res.status(400).json({ message: 'Ngày trả phòng phải sau ngày nhận phòng' })
      }

      const rows = await prisma.homestayAvailability.findMany({
        where: { productId: product.id, date: { gte: nights[0], lte: nights[nights.length - 1] } },
      })
      // Cột @db.Date trả về Date tại UTC midnight -> khớp trực tiếp với night.getTime().
      const byTime = new Map(rows.map((r) => [new Date(r.date).getTime(), r]))

      let minRooms = Infinity
      for (const night of nights) {
        const row = byTime.get(night.getTime())
        const free = row ? row.totalRooms - row.bookedRooms : 0
        minRooms = Math.min(minRooms, free)
      }
      const available = minRooms >= 1
      // BR-77: dùng giá riêng theo ngày (mùa/cuối tuần) do UC-16 thiết lập nếu có, ngược lại giá cơ bản.
      const tentativePrice = available
        ? nights.reduce((sum, night) => {
            const row = byTime.get(night.getTime())
            return sum + (row?.priceOverride ?? product.price)
          }, 0)
        : null
      return res.json({
        type: 'HOMESTAY',
        available,
        nights: nights.length,
        roomsLeft: available ? minRooms : 0,
        tentativePrice, // BR-09/BR-77
        message: available ? null : 'Không còn chỗ trống trong khoảng ngày đã chọn',
      })
    }

    // TOUR
    const { date, children } = req.query
    if (!date) {
      return res.status(400).json({ message: 'Vui lòng chọn ngày khởi hành' })
    }
    const numChildren = children ? Number(children) : 0
    if (!Number.isInteger(numChildren) || numChildren < 0) {
      return res.status(400).json({ message: 'Số trẻ em không hợp lệ' })
    }
    const day = parseUtcDate(date)
    if (!day) return res.status(400).json({ message: 'Ngày khởi hành không hợp lệ' })
    const nextDay = new Date(day.getTime() + DAY_MS)

    const departure = await prisma.tourDeparture.findFirst({
      where: { productId: product.id, date: { gte: day, lt: nextDay } },
    })
    // BR-79: chuyến đã đóng cũng coi như không mở để đặt.
    if (!departure || departure.closed) {
      return res.json({
        type: 'TOUR',
        available: false,
        seatsLeft: 0,
        tentativePrice: null,
        message: 'Không có chuyến khởi hành vào ngày đã chọn',
      })
    }

    const seatsLeft = departure.totalSeats - departure.bookedSeats
    const totalGuests = guests + numChildren
    const available = seatsLeft >= totalGuests
    // BR-83: ưu tiên giá riêng theo chuyến (do UC-17 thiết lập) trước giá cơ bản của sản phẩm.
    const adultPrice = departure.priceAdultOverride ?? product.price
    const childPrice = departure.priceChildOverride ?? product.priceChild ?? product.price
    const tentativePrice = available ? adultPrice * guests + childPrice * numChildren : null // BR-09/BR-83
    return res.json({
      type: 'TOUR',
      available,
      seatsLeft,
      tentativePrice,
      message: available ? null : 'Không còn đủ chỗ cho chuyến đã chọn',
    })
  } catch (err) {
    next(err)
  }
}

// UC-02 – Tìm kiếm & lọc sản phẩm.
// BR-04: chỉ VISIBLE. BR-05: homestay tính giá theo số đêm. BR-06/2a: kiểm tra hợp lệ tiêu chí.
export async function searchProducts(req, res, next) {
  try {
    const {
      type,
      destination,
      guests,
      from,
      to,
      depart,
      minPrice,
      maxPrice,
      location,
      amenities,
      minRating,
      duration,
      sort,
    } = req.query

    // ----- Kiểm tra hợp lệ (BR-06 / ngoại lệ 2a) -----
    if (guests !== undefined && guests !== '') {
      const g = Number(guests)
      if (!Number.isInteger(g) || g < 1) {
        return res.status(400).json({ message: 'Số khách phải là số nguyên ≥ 1' })
      }
    }

    let nights = null
    if (type === 'HOMESTAY' && from && to) {
      nights = diffNights(from, to)
      if (nights === null) {
        return res.status(400).json({ message: 'Ngày nhận/trả phòng không hợp lệ' })
      }
      if (nights <= 0) {
        return res.status(400).json({ message: 'Ngày trả phòng phải sau ngày nhận phòng' })
      }
    }

    // ----- Tập cơ sở cho facets (BR-04: VISIBLE) -----
    const baseWhere = { status: 'VISIBLE' }
    if (type === 'HOMESTAY' || type === 'TOUR') baseWhere.type = type
    if (destination) baseWhere.location = { contains: String(destination) }

    const base = await prisma.product.findMany({
      where: baseWhere,
      select: productCardSelect,
    })

    // ----- Facets (tùy chọn bộ lọc dựa trên dữ liệu thực) -----
    const facets = {
      locations: [...new Set(base.map((p) => p.location).filter(Boolean))].sort(),
      amenities: [
        ...new Set(
          base.flatMap((p) => (p.amenities ? p.amenities.split(',').map((s) => s.trim()) : [])),
        ),
      ].sort(),
      durations: [...new Set(base.map((p) => p.durationDays).filter((d) => d != null))].sort(
        (a, b) => a - b,
      ),
      priceMin: base.length ? Math.min(...base.map((p) => p.price)) : 0,
      priceMax: base.length ? Math.max(...base.map((p) => p.price)) : 0,
    }

    // ----- Áp dụng bộ lọc thứ cấp -----
    const wantedAmenities = amenities
      ? String(amenities).split(',').map((s) => s.trim()).filter(Boolean)
      : []
    const wantedDurations = duration
      ? String(duration).split(',').map((s) => Number(s)).filter((n) => !isNaN(n))
      : []

    let items = base.filter((p) => {
      if (minPrice && p.price < Number(minPrice)) return false
      if (maxPrice && p.price > Number(maxPrice)) return false
      if (location && !(p.location || '').includes(String(location))) return false
      if (minRating && p.rating < Number(minRating)) return false
      if (wantedDurations.length && !wantedDurations.includes(p.durationDays)) return false
      if (wantedAmenities.length) {
        const have = (p.amenities || '').split(',').map((s) => s.trim())
        if (!wantedAmenities.every((a) => have.includes(a))) return false
      }
      return true
    })

    // ----- Sắp xếp -----
    const sorters = {
      price_asc: (a, b) => a.price - b.price,
      price_desc: (a, b) => b.price - a.price,
      rating_desc: (a, b) => b.rating - a.rating,
    }
    if (sorters[sort]) items = [...items].sort(sorters[sort])

    // ----- BR-05: giá theo số đêm cho homestay -----
    const result = items.map((p) => {
      if (nights && p.type === 'HOMESTAY') {
        return { ...p, nights, totalPrice: p.price * nights }
      }
      return p
    })

    res.json({
      criteria: { type: type || null, destination: destination || null, guests: guests || null, from: from || null, to: to || null, depart: depart || null },
      nights,
      facets,
      count: result.length,
      items: result,
    })
  } catch (err) {
    next(err)
  }
}
