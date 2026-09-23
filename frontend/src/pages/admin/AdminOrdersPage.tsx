import { useCallback, useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { adminApi, type AdminOrder } from '../../lib/adminApi'

const STATUS_LABEL: Record<string, string> = {
  PENDING_DEPOSIT: 'Chờ cọc',
  DEPOSITED: 'Đã cọc',
  CONFIRMED: 'Đã xác nhận',
  COMPLETED: 'Hoàn tất',
  CANCELLED: 'Đã hủy',
}
const STATUS_COLOR: Record<string, string> = {
  PENDING_DEPOSIT: 'bg-amber-900 text-amber-300',
  DEPOSITED: 'bg-blue-900 text-blue-300',
  CONFIRMED: 'bg-indigo-900 text-indigo-300',
  COMPLETED: 'bg-emerald-900 text-emerald-300',
  CANCELLED: 'bg-slate-800 text-slate-400',
}

const field = 'rounded-lg border border-slate-700 bg-slate-800 px-3 py-2 text-sm text-slate-100 focus:border-emerald-500 focus:outline-none'

// UC-18 – Danh sách đơn (mọi trạng thái) kèm bộ lọc theo trạng thái/loại/thời gian.
export function AdminOrdersPage() {
  const [items, setItems] = useState<AdminOrder[]>([])
  const [search, setSearch] = useState('')
  const [status, setStatus] = useState('')
  const [type, setType] = useState('')
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  const load = useCallback(() => {
    setLoading(true)
    adminApi
      .listOrders({ status: status || undefined, type: type || undefined, search: search || undefined })
      .then((r) => setItems(r.items))
      .catch(() => setError('Không tải được danh sách đơn'))
      .finally(() => setLoading(false))
  }, [status, type, search])

  useEffect(() => {
    load()
  }, [load])

  return (
    <div>
      <h1 className="mb-6 text-2xl font-bold text-white">Quản lý đơn</h1>

      <div className="mb-4 flex flex-wrap gap-3">
        <input
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          placeholder="Tìm theo mã đơn, tên, email..."
          className={`${field} w-64`}
        />
        <select value={status} onChange={(e) => setStatus(e.target.value)} className={field}>
          <option value="">Tất cả trạng thái</option>
          {Object.entries(STATUS_LABEL).map(([k, v]) => (
            <option key={k} value={k}>
              {v}
            </option>
          ))}
        </select>
        <select value={type} onChange={(e) => setType(e.target.value)} className={field}>
          <option value="">Tất cả loại</option>
          <option value="HOMESTAY">Homestay</option>
          <option value="TOUR">Tour</option>
        </select>
      </div>

      {error && <div className="mb-4 rounded-lg border border-red-800 bg-red-950/40 px-4 py-2 text-sm text-red-300">{error}</div>}

      {loading ? (
        <p className="text-slate-500">Đang tải...</p>
      ) : items.length === 0 ? (
        <p className="text-slate-500">Không có đơn nào khớp bộ lọc.</p>
      ) : (
        <div className="overflow-hidden rounded-xl border border-slate-800">
          <table className="w-full text-sm">
            <thead className="bg-slate-950 text-left text-slate-400">
              <tr>
                <th className="px-4 py-3">Mã đơn</th>
                <th className="px-4 py-3">Sản phẩm</th>
                <th className="px-4 py-3">Khách</th>
                <th className="px-4 py-3">Ngày</th>
                <th className="px-4 py-3">Tổng tiền</th>
                <th className="px-4 py-3">Trạng thái</th>
                <th className="px-4 py-3"></th>
              </tr>
            </thead>
            <tbody>
              {items.map((o) => (
                <tr key={o.code} className="border-t border-slate-800">
                  <td className="px-4 py-3 font-mono text-slate-200">{o.code}</td>
                  <td className="px-4 py-3 text-slate-300">
                    {o.productName} <span className="text-xs text-slate-500">({o.type === 'HOMESTAY' ? 'Homestay' : 'Tour'})</span>
                  </td>
                  <td className="px-4 py-3 text-slate-400">
                    {o.guestName}
                    <div className="text-xs text-slate-600">{o.guestEmail}</div>
                  </td>
                  <td className="px-4 py-3 text-slate-400">{o.checkIn ? new Date(o.checkIn).toLocaleDateString('vi-VN') : '-'}</td>
                  <td className="px-4 py-3 text-slate-400">{o.totalPrice.toLocaleString('vi-VN')}₫</td>
                  <td className="px-4 py-3">
                    <span className={`rounded-full px-2 py-0.5 text-xs ${STATUS_COLOR[o.status]}`}>{STATUS_LABEL[o.status]}</span>
                  </td>
                  <td className="px-4 py-3">
                    <Link to={`/admin/orders/${o.code}`} className="text-emerald-400 hover:underline">
                      Chi tiết
                    </Link>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  )
}
