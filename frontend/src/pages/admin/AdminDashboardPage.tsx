import { useCallback, useEffect, useMemo, useState } from 'react'
import { Link } from 'react-router-dom'
import { useAdminAuth } from '../../lib/adminAuth'
import { adminApi, type AdminReports } from '../../lib/adminApi'
import { AreaChart, BarList, DonutChart, vnd } from '../../components/admin/DashboardCharts'

// Trang tổng quan sau khi đăng nhập khu vực quản trị.
const SHORTCUTS: { to: string; icon: string; title: string; desc: string }[] = [
  { to: '/admin/homestays', icon: '⌂', title: 'Homestay', desc: 'Quản lý chỗ nghỉ & lịch tồn phòng' },
  { to: '/admin/tours', icon: '✈', title: 'Tour', desc: 'Quản lý tour & ngày khởi hành' },
  { to: '/admin/orders', icon: '🧾', title: 'Đơn hàng', desc: 'Xử lý đơn, hủy & hoàn tiền' },
  { to: '/admin/discounts', icon: '％', title: 'Mã khuyến mại', desc: 'Tạo & quản lý ưu đãi' },
  { to: '/admin/reviews', icon: '★', title: 'Đánh giá', desc: 'Xem & phản hồi đánh giá của khách' },
  { to: '/admin/reports', icon: '📊', title: 'Báo cáo', desc: 'Thống kê doanh thu & hoạt động' },
  { to: '/admin/users', icon: '☺', title: 'Người dùng', desc: 'Quản lý tài khoản & phân quyền' },
  { to: '/admin/settings', icon: '⚙', title: 'Cấu hình', desc: 'Thiết lập hệ thống & nhật ký' },
]

const PERIODS = [
  { days: 7, label: '7 ngày' },
  { days: 30, label: '30 ngày' },
  { days: 90, label: '90 ngày' },
]

export function AdminDashboardPage() {
  const { admin } = useAdminAuth()
  const [days, setDays] = useState(30)
  const [rep, setRep] = useState<AdminReports | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  const load = useCallback(() => {
    setLoading(true)
    setError(null)
    const to = new Date()
    const from = new Date(to.getTime() - (days - 1) * 86400000)
    adminApi
      .getReports({ from: from.toISOString().slice(0, 10), to: to.toISOString().slice(0, 10) })
      .then(setRep)
      .catch(() => setError('Không tải được số liệu báo cáo'))
      .finally(() => setLoading(false))
  }, [days])

  useEffect(() => { load() }, [load])

  const totalOrders = useMemo(() => (rep?.ordersByStatus || []).reduce((s, o) => s + o.count, 0), [rep])
  // Donut: ưu tiên theo nhóm dịch vụ (nhiều mục), fallback theo loại (Tour/Homestay).
  const donut = useMemo(() => {
    const g = rep?.revenueByGroup || []
    if (g.length >= 2) return g.map((x) => ({ label: x.name, amount: x.amount }))
    return (rep?.revenueByType || []).map((x) => ({ label: x.label, amount: x.amount }))
  }, [rep])
  const topBars = useMemo(() => (rep?.topTours || []).slice(0, 6).map((t) => ({ label: t.name || `Tour #${t.productId}`, value: t.seats, sub: `${t.bookingsCount} đơn` })), [rep])

  return (
    <div>
      {/* Lời chào */}
      <div className="rounded-2xl border border-slate-800 bg-gradient-to-r from-emerald-900/40 to-slate-900 p-6">
        <h2 className="text-2xl font-semibold text-white">Xin chào, {admin?.name || admin?.username} 👋</h2>
        <p className="mt-1.5 text-slate-300">
          Bạn đang đăng nhập với quyền{' '}
          <span className="font-medium text-emerald-400">
            {admin?.role === 'SUPER_ADMIN' ? 'Toàn quyền (Super Admin)' : 'Quản lý (Manager)'}
          </span>
          .
        </p>
      </div>

      {/* ----- Báo cáo & biểu đồ ----- */}
      <div className="mt-8 mb-4 flex items-center justify-between">
        <h3 className="text-sm font-semibold uppercase tracking-wider text-slate-500">Tổng quan kinh doanh</h3>
        <div className="inline-flex rounded-lg border border-slate-800 bg-slate-900 p-0.5">
          {PERIODS.map((p) => (
            <button key={p.days} onClick={() => setDays(p.days)} className={`rounded-md px-3 py-1 text-xs font-medium transition ${days === p.days ? 'bg-slate-700 text-white' : 'text-slate-400 hover:text-slate-200'}`}>{p.label}</button>
          ))}
        </div>
      </div>

      {error && <div className="mb-4 rounded-lg border border-red-800 bg-red-950/40 px-4 py-2 text-sm text-red-300">⚠️ {error} <button onClick={load} className="ml-2 underline">Thử lại</button></div>}

      {loading ? (
        <p className="text-slate-500">Đang tải số liệu...</p>
      ) : rep ? (
        <>
          {/* KPI */}
          <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
            <Kpi label="Doanh thu thuần" value={vnd(rep.revenue.net)} accent="text-emerald-400" />
            <Kpi label="Tổng thu (gross)" value={vnd(rep.revenue.gross)} />
            <Kpi label="Đã hoàn tiền" value={vnd(rep.revenue.refunded)} accent="text-clay-400" />
            <Kpi label="Số đơn trong kỳ" value={String(totalOrders)} />
          </div>

          <div className="mt-4 grid gap-4 lg:grid-cols-2">
            <Card title="Doanh thu theo dịch vụ">
              <DonutChart data={donut} />
            </Card>
            <Card title="Tour bán chạy (theo số chỗ)">
              <BarList data={topBars} unit=" chỗ" />
            </Card>
          </div>
          <div className="mt-4">
            <Card title={`Xu hướng doanh thu (${days} ngày)`}>
              <AreaChart data={rep.revenue.byDay} />
            </Card>
          </div>
        </>
      ) : null}

      {/* Truy cập nhanh */}
      <h3 className="mt-8 mb-4 text-sm font-semibold uppercase tracking-wider text-slate-500">Truy cập nhanh</h3>
      <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
        {SHORTCUTS.map((s) => (
          <Link
            key={s.to}
            to={s.to}
            className="group rounded-2xl border border-slate-800 bg-slate-900 p-5 transition hover:border-emerald-500/60 hover:bg-slate-800/60"
          >
            <span className="grid h-11 w-11 place-items-center rounded-xl bg-emerald-500/15 text-xl text-emerald-300 transition group-hover:bg-emerald-500/25">
              {s.icon}
            </span>
            <p className="mt-3 font-semibold text-white">{s.title}</p>
            <p className="mt-1 text-sm text-slate-400">{s.desc}</p>
          </Link>
        ))}
      </div>
    </div>
  )
}

function Kpi({ label, value, accent = 'text-white' }: { label: string; value: string; accent?: string }) {
  return (
    <div className="rounded-2xl border border-slate-800 bg-slate-900 p-4">
      <p className="text-xs uppercase tracking-wide text-slate-500">{label}</p>
      <p className={`mt-1 text-xl font-bold ${accent}`}>{value}</p>
    </div>
  )
}
function Card({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <div className="rounded-2xl border border-slate-800 bg-slate-900 p-5">
      <h4 className="mb-4 font-semibold text-slate-200">{title}</h4>
      {children}
    </div>
  )
}
