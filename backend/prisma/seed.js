import { PrismaClient } from '@prisma/client'
import bcrypt from 'bcryptjs'

const prisma = new PrismaClient()

// Ảnh minh hoạ (Unsplash) – chỉ dùng cho dữ liệu demo.
const img = (id, w = 800) => `https://images.unsplash.com/${id}?auto=format&fit=crop&w=${w}&q=70`

// Ngày UTC-midnight để khớp cột @db.Date của Prisma (tránh lệch múi giờ).
const now = new Date()
const baseUtc = Date.UTC(now.getFullYear(), now.getMonth(), now.getDate())
const dayOffset = (n) => new Date(baseUtc + n * 86400000)
const inDays = (n) => new Date(Date.now() + n * 86400000)

async function main() {
  // ----- Dọn dữ liệu cũ theo đúng thứ tự khóa ngoại -----
  // Review tham chiếu Booking (Restrict) -> xóa trước Booking.
  await prisma.review.deleteMany() // cascade -> ReviewImage
  await prisma.booking.deleteMany() // cascade -> Payment, RefundRequest, ReviewToken
  await prisma.favorite.deleteMany()
  await prisma.discountCode.deleteMany() // tham chiếu Product/Property/Tour (Restrict)
  await prisma.tour.deleteMany() // cascade -> TourImage/Departure(+Price)/Itinerary/Inclusion/Note/TravelGuideTour
  await prisma.property.deleteMany() // cascade -> RoomType(+Inventory/Image)/Image/Amenity/Policy
  await prisma.amenity.deleteMany()
  await prisma.product.deleteMany() // di sản: cascade -> ProductImage/HomestayAvailability
  await prisma.category.deleteMany()
  await prisma.cancellationPolicy.deleteMany() // cascade -> PolicyMilestone
  await prisma.area.deleteMany()
  await prisma.promotion.deleteMany()
  await prisma.infoArticle.deleteMany()

  // ----- Danh mục nhiều cấp (có `kind` cho model Property/Tour mới) -----
  // Homestay: Tỉnh/thành (province) -> Khu vực (area)
  const catDaLat = await prisma.category.create({ data: { name: 'Đà Lạt', slug: 'da-lat-tinh', type: 'HOMESTAY', kind: 'province', order: 1 } })
  const catDaLatCenter = await prisma.category.create({ data: { name: 'Trung tâm Đà Lạt', slug: 'da-lat-trung-tam', type: 'HOMESTAY', kind: 'area', parentId: catDaLat.id, order: 1 } })
  const catDaNang = await prisma.category.create({ data: { name: 'Đà Nẵng', slug: 'da-nang-tinh', type: 'HOMESTAY', kind: 'province', order: 2 } })
  const catMyKhe = await prisma.category.create({ data: { name: 'Gần biển Mỹ Khê', slug: 'da-nang-my-khe', type: 'HOMESTAY', kind: 'area', parentId: catDaNang.id, order: 1 } })

  // Tour: Vùng miền (region) + Chủ đề (theme)
  const regMienBac = await prisma.category.create({ data: { name: 'Miền Bắc', slug: 'tour-mien-bac', type: 'TOUR', kind: 'region', order: 1 } })
  const regMienTrung = await prisma.category.create({ data: { name: 'Miền Trung', slug: 'tour-mien-trung', type: 'TOUR', kind: 'region', order: 2 } })
  const themeTrekking = await prisma.category.create({ data: { name: 'Trekking / Núi rừng', slug: 'tour-trekking', type: 'TOUR', kind: 'theme', order: 1 } })
  const themeBienDao = await prisma.category.create({ data: { name: 'Biển đảo', slug: 'tour-bien-dao', type: 'TOUR', kind: 'theme', order: 2 } })

  // ----- Chính sách hủy dùng chung (UC-14/23) -----
  const policy = await prisma.cancellationPolicy.create({
    data: {
      name: 'Chính sách hủy tiêu chuẩn',
      isRefundable: true,
      freeHours: 24, // miễn phí hủy trong 24h đầu sau khi đặt
      milestones: {
        create: [
          { daysBefore: 7, refundRate: 100 }, // hủy trước 7 ngày: hoàn 100%
          { daysBefore: 3, refundRate: 50 }, // hủy trước 3–7 ngày: hoàn 50%
          { daysBefore: 0, refundRate: 0 }, // trong 3 ngày: không hoàn
        ],
      },
    },
  })

  // ----- Tiện nghi (Amenity) -----
  const amenityNames = [
    { name: 'Wifi', scope: 'GENERAL' },
    { name: 'Bếp', scope: 'GENERAL' },
    { name: 'Chỗ đậu xe', scope: 'GENERAL' },
    { name: 'Hồ bơi', scope: 'GENERAL' },
    { name: 'BBQ', scope: 'GENERAL' },
    { name: 'Máy lạnh', scope: 'ROOM' },
    { name: 'Máy sưởi', scope: 'ROOM' },
    { name: 'Ban công', scope: 'ROOM' },
    { name: 'View biển', scope: 'ROOM' },
    { name: 'View đồi', scope: 'ROOM' },
  ]
  const amenity = {}
  for (const a of amenityNames) {
    amenity[a.name] = await prisma.amenity.create({ data: a })
  }

  const galleryExtra = ['photo-1560448204-603b3fc33ddc', 'photo-1512918728675-ed5a9ecdebfd']
  // Lịch tồn phòng 30 đêm tới; hết phòng đêm thứ 3 & 4 để test "không còn chỗ trống".
  const buildInventory = (total) =>
    Array.from({ length: 30 }, (_, i) => ({
      date: dayOffset(i),
      totalRooms: total,
      bookedRooms: i === 3 || i === 4 ? total : i % 5 === 0 ? Math.min(total, 2) : 1,
    }))

  // ----- Chỗ nghỉ (Property → RoomType → RoomInventory) -----
  const properties = [
    {
      code: 'PROP-PINE', name: 'Pine Hill Homestay', slug: 'pine-hill-homestay', propertyType: 'HOMESTAY',
      provinceId: catDaLat.id, areaId: catDaLatCenter.id, address: 'Phường 10, TP. Đà Lạt', basePrice: 850000,
      isFeatured: true, thumbnail: img('photo-1522708323590-d24dbb6b0267'),
      shortDescription: 'View đồi thông, yên tĩnh gần trung tâm Đà Lạt.',
      description: 'Homestay view đồi thông, không gian yên tĩnh, cách chợ đêm Đà Lạt 10 phút đi xe.',
      amenities: ['Wifi', 'Bếp', 'Chỗ đậu xe', 'View đồi', 'Máy sưởi'],
      rooms: [
        { name: 'Phòng Đôi Deluxe', bedType: '1 giường đôi', maxOccupancy: 2, totalRooms: 4, basePricePerNight: 850000, breakfastIncluded: true },
        { name: 'Phòng Gia đình', bedType: '2 giường đôi', maxOccupancy: 4, totalRooms: 2, basePricePerNight: 1300000 },
      ],
    },
    {
      code: 'PROP-SUNNY', name: 'Sunny Villa Đà Lạt', slug: 'sunny-villa-da-lat', propertyType: 'VILLA',
      provinceId: catDaLat.id, areaId: catDaLatCenter.id, address: 'Đường Trần Hưng Đạo, TP. Đà Lạt', basePrice: 1500000,
      isFeatured: true, thumbnail: img('photo-1618773928121-c32242e63f39'),
      shortDescription: 'Villa nguyên căn có hồ bơi và sân vườn.',
      description: 'Villa 3 phòng ngủ, có bếp, hồ bơi và khu BBQ ngoài trời, phù hợp nhóm/gia đình.',
      amenities: ['Wifi', 'Bếp', 'Hồ bơi', 'Chỗ đậu xe', 'BBQ'],
      rooms: [
        { name: 'Villa nguyên căn 3PN', bedType: '3 giường đôi', maxOccupancy: 8, totalRooms: 2, basePricePerNight: 1500000, breakfastIncluded: true },
      ],
    },
    {
      code: 'PROP-COZY', name: 'Cozy Corner Đà Lạt', slug: 'cozy-corner-da-lat', propertyType: 'HOMESTAY',
      provinceId: catDaLat.id, areaId: catDaLatCenter.id, address: 'Gần chợ đêm Đà Lạt', basePrice: 550000,
      isFeatured: false, thumbnail: img('photo-1560448204-e02f11c3d0e2'),
      shortDescription: 'Ấm cúng, đi bộ ra chợ đêm.',
      description: 'Phòng đôi ấm cúng ngay trung tâm, đi bộ ra chợ đêm Đà Lạt.',
      amenities: ['Wifi', 'Máy sưởi'],
      rooms: [
        { name: 'Phòng Đôi Tiêu chuẩn', bedType: '1 giường đôi', maxOccupancy: 2, totalRooms: 6, basePricePerNight: 550000 },
      ],
    },
    {
      code: 'PROP-SEA', name: 'Sea Breeze Mỹ Khê', slug: 'sea-breeze-my-khe', propertyType: 'HOMESTAY',
      provinceId: catDaNang.id, areaId: catMyKhe.id, address: 'Cách biển Mỹ Khê 200m, TP. Đà Nẵng', basePrice: 950000,
      isFeatured: true, thumbnail: img('photo-1566073771259-6a8506099945'),
      shortDescription: 'Cách biển Mỹ Khê 200m, ban công đón nắng.',
      description: 'Homestay gần biển Mỹ Khê, ban công đón nắng, đầy đủ tiện nghi.',
      amenities: ['Wifi', 'Máy lạnh', 'View biển', 'Ban công'],
      rooms: [
        { name: 'Phòng Đôi View biển', bedType: '1 giường đôi', maxOccupancy: 2, totalRooms: 5, basePricePerNight: 950000, breakfastIncluded: true },
        { name: 'Phòng Ba', bedType: '1 đôi + 1 đơn', maxOccupancy: 3, totalRooms: 3, basePricePerNight: 1250000 },
      ],
    },
    {
      code: 'PROP-OCEAN', name: 'Ocean View Studio', slug: 'ocean-view-studio', propertyType: 'APARTMENT',
      provinceId: catDaNang.id, areaId: catMyKhe.id, address: 'Tầng cao ven biển, TP. Đà Nẵng', basePrice: 1200000,
      isFeatured: false, thumbnail: img('photo-1582719478250-c89cae4dc85b'),
      shortDescription: 'Studio tầng cao nhìn ra biển.',
      description: 'Studio tầng cao nhìn ra biển, có hồ bơi vô cực, đầy đủ tiện nghi.',
      amenities: ['Wifi', 'Máy lạnh', 'Hồ bơi', 'View biển'],
      rooms: [
        { name: 'Studio View biển', bedType: '1 giường đôi', maxOccupancy: 2, totalRooms: 4, basePricePerNight: 1200000 },
      ],
    },
    // Chỗ nghỉ ẩn (HIDDEN) để kiểm chứng BR-73: KHÔNG được hiển thị.
    {
      code: 'PROP-HIDDEN', name: 'Hidden Homestay (ẩn)', slug: 'hidden-homestay', propertyType: 'HOMESTAY',
      status: 'HIDDEN', provinceId: catDaLat.id, areaId: catDaLatCenter.id, basePrice: 700000,
      isFeatured: true, thumbnail: img('photo-1520250497591-112f2f40a3f4'),
      shortDescription: 'Đang ẩn – không được xuất hiện.',
      description: 'Chỗ nghỉ đang ẩn – KHÔNG được xuất hiện ở trang chủ/danh mục/tìm kiếm.',
      amenities: ['Wifi'],
      rooms: [{ name: 'Phòng Đôi', bedType: '1 giường đôi', maxOccupancy: 2, totalRooms: 2, basePricePerNight: 700000 }],
    },
  ]

  const propBySlug = {}
  for (const p of properties) {
    const created = await prisma.property.create({
      data: {
        propertyCode: p.code,
        name: p.name,
        slug: p.slug,
        propertyType: p.propertyType,
        status: p.status || 'VISIBLE',
        shortDescription: p.shortDescription,
        description: p.description,
        provinceId: p.provinceId,
        areaId: p.areaId,
        address: p.address,
        checkInTime: '14:00',
        checkOutTime: '12:00',
        basePrice: p.basePrice,
        isFeatured: p.isFeatured,
        thumbnail: p.thumbnail,
        cancellationPolicyId: policy.id,
        images: {
          create: [p.thumbnail, ...galleryExtra.map((id) => img(id))]
            .filter(Boolean)
            .map((url, i) => ({ url, isCover: i === 0, sortOrder: i })),
        },
        amenities: {
          create: p.amenities.map((n) => ({ amenity: { connect: { id: amenity[n].id } } })),
        },
        policies: {
          create: [
            { type: 'HOUSE_RULE', title: 'Nội quy', content: 'Xuất trình giấy tờ tùy thân khi nhận phòng. Không hút thuốc trong phòng. Giữ yên lặng sau 22:00.' },
          ],
        },
        roomTypes: {
          create: p.rooms.map((r) => ({
            name: r.name,
            bedType: r.bedType,
            maxOccupancy: r.maxOccupancy,
            totalRooms: r.totalRooms,
            basePricePerNight: r.basePricePerNight,
            breakfastIncluded: r.breakfastIncluded || false,
            inventory: { create: buildInventory(r.totalRooms) },
          })),
        },
      },
    })
    propBySlug[p.slug] = created
  }

  // ----- Tour (Tour → Departure → Price / Itinerary / Inclusion / Note) -----
  const tours = [
    {
      code: 'TOUR-FANSIPAN', title: 'Chinh phục Fansipan 3N2Đ', slug: 'tour-fansipan-3n2d',
      regionId: regMienBac.id, themeId: themeTrekking.id, durationDays: 3, durationNights: 2,
      departurePoint: 'Hà Nội', destination: 'Sa Pa, Lào Cai', basePrice: 3200000, isFeatured: true,
      thumbnail: img('photo-1464822759023-fed622ff2c3b'),
      shortDescription: 'Trekking Tây Bắc, chinh phục nóc nhà Đông Dương.',
      description: 'Hành trình chinh phục đỉnh Fansipan 3143m, trải nghiệm văn hóa bản địa và cảnh sắc núi rừng Tây Bắc.',
    },
    {
      code: 'TOUR-TAXUA', title: 'Săn mây Tà Xùa 3N2Đ', slug: 'tour-ta-xua-3n2d',
      regionId: regMienBac.id, themeId: themeTrekking.id, durationDays: 3, durationNights: 2,
      departurePoint: 'Hà Nội', destination: 'Bắc Yên, Sơn La', basePrice: 2500000, isFeatured: false,
      thumbnail: img('photo-1454496522488-7a8e488e8606'),
      shortDescription: 'Săn mây, cắm trại giữa sống lưng khủng long.',
      description: 'Săn mây, cắm trại và check-in sống lưng khủng long Tà Xùa nổi tiếng.',
    },
    {
      code: 'TOUR-CULAOCHAM', title: 'Cù Lao Chàm 1 ngày', slug: 'tour-cu-lao-cham',
      regionId: regMienTrung.id, themeId: themeBienDao.id, durationDays: 1, durationNights: 0,
      departurePoint: 'Hội An', destination: 'Cù Lao Chàm, Quảng Nam', basePrice: 750000, isFeatured: true,
      thumbnail: img('photo-1505228395891-9a51e7e86bf6'),
      shortDescription: 'Lặn ngắm san hô, khám phá đảo.',
      description: 'Tour trong ngày lặn ngắm san hô và khám phá đảo Cù Lao Chàm.',
    },
    {
      code: 'TOUR-LYSON', title: 'Lý Sơn 2N1Đ', slug: 'tour-ly-son-2n1d',
      regionId: regMienTrung.id, themeId: themeBienDao.id, durationDays: 2, durationNights: 1,
      departurePoint: 'Quảng Ngãi', destination: 'Đảo Lý Sơn, Quảng Ngãi', basePrice: 1800000, isFeatured: false,
      thumbnail: img('photo-1507525428034-b723cf961d3e'),
      shortDescription: 'Đảo tiền tiêu, cánh đồng tỏi và biển xanh.',
      description: 'Khám phá đảo tiền tiêu Lý Sơn: cổng Tò Vò, hang Câu, cánh đồng tỏi và biển xanh.',
    },
  ]

  const tourBySlug = {}
  for (const t of tours) {
    const nights = t.durationDays >= 3 ? 3 : 2
    const itinerary = Array.from({ length: t.durationDays }, (_, i) => ({
      dayNumber: i + 1,
      title:
        i === 0 ? 'Khởi hành & nhận đoàn' : i === t.durationDays - 1 ? 'Tự do & trở về' : 'Tham quan & trải nghiệm',
      description:
        i === 0
          ? `Xe/di chuyển đến ${t.destination}, nhận phòng, ăn tối và nghỉ ngơi.`
          : i === t.durationDays - 1
            ? 'Ăn sáng, tự do mua sắm đặc sản, di chuyển về điểm khởi hành, kết thúc chương trình.'
            : 'Tham quan các điểm nổi bật, trải nghiệm ẩm thực và văn hóa địa phương.',
      meals: i === 0 ? 'Tối' : 'Sáng, Trưa, Tối',
    }))

    // 3 chuyến: sắp tới (mở), sau 2 tuần (hết chỗ), sau 3 tuần (mở)
    const mkPrices = () => ({
      create: [
        { paxType: 'ADULT', price: t.basePrice, description: 'Người lớn' },
        { paxType: 'CHILD', price: Math.round(t.basePrice * 0.7), description: 'Trẻ em 5–11 tuổi' },
      ],
    })
    const created = await prisma.tour.create({
      data: {
        tourCode: t.code,
        title: t.title,
        slug: t.slug,
        status: 'VISIBLE',
        shortDescription: t.shortDescription,
        description: t.description,
        regionId: t.regionId,
        themeId: t.themeId,
        durationDays: t.durationDays,
        durationNights: t.durationNights,
        departurePoint: t.departurePoint,
        destination: t.destination,
        minPax: 2,
        maxPax: 20,
        basePrice: t.basePrice,
        isFeatured: t.isFeatured,
        thumbnail: t.thumbnail,
        cancellationPolicyId: policy.id,
        images: {
          create: [t.thumbnail, ...galleryExtra.map((id) => img(id))]
            .filter(Boolean)
            .map((url, i) => ({ url, isCover: i === 0, sortOrder: i })),
        },
        itinerary: { create: itinerary },
        inclusions: {
          create: [
            { type: 'INCLUDED', itemText: 'Xe đưa đón theo chương trình', sortOrder: 0 },
            { type: 'INCLUDED', itemText: 'Hướng dẫn viên nhiệt tình', sortOrder: 1 },
            { type: 'INCLUDED', itemText: 'Các bữa ăn theo lịch trình', sortOrder: 2 },
            { type: 'EXCLUDED', itemText: 'Chi phí cá nhân, đồ uống', sortOrder: 0 },
            { type: 'EXCLUDED', itemText: 'VAT (nếu có)', sortOrder: 1 },
          ],
        },
        notes: {
          create: [
            { type: 'TERM', title: 'Cần biết trước khi đặt', content: 'Mang theo giấy tờ tùy thân. Trẻ em dưới 5 tuổi miễn phí (ngủ ghép).', sortOrder: 0 },
            { type: 'FAQ', title: 'Có đón tận nơi không?', content: 'Xe đón tại điểm hẹn trung tâm; đón tận nơi tùy khu vực, vui lòng liên hệ.', sortOrder: 1 },
          ],
        },
        departures: {
          create: [
            { departureDate: dayOffset(7), returnDate: dayOffset(7 + nights), totalSlots: 20, bookedSlots: 5, status: 'OPEN', prices: mkPrices() },
            { departureDate: dayOffset(14), returnDate: dayOffset(14 + nights), totalSlots: 20, bookedSlots: 20, status: 'FULL', prices: mkPrices() },
            { departureDate: dayOffset(21), returnDate: dayOffset(21 + nights), totalSlots: 20, bookedSlots: 12, status: 'OPEN', prices: mkPrices() },
          ],
        },
      },
    })
    tourBySlug[t.slug] = created
  }

  // ----- Đánh giá đa hình (BR-08: có cả đánh giá CHƯA duyệt để kiểm chứng) -----
  const propReviews = {
    'pine-hill-homestay': [
      { authorName: 'Minh Anh', rating: 5, comment: 'View đồi thông tuyệt đẹp, chủ nhà thân thiện.', approved: true },
      { authorName: 'Hoàng Nam', rating: 4, comment: 'Phòng sạch, hơi xa trung tâm một chút.', approved: true },
      { authorName: 'Spam Bot', rating: 1, comment: 'Đánh giá chưa kiểm duyệt – KHÔNG được hiển thị.', approved: false },
    ],
    'sunny-villa-da-lat': [
      { authorName: 'Thu Hà', rating: 5, comment: 'Villa rộng rãi, hồ bơi sạch, rất đáng tiền.', approved: true },
    ],
  }
  for (const [slug, list] of Object.entries(propReviews)) {
    const p = propBySlug[slug]
    if (p) {
      await prisma.review.createMany({ data: list.map((r) => ({ ...r, productType: 'HOMESTAY', propertyId: p.id })) })
    }
  }
  const tourReviews = {
    'tour-fansipan-3n2d': [
      { authorName: 'Đức Long', rating: 5, comment: 'Hướng dẫn viên nhiệt tình, cảnh đẹp mê ly.', approved: true },
      { authorName: 'Chưa duyệt', rating: 2, comment: 'Bình luận đang chờ duyệt.', approved: false },
    ],
  }
  for (const [slug, list] of Object.entries(tourReviews)) {
    const t = tourBySlug[slug]
    if (t) {
      await prisma.review.createMany({ data: list.map((r) => ({ ...r, productType: 'TOUR', tourId: t.id })) })
    }
  }

  // Cập nhật avgRating/reviewCount từ đánh giá đã duyệt.
  for (const p of Object.values(propBySlug)) {
    const agg = await prisma.review.aggregate({ where: { propertyId: p.id, approved: true }, _avg: { rating: true }, _count: true })
    await prisma.property.update({
      where: { id: p.id },
      data: { avgRating: agg._avg.rating ? Number(agg._avg.rating.toFixed(1)) : 0, reviewCount: agg._count },
    })
  }
  for (const t of Object.values(tourBySlug)) {
    const agg = await prisma.review.aggregate({ where: { tourId: t.id, approved: true }, _avg: { rating: true }, _count: true })
    await prisma.tour.update({
      where: { id: t.id },
      data: { avgRating: agg._avg.rating ? Number(agg._avg.rating.toFixed(1)) : 0, reviewCount: agg._count },
    })
  }

  // ----- Khu vực du lịch phổ biến -----
  await prisma.area.createMany({
    data: [
      { name: 'Đà Lạt', slug: 'da-lat', order: 1, image: img('photo-1528127269322-539801943592', 600) },
      { name: 'Đà Nẵng', slug: 'da-nang', order: 2, image: img('photo-1559592413-7cec4d0cae2b', 600) },
      { name: 'Sa Pa', slug: 'sa-pa', order: 3, image: img('photo-1528181304800-259b08848526', 600) },
      { name: 'Hội An', slug: 'hoi-an', order: 4, image: img('photo-1535139262971-c51845709a48', 600) },
    ],
  })

  // ----- Khuyến mại -----
  await prisma.promotion.createMany({
    data: [
      { title: 'Giảm 20% đặt homestay dịp lễ', description: 'Áp dụng cho đơn đặt trước 7 ngày.', active: true, image: img('photo-1501117716987-c8e2a3a8e0f9', 800) },
      { title: 'Tour Tây Bắc mùa săn mây', description: 'Ưu đãi nhóm từ 4 khách trở lên.', active: true, image: img('photo-1519681393784-d120267933ba', 800) },
      { title: 'Khuyến mại đã kết thúc (ẩn)', description: 'Không hiển thị vì active = false.', active: false },
    ],
  })

  // ----- UC-04: Bài viết thông tin & chính sách (BR-10) + cẩm nang -----
  const P = (arr) => arr.join('\n\n')
  await prisma.infoArticle.createMany({
    data: [
      {
        slug: 'gioi-thieu',
        title: 'Thông tin người bán',
        category: 'ABOUT',
        order: 1,
        excerpt: 'Thông tin về đơn vị vận hành nền tảng StayTour.',
        content: P([
          'StayTour là nền tảng đặt homestay và tour du lịch trực tuyến, kết nối du khách với các chủ homestay và đơn vị lữ hành trên khắp Việt Nam.',
          'Đơn vị vận hành: Nhóm 09 – Đồ án môn Thương mại điện tử (CSE703102).',
          'Địa chỉ: Trường Đại học ... · Email: support@staytour.example · Hotline: 1900 0000.',
        ]),
      },
      {
        slug: 'dieu-kien-giao-dich',
        title: 'Điều kiện giao dịch chung',
        category: 'POLICY',
        order: 1,
        excerpt: 'Quy định chung áp dụng cho mọi giao dịch trên nền tảng.',
        content: P([
          '1. Phạm vi áp dụng: các giao dịch đặt homestay và tour thực hiện qua nền tảng StayTour.',
          '2. Giá và thanh toán: giá hiển thị đã bao gồm các loại phí theo quy định; phương thức thanh toán được nêu tại bước đặt.',
          '3. Quyền và nghĩa vụ: người dùng cung cấp thông tin chính xác; nền tảng bảo đảm thông tin sản phẩm đúng như công bố.',
        ]),
      },
      {
        slug: 'chinh-sach-doi-tra-huy',
        title: 'Chính sách đổi – trả – hủy',
        category: 'POLICY',
        order: 2,
        excerpt: 'Điều kiện hoàn/hủy đơn đặt homestay và tour.',
        content: P([
          'Miễn phí hủy trong vòng 24 giờ sau khi đặt.',
          'Hủy trước 7 ngày so với ngày nhận phòng/khởi hành: hoàn 100%.',
          'Hủy trong vòng 3–7 ngày: hoàn 50%. Hủy trong vòng 3 ngày: không hoàn tiền.',
          'Yêu cầu đổi/hủy được gửi qua tài khoản hoặc hotline hỗ trợ.',
        ]),
      },
      {
        slug: 'bao-mat-du-lieu',
        title: 'Chính sách bảo vệ dữ liệu cá nhân',
        category: 'POLICY',
        order: 3,
        excerpt: 'Cách nền tảng thu thập, sử dụng và bảo vệ dữ liệu người dùng.',
        content: P([
          'Chúng tôi thu thập thông tin cần thiết để xử lý đặt chỗ: họ tên, liên hệ, thông tin đặt.',
          'Dữ liệu được sử dụng cho mục đích cung cấp dịch vụ và không chia sẻ cho bên thứ ba ngoài phạm vi giao dịch.',
          'Người dùng có quyền yêu cầu truy cập, chỉnh sửa hoặc xóa dữ liệu cá nhân của mình.',
        ]),
      },
      {
        slug: 'kinh-nghiem-du-lich-da-lat',
        title: 'Kinh nghiệm du lịch Đà Lạt',
        category: 'GUIDE',
        order: 1,
        excerpt: 'Gợi ý thời điểm, di chuyển và điểm đến khi tới Đà Lạt.',
        content: P([
          'Thời điểm đẹp: tháng 11–12 mùa hoa dã quỳ, tháng 3 mùa mai anh đào.',
          'Di chuyển: xe khách giường nằm hoặc máy bay tới Liên Khương, sau đó thuê xe máy dạo quanh thành phố.',
          'Điểm đến gợi ý: hồ Tuyền Lâm, đồi chè Cầu Đất, chợ đêm Đà Lạt.',
        ]),
      },
      {
        slug: 'chuan-bi-trekking-tay-bac',
        title: 'Chuẩn bị cho chuyến trekking Tây Bắc',
        category: 'GUIDE',
        order: 2,
        excerpt: 'Danh sách đồ dùng và lưu ý an toàn khi trekking.',
        content: P([
          'Trang bị: giày trekking, áo giữ nhiệt, áo mưa, đèn pin, nước và đồ ăn nhẹ.',
          'Sức khỏe: luyện thể lực trước chuyến đi; đi theo nhóm và hướng dẫn viên.',
          'An toàn: theo dõi thời tiết, không tách đoàn, giữ liên lạc.',
        ]),
      },
      // Bài CHƯA công bố -> dùng kiểm chứng ngoại lệ 2a (không tìm thấy).
      {
        slug: 'ban-nhap-chua-cong-bo',
        title: 'Bản nháp chưa công bố',
        category: 'GUIDE',
        order: 99,
        published: false,
        content: 'Nội dung này chưa được công bố và KHÔNG được hiển thị.',
      },
    ],
  })

  // ----- UC-12: Mã giảm giá mẫu (BR-48: bình thường do admin tạo qua UC-20) -----
  await prisma.discountCode.createMany({
    data: [
      { code: 'STAYTOUR10', type: 'PERCENT', value: 10, minOrderValue: 500000, scope: 'ALL', maxUses: 100, startAt: inDays(-30), endAt: inDays(60) },
      { code: 'HOMESTAY50K', type: 'FIXED', value: 50000, minOrderValue: 300000, scope: 'HOMESTAY', maxUses: 50, startAt: inDays(-30), endAt: inDays(60) },
      { code: 'TOUR15', type: 'PERCENT', value: 15, minOrderValue: 1000000, scope: 'TOUR', maxUses: 50, startAt: inDays(-30), endAt: inDays(60) },
      // Đã hết hạn -> kiểm chứng ngoại lệ 2a.
      { code: 'EXPIRED5', type: 'PERCENT', value: 5, scope: 'ALL', startAt: inDays(-60), endAt: inDays(-1) },
      // Đã hết lượt -> kiểm chứng ngoại lệ 2b.
      { code: 'USEDUP', type: 'FIXED', value: 100000, scope: 'ALL', maxUses: 1, usedCount: 1, startAt: inDays(-30), endAt: inDays(60) },
      // Yêu cầu đơn tối thiểu rất cao -> kiểm chứng ngoại lệ 3a.
      { code: 'VIP2TR', type: 'FIXED', value: 200000, minOrderValue: 20000000, scope: 'ALL', startAt: inDays(-30), endAt: inDays(60) },
    ],
  })

  // ----- UC-24: Tài khoản quản trị mặc định (chỉ tạo nếu chưa có, không xóa admin cũ) -----
  const adminUsername = process.env.SEED_ADMIN_USERNAME || 'admin'
  const adminPassword = process.env.SEED_ADMIN_PASSWORD || 'Admin@123456'
  const existingAdmin = await prisma.admin.findUnique({ where: { username: adminUsername } })
  if (!existingAdmin) {
    await prisma.admin.create({
      data: {
        username: adminUsername,
        password: await bcrypt.hash(adminPassword, 10),
        name: 'Quản trị viên',
        role: 'SUPER_ADMIN',
      },
    })
    console.log(`Đã tạo tài khoản admin mặc định: ${adminUsername} / ${adminPassword} (đổi mật khẩu ngay sau khi đăng nhập lần đầu)`)
  }

  const counts = {
    categories: await prisma.category.count(),
    properties: await prisma.property.count(),
    roomTypes: await prisma.roomType.count(),
    tours: await prisma.tour.count(),
    tourDepartures: await prisma.tourDeparture.count(),
    reviews: await prisma.review.count(),
    areas: await prisma.area.count(),
    promotions: await prisma.promotion.count(),
    infoArticles: await prisma.infoArticle.count(),
    discountCodes: await prisma.discountCode.count(),
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
