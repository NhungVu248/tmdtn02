import { Link } from 'react-router-dom'

const FEATURES = [
  { icon: '🏡', title: 'Homestay đa dạng', desc: 'Từ homestay, villa đến căn hộ, resort khắp mọi miền — đặt phòng minh bạch, xác nhận nhanh.' },
  { icon: '🧭', title: 'Tour trọn gói', desc: 'Hành trình theo vùng miền và chủ đề, lịch khởi hành rõ ràng, giá theo từng nhóm khách.' },
  { icon: '🔒', title: 'Thanh toán an toàn', desc: 'Cổng VNPAY sandbox, đặt cọc linh hoạt, chính sách hủy & hoàn tiền công khai.' },
  { icon: '⭐', title: 'Đánh giá thật', desc: 'Chỉ khách đã trải nghiệm mới được đánh giá — kèm hình ảnh, kiểm duyệt minh bạch.' },
]

// Đội ngũ phát triển (theo bảng phân công nhiệm vụ - Nhóm 09).
const TEAM = [
  {
    name: 'Vũ Hồng Nhung',
    role: 'Nhóm trưởng · Front-end · Back-end',
    tasks: 'Lập kế hoạch, phân công, theo dõi tiến độ, đầu mối liên hệ giảng viên; lập trình giao diện & hệ thống (code chính); báo cáo.',
    lead: true,
  },
  {
    name: 'Trần Thiên Đạt',
    role: 'Phân tích – Thiết kế',
    tasks: 'Khảo sát nghiệp vụ, đặc tả yêu cầu, thiết kế use case, sitemap, wireframe; báo cáo.',
  },
  {
    name: 'Vũ Thị Hải Yến',
    role: 'Phân tích – Thiết kế · QA',
    tasks: 'Hỗ trợ đặc tả, sơ đồ use case, wireframe; thiết kế & thực hiện ca kiểm thử, rà soát bảo mật; báo cáo.',
  },
  {
    name: 'Đào Quỳnh Nga',
    role: 'Phân tích – Thiết kế',
    tasks: 'Hỗ trợ sơ đồ use case; xây dựng cấu trúc & khung báo cáo theo yêu cầu giảng viên; báo cáo.',
  },
  {
    name: 'Đoàn Thị Thu Thảo',
    role: 'Bảo mật – Kiểm thử (QA)',
    tasks: 'Thiết kế & thực hiện ca kiểm thử, đối chiếu yêu cầu pháp lý; báo cáo.',
  },
]

