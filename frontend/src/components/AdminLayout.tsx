import { NavLink, Link, Outlet, useLocation, useNavigate } from 'react-router-dom'
import { useAdminAuth } from '../lib/adminAuth'

const ROLE_LABEL: Record<string, string> = {
  SUPER_ADMIN: 'Toàn quyền',
  MANAGER: 'Quản lý',
}

// Cấu trúc menu quản trị theo nhóm chức năng.
const NAV_GROUPS: { title: string; items: { to: string; label: string; icon: string; end?: boolean }[] }[] = [
  {
    title: 'Tổng quan',
    items: [{ to: '/admin', label: 'Bảng điều khiển', icon: '▦', end: true }],
  },
  {
    title: 'Kinh doanh',
    items: [
      { to: '/admin/homestays', label: 'Homestay', icon: '⌂' },
      { to: '/admin/tours', label: 'Tour', icon: '✈' },
      { to: '/admin/guides', label: 'Cẩm nang du lịch', icon: '❏' },
      { to: '/admin/orders', label: 'Đơn hàng', icon: '🧾' },
      { to: '/admin/discounts', label: 'Mã khuyến mại', icon: '％' },
    ],
  },
  {
    title: 'Vận hành',
    items: [
      { to: '/admin/reviews', label: 'Kiểm duyệt đánh giá', icon: '★' },
      { to: '/admin/reports', label: 'Báo cáo & thống kê', icon: '📊' },
      { to: '/admin/users', label: 'Người dùng', icon: '☺' },
      { to: '/admin/settings', label: 'Cấu hình hệ thống', icon: '⚙' },
    ],
  },
]

// Nhãn tiêu đề trang theo đường dẫn hiện tại.
const TITLES: { prefix: string; label: string }[] = [
  { prefix: '/admin/homestays', label: 'Quản lý Homestay' },
  { prefix: '/admin/tours', label: 'Quản lý Tour' },
  { prefix: '/admin/guides', label: 'Cẩm nang du lịch' },
  { prefix: '/admin/orders', label: 'Quản lý đơn hàng' },
  { prefix: '/admin/discounts', label: 'Mã khuyến mại' },
  { prefix: '/admin/reviews', label: 'Kiểm duyệt đánh giá' },
  { prefix: '/admin/reports', label: 'Báo cáo & thống kê' },
  { prefix: '/admin/users', label: 'Quản lý người dùng' },
  { prefix: '/admin/settings', label: 'Cấu hình hệ thống' },
]

export function AdminLayout() {
  const { admin, logout } = useAdminAuth()
  const navigate = useNavigate()
  const { pathname } = useLocation()

  const pageTitle = TITLES.find((t) => pathname.startsWith(t.prefix))?.label ?? 'Bảng điều khiển'
  const initials = (admin?.name || admin?.username || 'A').charAt(0).toUpperCase()

  return (
    <div className="min-h-screen bg-slate-950 text-slate-100">
      <div className="flex">
        {/* ── Sidebar ── */}
        <aside className="fixed inset-y-0 left-0 hidden w-64 flex-col border-r border-slate-800 bg-slate-900 lg:flex">
          <Link to="/admin" className="flex items-center gap-2.5 border-b border-slate-800 px-6 py-5">
            <span className="grid h-9 w-9 place-items-center rounded-lg bg-emerald-500 text-base font-bold text-slate-900">S</span>
            <span className="text-lg font-semibold text-white">StayTour <span className="text-emerald-400">Admin</span></span>
          </Link>

          <nav className="flex-1 space-y-6 overflow-y-auto px-3 py-5">
            {NAV_GROUPS.map((group) => (
              <div key={group.title}>
                <p className="px-3 pb-2 text-[11px] font-semibold uppercase tracking-wider text-slate-500">{group.title}</p>
                <div className="space-y-1">
                  {group.items.map((item) => (
                    <NavLink
                      key={item.to}
                      to={item.to}
                      end={item.end}
                      className={({ isActive }) =>
                        `flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium transition ${
                          isActive
                            ? 'bg-emerald-500/15 text-emerald-300 shadow-[inset_2px_0_0_0] shadow-emerald-400'
                            : 'text-slate-400 hover:bg-slate-800 hover:text-white'
                        }`
                      }
                    >
                      <span className="w-5 text-center text-base">{item.icon}</span>
                      {item.label}
                    </NavLink>
                  ))}
                </div>
              </div>
            ))}
          </nav>

          <div className="border-t border-slate-800 p-3">
            <Link to="/" className="flex items-center gap-3 rounded-lg px-3 py-2 text-sm text-slate-400 transition hover:bg-slate-800 hover:text-white">
              <span className="w-5 text-center">↩</span> Về trang khách hàng
            </Link>
          </div>
        </aside>

        {/* ── Nội dung ── */}
        <div className="min-h-screen flex-1 lg:ml-64">
          <header className="sticky top-0 z-20 flex items-center justify-between border-b border-slate-800 bg-slate-900/80 px-6 py-3.5 backdrop-blur">
            <div>
              <h1 className="text-lg font-semibold text-white">{pageTitle}</h1>
              <p className="text-xs text-slate-500">Khu vực quản trị</p>
            </div>
            <div className="flex items-center gap-4">
              <div className="hidden items-center gap-2.5 sm:flex">
                <span className="grid h-9 w-9 place-items-center rounded-full bg-emerald-500/20 text-sm font-semibold text-emerald-300">
                  {initials}
                </span>
                <div className="leading-tight">
                  <p className="text-sm font-medium text-slate-100">{admin?.name || admin?.username}</p>
                  <p className="text-xs text-slate-500">{admin ? ROLE_LABEL[admin.role] : ''}</p>
                </div>
              </div>
              <button
                onClick={() => {
                  logout()
                  navigate('/admin/login')
                }}
                className="rounded-lg border border-slate-700 px-3.5 py-1.5 text-sm font-medium text-slate-300 transition hover:bg-slate-800"
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
