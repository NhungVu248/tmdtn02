import { Link } from 'react-router-dom'

// Trang giới thiệu website StayTour.
export function AboutPage() {
  const features = [
    { icon: '🏡', title: 'Homestay đa dạng', desc: 'Từ homestay, villa đến căn hộ, resort khắp mọi miền — đặt phòng minh bạch, xác nhận nhanh.' },
    { icon: '🧭', title: 'Tour trọn gói', desc: 'Hành trình theo vùng miền và chủ đề, lịch khởi hành rõ ràng, giá theo từng nhóm khách.' },
    { icon: '🔒', title: 'Thanh toán an toàn', desc: 'Cổng VNPAY sandbox, đặt cọc linh hoạt, chính sách hủy & hoàn tiền công khai.' },
    { icon: '⭐', title: 'Đánh giá thật', desc: 'Chỉ khách đã trải nghiệm mới được đánh giá — kèm hình ảnh, kiểm duyệt minh bạch.' },
  ]
  return (
    <div>
      <section className="bg-gradient-to-br from-emerald-600 to-teal-700 text-white">
        <div className="mx-auto max-w-4xl px-4 py-16 text-center">
          <h1 className="text-3xl font-bold sm:text-4xl">Về StayTour</h1>
          <p className="mx-auto mt-4 max-w-2xl text-emerald-50">
            StayTour là nền tảng đặt homestay và tour du lịch trực tuyến, giúp bạn tìm kiếm, so sánh và đặt chỗ
            cho những chuyến đi đáng nhớ trên khắp Việt Nam — nhanh chóng, minh bạch và an toàn.
          </p>
        </div>
      </section>

      <section className="mx-auto max-w-5xl px-4 py-12">
        <div className="grid gap-6 sm:grid-cols-2">
          {features.map((f) => (
            <div key={f.title} className="rounded-xl border border-slate-200 bg-white p-5">
              <div className="text-3xl">{f.icon}</div>
              <h3 className="mt-3 font-semibold text-slate-900">{f.title}</h3>
              <p className="mt-1 text-sm text-slate-500">{f.desc}</p>
            </div>
          ))}
        </div>
      </section>

      <section className="mx-auto max-w-4xl px-4 pb-12">
        <div className="rounded-xl border border-slate-200 bg-white p-6">
          <h2 className="text-lg font-semibold text-slate-900">Sứ mệnh của chúng tôi</h2>
          <p className="mt-2 leading-relaxed text-slate-600">
            Chúng tôi mong muốn kết nối du khách với những trải nghiệm lưu trú và hành trình chất lượng, đồng thời
            hỗ trợ các chủ homestay và đơn vị lữ hành tiếp cận khách hàng dễ dàng hơn. Mọi thông tin sản phẩm,
            giá cả và chính sách đều được công khai để bạn an tâm khi đặt chỗ.
          </p>
          <div className="mt-5 flex flex-wrap gap-3">
            <Link to="/homestays" className="rounded-lg bg-emerald-600 px-4 py-2 text-sm font-semibold text-white hover:bg-emerald-700">Khám phá homestay</Link>
            <Link to="/tours" className="rounded-lg border border-emerald-600 px-4 py-2 text-sm font-semibold text-emerald-700 hover:bg-emerald-50">Xem tour</Link>
            <Link to="/guides" className="rounded-lg border border-slate-300 px-4 py-2 text-sm font-semibold text-slate-700 hover:bg-slate-50">Cẩm nang du lịch</Link>
          </div>
        </div>

        <div className="mt-6 grid gap-4 text-sm text-slate-600 sm:grid-cols-3">
          <div className="rounded-lg border border-slate-200 bg-white p-4">
            <p className="font-medium text-slate-800">Liên hệ</p>
            <p className="mt-1">support@staytour.example</p>
            <p>Hotline: 1900 0000</p>
          </div>
          <div className="rounded-lg border border-slate-200 bg-white p-4">
            <p className="font-medium text-slate-800">Chính sách</p>
            <Link to="/info/chinh-sach-doi-tra-huy" className="mt-1 block hover:text-emerald-700">Đổi – trả – hủy</Link>
            <Link to="/info/bao-mat-du-lieu" className="block hover:text-emerald-700">Bảo mật dữ liệu</Link>
          </div>
          <div className="rounded-lg border border-slate-200 bg-white p-4">
            <p className="font-medium text-slate-800">Về đồ án</p>
            <p className="mt-1">Thương mại điện tử — Nhóm 09.</p>
          </div>
        </div>
      </section>
    </div>
  )
}
