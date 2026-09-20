import { Link, Outlet } from 'react-router-dom'
import { CategoryMenu } from './CategoryMenu'

export function Layout() {
  return (
    <div className="min-h-screen bg-slate-50 text-slate-900">
      <header className="sticky top-0 z-30 border-b border-slate-200 bg-white/90 backdrop-blur">
        <div className="mx-auto flex max-w-6xl items-center gap-6 px-4 py-3">
          <Link to="/" className="text-lg font-bold text-emerald-700">
            🏡 StayTour
          </Link>
          <CategoryMenu />
          <div className="ml-auto flex items-center gap-2 text-sm">
            <Link to="/info/chinh-sach" className="text-slate-600 hover:text-emerald-700">
              Thông tin & chính sách
            </Link>
          </div>
        </div>
      </header>

      <main>
        <Outlet />
      </main>

      <footer className="mt-16 border-t border-slate-200 bg-white">
        <div className="mx-auto max-w-6xl px-4 py-8 text-sm text-slate-500">
          <div className="flex flex-wrap gap-x-8 gap-y-2">
            <Link to="/info/gioi-thieu" className="hover:text-emerald-700">Về chúng tôi</Link>
            <Link to="/info/chinh-sach-huy" className="hover:text-emerald-700">Chính sách hủy</Link>
            <Link to="/info/bao-mat" className="hover:text-emerald-700">Bảo vệ dữ liệu cá nhân</Link>
            <Link to="/info/cam-nang" className="hover:text-emerald-700">Cẩm nang du lịch</Link>
          </div>
          <p className="mt-4">© 2026 StayTour — Đồ án Thương mại điện tử (Nhóm 09).</p>
        </div>
      </footer>
    </div>
  )
}