// Trang giới thiệu website StayTour.
export function AboutPage() {
  return (
    <div>
      {/* ── Hero banner ── */}
      <section className="relative overflow-hidden">
        <img
          src="https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1600&q=75"
          alt=""
          className="absolute inset-0 h-full w-full object-cover"
        />
        <div className="absolute inset-0 bg-gradient-to-r from-forest-900/90 via-forest-900/70 to-forest-900/40" />
        <div className="relative mx-auto max-w-4xl px-6 py-24 text-center">
          <p className="mb-4 text-sm font-medium uppercase tracking-[0.3em] text-cream-200">Về chúng tôi</p>
          <h1 className="font-display text-5xl font-semibold text-cream-50 sm:text-6xl">Về StayTour</h1>
          <p className="mx-auto mt-5 max-w-2xl text-lg leading-relaxed text-cream-100">
            StayTour là nền tảng đặt homestay và tour du lịch trực tuyến, giúp bạn tìm kiếm, so sánh và đặt chỗ cho
            những chuyến đi đáng nhớ trên khắp Việt Nam — nhanh chóng, minh bạch và an toàn.
          </p>
          <div className="mt-8 flex flex-wrap justify-center gap-4">
            <Link to="/homestays" className="rounded-full bg-clay-500 px-7 py-3 text-sm font-semibold text-white shadow-lg transition hover:bg-clay-600">
              Khám phá homestay →
            </Link>
            <Link to="/tours" className="rounded-full border border-cream-100/60 bg-white/10 px-7 py-3 text-sm font-semibold text-cream-50 backdrop-blur transition hover:bg-white/20">
              Xem tour
            </Link>
          </div>
        </div>
      </section>

      {/* ── Tính năng nổi bật ── */}
      <section className="mx-auto max-w-6xl px-6 py-16">
        <div className="mb-10 text-center">
          <p className="text-sm font-medium uppercase tracking-[0.2em] text-clay-500">Điểm nổi bật</p>
          <h2 className="mt-2 font-display text-4xl font-semibold text-forest-900">Vì sao chọn StayTour</h2>
        </div>
        <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-4">
          {FEATURES.map((f) => (
            <div key={f.title} className="rounded-2xl border border-cream-200 bg-white p-6 transition hover:shadow-lg hover:shadow-forest-900/5">
              <div className="grid h-12 w-12 place-items-center rounded-xl bg-forest-100 text-2xl">{f.icon}</div>
              <h3 className="mt-4 font-display text-lg font-semibold text-forest-900">{f.title}</h3>
              <p className="mt-1.5 text-sm leading-relaxed text-forest-400">{f.desc}</p>
            </div>
          ))}
        </div>
      </section>

      {/* ── Đội ngũ phát triển ── */}
      <section className="bg-cream-100/60 py-16">
        <div className="mx-auto max-w-6xl px-6">
          <div className="mb-10 text-center">
            <p className="text-sm font-medium uppercase tracking-[0.2em] text-clay-500">Nhóm 09</p>
            <h2 className="mt-2 font-display text-4xl font-semibold text-forest-900">Đội ngũ phát triển</h2>
            <p className="mx-auto mt-2 max-w-xl text-forest-400">
              Những thành viên đã cùng nhau xây dựng StayTour cho đồ án Thương mại điện tử.
            </p>
          </div>

          <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
            {TEAM.map((m) => (
              <div
                key={m.name}
                className={`rounded-2xl border bg-white p-6 transition hover:shadow-lg hover:shadow-forest-900/5 ${
                  m.lead ? 'border-clay-400 ring-1 ring-clay-400/30' : 'border-cream-200'
                }`}
              >
                <div className="flex items-center gap-4">
                  <div className="grid h-14 w-14 shrink-0 place-items-center rounded-full bg-forest-100 font-display text-xl font-semibold text-forest-700">
                    {m.name.split(' ').pop()?.charAt(0)}
                  </div>
                  <div className="min-w-0">
                    <div className="flex items-center gap-2">
                      <h3 className="font-display text-lg font-semibold text-forest-900">{m.name}</h3>
                      {m.lead && (
                        <span className="rounded-full bg-clay-500/15 px-2 py-0.5 text-[11px] font-medium text-clay-600">Trưởng nhóm</span>
                      )}
                    </div>
                    <p className="text-sm font-medium text-forest-500">{m.role}</p>
                  </div>
                </div>
                <p className="mt-4 border-t border-cream-100 pt-3 text-sm leading-relaxed text-forest-400">{m.tasks}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ── Sứ mệnh & liên hệ ── */}
      <section className="mx-auto max-w-5xl px-6 py-16">
        <div className="rounded-3xl border border-cream-200 bg-white p-8">
          <h2 className="font-display text-2xl font-semibold text-forest-900">Sứ mệnh của chúng tôi</h2>
          <p className="mt-3 leading-relaxed text-forest-500">
            Chúng tôi mong muốn kết nối du khách với những trải nghiệm lưu trú và hành trình chất lượng, đồng thời hỗ trợ
            các chủ homestay và đơn vị lữ hành tiếp cận khách hàng dễ dàng hơn. Mọi thông tin sản phẩm, giá cả và chính
            sách đều được công khai để bạn an tâm khi đặt chỗ.
          </p>
          <div className="mt-6 flex flex-wrap gap-3">
            <Link to="/homestays" className="rounded-full bg-forest-700 px-5 py-2.5 text-sm font-semibold text-cream-50 hover:bg-forest-800">Khám phá homestay</Link>
            <Link to="/tours" className="rounded-full border border-forest-300 px-5 py-2.5 text-sm font-semibold text-forest-700 hover:bg-forest-50">Xem tour</Link>
            <Link to="/guides" className="rounded-full border border-cream-300 px-5 py-2.5 text-sm font-semibold text-forest-600 hover:bg-cream-100">Cẩm nang du lịch</Link>
          </div>
        </div>

        <div className="mt-6 grid gap-4 sm:grid-cols-3">
          <div className="rounded-2xl border border-cream-200 bg-white p-5 text-sm text-forest-500">
            <p className="font-display text-base font-semibold text-forest-900">Liên hệ</p>
            <p className="mt-2">hotro@staytour.vn</p>
            <p>Hotline: 1900 6868</p>
          </div>
          <div className="rounded-2xl border border-cream-200 bg-white p-5 text-sm text-forest-500">
            <p className="font-display text-base font-semibold text-forest-900">Chính sách</p>
            <Link to="/info/chinh-sach-doi-tra-huy" className="mt-2 block hover:text-clay-600">Đổi – trả – hủy</Link>
            <Link to="/info/bao-mat-du-lieu" className="block hover:text-clay-600">Bảo mật dữ liệu</Link>
          </div>
          <div className="rounded-2xl border border-cream-200 bg-white p-5 text-sm text-forest-500">
            <p className="font-display text-base font-semibold text-forest-900">Về đồ án</p>
            <p className="mt-2">Thương mại điện tử — Nhóm 09.</p>
          </div>
        </div>
      </section>
    </div>
  )
}
