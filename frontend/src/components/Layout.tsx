import { Link, Outlet, useNavigate } from 'react-router-dom'
import { CategoryMenu } from './CategoryMenu'
import { useAuth } from '../lib/auth'

export function Layout() {
  const { user, logout } = useAuth()
  const navigate = useNavigate()
  return (
    <div className="min-h-screen bg-slate-50 text-slate-900">
      <header className="sticky top-0 z-30 border-b border-slate-200 bg-white/90 backdrop-blur">
        <div className="mx-auto flex max-w-6xl items-center gap-6 px-4 py-3">
          <Link to="/" className="text-lg font-bold text-emerald-700">
            🏡 StayTour
          </Link>
          <CategoryMenu />
          <div className="ml-auto flex items-center gap-3 text-sm">
            <Link to="/info" className="text-slate-600 hover:text-emerald-700">
              Thông tin & chính sách
            </Link>
            {user ? (
              <div className="flex items-center gap-2">
                <Link to="/profile" className="flex items-center gap-2 hover:text-emerald-700">
                  {user.avatar && <img src={user.avatar} alt="" className="h-7 w-7 rounded-full" />}
                  <span className="max-w-[10rem] truncate text-slate-700">{user.name || user.email}</span>
                </Link>
                <button
                  onClick={() => {
                    logout()
                    navigate('/')
                  }}
                  className="rounded-lg border border-slate-300 px-3 py-1.5 font-medium hover:bg-slate-50"
                >
                  Đăng xuất
                </button>
              </div>
            ) : (
              <>
                <Link to="/login" className="text-slate-600 hover:text-emerald-700">
                  Đăng nhập
                </Link>
                <Link
                  to="/register"
                  className="rounded-lg bg-emerald-600 px-3 py-1.5 font-medium text-white hover:bg-emerald-700"
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

      <footer className="mt-16 border-t border-slate-200 bg-white">
        <div className="mx-auto max-w-6xl px-4 py-8 text-sm text-slate-500">
          <div className="flex flex-wrap gap-x-8 gap-y-2">
            <Link to="/info/gioi-thieu" className="hover:text-emerald-700">Thông tin người bán</Link>
            <Link to="/info/dieu-kien-giao-dich" className="hover:text-emerald-700">Điều kiện giao dịch chung</Link>
            <Link to="/info/chinh-sach-doi-tra-huy" className="hover:text-emerald-700">Chính sách đổi–trả–hủy</Link>
            <Link to="/info/bao-mat-du-lieu" className="hover:text-emerald-700">Bảo vệ dữ liệu cá nhân</Link>
            <Link to="/info" className="hover:text-emerald-700">Cẩm nang du lịch</Link>
          </div>
          <p className="mt-4">© 2026 StayTour — Đồ án Thương mại điện tử (Nhóm 09).</p>
        </div>
      </footer>
    </div>
  )
}
