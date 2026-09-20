import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { ApiError, api, formatPrice, type Availability, type ProductDetail } from '../lib/api'

// UC-03 – Kiểm tra tình trạng còn trống + giá tạm tính, dẫn sang luồng đặt (UC-09/10).
export function AvailabilityChecker({ product }: { product: ProductDetail }) {
  const navigate = useNavigate()
  const isHomestay = product.type === 'HOMESTAY'

  const [from, setFrom] = useState('')
  const [to, setTo] = useState('')
  const [date, setDate] = useState('')
  const [guests, setGuests] = useState(2)
  const [children, setChildren] = useState(0)

  const [result, setResult] = useState<Availability | null>(null)
  const [error, setError] = useState<string | null>(null) // lỗi tiêu chí (2a)
  const [loading, setLoading] = useState(false)

  async function check() {
    const qs = new URLSearchParams({ guests: String(guests) })
    if (isHomestay) {
      qs.set('from', from)
      qs.set('to', to)
    } else {
      qs.set('date', date)
      qs.set('children', String(children))
    }
    setLoading(true)
    setError(null)
    setResult(null)
    try {
      setResult(await api.checkAvailability(product.slug, qs))
    } catch (err) {
      if (err instanceof ApiError) setError(err.message)
      else setError('Không kiểm tra được tình trạng còn trống.')
    } finally {
      setLoading(false)
    }
  }

  function book() {
    const qs = new URLSearchParams({ guests: String(guests) })
    if (isHomestay) {
      qs.set('from', from)
      qs.set('to', to)
    } else {
      qs.set('date', date)
      qs.set('children', String(children))
    }
    navigate(`/booking/${product.slug}?${qs.toString()}`)
  }

  const canCheck = isHomestay ? from && to : date
  const field = 'w-full rounded-lg border border-slate-300 px-3 py-2 text-sm focus:border-emerald-500 focus:outline-none'

  return (
    <div className="rounded-xl border border-slate-200 bg-white p-4 shadow-sm">
      {/* Bảng giá (BR-09) */}
      <div className="mb-3">
        <span className="text-xl font-bold text-emerald-700">{formatPrice(product.price)}</span>
        <span className="text-sm text-slate-500">{isHomestay ? ' / đêm' : ' / người lớn'}</span>
        {!isHomestay && product.priceChild != null && (
          <span className="ml-2 text-sm text-slate-500">· Trẻ em {formatPrice(product.priceChild)}</span>
        )}
      </div>

      <div className="space-y-2">
        {isHomestay ? (
          <div className="grid grid-cols-2 gap-2">
            <label className="flex flex-col gap-1 text-xs text-slate-500">
              Nhận phòng
              <input type="date" className={field} value={from} onChange={(e) => setFrom(e.target.value)} />
            </label>
            <label className="flex flex-col gap-1 text-xs text-slate-500">
              Trả phòng
              <input type="date" className={field} value={to} onChange={(e) => setTo(e.target.value)} />
            </label>
          </div>
        ) : (
          <label className="flex flex-col gap-1 text-xs text-slate-500">
            Ngày khởi hành
            {product.departures.length > 0 ? (
              <select className={field} value={date} onChange={(e) => setDate(e.target.value)}>
                <option value="">-- Chọn chuyến --</option>
                {product.departures.map((d) => (
                  <option key={d.id} value={d.date.slice(0, 10)} disabled={d.seatsLeft <= 0}>
                    {new Date(d.date).toLocaleDateString('vi-VN')}
                    {d.seatsLeft <= 0 ? ' (hết chỗ)' : ` (còn ${d.seatsLeft} chỗ)`}
                  </option>
                ))}
              </select>
            ) : (
              <input type="date" className={field} value={date} onChange={(e) => setDate(e.target.value)} />
            )}
          </label>
        )}

        <div className="grid grid-cols-2 gap-2">
          <label className="flex flex-col gap-1 text-xs text-slate-500">
            {isHomestay ? 'Số khách' : 'Người lớn'}
            <input
              type="number"
              min={1}
              className={field}
              value={guests}
              onChange={(e) => setGuests(Math.max(1, Number(e.target.value)))}
            />
          </label>
          {!isHomestay && (
            <label className="flex flex-col gap-1 text-xs text-slate-500">
              Trẻ em
              <input
                type="number"
                min={0}
                className={field}
                value={children}
                onChange={(e) => setChildren(Math.max(0, Number(e.target.value)))}
              />
            </label>
          )}
        </div>

        <button
          onClick={check}
          disabled={!canCheck || loading}
          className="w-full rounded-lg bg-slate-800 px-4 py-2 text-sm font-semibold text-white hover:bg-slate-900 disabled:opacity-40"
        >
          {loading ? 'Đang kiểm tra...' : 'Kiểm tra tình trạng còn trống'}
        </button>
      </div>

      {/* Ngoại lệ 2a: tiêu chí không hợp lệ */}
      {error && (
        <p className="mt-3 rounded-lg border border-amber-300 bg-amber-50 px-3 py-2 text-sm text-amber-800">
          ⚠️ {error}
        </p>
      )}

      {result && !error && (
        <div className="mt-3">
          {result.available ? (
            <div className="rounded-lg border border-emerald-300 bg-emerald-50 p-3">
              <p className="text-sm font-medium text-emerald-800">
                ✓ Còn chỗ
                {result.roomsLeft != null && ` — ${result.roomsLeft} phòng trống`}
                {result.seatsLeft != null && ` — ${result.seatsLeft} chỗ còn lại`}
              </p>
              {result.tentativePrice != null && (
                <p className="mt-1 text-sm text-slate-700">
                  Giá tạm tính{result.nights ? ` (${result.nights} đêm)` : ''}:{' '}
                  <span className="font-bold text-emerald-700">{formatPrice(result.tentativePrice)}</span>
                </p>
              )}
              <button
                onClick={book}
                className="mt-2 w-full rounded-lg bg-emerald-600 px-4 py-2 text-sm font-semibold text-white hover:bg-emerald-700"
              >
                Đặt ngay
              </button>
            </div>
          ) : (
            // Ngoại lệ 3a: hết chỗ
            <div className="rounded-lg border border-red-300 bg-red-50 p-3 text-sm text-red-700">
              <p className="font-medium">✕ {result.message || 'Không còn chỗ trống'}</p>
              <p className="mt-1 text-red-600/80">Vui lòng thử chọn ngày khác.</p>
            </div>
          )}
        </div>
      )}
    </div>
  )
}
