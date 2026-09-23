import { useCallback, useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { adminApi, type AdminTour } from '../../lib/adminApi'

// UC-17 – Danh sách tour trong khu vực quản trị (mọi trạng thái).
export function AdminToursPage() {
  const [items, setItems] = useState<AdminTour[]>([])
  const [search, setSearch] = useState('')
  const [status, setStatus] = useState<'' | 'VISIBLE' | 'HIDDEN'>('')
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [warning, setWarning] = useState<string | null>(null)

  const load = useCallback(() => {
    setLoading(true)
    adminApi
      .listTours({ status: status || undefined, search: search || undefined })
      .then((r) => setItems(r.items))
      .catch(() => setError('Không tải được danh sách'))
      .finally(() => setLoading(false))
  }, [status, search])

  useEffect(() => {
    load()
  }, [load])

  async function toggleVisibility(p: AdminTour) {
    const next = p.status === 'VISIBLE' ? 'HIDDEN' : 'VISIBLE'
    try {
      const r = await adminApi.setTourVisibility(p.id, next)
      setWarning(r.warning?.message ?? null) // BR-81: cảnh báo nếu còn đơn tương lai khi gỡ hiển thị
      load()
    } catch {
      setError('Cập nhật trạng thái thất bại')
    }
  }

  return (
    <div>
      <div className="mb-4 flex items-center justify-between">
        <h1 className="text-2xl font-bold text-white">Quản lý Tour</h1>
        <Link to="/admin/tours/new" className="rounded-lg bg-emerald-600 px-4 py-2 text-sm font-semibold text-white hover:bg-emerald-700">
          + Thêm mới
        </Link>
      </div>

      <div className="mb-4 flex gap-3">
        <input
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          placeholder="Tìm theo tên..."
          className="rounded-lg border border-slate-700 bg-slate-800 px-3 py-2 text-sm text-slate-100 placeholder:text-slate-500"
        />
        <select
          value={status}
          onChange={(e) => setStatus(e.target.value as '' | 'VISIBLE' | 'HIDDEN')}
          className="rounded-lg border border-slate-700 bg-slate-800 px-3 py-2 text-sm text-slate-100"
        >
          <option value="">Tất cả trạng thái</option>
          <option value="VISIBLE">Đang hiển thị</option>
          <option value="HIDDEN">Đã ẩn</option>
        </select>
      </div>

      {warning && (
        <div className="mb-4 rounded-lg border border-amber-700 bg-amber-950/40 px-4 py-2 text-sm text-amber-300">
          ⚠️ {warning}
        </div>
      )}
      {error && <div className="mb-4 rounded-lg border border-red-800 bg-red-950/40 px-4 py-2 text-sm text-red-300">{error}</div>}

      {loading ? (
        <p className="text-slate-500">Đang tải...</p>
      ) : items.length === 0 ? (
        <p className="text-slate-500">Chưa có tour nào.</p>
      ) : (
        <div className="overflow-hidden rounded-xl border border-slate-800">
          <table className="w-full text-sm">
            <thead className="bg-slate-950 text-left text-slate-400">
              <tr>
                <th className="px-4 py-3">Tour</th>
                <th className="px-4 py-3">Khu vực</th>
                <th className="px-4 py-3">Giá người lớn</th>
                <th className="px-4 py-3">Thời lượng</th>
                <th className="px-4 py-3">Trạng thái</th>
                <th className="px-4 py-3">Thao tác</th>
              </tr>
            </thead>
            <tbody>
              {items.map((p) => (
                <tr key={p.id} className="border-t border-slate-800">
                  <td className="flex items-center gap-3 px-4 py-3">
                    {p.thumbnail && <img src={p.thumbnail} alt="" className="h-10 w-14 rounded object-cover" />}
                    <span className="text-slate-200">{p.name}</span>
                  </td>
                  <td className="px-4 py-3 text-slate-400">{p.location}</td>
                  <td className="px-4 py-3 text-slate-400">{p.price.toLocaleString('vi-VN')}₫</td>
                  <td className="px-4 py-3 text-slate-400">{p.durationDays ? `${p.durationDays} ngày` : '-'}</td>
                  <td className="px-4 py-3">
                    <span
                      className={`rounded-full px-2 py-0.5 text-xs ${
                        p.status === 'VISIBLE' ? 'bg-emerald-900 text-emerald-300' : 'bg-slate-800 text-slate-400'
                      }`}
                    >
                      {p.status === 'VISIBLE' ? 'Đang hiển thị' : 'Đã ẩn'}
                    </span>
                  </td>
                  <td className="space-x-2 px-4 py-3">
                    <Link to={`/admin/tours/${p.id}/edit`} className="text-emerald-400 hover:underline">
                      Sửa
                    </Link>
                    <Link to={`/admin/tours/${p.id}/departures`} className="text-blue-400 hover:underline">
                      Chuyến khởi hành
                    </Link>
                    <button onClick={() => toggleVisibility(p)} className="text-slate-400 hover:underline">
                      {p.status === 'VISIBLE' ? 'Gỡ hiển thị' : 'Hiển thị'}
                    </button>
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
