// Dữ liệu DEMO cho buổi bảo vệ: khách hàng, đơn đủ trạng thái, thanh toán,
// đánh giá (đã duyệt + chờ duyệt), hoàn tiền, yêu thích, token đánh giá (UC-15).
// Chạy SAU seed gốc. Idempotent: xoá sạch booking/payment/review/... rồi tạo lại.
import { PrismaClient } from '@prisma/client'
import bcrypt from 'bcryptjs'
import crypto from 'crypto'

const prisma = new PrismaClient()
const sha256 = (s) => crypto.createHash('sha256').update(s).digest('hex')

function dOnly(n) {
  const d = new Date()
  d.setUTCHours(0, 0, 0, 0)
  d.setUTCDate(d.getUTCDate() + n)
  return d
}
function nightsBetween(a, b) {
  const out = []
  for (let t = a.getTime(); t < b.getTime(); t += 86400000) out.push(new Date(t))
  return out
}
const DEPOSIT = 0.3
const round = (n) => Math.round(n)

async function decHomestay(roomTypeId, checkIn, checkOut, rooms = 1) {
  // chỉ trừ tồn với các đêm nằm trong lịch đã seed (tương lai)
  for (const date of nightsBetween(checkIn, checkOut)) {
    await prisma.roomInventory.updateMany({
      where: { roomTypeId, date },
      data: { bookedRooms: { increment: rooms } },
    }).catch(() => {})
  }
}

