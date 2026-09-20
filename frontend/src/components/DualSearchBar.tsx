import { useState } from 'react'
import { useNavigate, useSearchParams } from 'react-router-dom'
import type { ProductType } from '../lib/api'

// Thanh tìm kiếm kép Homestay/Tour (UC-01). Xác nhận tìm -> UC-02 (luồng thay thế 3b).
// Trên trang tìm kiếm, tự điền lại tiêu chí từ URL để người dùng chỉnh & tìm lại (UC-02, luồng 4a).
export function DualSearchBar({ compact = false }: { compact?: boolean }) {
  const navigate = useNavigate()
  const [params] = useSearchParams()
  const [tab, setTab] = useState<ProductType>(params.get('type') === 'TOUR' ? 'TOUR' : 'HOMESTAY')
  const [destination, setDestination] = useState(params.get('destination') ?? '')
  const [guests, setGuests] = useState(Number(params.get('guests')) || 2)
  const [dateFrom, setDateFrom] = useState(params.get('from') ?? '')
  const [dateTo, setDateTo] = useState(params.get('to') ?? '')
  const [departDate, setDepartDate] = useState(params.get('depart') ?? '')

  function submit(e: React.FormEvent) {
    e.preventDefault()
    const qs = new URLSearchParams({ type: tab })
    if (destination) qs.set('destination', destination)
    qs.set('guests', String(guests))
    if (tab === 'HOMESTAY') {
      if (dateFrom) qs.set('from', dateFrom)
      if (dateTo) qs.set('to', dateTo)
    } else if (departDate) {
      qs.set('depart', departDate)
    }
    navigate(`/search?${qs.toString()}`)
  }

  const field = 'rounded-lg border border-slate-300 px-3 py-2 text-sm focus:border-emerald-500 focus:outline-none'

  return (
    <div className={compact ? '' : 'rounded-2xl bg-white p-4 shadow-lg'}>
      <div className="mb-3 inline-flex rounded-lg bg-slate-100 p-1">
        {(['HOMESTAY', 'TOUR'] as const).map((t) => (
          <button
            key={t}
            type="button"
            onClick={() => setTab(t)}
            className={`rounded-md px-4 py-1.5 text-sm font-medium transition ${
              tab === t ? 'bg-white text-emerald-700 shadow' : 'text-slate-500'
            }`}
          >
            {t === 'HOMESTAY' ? 'Homestay' : 'Tour'}
          </button>
        ))}
      </div>

      <form onSubmit={submit} className="flex flex-wrap items-end gap-3">
        <label className="flex flex-col gap-1">
          <span className="text-xs text-slate-500">Điểm đến</span>
          <input
            className={`${field} w-48`}
            placeholder="Đà Lạt, Sa Pa..."
            value={destination}
            onChange={(e) => setDestination(e.target.value)}
          />
        </label>

        {tab === 'HOMESTAY' ? (
          <>
            <label className="flex flex-col gap-1">
              <span className="text-xs text-slate-500">Nhận phòng</span>
              <input type="date" className={field} value={dateFrom} onChange={(e) => setDateFrom(e.target.value)} />
            </label>
            <label className="flex flex-col gap-1">
              <span className="text-xs text-slate-500">Trả phòng</span>
              <input type="date" className={field} value={dateTo} onChange={(e) => setDateTo(e.target.value)} />
            </label>
          </>
        ) : (
          <label className="flex flex-col gap-1">
            <span className="text-xs text-slate-500">Ngày khởi hành</span>
            <input type="date" className={field} value={departDate} onChange={(e) => setDepartDate(e.target.value)} />
          </label>
        )}

        <label className="flex flex-col gap-1">
          <span className="text-xs text-slate-500">Số khách</span>
          <input
            type="number"
            min={1}
            className={`${field} w-20`}
            value={guests}
            onChange={(e) => setGuests(Math.max(1, Number(e.target.value)))}
          />
        </label>

        <button
          type="submit"
          className="rounded-lg bg-emerald-600 px-5 py-2 text-sm font-semibold text-white hover:bg-emerald-700"
        >
          Tìm kiếm
        </button>
      </form>
    </div>
  )
}
