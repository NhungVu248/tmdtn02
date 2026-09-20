import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

// Ảnh minh hoạ (Unsplash) – chỉ dùng cho dữ liệu demo.
const img = (id, w = 800) => `https://images.unsplash.com/${id}?auto=format&fit=crop&w=${w}&q=70`

async function main() {
  // Dọn dữ liệu cũ (giữ bảng User).
  await prisma.product.deleteMany()
  await prisma.category.deleteMany()
  await prisma.area.deleteMany()
  await prisma.promotion.deleteMany()
  await prisma.infoArticle.deleteMany()

  // ----- Danh mục nhiều cấp -----
  // Homestay: Tỉnh/thành -> Khu vực -> Loại hình
  const hsDaLat = await prisma.category.create({ data: { name: 'Homestay Đà Lạt', slug: 'homestay-da-lat', type: 'HOMESTAY', order: 1 } })
  const hsDaLatCenter = await prisma.category.create({ data: { name: 'Trung tâm Đà Lạt', slug: 'homestay-da-lat-trung-tam', type: 'HOMESTAY', parentId: hsDaLat.id, order: 1 } })
  const hsDaLatVilla = await prisma.category.create({ data: { name: 'Villa/Biệt thự', slug: 'homestay-da-lat-villa', type: 'HOMESTAY', parentId: hsDaLatCenter.id, order: 1 } })

  const hsDaNang = await prisma.category.create({ data: { name: 'Homestay Đà Nẵng', slug: 'homestay-da-nang', type: 'HOMESTAY', order: 2 } })
  const hsDaNangBien = await prisma.category.create({ data: { name: 'Gần biển Mỹ Khê', slug: 'homestay-da-nang-my-khe', type: 'HOMESTAY', parentId: hsDaNang.id, order: 1 } })

  // Tour: Vùng miền -> Chủ đề -> Thời lượng
  const tourBac = await prisma.category.create({ data: { name: 'Tour Miền Bắc', slug: 'tour-mien-bac', type: 'TOUR', order: 1 } })
  const tourBacNui = await prisma.category.create({ data: { name: 'Núi rừng Tây Bắc', slug: 'tour-mien-bac-tay-bac', type: 'TOUR', parentId: tourBac.id, order: 1 } })
  const tourBacNui3n = await prisma.category.create({ data: { name: '3 ngày 2 đêm', slug: 'tour-mien-bac-tay-bac-3n2d', type: 'TOUR', parentId: tourBacNui.id, order: 1 } })

  const tourTrung = await prisma.category.create({ data: { name: 'Tour Miền Trung', slug: 'tour-mien-trung', type: 'TOUR', order: 2 } })
  const tourTrungBien = await prisma.category.create({ data: { name: 'Biển đảo', slug: 'tour-mien-trung-bien-dao', type: 'TOUR', parentId: tourTrung.id, order: 1 } })

  // ----- Sản phẩm -----
  const products = [
    { name: 'Pine Hill Homestay', slug: 'pine-hill-homestay', type: 'HOMESTAY', location: 'Đà Lạt', price: 850000, rating: 4.8, isFeatured: true, categoryId: hsDaLatVilla.id, amenities: 'Wifi,Bếp,Chỗ đậu xe,View đồi', thumbnail: img('photo-1522708323590-d24dbb6b0267'), description: 'Homestay view đồi thông, không gian yên tĩnh gần trung tâm Đà Lạt.' },
    { name: 'Sunny Villa Đà Lạt', slug: 'sunny-villa-da-lat', type: 'HOMESTAY', location: 'Đà Lạt', price: 1500000, rating: 4.9, isFeatured: true, categoryId: hsDaLatVilla.id, amenities: 'Wifi,Bếp,Hồ bơi,Chỗ đậu xe,BBQ', thumbnail: img('photo-1618773928121-c32242e63f39'), description: 'Villa nguyên căn 3 phòng ngủ, có bếp và sân vườn.' },
    { name: 'Cozy Corner Đà Lạt', slug: 'cozy-corner-da-lat', type: 'HOMESTAY', location: 'Đà Lạt', price: 550000, rating: 4.5, isFeatured: false, categoryId: hsDaLatCenter.id, amenities: 'Wifi,Máy sưởi', thumbnail: img('photo-1560448204-e02f11c3d0e2'), description: 'Phòng đôi ấm cúng ngay trung tâm, đi bộ ra chợ đêm.' },
    { name: 'Sea Breeze Mỹ Khê', slug: 'sea-breeze-my-khe', type: 'HOMESTAY', location: 'Đà Nẵng', price: 950000, rating: 4.7, isFeatured: true, categoryId: hsDaNangBien.id, amenities: 'Wifi,Máy lạnh,View biển,Ban công', thumbnail: img('photo-1566073771259-6a8506099945'), description: 'Homestay cách biển Mỹ Khê 200m, ban công đón nắng.' },
    { name: 'Ocean View Studio', slug: 'ocean-view-studio', type: 'HOMESTAY', location: 'Đà Nẵng', price: 1200000, rating: 4.6, isFeatured: false, categoryId: hsDaNangBien.id, amenities: 'Wifi,Máy lạnh,Hồ bơi,View biển', thumbnail: img('photo-1582719478250-c89cae4dc85b'), description: 'Studio tầng cao nhìn ra biển, đầy đủ tiện nghi.' },
    // Sản phẩm ẩn (HIDDEN) để kiểm chứng BR-01/BR-04: không được hiển thị.
    { name: 'Hidden Homestay (ẩn)', slug: 'hidden-homestay', type: 'HOMESTAY', status: 'HIDDEN', location: 'Đà Lạt', price: 700000, rating: 4.0, isFeatured: true, categoryId: hsDaLatCenter.id, amenities: 'Wifi', thumbnail: img('photo-1520250497591-112f2f40a3f4'), description: 'Sản phẩm đang ẩn – KHÔNG được xuất hiện ở trang chủ/danh mục/tìm kiếm.' },

    { name: 'Chinh phục Fansipan 3N2Đ', slug: 'tour-fansipan-3n2d', type: 'TOUR', location: 'Sa Pa, Lào Cai', price: 3200000, rating: 4.8, isFeatured: true, categoryId: tourBacNui3n.id, durationDays: 3, thumbnail: img('photo-1464822759023-fed622ff2c3b'), description: 'Trekking Tây Bắc, chinh phục nóc nhà Đông Dương.' },
    { name: 'Săn mây Tà Xùa 3N2Đ', slug: 'tour-ta-xua-3n2d', type: 'TOUR', location: 'Sơn La', price: 2500000, rating: 4.7, isFeatured: false, categoryId: tourBacNui3n.id, durationDays: 3, thumbnail: img('photo-1454496522488-7a8e488e8606'), description: 'Săn mây, cắm trại giữa sống lưng khủng long Tà Xùa.' },
    { name: 'Cù Lao Chàm 1 ngày', slug: 'tour-cu-lao-cham', type: 'TOUR', location: 'Hội An, Quảng Nam', price: 750000, rating: 4.6, isFeatured: true, categoryId: tourTrungBien.id, durationDays: 1, thumbnail: img('photo-1505228395891-9a51e7e86bf6'), description: 'Lặn ngắm san hô, khám phá đảo Cù Lao Chàm.' },
    { name: 'Lý Sơn 2N1Đ', slug: 'tour-ly-son-2n1d', type: 'TOUR', location: 'Quảng Ngãi', price: 1800000, rating: 4.5, isFeatured: false, categoryId: tourTrungBien.id, durationDays: 2, thumbnail: img('photo-1507525428034-b723cf961d3e'), description: 'Đảo tiền tiêu Lý Sơn, cánh đồng tỏi và biển xanh.' },
  ]
  const cancellationPolicy =
    'Miễn phí hủy trong vòng 24 giờ sau khi đặt. Hủy trước 7 ngày so với ngày nhận/khởi hành: hoàn 100%. ' +
    'Hủy trong vòng 3–7 ngày: hoàn 50%. Hủy trong vòng 3 ngày: không hoàn tiền.'

  const created = {}
  for (const p of products) {
    const data = { ...p, cancellationPolicy }
    if (p.type === 'TOUR') {
      data.priceChild = Math.round(p.price * 0.7) // BR-09: giá trẻ em
      data.itinerary =
        `Ngày 1: Khởi hành, di chuyển đến điểm đến, nhận phòng.\n` +
        `Ngày 2: Tham quan các điểm nổi bật, trải nghiệm địa phương.\n` +
        (p.durationDays >= 3 ? `Ngày 3: Tự do khám phá và trở về.` : `Buổi chiều: Trở về, kết thúc chương trình.`)
    }
    created[p.slug] = await prisma.product.create({ data })
  }

  // ----- Thư viện ảnh: thumbnail + 2 ảnh phụ -----
  const galleryExtra = ['photo-1560448204-603b3fc33ddc', 'photo-1512918728675-ed5a9ecdebfd']
  for (const p of Object.values(created)) {
    const urls = [p.thumbnail, ...galleryExtra.map((id) => img(id))]
    await prisma.productImage.createMany({
      data: urls.filter(Boolean).map((url, i) => ({ productId: p.id, url, order: i })),
    })
  }

  // ----- Đánh giá (BR-08: có cả đánh giá CHƯA duyệt để kiểm chứng) -----
  const reviewsBySlug = {
    'pine-hill-homestay': [
      { authorName: 'Minh Anh', rating: 5, comment: 'View đồi thông tuyệt đẹp, chủ nhà thân thiện.', approved: true },
      { authorName: 'Hoàng Nam', rating: 4, comment: 'Phòng sạch, hơi xa trung tâm một chút.', approved: true },
      { authorName: 'Spam Bot', rating: 1, comment: 'Đánh giá chưa kiểm duyệt – KHÔNG được hiển thị.', approved: false },
    ],
    'sunny-villa-da-lat': [
      { authorName: 'Thu Hà', rating: 5, comment: 'Villa rộng rãi, hồ bơi sạch, rất đáng tiền.', approved: true },
    ],
    'tour-fansipan-3n2d': [
      { authorName: 'Đức Long', rating: 5, comment: 'Hướng dẫn viên nhiệt tình, cảnh đẹp mê ly.', approved: true },
      { authorName: 'Chưa duyệt', rating: 2, comment: 'Bình luận đang chờ duyệt.', approved: false },
    ],
  }
  for (const [slug, list] of Object.entries(reviewsBySlug)) {
    const p = created[slug]
    if (p) await prisma.review.createMany({ data: list.map((r) => ({ ...r, productId: p.id })) })
  }

  // Cập nhật rating trung bình từ các đánh giá đã duyệt.
  for (const p of Object.values(created)) {
    const agg = await prisma.review.aggregate({
      where: { productId: p.id, approved: true },
      _avg: { rating: true },
    })
    if (agg._avg.rating != null) {
      await prisma.product.update({ where: { id: p.id }, data: { rating: Number(agg._avg.rating.toFixed(1)) } })
    }
  }

  // ----- Lịch tồn phòng homestay: 30 đêm tới, xen kẽ vài đêm hết phòng (ngoại lệ 3a) -----
  // Dùng UTC midnight để khớp với cột @db.Date của Prisma (tránh lệch múi giờ).
  const now = new Date()
  const baseUtc = Date.UTC(now.getFullYear(), now.getMonth(), now.getDate())
  const dayOffset = (n) => new Date(baseUtc + n * 86400000)
  for (const p of Object.values(created)) {
    if (p.type !== 'HOMESTAY') continue
    const rows = []
    for (let i = 0; i < 30; i++) {
      const total = 5
      // Hết phòng ở đêm thứ 3 và 4 (để test "không còn chỗ trống").
      const booked = i === 3 || i === 4 ? 5 : (i % 5 === 0 ? 3 : 1)
      rows.push({ productId: p.id, date: dayOffset(i), totalRooms: total, bookedRooms: booked })
    }
    await prisma.homestayAvailability.createMany({ data: rows })
  }

  // ----- Chuyến khởi hành tour: vài mốc, có 1 chuyến hết chỗ -----
  for (const p of Object.values(created)) {
    if (p.type !== 'TOUR') continue
    await prisma.tourDeparture.createMany({
      data: [
        { productId: p.id, date: dayOffset(7), totalSeats: 20, bookedSeats: 5 },
        { productId: p.id, date: dayOffset(14), totalSeats: 20, bookedSeats: 20 }, // hết chỗ
        { productId: p.id, date: dayOffset(21), totalSeats: 20, bookedSeats: 12 },
      ],
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

  const counts = {
    categories: await prisma.category.count(),
    products: await prisma.product.count(),
    areas: await prisma.area.count(),
    promotions: await prisma.promotion.count(),
    infoArticles: await prisma.infoArticle.count(),
  }
  console.log('Seed hoàn tất:', counts)
}

main()
  .catch((e) => { console.error(e); process.exit(1) })
  .finally(async () => { await prisma.$disconnect() })