async function main() {
  // --- Dọn dữ liệu giao dịch cũ (giữ catalog) ---
  await prisma.reviewImage.deleteMany().catch(() => {})
  await prisma.review.deleteMany().catch(() => {})
  await prisma.reviewToken.deleteMany().catch(() => {})
  await prisma.payment.deleteMany().catch(() => {})
  await prisma.refundRequest.deleteMany().catch(() => {})
  await prisma.booking.deleteMany().catch(() => {})
  await prisma.favorite.deleteMany().catch(() => {})

  const props = await prisma.property.findMany({
    include: { roomTypes: { orderBy: { basePricePerNight: 'asc' } } },
    orderBy: { id: 'asc' },
  })
  const tours = await prisma.tour.findMany({
    include: { departures: { orderBy: { departureDate: 'asc' } } },
    orderBy: { id: 'asc' },
  })
  if (props.length < 3 || tours.length < 2) throw new Error('Chưa đủ catalog, hãy chạy seed gốc trước.')

  // ---------- Tài khoản khách hàng ----------
  const pw = await bcrypt.hash('Khach@123', 10)
  const custA = await prisma.user.upsert({
    where: { email: 'khachhang@gmail.com' },
    update: {},
    create: {
      email: 'khachhang@gmail.com', password: pw, name: 'Nguyễn Minh Anh',
      phone: '0905123456', address: '12 Nguyễn Trãi, Thanh Xuân', city: 'Hà Nội',
      dateOfBirth: new Date('1998-04-12'), gender: 'FEMALE', nationality: 'Việt Nam',
      idNumber: '001198000123', emailVerified: true, acceptedTerms: true,
    },
  })
  const custB = await prisma.user.upsert({
    where: { email: 'ha.tran@gmail.com' },
    update: {},
    create: {
      email: 'ha.tran@gmail.com', password: pw, name: 'Trần Thu Hà',
      phone: '0912345678', address: '45 Lê Lợi, Quận 1', city: 'TP. Hồ Chí Minh',
      dateOfBirth: new Date('1995-09-02'), gender: 'FEMALE', nationality: 'Việt Nam',
      idNumber: '079095000456', emailVerified: true, acceptedTerms: true,
    },
  })

  const p0 = props[0], p1 = props[1], p2 = props[2]
  const rt0 = p0.roomTypes[0], rt1 = p1.roomTypes[0], rt2 = p2.roomTypes[0]
  const t0 = tours[0], t1 = tours[1]
  const dep0 = t0.departures.find((d) => d.departureDate > new Date()) || t0.departures[0]
  const dep1 = t1.departures.find((d) => d.departureDate > new Date()) || t1.departures[0]

  let n = 0
  const codes = {}
  const mkCode = () => {
    const ab = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'
    let s = ''
    for (const b of crypto.randomBytes(9)) s += ab[b % ab.length]
    return `BK-${s}`
  }

  async function homestayBooking({ user, prop, rt, ci, co, status, guestName, guestEmail, guestPhone, note, pin, pay, review }) {
    const nights = nightsBetween(dOnly(ci), dOnly(co)).length
    const price = rt.basePricePerNight
    const total = nights * price
    const deposit = round(total * DEPOSIT)
    const code = mkCode()
    const b = await prisma.booking.create({
      data: {
        code, type: 'HOMESTAY', status,
        propertyId: prop.id, roomTypeId: rt.id,
        userId: user ? user.id : null,
        pinHash: pin ? sha256(pin) : null,
        guestName, guestEmail, guestPhone, note: note || null,
        checkIn: dOnly(ci), checkOut: dOnly(co), nights, guests: 2, children: 0,
        totalPrice: total, depositAmount: deposit, remainingAmount: total - deposit,
        paymentMethod: pay ? pay.method : null,
        depositPaidAt: pay ? dOnly(ci - 30) : null,
        heldUntil: status === 'PENDING_DEPOSIT' ? new Date(Date.now() + 15 * 60000) : null,
      },
    })
    if (pay) await prisma.payment.create({ data: { bookingId: b.id, method: pay.method, amount: deposit, status: 'SUCCESS', transactionId: pay.tx } })
    if (ci > 0) await decHomestay(rt.id, dOnly(ci), dOnly(co))
    n++
    codes[status + '_H'] = code
    let token = null
    if (review === 'invite') {
      const raw = crypto.randomBytes(32).toString('hex')
      token = raw
      await prisma.reviewToken.create({ data: { bookingId: b.id, tokenHash: sha256(raw), expiresAt: dOnly(30) } })
    } else if (review) {
      await prisma.review.create({
        data: {
          productType: 'HOMESTAY', propertyId: prop.id, bookingId: b.id,
          authorName: guestName, rating: review.rating, comment: review.comment,
          approved: review.approved, rejected: false, createdAt: dOnly(co + 1),
        },
      })
    }
    return { b, code, token }
  }

  async function tourBooking({ user, tour, dep, status, guestName, guestEmail, guestPhone, note, pax, pay, review, refund, cancelled }) {
    const adults = pax || 2
    const price = tour.basePrice
    const total = adults * price
    const deposit = round(total * DEPOSIT)
    const code = mkCode()
    const ci = dep ? dep.departureDate : dOnly(15)
    const b = await prisma.booking.create({
      data: {
        code, type: 'TOUR', status,
        tourId: tour.id, tourDepartureId: dep ? dep.id : null,
        userId: user ? user.id : null,
        guestName, guestEmail, guestPhone, note: note || null,
        checkIn: ci, checkOut: dep?.returnDate || ci, nights: tour.durationNights,
        guests: adults, children: 0,
        totalPrice: total, depositAmount: deposit, remainingAmount: total - deposit,
        paymentMethod: pay ? pay.method : null,
        depositPaidAt: pay ? dOnly(-5) : null,
        cancelledAt: cancelled ? dOnly(-2) : null,
      },
    })
    if (pay) await prisma.payment.create({ data: { bookingId: b.id, method: pay.method, amount: deposit, status: 'SUCCESS', transactionId: pay.tx } })
    if (dep && (status === 'CONFIRMED' || status === 'DEPOSITED')) {
      await prisma.tourDeparture.update({ where: { id: dep.id }, data: { bookedSlots: { increment: adults } } }).catch(() => {})
    }
    if (refund) await prisma.refundRequest.create({ data: { bookingId: b.id, amount: refund.amount, ratio: refund.ratio, status: refund.status } })
    if (review && review !== 'invite') {
      await prisma.review.create({
        data: {
          productType: 'TOUR', tourId: tour.id, bookingId: b.id,
          authorName: guestName, rating: review.rating, comment: review.comment,
          approved: review.approved, rejected: false, createdAt: dOnly(-1),
        },
      })
    }
    n++
    codes[status + '_T'] = code
    return { b, code }
  }

  // ===== Đơn của Nguyễn Minh Anh (custA) =====
  await homestayBooking({ user: custA, prop: p0, rt: rt0, ci: 20, co: 22, status: 'DEPOSITED',
    guestName: custA.name, guestEmail: custA.email, guestPhone: custA.phone,
    note: 'Nhận phòng muộn ~21h. Xin phòng tầng cao, yên tĩnh.',
    pay: { method: 'VNPAY', tx: 'VNP' + Date.now() } })

  await homestayBooking({ user: custA, prop: p1, rt: rt1, ci: 35, co: 37, status: 'PENDING_DEPOSIT',
    guestName: custA.name, guestEmail: custA.email, guestPhone: custA.phone,
    note: 'Cần thêm 1 giường phụ cho trẻ em.' })

  await homestayBooking({ user: custA, prop: p2, rt: rt2, ci: -20, co: -18, status: 'COMPLETED',
    guestName: custA.name, guestEmail: custA.email, guestPhone: custA.phone,
    note: 'Kỳ nghỉ gia đình.',
    pay: { method: 'VNPAY', tx: 'VNP' + (Date.now() - 5000) },
    review: { rating: 5, comment: 'Homestay tuyệt vời, view đẹp, chủ nhà thân thiện. Sẽ quay lại!', approved: true } })

  await tourBooking({ user: custA, tour: t0, dep: dep0, status: 'CONFIRMED',
    guestName: custA.name, guestEmail: custA.email, guestPhone: custA.phone,
    note: 'Ăn chay 1 suất.', pax: 2, pay: { method: 'VNPAY', tx: 'VNP' + (Date.now() - 9000) } })

  // Tour đã hoàn tất + đánh giá CHỜ DUYỆT (demo kiểm duyệt của admin)
  await tourBooking({ user: custA, tour: t1, dep: null, status: 'COMPLETED',
    guestName: custA.name, guestEmail: custA.email, guestPhone: custA.phone,
    pax: 2, pay: { method: 'COD', tx: null },
    review: { rating: 4, comment: 'Lịch trình ổn, hướng dẫn viên nhiệt tình. Xe hơi đông.', approved: false } })

  // ===== Đơn của Trần Thu Hà (custB) =====
  await tourBooking({ user: custB, tour: t0, dep: dep0, status: 'CANCELLED', cancelled: true,
    guestName: custB.name, guestEmail: custB.email, guestPhone: custB.phone,
    note: 'Bận việc đột xuất.', pax: 2, pay: { method: 'VNPAY', tx: 'VNP' + (Date.now() - 12000) },
    refund: { amount: round(t0.basePrice * 2 * DEPOSIT * 0.5), ratio: 50, status: 'PENDING' } })

  // ===== Đơn KHÁCH VÃNG LAI (guest checkout) =====
  // G1: đã hoàn tất + token mời đánh giá (UC-15) — link in ra để demo
  const g1 = await homestayBooking({ prop: p0, rt: rt0, ci: -15, co: -13, status: 'COMPLETED',
    guestName: 'Lê Văn Khách', guestEmail: 'khachvanglai@example.com', guestPhone: '0988777666',
    pin: '135790', pay: { method: 'COD', tx: null }, review: 'invite' })

  // G2: chờ cọc, có PIN cố định để demo tra cứu đơn (UC-13)
  const g2 = await homestayBooking({ prop: p1, rt: rt1, ci: 10, co: 12, status: 'PENDING_DEPOSIT',
    guestName: 'Phạm Thu Trang', guestEmail: 'guest.track@example.com', guestPhone: '0977555444',
    note: 'Đặt hộ bạn.', pin: '123456' })

  // ===== Đánh giá công khai (đã duyệt) để trang sản phẩm có sao & nhận xét =====
  const extraReviews = [
    { pt: 'HOMESTAY', pid: p0.id, name: 'Hoàng Thị Mai', r: 5, c: 'Sạch sẽ, gần trung tâm, nhân viên dễ thương.' },
    { pt: 'HOMESTAY', pid: p0.id, name: 'Đỗ Quang Huy', r: 4, c: 'Phòng đẹp, buổi sáng hơi ồn một chút.' },
    { pt: 'HOMESTAY', pid: p1.id, name: 'Vũ Thị Lan', r: 5, c: 'Không gian yên tĩnh, bữa sáng ngon.' },
    { pt: 'TOUR', tid: t0.id, name: 'Nguyễn Văn Tú', r: 5, c: 'Cảnh đẹp mê hồn, tổ chức chuyên nghiệp.' },
    { pt: 'TOUR', tid: t0.id, name: 'Trịnh Bảo', r: 4, c: 'Đáng tiền, nên mang thêm áo ấm.' },
    { pt: 'TOUR', tid: t1.id, name: 'Lý Thu Hằng', r: 5, c: 'Chuyến đi đáng nhớ, hướng dẫn viên vui tính.' },
  ]
  for (const e of extraReviews) {
    await prisma.review.create({
      data: {
        productType: e.pt, propertyId: e.pid || null, tourId: e.tid || null,
        authorName: e.name, rating: e.r, comment: e.c, approved: true, rejected: false,
        createdAt: dOnly(-Math.ceil(Math.random() * 25)),
      },
    })
  }

  // ===== Yêu thích của custA =====
  await prisma.favorite.create({ data: { userId: custA.id, propertyId: p0.id } }).catch(() => {})
  await prisma.favorite.create({ data: { userId: custA.id, tourId: t0.id } }).catch(() => {})
  await prisma.favorite.create({ data: { userId: custB.id, propertyId: p2.id } }).catch(() => {})

  // ===== Cập nhật avgRating/reviewCount từ đánh giá đã duyệt =====
  for (const p of props) {
    const rs = await prisma.review.findMany({ where: { propertyId: p.id, approved: true }, select: { rating: true } })
    if (rs.length) {
      const avg = rs.reduce((s, x) => s + x.rating, 0) / rs.length
      await prisma.property.update({ where: { id: p.id }, data: { avgRating: Math.round(avg * 10) / 10, reviewCount: rs.length } })
    }
  }
  for (const t of tours) {
    const rs = await prisma.review.findMany({ where: { tourId: t.id, approved: true }, select: { rating: true } })
    if (rs.length) {
      const avg = rs.reduce((s, x) => s + x.rating, 0) / rs.length
      await prisma.tour.update({ where: { id: t.id }, data: { avgRating: Math.round(avg * 10) / 10, reviewCount: rs.length } })
    }
  }

  const summary = {
    users: await prisma.user.count(),
    bookings: await prisma.booking.count(),
    payments: await prisma.payment.count(),
    reviews_total: await prisma.review.count(),
    reviews_approved: await prisma.review.count({ where: { approved: true } }),
    reviews_pending: await prisma.review.count({ where: { approved: false, rejected: false } }),
    refundRequests: await prisma.refundRequest.count(),
    favorites: await prisma.favorite.count(),
    reviewTokens: await prisma.reviewToken.count(),
  }
  console.log('DEMO DATA DONE:', summary)
  console.log('--- Tài khoản demo ---')
  console.log('  Khách hàng A : khachhang@gmail.com / Khach@123')
  console.log('  Khách hàng B : ha.tran@gmail.com   / Khach@123')
  console.log('  Admin        : admin / Admin@123456')
  console.log('--- Mã đơn demo ---', codes)
  console.log('  Guest tra cứu (UC-13): mã', g2.code, '| PIN 123456')
  console.log('  Guest link đánh giá (UC-15): /review?token=' + g1.token)
}

main().then(() => prisma.$disconnect()).catch((e) => { console.error(e); prisma.$disconnect(); process.exit(1) })
