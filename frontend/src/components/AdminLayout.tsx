import { Link, Outlet, useNavigate } from 'react-router-dom'
import { useAdminAuth } from '../lib/adminAuth'

const ROLE_LABEL: Record<string, string> = {
  SUPER_ADMIN: 'Toàn quyền',
  MANAGER: 'Quản lý',
}

// UC-24 – Khung giao diện khu vực quản trị (/admin), hoàn toàn tách biệt với Layout Customer.
export function AdminLayout() {
  const { admin, logout } = useAdminAuth()
  const navigate = useNavigate()

  return (
    <div className="min-h-screen bg-slate-900 text-slate-100">
      <div className="flex">
        <aside className="hidden w-56 shrink-0 border-r border-slate-800 bg-slate-950 p-4 lg:block">
          <Link to="/admin" className="mb-6 block text-lg font-bold text-white">
            🛠️ StayTour Admin
          </Link>
          <nav className="space-y-1 text-sm">
            <NavItem to="/admin">Tổng quan</NavItem>
            <NavItem to="/admin/homestays">Homestay (UC-16)</NavItem>
            <NavItem to="/admin/tours">Tour (UC-17)</NavItem>
            <NavItem to="/admin/orders">Đơn hàng (UC-18)</NavItem>
            <NavItem to="/admin/users">Người dùng (UC-19)</NavItem>
            <NavItem to="/admin/discounts">Mã khuyến mại (UC-20)</NavItem>
            <NavItem to="/admin/reviews">Kiểm duyệt đánh giá (UC-21)</NavItem>
            <NavItem to="/admin/reports">Báo cáo (UC-22)</NavItem>
            <NavItem to="/admin/settings">Cấu hình (UC-23)</NavItem>
          </nav>
        </aside>

        <div className="min-h-screen flex-1">
          <header className="flex items-center justify-between border-b border-slate-800 bg-slate-900 px-4 py-3">
            <span className="text-sm text-slate-400">Khu vực quản trị</span>
            <div className="flex items-center gap-3 text-sm">
              <span className="text-slate-300">
                {admin?.name || admin?.username}{' '}
                <span className="rounded-full bg-slate-800 px-2 py-0.5 text-xs text-slate-400">
                  {admin ? ROLE_LABEL[admin.role] : ''}
                </span>
              </span>
              <button
                onClick={() => {
                  logout()
                  navigate('/admin/login')
                }}
                className="rounded-lg border border-slate-700 px-3 py-1.5 font-medium hover:bg-slate-800"
              >
                Đăng xuất
              </button>
            </div>
          </header>
          <main className="p-6">
            <Outlet />
          </main>
        </div>
      </div>
    </div>
  )
}

function NavItem({ to, disabled, children }: { to: string; disabled?: boolean; children: React.ReactNode }) {
  if (disabled) {
    return (
      <span className="block cursor-not-allowed rounded-lg px-3 py-2 text-slate-600" title="Sẽ hoàn thiện ở UC tương ứng">
        {children}
      </span>
    )
  }
  return (
    <Link to={to} className="block rounded-lg px-3 py-2 text-slate-300 hover:bg-slate-800 hover:text-white">
      {children}
    </Link>
  )
}
