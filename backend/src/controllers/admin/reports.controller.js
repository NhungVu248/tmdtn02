import { prisma } from '../../lib/prisma.js'

const DAY_MS = 86400000

function parseRange(query) {
  const to = query.to ? new Date(query.to) : new Date()
  const from = query.from ? new Date(query.from) : new Date(to.getTime() - 29 * DAY_MS)
  from.setHours(0, 0, 0, 0)
  to.setHours(23, 59, 59, 999)
  return { from, to }
}

function dayKey(d) {
  return new Date(d).toISOString().slice(0, 10)
}

// UC-22 – Báo cáo & thống kê tổng hợp (chỉ đọc — BR-108). Trả về cả 4 loại báo cáo cùng lúc
// cho một khoảng thời gian, để trang quản trị hiển thị dạng dashboard duy nhất.
export async function getReports(req, res, next) {
  try {
    const { from, to } = parseRange(req.query)

    // ----- Doanh thu (BR-109): tiền đã thanh toán thành công trừ đi các khoản đã hoàn tiền -----
    const payments = await prisma.payment.findMany({
      where: { status: 'SUCCESS', createdAt: { gte: from, lte: to } },
      select: { amount: true, createdAt: true },
    })
    const refunds = await prisma.refundRequest.findMany({
      where: { status: 'PROCESSED', createdAt: { gte: from, lte: to } },
      select: { amount: true, createdAt: true },
    })
    const byDayMap = new Map()
    for (const p of payments) byDayMap.set(dayKey(p.createdAt), (byDayMap.get(dayKey(p.createdAt)) || 0) + p.amount)
    for (const r of refunds) byDayMap.set(dayKey(r.createdAt), (byDayMap.get(dayKey(r.createdAt)) || 0) - r.amount)
    const grossRevenue = payments.reduce((s, p) => s + p.amount, 0)
    const refundedAmount = refunds.reduce((s, r) => s + r.amount, 0)
    const revenueByDay = [...byDayMap.entries()].sort(([a], [b]) => (a < b ? -1 : 1)).map(([date, amount]) => ({ date, amount }))

    // ----- Đơn theo trạng thái -----
    const bookingsInRange = await prisma.booking.findMany({
      where: { createdAt: { gte: from, lte: to } },
      select: { status: true, type: true, productId: true, guests: true, children: true },
    })
    const statusMap = new Map()
    for (const b of bookingsInRange) statusMap.set(b.status, (statusMap.get(b.status) || 0) + 1)
    const ordersByStatus = [...statusMap.entries()].map(([status, count]) => ({ status, count }))

    // ----- Tour bán chạy (BR-110): số chỗ đã đặt theo tour, trừ đơn đã hủy -----
    const tourBookings = bookingsInRange.filter((b) => b.type === 'TOUR' && b.status !== 'CANCELLED')
    const tourMap = new Map()
    for (const b of tourBookings) {
      const cur = tourMap.get(b.productId) || { productId: b.productId, bookingsCount: 0, seats: 0 }
      cur.bookingsCount += 1
      cur.seats += (b.guests || 0) + (b.children || 0)
      tourMap.set(b.productId, cur)
    }
    const topTourIds = [...tourMap.values()].sort((a, b) => b.seats - a.seats).slice(0, 10)
    const tourProducts = await prisma.product.findMany({
      where: { id: { in: topTourIds.map((t) => t.productId) } },
      select: { id: true, name: true, slug: true },
    })
    const tourProductById = new Map(tourProducts.map((p) => [p.id, p]))
    const topTours = topTourIds.map((t) => ({ ...t, name: tourProductById.get(t.productId)?.name, slug: tourProductById.get(t.productId)?.slug }))

    // ----- Công suất phòng homestay (BR-110): tổng bookedRooms/totalRooms trong kỳ theo từng homestay -----
    const availabilityRows = await prisma.homestayAvailability.findMany({
      where: { date: { gte: from, lte: to } },
      select: { productId: true, totalRooms: true, bookedRooms: true },
    })
    const occMap = new Map()
    for (const r of availabilityRows) {
      const cur = occMap.get(r.productId) || { productId: r.productId, totalRoomNights: 0, bookedRoomNights: 0 }
      cur.totalRoomNights += r.totalRooms
      cur.bookedRoomNights += r.bookedRooms
      occMap.set(r.productId, cur)
    }
    const homestayIds = [...occMap.keys()]
    const homestayProducts = await prisma.product.findMany({
      where: { id: { in: homestayIds } },
      select: { id: true, name: true, slug: true },
    })
    const homestayById = new Map(homestayProducts.map((p) => [p.id, p]))
    const homestayOccupancy = [...occMap.values()]
      .map((o) => ({
        ...o,
        name: homestayById.get(o.productId)?.name,
        slug: homestayById.get(o.productId)?.slug,
        rate: o.totalRoomNights > 0 ? Math.round((o.bookedRoomNights / o.totalRoomNights) * 1000) / 10 : 0,
      }))
      .sort((a, b) => b.rate - a.rate)

    // 2a: không có dữ liệu trong kỳ — frontend tự hiển thị thông báo khi mọi mảng đều rỗng.
    res.json({
      range: { from: from.toISOString(), to: to.toISOString() },
      revenue: { gross: grossRevenue, refunded: refundedAmount, net: grossRevenue - refundedAmount, byDay: revenueByDay },
      ordersByStatus,
      topTours,
      homestayOccupancy,
    })
  } catch (err) {
    next(err)
  }
}
