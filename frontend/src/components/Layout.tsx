import { Link, Outlet, useNavigate } from 'react-router-dom'
import { CategoryMenu } from './CategoryMenu'
import { useAuth } from '../lib/auth'

export function Layout() {
  const { user, logout } = useAuth()
  const navigate = useNavigate()
  return (
    <div className="min-h-screen bg-cream-50 text-forest-900">
      {/* Thanh liên hệ trên cùng (phong cách Travivu/Royelle) */}
      <div className="hidden bg-forest-800 text-cream-100 md:block">
        <div className="mx-auto flex max-w-7xl items-center justify-between px-6 py-2 text-xs">
          <div className="flex items-center gap-5">
            <span className="flex items-center gap-1.5">✆ 1900 6868</span>
            <span className="flex items-center gap-1.5">✉ hotro@staytour.vn</span>
            <span className="hidden items-center gap-1.5 lg:flex">◷ Hỗ trợ đặt phòng 24/7</span>
          </div>
          <div className="flex items-center gap-4">
            <Link to="/track" className="hover:text-white">Tra cứu đơn</Link>
            <Link to="/info" className="hover:text-white">Cẩm nang du lịch</Link>
          </div>
        </div>
      </div>

      {/* Header chính */}
      <header className="sticky top-0 z-30 border-b border-cream-200 bg-cream-50/90 backdrop-blur">
        <div className="mx-auto flex max-w-7xl items-center gap-8 px-6 py-4">
          <Link to="/" className="flex items-center gap-2 font-display text-2xl font-semibold text-forest-700">
            <span className="grid h-9 w-9 place-items-center rounded-full bg-forest-700 text-base text-cream-50">✦</span>
            StayTour
          </Link>
          <div className="hidden lg:block">
            <CategoryMenu />
          </div>
          <div className="ml-auto flex items-center gap-4 text-sm">
            {user ? (
              <div className="flex items-center gap-4">
                <Link to="/orders" className="hidden text-forest-600 hover:text-forest-800 sm:inline">
                  Đơn của tôi
                </Link>
                <Link to="/favorites" className="text-forest-600 hover:text-forest-800">
                  ♡ Yêu thích
                </Link>
                <Link to="/profile" className="flex items-center gap-2 text-forest-700 hover:text-forest-900">
                  {user.avatar && <img src={user.avatar} alt="" className="h-8 w-8 rounded-full object-cover" />}
                  <span className="max-w-[9rem] truncate font-medium">{user.name || user.email}</span>
                </Link>
                <button
                  onClick={() => {
                    logout()
                    navigate('/')
                  }}
                  className="rounded-full border border-forest-300 px-4 py-1.5 font-medium text-forest-700 transition hover:bg-forest-50"
                >
                  Đăng xuất
                </button>
              </div>
            ) : (
              <>
                <Link to="/login" className="font-medium text-forest-700 hover:text-forest-900">
                  Đăng nhập
                </Link>
                <Link
                  to="/register"
                  className="rounded-full bg-forest-700 px-5 py-2 font-medium text-cream-50 shadow-sm transition hover:bg-forest-800"
                >
                  Đăng ký
                </Link>
              </>
            )}
          </div>
        </div>
      </header>

      <main>
        <Outlet />
      </main>

      {/* Footer đầy đủ (phong cách Travivu) */}
      <footer className="mt-20 bg-forest-800 text-cream-100">
        <div className="mx-auto max-w-7xl px-6 py-14">
          <div className="grid gap-10 md:grid-cols-2 lg:grid-cols-4">
            <div>
              <div className="flex items-center gap-2 font-display text-2xl font-semibold text-cream-50">
                <span className="grid h-9 w-9 place-items-center rounded-full bg-cream-50 text-base text-forest-700">✦</span>
                StayTour
              </div>
              <p className="mt-4 max-w-xs text-sm leading-relaxed text-cream-200">
                Đặt phòng homestay và tour du lịch khắp Việt Nam — hành trình của bạn, chỉn chu trong từng chi tiết.
              </p>
              <div className="mt-5 flex gap-3 text-cream-200">
                <span className="grid h-9 w-9 place-items-center rounded-full border border-forest-500 hover:bg-forest-700">f</span>
                <span className="grid h-9 w-9 place-items-center rounded-full border border-forest-500 hover:bg-forest-700">◎</span>
                <span className="grid h-9 w-9 place-items-center rounded-full border border-forest-500 hover:bg-forest-700">✕</span>
                <span className="grid h-9 w-9 place-items-center rounded-full border border-forest-500 hover:bg-forest-700">▶</span>
              </div>
            </div>

            <div>
              <h4 className="font-display text-lg text-cream-50">Khám phá</h4>
              <ul className="mt-4 space-y-2.5 text-sm text-cream-200">
                <li><Link to="/search?type=HOMESTAY" className="hover:text-white">Homestay</Link></li>
                <li><Link to="/search?type=TOUR" className="hover:text-white">Tour du lịch</Link></li>
                <li><Link to="/info" className="hover:text-white">Cẩm nang du lịch</Link></li>
                <li><Link to="/track" className="hover:text-white">Tra cứu đơn hàng</Link></li>
              </ul>
            </div>

            <div>
              <h4 className="font-display text-lg text-cream-50">Hỗ trợ</h4>
              <ul className="mt-4 space-y-2.5 text-sm text-cream-200">
                <li><Link to="/info/gioi-thieu" className="hover:text-white">Thông tin người bán</Link></li>
                <li><Link to="/info/dieu-kien-giao-dich" className="hover:text-white">Điều kiện giao dịch chung</Link></li>
                <li><Link to="/info/chinh-sach-doi-tra-huy" className="hover:text-white">Chính sách đổi–trả–hủy</Link></li>
                <li><Link to="/info/bao-mat-du-lieu" className="hover:text-white">Bảo vệ dữ liệu cá nhân</Link></li>
              </ul>
            </div>

            <div>
              <h4 className="font-display text-lg text-cream-50">Nhận ưu đãi</h4>
              <p className="mt-4 text-sm text-cream-200">Đăng ký để nhận những chương trình khuyến mại mới nhất.</p>
              <form className="mt-4 flex overflow-hidden rounded-full bg-cream-50" onSubmit={(e) => e.preventDefault()}>
                <input
                  type="email"
                  placeholder="Email của bạn"
                  className="min-w-0 flex-1 bg-transparent px-4 py-2.5 text-sm text-forest-900 placeholder:text-forest-400 focus:outline-none"
                />
                <button className="bg-clay-500 px-5 text-sm font-medium text-white transition hover:bg-clay-600">
                  Gửi
                </button>
              </form>
            </div>
          </div>

          <div className="mt-12 border-t border-forest-600 pt-6 text-sm text-cream-200">
            © 2026 StayTour — Đồ án Thương mại điện tử (Nhóm 09). Hành trình của bạn, chỉn chu trong từng chi tiết.
          </div>
        </div>
      </footer>
    </div>
  )
}
