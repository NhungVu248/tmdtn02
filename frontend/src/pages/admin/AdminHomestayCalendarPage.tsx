import { useCallback, useEffect, useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import { AdminApiError, adminApi, type AvailabilityConflict, type AvailabilityDay } from '../../lib/adminApi'

const field = 'rounded-lg border border-slate-700 bg-slate-800 px-3 py-2 text-sm text-slate-100 focus:border-emerald-500 focus:outline-none'

function todayStr() {
  return new Date().toISOString().slice(0, 10)
}
function plusDays(n: number) {
  const d = new Date()
  d.setDate(d.getDate() + n)
  return d.toISOString().slice(0, 10)
}

// UC-16 – Lịch tồn phòng: mở/chặn từng khoảng ngày + giá riêng theo mùa/cuối tuần (BR-74).
export function AdminHomestayCalendarPage() {
  const { id } = useParams<{ id: string }>()
  const productId = Number(id)

  const [rangeFrom, setRangeFrom] = useState(todayStr())
  const [rangeTo, setRangeTo] = useState(plusDays(14))
  const [calendar, setCalendar] = useState<AvailabilityDay[]>([])
  const [basePrice, setBasePrice] = useState(0)
  const [loading, setLoading] = useState(true)

  // Form áp dụng cho một khoảng ngày (mở/chặn + giá)
  const [applyFrom, setApplyFrom] = useState(todayStr())
  const [applyTo, setApplyTo] = useState(plusDays(1))
  const [totalRooms, setTotalRooms] = useState('5')
  const [priceOverride, setPriceOverride] = useState('')
  const [applying, setApplying] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [conflict, setConflict] = useState<AvailabilityConflict | null>(null)
  const [success, setSuccess] = useState<string | null>(null)

  const load = useCallback(() => {
    setLoading(true)
    adminApi
      .getAvailability(productId, rangeFrom, rangeTo)
      .then((r) => {
        setCalendar(r.calendar)
        setBasePrice(r.basePrice)
      })
      .finally(() => setLoading(false))
  }, [productId, rangeFrom, rangeTo])

  useEffect(() => {
    load()
  }, [load])

  async function applyRange(e: React.FormEvent) {
    e.preventDefault()
    setError(null)
    setConflict(null)
    setSuccess(null)
    setApplying(true)
    try {
      await adminApi.setAvailability(productId, {
        from: applyFrom,
        to: applyTo,
        totalRooms: Number(totalRooms),
        priceOverride: priceOverride ? Number(priceOverride) : null,
      })
      setSuccess('Đã cập nhật lịch tồn phòng.')
      load()
    } catch (err) {
      if (err instanceof AdminApiError && err.status === 409) {
        // BR-75/2a-1: xung đột với đơn hợp lệ đang giữ chỗ — không áp dụng, yêu cầu xử lý trước.
        setConflict((err.body as AvailabilityConflict) ?? null)
        setError(err.message)
      } else {
        setError(err instanceof AdminApiError ? err.message : 'Cập nhật thất bại')
      }
    } finally {
      setApplying(false)
    }
  }

  return (
    <div>
      <nav className="mb-4 text-sm text-slate-500">
        <Link to="/admin/homestays" className="hover:text-emerald-400">Homestay</Link> / Lịch tồn phòng
      </nav>
      <h1 className="mb-6 text-2xl font-bold text-white">Lịch tồn phòng</h1>

      <form onSubmit={applyRange} className="mb-6 rounded-xl border border-slate-800 bg-slate-950 p-5">
        <h2 className="mb-3 font-semibold text-slate-200">Áp dụng cho một khoảng ngày</h2>
        <div className="flex flex-wrap items-end gap-3">
          <label className="flex flex-col gap-1 text-xs text-slate-400">
            Từ ngày
            <input className={field} type="date" value={applyFrom} onChange={(e) => setApplyFrom(e.target.value)} />
          </label>
          <label className="flex flex-col gap-1 text-xs text-slate-400">
            Đến ngày (không tính)
            <input className={field} type="date" value={applyTo} onChange={(e) => setApplyTo(e.target.value)} />
          </label>
          <label className="flex flex-col gap-1 text-xs text-slate-400">
            Số phòng mở bán (0 = chặn ngày)
            <input className={`${field} w-40`} type="number" min={0} value={totalRooms} onChange={(e) => setTotalRooms(e.target.value)} />
          </label>
          <label className="flex flex-col gap-1 text-xs text-slate-400">
            Giá riêng (bỏ trống = giá cơ bản {basePrice.toLocaleString('vi-VN')}đ)
            <input className={`${field} w-48`} type="number" min={0} value={priceOverride} onChange={(e) => setPriceOverride(e.target.value)} />
          </label>
          <button
            type="submit"
            disabled={applying}
            className="rounded-lg bg-emerald-600 px-4 py-2 text-sm font-semibold text-white hover:bg-emerald-700 disabled:opacity-50"
          >
            {applying ? 'Đang áp dụng...' : 'Áp dụng'}
          </button>
        </div>

        {success && <p className="mt-3 text-sm text-emerald-400">{success}</p>}
        {error && (
          <div className="mt-3 rounded-lg border border-red-800 bg-red-950/40 px-3 py-2 text-sm text-red-300">
            <p>⚠️ {error}</p>
            {conflict && conflict.bookings.length > 0 && (
              <ul className="mt-2 list-disc pl-5 text-xs">
                {conflict.bookings.map((b) => (
                  <li key={b.code}>
                    Đơn <span className="font-mono">{b.code}</span> ({new Date(b.checkIn).toLocaleDateString('vi-VN')} →{' '}
                    {new Date(b.checkOut).toLocaleDateString('vi-VN')}) — cần xử lý ở Quản lý đơn (UC-18) trước.
                  </li>
                ))}
              </ul>
            )}
          </div>
        )}
      </form>

      <div className="mb-3 flex items-end gap-3">
        <label className="flex flex-col gap-1 text-xs text-slate-400">
          Xem từ
          <input className={field} type="date" value={rangeFrom} onChange={(e) => setRangeFrom(e.target.value)} />
        </label>
        <label className="flex flex-col gap-1 text-xs text-slate-400">
          Đến
          <input className={field} type="date" value={rangeTo} onChange={(e) => setRangeTo(e.target.value)} />
        </label>
      </div>

      {loading ? (
        <p className="text-slate-500">Đang tải...</p>
      ) : (
        <div className="overflow-hidden rounded-xl border border-slate-800">
          <table className="w-full text-sm">
            <thead className="bg-slate-950 text-left text-slate-400">
              <tr>
                <th className="px-4 py-2">Ngày</th>
                <th className="px-4 py-2">Tổng phòng</th>
                <th className="px-4 py-2">Đã đặt</th>
                <th className="px-4 py-2">Còn trống</th>
                <th className="px-4 py-2">Giá riêng</th>
              </tr>
            </thead>
            <tbody>
              {calendar.map((c) => (
                <tr key={c.date} className="border-t border-slate-800">
                  <td className="px-4 py-2 text-slate-200">{new Date(c.date).toLocaleDateString('vi-VN')}</td>
                  <td className="px-4 py-2 text-slate-400">{c.totalRooms}</td>
                  <td className="px-4 py-2 text-slate-400">{c.bookedRooms}</td>
                  <td className={`px-4 py-2 ${c.totalRooms - c.bookedRooms <= 0 ? 'text-red-400' : 'text-emerald-400'}`}>
                    {c.totalRooms - c.bookedRooms}
                  </td>
                  <td className="px-4 py-2 text-slate-400">
                    {c.priceOverride != null ? `${c.priceOverride.toLocaleString('vi-VN')}đ` : <span className="text-slate-600">giá cơ bản</span>}
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
