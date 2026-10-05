import { PrismaClient } from '@prisma/client'
import bcrypt from 'bcryptjs'

const prisma = new PrismaClient()

// Ảnh minh hoạ (Unsplash) — chỉ dùng cho dữ liệu demo.
const img = (id, w = 1000) => `https://images.unsplash.com/${id}?auto=format&fit=crop&w=${w}&q=70`

function addDays(n) {
  const d = new Date()
  d.setUTCHours(0, 0, 0, 0)
  d.setUTCDate(d.getUTCDate() + n)
  return d
}

async function main() {
  // ---- Dọn dữ liệu cũ (theo thứ tự khoá ngoại an toàn). Giữ bảng User. ----
  await prisma.payment.deleteMany().catch(() => {})
  await prisma.booking.deleteMany().catch(() => {})
  await prisma.review.deleteMany().catch(() => {})
  await prisma.roomInventory.deleteMany().catch(() => {})
  await prisma.roomType.deleteMany().catch(() => {})
  await prisma.property.deleteMany().catch(() => {})
  await prisma.tourPrice.deleteMany().catch(() => {})
  await prisma.tourDeparture.deleteMany().catch(() => {})
  await prisma.travelGuideTour.deleteMany().catch(() => {})
  await prisma.travelGuide.deleteMany().catch(() => {})
  await prisma.tour.deleteMany().catch(() => {})
  await prisma.discountCode.deleteMany().catch(() => {})
  await prisma.promotion.deleteMany().catch(() => {})
  await prisma.area.deleteMany().catch(() => {})
  await prisma.infoArticle.deleteMany().catch(() => {})
  await prisma.category.deleteMany().catch(() => {})

  // ---- Chính sách hủy dùng chung ----
  const policy = await prisma.cancellationPolicy.create({
    data: {
      name: 'Linh hoạt tiêu chuẩn',
      isRefundable: true,
      freeHours: 24,
      milestones: {
        create: [
          { daysBefore: 7, refundRate: 100 },
          { daysBefore: 3, refundRate: 50 },
        ],
      },
    },
  })

  // ---- HOMESTAY (Property + RoomType + RoomInventory) ----
  const homestays = [
    {
      propertyCode: 'HS001', name: 'Pine Hill Homestay', slug: 'pine-hill-homestay',
      address: 'Đà Lạt, Lâm Đồng', basePrice: 850000, thumb: 'photo-1618773928121-c32242e63f39',
      desc: 'Homestay ấm cúng giữa rừng thông Đà Lạt, view đồi lãng mạn.',
      rooms: [
        { name: 'Phòng tiêu chuẩn', bed: '1 giường đôi', occ: 2, total: 6, price: 850000, desc: 'Gọn gàng, ban công nhỏ nhìn ra vườn.' },
        { name: 'Phòng Deluxe', bed: '1 giường lớn', occ: 2, total: 4, price: 1250000, desc: 'Rộng rãi, cửa kính lớn view đồi thông.' },
        { name: 'Phòng Family', bed: '2 giường đôi', occ: 4, total: 2, price: 1800000, desc: 'Phù hợp gia đình 4 người.' },
      ],
    },
    {
      propertyCode: 'HS002', name: 'Biển Ngọc Villa', slug: 'bien-ngoc-villa',
      address: 'Mỹ Khê, Đà Nẵng', basePrice: 1600000, thumb: 'photo-1582719478250-c89cae4dc85b',
      desc: 'Villa sát biển Mỹ Khê, hồ bơi riêng, đầy đủ tiện nghi.',
      rooms: [
        { name: 'Phòng hướng biển', bed: '1 giường lớn', occ: 2, total: 5, price: 1600000, desc: 'Ban công nhìn thẳng ra biển.' },
        { name: 'Suite gia đình', bed: '2 giường lớn', occ: 4, total: 3, price: 2600000, desc: 'Không gian rộng, bếp mini.' },
      ],
    },
    {
      propertyCode: 'HS003', name: 'Sông Trăng Riverside', slug: 'song-trang-riverside',
      address: 'Hội An, Quảng Nam', basePrice: 1100000, thumb: 'photo-1566073771259-6a8506099945',
      desc: 'Nhà vườn bên sông Hoài, đạp xe 5 phút tới phố cổ.',
      rooms: [
        { name: 'Phòng vườn', bed: '1 giường đôi', occ: 2, total: 6, price: 1100000, desc: 'Yên tĩnh, nhìn ra vườn.' },
        { name: 'Phòng view sông', bed: '1 giường lớn', occ: 2, total: 3, price: 1600000, desc: 'Ban công nhìn ra sông Hoài.' },
      ],
    },
    {
      propertyCode: 'HS004', name: 'Nhà Của Rừng', slug: 'nha-cua-rung-sapa',
      address: 'Sa Pa, Lào Cai', basePrice: 700000, thumb: 'photo-1501785888041-af3ef285b470',
      desc: 'Bungalow gỗ giữa thung lũng ruộng bậc thang Sa Pa.',
      rooms: [
        { name: 'Giường tầng (Dorm)', bed: 'Giường tầng', occ: 1, total: 10, price: 350000, desc: 'Tiết kiệm cho khách đi phượt.' },
        { name: 'Cabin gỗ', bed: '1 giường đôi', occ: 2, total: 4, price: 1200000, desc: 'Riêng tư, lò sưởi ấm áp.' },
      ],
    },
  ]

  for (const h of homestays) {
    const prop = await prisma.property.create({
      data: {
        propertyCode: h.propertyCode, name: h.name, slug: h.slug, propertyType: 'HOMESTAY',
        shortDescription: h.desc, description: h.desc, address: h.address,
        checkInTime: '14:00', checkOutTime: '12:00', basePrice: h.basePrice, depositRate: 30,
        cancellationPolicyId: policy.id, avgRating: 4.6, reviewCount: 12,
        status: 'VISIBLE', thumbnail: img(h.thumb), isFeatured: true,
      },
    })
    for (const r of h.rooms) {
      const rt = await prisma.roomType.create({
        data: {
          propertyId: prop.id, name: r.name, bedType: r.bed, maxOccupancy: r.occ,
          totalRooms: r.total, breakfastIncluded: true, basePricePerNight: r.price, description: r.desc,
          roomSize: 28,
        },
      })
      // Mở lịch tồn phòng 120 ngày tới.
      const rows = []
      for (let i = 1; i <= 120; i++) {
        rows.push({ roomTypeId: rt.id, date: addDays(i), totalRooms: r.total, bookedRooms: 0, heldRooms: 0 })
      }
      await prisma.roomInventory.createMany({ data: rows })
    }
  }

  // ---- TOUR (Tour + TourDeparture + TourPrice) ----
  const tours = [
    {
      tourCode: 'TR001', title: 'Săn mây Tà Xùa 3N2Đ', slug: 'san-may-ta-xua-3n2d',
      days: 3, nights: 2, basePrice: 2500000, dest: 'Tà Xùa, Sơn La', from: 'Hà Nội',
      thumb: 'photo-1464822759023-fed622ff2c3b', desc: 'Chinh phục sống lưng khủng long, săn biển mây tuyệt đẹp.',
    },
    {
      tourCode: 'TR002', title: 'Khám phá Hà Giang 4N3Đ', slug: 'kham-pha-ha-giang-4n3d',
      days: 4, nights: 3, basePrice: 3900000, dest: 'Hà Giang', from: 'Hà Nội',
      thumb: 'photo-1528127269322-539801943592', desc: 'Cao nguyên đá Đồng Văn, đèo Mã Pí Lèng, sông Nho Quế.',
    },
    {
      tourCode: 'TR003', title: 'Lý Sơn – Đảo tiên 2N1Đ', slug: 'ly-son-dao-tien-2n1d',
      days: 2, nights: 1, basePrice: 1800000, dest: 'Lý Sơn, Quảng Ngãi', from: 'Đà Nẵng',
      thumb: 'photo-1507525428034-b723cf961d3e', desc: 'Đảo núi lửa, bãi biển trong xanh, hải sản tươi ngon.',
    },
    {
      tourCode: 'TR004', title: 'Kỳ Co – Eo Gió 1 ngày', slug: 'ky-co-eo-gio-1-ngay',
      days: 1, nights: 0, basePrice: 650000, dest: 'Quy Nhơn, Bình Định', from: 'Quy Nhơn',
      thumb: 'photo-1519046904884-53103b34b206', desc: 'Biển Kỳ Co ngọc bích, cano vượt sóng, lặn ngắm san hô.',
    },
  ]

  for (const t of tours) {
    const tour = await prisma.tour.create({
      data: {
        tourCode: t.tourCode, title: t.title, slug: t.slug, shortDescription: t.desc, description: t.desc,
        durationDays: t.days, durationNights: t.nights, departurePoint: t.from, destination: t.dest,
        minPax: 1, maxPax: 25, basePrice: t.basePrice, depositRate: 30, cancellationPolicyId: policy.id,
        avgRating: 4.7, reviewCount: 20, status: 'VISIBLE', thumbnail: img(t.thumb), isFeatured: true,
      },
    })
    // 3 chuyến khởi hành sắp tới.
    for (const offset of [10, 24, 40]) {
      const dep = await prisma.tourDeparture.create({
        data: {
          tourId: tour.id, departureDate: addDays(offset), returnDate: addDays(offset + t.days - 1),
          totalSlots: 20, bookedSlots: 0, heldSlots: 0, status: 'OPEN',
        },
      })
      await prisma.tourPrice.createMany({
        data: [
          { departureId: dep.id, paxType: 'ADULT', price: t.basePrice, description: 'Người lớn' },
          { departureId: dep.id, paxType: 'CHILD', price: Math.round(t.basePrice * 0.7), description: 'Trẻ em 5–11 tuổi' },
        ],
      })
    }
  }

  // ---- Khu vực du lịch phổ biến (trang chủ) ----
  await prisma.area.createMany({
    data: [
      { name: 'Đà Lạt', slug: 'da-lat', image: img('photo-1589820296156-2454bb8a6ad1'), order: 1 },
      { name: 'Đà Nẵng', slug: 'da-nang', image: img('photo-1559592413-7cec4d0cae2b'), order: 2 },
      { name: 'Hội An', slug: 'hoi-an', image: img('photo-1535139262971-c51845709a48'), order: 3 },
      { name: 'Sa Pa', slug: 'sa-pa', image: img('photo-1528127269322-539801943592'), order: 4 },
    ],
  })

  // ---- Khuyến mại (banner trang chủ) ----
  await prisma.promotion.createMany({
    data: [
      { title: 'Giảm 20% đặt homestay dịp lễ', description: 'Áp dụng cho đơn đặt trước 7 ngày.', image: img('photo-1501785888041-af3ef285b470'), active: true },
      { title: 'Tour Tây Bắc mùa săn mây', description: 'Ưu đãi nhóm từ 4 khách trở lên.', image: img('photo-1464822759023-fed622ff2c3b'), active: true },
    ],
  })

  // ---- Mã giảm giá ----
  await prisma.discountCode.createMany({
    data: [
      { code: 'STAYTOUR10', type: 'PERCENT', value: 10, minOrderValue: 500000, scope: 'ALL', active: true },
      { code: 'HE2026', type: 'FIXED', value: 150000, minOrderValue: 1000000, scope: 'HOMESTAY', active: true },
    ],
  })

  // ---- Bài thông tin & chính sách (footer) ----
  await prisma.infoArticle.createMany({
    data: [
      { slug: 'gioi-thieu', title: 'Thông tin người bán', category: 'ABOUT', excerpt: 'Về StayTour', content: 'StayTour là nền tảng đặt homestay và tour du lịch nội địa.', order: 1 },
      { slug: 'dieu-kien-giao-dich', title: 'Điều kiện giao dịch chung', category: 'POLICY', excerpt: 'Điều khoản', content: 'Các điều kiện và điều khoản giao dịch chung khi sử dụng StayTour.', order: 2 },
      { slug: 'chinh-sach-doi-tra-huy', title: 'Chính sách đổi – trả – hủy', category: 'POLICY', excerpt: 'Hủy & hoàn tiền', content: 'Chính sách hủy đặt chỗ và hoàn tiền theo từng mốc thời gian.', order: 3 },
      { slug: 'bao-mat-du-lieu', title: 'Bảo vệ dữ liệu cá nhân', category: 'POLICY', excerpt: 'Bảo mật', content: 'Cam kết bảo vệ dữ liệu cá nhân của khách hàng.', order: 4 },
    ],
  })

  // ---- Cẩm nang du lịch ----
  await prisma.travelGuide.create({
    data: {
      title: 'Kinh nghiệm du lịch Đà Lạt 3 ngày 2 đêm', slug: 'kinh-nghiem-du-lich-da-lat-3n2d',
      authorName: 'Ban biên tập StayTour', coverImage: img('photo-1589820296156-2454bb8a6ad1'),
      excerpt: 'Gợi ý lịch trình Đà Lạt tiết kiệm cho nhóm bạn.',
      content: 'Ngày 1: khám phá trung tâm, chợ đêm Đà Lạt.\nNgày 2: đồi chè Cầu Đất, săn mây.\nNgày 3: vườn hoa, mua đặc sản về làm quà.',
      locationName: 'Đà Lạt, Lâm Đồng', status: 'VISIBLE', publishedAt: new Date(),
    },
  })

  // ---- Tài khoản quản trị mặc định (chỉ tạo nếu chưa có) ----
  const adminUsername = process.env.SEED_ADMIN_USERNAME || 'admin'
  const adminPassword = process.env.SEED_ADMIN_PASSWORD || 'Admin@123456'
  const existingAdmin = await prisma.admin.findUnique({ where: { username: adminUsername } })
  if (!existingAdmin) {
    await prisma.admin.create({
      data: { username: adminUsername, password: await bcrypt.hash(adminPassword, 10), name: 'Quản trị viên', role: 'SUPER_ADMIN' },
    })
    console.log(`Đã tạo tài khoản admin mặc định: ${adminUsername} / ${adminPassword} (đổi mật khẩu sau khi đăng nhập).`)
  }

  const counts = {
    properties: await prisma.property.count(),
    roomTypes: await prisma.roomType.count(),
    tours: await prisma.tour.count(),
    departures: await prisma.tourDeparture.count(),
    areas: await prisma.area.count(),
    promotions: await prisma.promotion.count(),
    discountCodes: await prisma.discountCode.count(),
    infoArticles: await prisma.infoArticle.count(),
    travelGuides: await prisma.travelGuide.count(),
    admins: await prisma.admin.count(),
  }
  console.log('Seed hoàn tất:', counts)
}

main()
  .catch((e) => {
    console.error(e)
    process.exit(1)
  })
  .finally(async () => {
    await prisma.$disconnect()
  })
