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

  const input =
    'w-full bg-transparent text-sm text-forest-900 placeholder:text-forest-300 focus:outline-none'
  const label = 'text-[11px] font-medium uppercase tracking-wide text-forest-400'

  return (
    <div className={compact ? '' : 'rounded-3xl bg-white p-3 shadow-2xl shadow-forest-900/15 ring-1 ring-cream-200'}>
      {/* Tab chuyển Homestay / Tour */}
      <div className="mb-3 inline-flex rounded-full bg-cream-100 p-1">
        {(['HOMESTAY', 'TOUR'] as const).map((t) => (
          <button
            key={t}
            type="button"
            onClick={() => setTab(t)}
            className={`rounded-full px-5 py-1.5 text-sm font-medium transition ${
              tab === t ? 'bg-forest-700 text-cream-50 shadow' : 'text-forest-500 hover:text-forest-700'
            }`}
          >
            {t === 'HOMESTAY' ? 'Homestay' : 'Tour'}
          </button>
        ))}
      </div>

      <form onSubmit={submit} className="flex flex-col gap-2 md:flex-row md:items-stretch md:gap-0">
        <div className="flex flex-1 flex-col justify-center px-4 py-2 md:border-r md:border-cream-200">
          <span className={label}>◍ Điểm đến</span>
          <input
            className={input}
            placeholder="Đà Lạt, Sa Pa..."
            value={destination}
            onChange={(e) => setDestination(e.target.value)}
          />
        </div>

        {tab === 'HOMESTAY' ? (
          <>
            <div className="flex flex-1 flex-col justify-center px-4 py-2 md:border-r md:border-cream-200">
              <span className={label}>▤ Nhận phòng</span>
              <input type="date" className={input} value={dateFrom} onChange={(e) => setDateFrom(e.target.value)} />
            </div>
            <div className="flex flex-1 flex-col justify-center px-4 py-2 md:border-r md:border-cream-200">
              <span className={label}>▤ Trả phòng</span>
              <input type="date" className={input} value={dateTo} onChange={(e) => setDateTo(e.target.value)} />
            </div>
          </>
        ) : (
          <div className="flex flex-1 flex-col justify-center px-4 py-2 md:border-r md:border-cream-200">
            <span className={label}>▤ Ngày khởi hành</span>
            <input type="date" className={input} value={departDate} onChange={(e) => setDepartDate(e.target.value)} />
          </div>
        )}

        <div className="flex w-full flex-col justify-center px-4 py-2 md:w-32 md:border-r md:border-cream-200">
          <span className={label}>☺ Số khách</span>
          <input
            type="number"
            min={1}
            className={input}
            value={guests}
            onChange={(e) => setGuests(Math.max(1, Number(e.target.value)))}
          />
        </div>

        <button
          type="submit"
          className="mt-1 flex items-center justify-center gap-2 rounded-2xl bg-clay-500 px-7 py-3 text-sm font-semibold text-white shadow-lg transition hover:bg-clay-600 md:mt-0"
        >
          Tìm kiếm →
        </button>
      </form>
    </div>
  )
}
