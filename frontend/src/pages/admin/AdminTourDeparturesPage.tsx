import { useCallback, useEffect, useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import { AdminApiError, adminApi, type Departure } from '../../lib/adminApi'

const field = 'rounded-lg border border-slate-700 bg-slate-800 px-3 py-2 text-sm text-slate-100 focus:border-emerald-500 focus:outline-none'

function tomorrow() {
  const d = new Date()
  d.setDate(d.getDate() + 1)
  return d.toISOString().slice(0, 10)
}
const priceOf = (d: Departure, t: 'ADULT' | 'CHILD') => d.prices.find((p) => p.paxType === t)?.price ?? null

// ----- Lịch tháng (UTC, khớp cột @db.Date) -----
const WEEKDAYS = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'] // bắt đầu từ Thứ Hai
const ymd = (d: Date) => `${d.getUTCFullYear()}-${String(d.getUTCMonth() + 1).padStart(2, '0')}-${String(d.getUTCDate()).padStart(2, '0')}`
const depKey = (iso: string) => ymd(new Date(iso)) // khóa ngày khởi hành (UTC)
function startOfTodayUTC() {
  const n = new Date()
  return new Date(Date.UTC(n.getUTCFullYear(), n.getUTCMonth(), n.getUTCDate()))
}

// UC-17 – Quản lý chuyến khởi hành: thêm chuyến, số chỗ, giá theo loại khách (BR-80/33), đóng chuyến (4a-1).
export function AdminTourDeparturesPage() {
  const { id } = useParams<{ id: string }>()
  const tourId = Number(id)

  const [departures, setDepartures] = useState<Departure[]>([])
  const [tourName, setTourName] = useState('')
  const [loading, setLoading] = useState(true)

  const [date, setDate] = useState(tomorrow())
  const [totalSlots, setTotalSlots] = useState('20')
  const [priceAdult, setPriceAdult] = useState('')
  const [priceChild, setPriceChild] = useState('')
  const [guideName, setGuideName] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [conflict, setConflict] = useState<{ code: string; guests: number; children: number; status: string }[] | null>(null)
  const [submitting, setSubmitting] = useState(false)
  const [view, setView] = useState<'table' | 'timeline'>('table')

  const load = useCallback(() => {
    setLoading(true)
    adminApi
      .getTour(tourId)
      .then(({ tour }) => {
        setDepartures(tour.departures)
        setTourName(tour.title)
      })
      .finally(() => setLoading(false))
  }, [tourId])

  useEffect(() => {
    load()
  }, [load])

  async function addDeparture(e: React.FormEvent) {
    e.preventDefault()
    setError(null)
    setConflict(null)
    setSubmitting(true)
    try {
      await adminApi.createDeparture(tourId, {
        date,
        totalSlots: Number(totalSlots),
        priceAdult: priceAdult ? Number(priceAdult) : null,
        priceChild: priceChild ? Number(priceChild) : null,
        guideName: guideName || undefined,
      })
      setPriceAdult('')
      setPriceChild('')
      setGuideName('')
      load()
    } catch (err) {
      setError(err instanceof AdminApiError ? err.message : 'Thêm chuyến thất bại') // 5a
    } finally {
      setSubmitting(false)
    }
  }

  async function updateSlots(dep: Departure, newSlots: number) {
    setError(null)
    setConflict(null)
    try {
      await adminApi.updateDeparture(tourId, dep.id, { totalSlots: newSlots })
      load()
    } catch (err) {
      setError(err instanceof AdminApiError ? err.message : 'Cập nhật thất bại') // 4a-2
    }
  }

  async function closeDeparture(dep: Departure) {
    setError(null)
    setConflict(null)
    try {
      await adminApi.closeDeparture(tourId, dep.id)
      load()
    } catch (err) {
      if (err instanceof AdminApiError && err.status === 409) {
        setError(err.message) // 4a-1
        const body = err.body as { bookings?: typeof conflict }
        setConflict(body?.bookings ?? null)
      } else {
        setError('Đóng chuyến thất bại')
      }
    }
  }

  return (
    <div>
      <nav className="mb-4 text-sm text-slate-500">
        <Link to="/admin/tours" className="hover:text-emerald-400">Tour</Link> / Chuyến khởi hành
      </nav>
      <div className="mb-6 flex flex-wrap items-center justify-between gap-3">
        <h1 className="text-2xl font-bold text-white">Chuyến khởi hành — {tourName}</h1>
        <div className="inline-flex rounded-lg border border-slate-700 bg-slate-900 p-0.5 text-sm">
          <button onClick={() => setView('table')} className={`rounded-md px-3 py-1.5 ${view === 'table' ? 'bg-emerald-600 text-white' : 'text-slate-300 hover:text-white'}`}>▦ Bảng</button>
          <button onClick={() => setView('timeline')} className={`rounded-md px-3 py-1.5 ${view === 'timeline' ? 'bg-emerald-600 text-white' : 'text-slate-300 hover:text-white'}`}>▦ Lịch</button>
        </div>
      </div>

      <form onSubmit={addDeparture} className="mb-6 rounded-xl border border-slate-800 bg-slate-950 p-5">
        <h2 className="mb-3 font-semibold text-slate-200">Thêm chuyến mới</h2>
        <div className="flex flex-wrap items-end gap-3">
          <label className="flex flex-col gap-1 text-xs text-slate-400">Ngày khởi hành
            <input className={field} type="date" value={date} onChange={(e) => setDate(e.target.value)} />
          </label>
          <label className="flex flex-col gap-1 text-xs text-slate-400">Số chỗ tối đa
            <input className={`${field} w-28`} type="number" min={1} value={totalSlots} onChange={(e) => setTotalSlots(e.target.value)} />
          </label>
          <label className="flex flex-col gap-1 text-xs text-slate-400">Giá người lớn
            <input className={`${field} w-36`} type="number" min={0} value={priceAdult} onChange={(e) => setPriceAdult(e.target.value)} placeholder="Giá cơ bản" />
          </label>
          <label className="flex flex-col gap-1 text-xs text-slate-400">Giá trẻ em
            <input className={`${field} w-36`} type="number" min={0} value={priceChild} onChange={(e) => setPriceChild(e.target.value)} placeholder="(không có)" />
          </label>
          <label className="flex flex-col gap-1 text-xs text-slate-400">Hướng dẫn viên
            <input className={`${field} w-40`} value={guideName} onChange={(e) => setGuideName(e.target.value)} placeholder="(tùy chọn)" />
          </label>
          <button type="submit" disabled={submitting} className="rounded-lg bg-emerald-600 px-4 py-2 text-sm font-semibold text-white hover:bg-emerald-700 disabled:opacity-50">
            {submitting ? 'Đang thêm...' : 'Thêm chuyến'}
          </button>
        </div>
      </form>

      {error && (
        <div className="mb-4 rounded-lg border border-red-800 bg-red-950/40 px-4 py-2 text-sm text-red-300">
          <p>⚠️ {error}</p>
          {conflict && conflict.length > 0 && (
            <ul className="mt-2 list-disc pl-5 text-xs">
              {conflict.map((b) => (
                <li key={b.code}>Đơn <span className="font-mono">{b.code}</span> ({b.guests} người lớn{b.children ? ` · ${b.children} trẻ em` : ''}) — xử lý ở Quản lý đơn hàng trước.</li>
              ))}
            </ul>
          )}
        </div>
      )}

      {loading ? (
        <p className="text-slate-500">Đang tải...</p>
      ) : departures.length === 0 ? (
        <p className="text-slate-500">Chưa có chuyến khởi hành nào.</p>
      ) : view === 'timeline' ? (
        <DepartureCalendar
          departures={departures}
          onUpdateSlots={updateSlots}
          onClose={closeDeparture}
        />
      ) : (
        <div className="overflow-x-auto rounded-xl border border-slate-800">
          <table className="w-full text-sm">
            <thead className="bg-slate-950 text-left text-slate-400">
              <tr>
                <th className="px-4 py-2">Ngày</th>
                <th className="px-4 py-2">Số chỗ</th>
                <th className="px-4 py-2">Đã bán</th>
                <th className="px-4 py-2">Còn</th>
                <th className="px-4 py-2">Giá (lớn/trẻ)</th>
                <th className="px-4 py-2">HDV</th>
                <th className="px-4 py-2">Trạng thái</th>
                <th className="px-4 py-2">Thao tác</th>
              </tr>
            </thead>
            <tbody>
              {departures.map((d) => {
                const closed = d.status === 'CLOSED' || d.status === 'CANCELLED'
                const left = d.totalSlots - d.bookedSlots - d.heldSlots
                return (
                  <tr key={d.id} className="border-t border-slate-800">
                    <td className="px-4 py-2 text-slate-200">{new Date(d.departureDate).toLocaleDateString('vi-VN')}</td>
                    <td className="px-4 py-2">
                      <input
                        type="number"
                        min={1}
                        defaultValue={d.totalSlots}
                        onBlur={(e) => { const v = Number(e.target.value); if (v !== d.totalSlots) updateSlots(d, v) }}
                        className="w-20 rounded border border-slate-700 bg-slate-800 px-2 py-1 text-slate-100"
                        disabled={closed}
                      />
                    </td>
                    <td className="px-4 py-2 text-slate-400">{d.bookedSlots}</td>
                    <td className={`px-4 py-2 ${left <= 0 ? 'text-red-400' : 'text-emerald-400'}`}>{left}</td>
                    <td className="px-4 py-2 text-slate-400">
                      {priceOf(d, 'ADULT')?.toLocaleString('vi-VN') ?? '-'} / {priceOf(d, 'CHILD')?.toLocaleString('vi-VN') ?? '-'}
                    </td>
                    <td className="px-4 py-2 text-slate-400">{d.guideName || '-'}</td>
                    <td className="px-4 py-2">
                      <span className={`rounded-full px-2 py-0.5 text-xs ${closed ? 'bg-slate-800 text-slate-500' : 'bg-emerald-900 text-emerald-300'}`}>
                        {closed ? 'Đã đóng' : 'Đang mở'}
                      </span>
                    </td>
                    <td className="px-4 py-2">
                      {!closed && <button onClick={() => closeDeparture(d)} className="text-red-400 hover:underline">Đóng chuyến</button>}
                    </td>
                  </tr>
                )
              })}
            </tbody>
          </table>
        </div>
      )}
    </div>
  )
}

// Lịch tháng: ô ngày có chuyến hiện badge "đã bán/tổng" tô theo tình trạng chỗ;
// bấm vào ô để mở bảng quản lý chuyến (sửa số chỗ / đóng chuyến) ngay bên dưới.
function DepartureCalendar({
  departures,
  onUpdateSlots,
  onClose,
}: {
  departures: Departure[]
  onUpdateSlots: (dep: Departure, slots: number) => void
  onClose: (dep: Departure) => void
}) {
  // Mốc tháng đang xem: mặc định tháng của chuyến gần nhất sắp tới, không thì tháng hiện tại.
  const [month, setMonth] = useState<Date>(() => {
    const today = startOfTodayUTC()
    const upcoming = [...departures]
      .map((d) => new Date(d.departureDate))
      .filter((d) => d.getTime() >= today.getTime())
      .sort((a, b) => a.getTime() - b.getTime())[0]
    const base = upcoming ?? (departures.length ? new Date(departures[0].departureDate) : today)
    return new Date(Date.UTC(base.getUTCFullYear(), base.getUTCMonth(), 1))
  })
  const [selectedId, setSelectedId] = useState<number | null>(null)

  const todayStr = ymd(startOfTodayUTC())
  const byDate = new Map<string, Departure>()
  for (const d of departures) byDate.set(depKey(d.departureDate), d)

  // Dựng lưới tuần (bắt đầu Thứ Hai), đủ số tuần phủ hết tháng.
  const y = month.getUTCFullYear()
  const m = month.getUTCMonth()
  const first = new Date(Date.UTC(y, m, 1))
  const lead = (first.getUTCDay() + 6) % 7 // số ô trống đầu (Thứ Hai = 0)
  const daysInMonth = new Date(Date.UTC(y, m + 1, 0)).getUTCDate()
  const cells: (Date | null)[] = []
  for (let i = 0; i < lead; i++) cells.push(null)
  for (let d = 1; d <= daysInMonth; d++) cells.push(new Date(Date.UTC(y, m, d)))
  while (cells.length % 7 !== 0) cells.push(null)

  const selected = selectedId != null ? departures.find((d) => d.id === selectedId) ?? null : null
  const goMonth = (delta: number) => { setMonth(new Date(Date.UTC(y, m + delta, 1))); setSelectedId(null) }

  function cellColor(dep: Departure) {
    const left = dep.totalSlots - dep.bookedSlots - dep.heldSlots
    if (dep.status === 'CLOSED' || dep.status === 'CANCELLED') return 'bg-slate-700/60 border-slate-600 text-slate-300'
    if (left <= 0) return 'bg-red-900/70 border-red-600 text-red-100'
    if (dep.bookedSlots > 0) return 'bg-emerald-900/70 border-emerald-500 text-emerald-100'
    return 'bg-slate-800 border-slate-600 text-slate-200' // mở, chưa có khách
  }

  return (
    <div>
      {/* Điều hướng tháng + chú thích */}
      <div className="mb-3 flex flex-wrap items-center justify-between gap-3">
        <div className="flex items-center gap-2">
          <button onClick={() => goMonth(-1)} className="rounded-lg border border-slate-700 bg-slate-800 px-3 py-1.5 text-sm text-slate-200 hover:bg-slate-700">‹</button>
          <span className="min-w-[140px] text-center text-sm font-semibold text-slate-200">Tháng {m + 1}/{y}</span>
          <button onClick={() => goMonth(1)} className="rounded-lg border border-slate-700 bg-slate-800 px-3 py-1.5 text-sm text-slate-200 hover:bg-slate-700">›</button>
          <button onClick={() => { const t = startOfTodayUTC(); setMonth(new Date(Date.UTC(t.getUTCFullYear(), t.getUTCMonth(), 1))); setSelectedId(null) }} className="ml-1 rounded-lg border border-slate-700 bg-slate-800 px-3 py-1.5 text-xs text-slate-300 hover:bg-slate-700">Hôm nay</button>
        </div>
        <div className="flex flex-wrap items-center gap-3 text-xs text-slate-400">
          <Legend className="bg-emerald-900/70 border-emerald-500" label="Còn chỗ" />
          <Legend className="bg-red-900/70 border-red-600" label="Hết chỗ" />
          <Legend className="bg-slate-700/60 border-slate-600" label="Đã đóng" />
          <span className="text-slate-500">· số = đã bán/tổng chỗ</span>
        </div>
      </div>

      {/* Lưới lịch */}
      <div className="overflow-hidden rounded-xl border border-slate-800 bg-slate-950">
        <div className="grid grid-cols-7 border-b border-slate-800 bg-slate-900 text-center text-xs font-semibold text-slate-400">
          {WEEKDAYS.map((w) => <div key={w} className="py-2">{w}</div>)}
        </div>
        <div className="grid grid-cols-7">
          {cells.map((d, i) => {
            if (!d) return <div key={`b${i}`} className="min-h-[76px] border-b border-l border-slate-800/60 bg-slate-950/40 first:border-l-0" />
            const key = ymd(d)
            const dep = byDate.get(key)
            const isToday = key === todayStr
            const dow = d.getUTCDay()
            const weekend = dow === 0 || dow === 6
            return (
              <div key={key} className={`min-h-[76px] border-b border-l border-slate-800/60 p-1.5 ${i % 7 === 0 ? 'border-l-0' : ''} ${isToday ? 'bg-emerald-950/30' : ''}`}>
                <div className={`mb-1 text-right text-xs ${isToday ? 'font-bold text-emerald-300' : weekend ? 'text-slate-500' : 'text-slate-400'}`}>{d.getUTCDate()}</div>
                {dep && (
                  <button
                    onClick={() => setSelectedId(dep.id)}
                    title={`${new Date(dep.departureDate).toLocaleDateString('vi-VN')} · ${dep.bookedSlots}/${dep.totalSlots} chỗ · ${dep.status}`}
                    className={`block w-full truncate rounded-md border px-1.5 py-1 text-left text-[11px] font-medium transition hover:brightness-110 ${cellColor(dep)} ${selectedId === dep.id ? 'ring-2 ring-emerald-400' : ''}`}
                  >
                    🧳 {dep.bookedSlots}/{dep.totalSlots}
                  </button>
                )}
              </div>
            )
          })}
        </div>
      </div>

      {/* Bảng quản lý chuyến được chọn */}
      {selected ? (
        <DepartureEditor key={selected.id} dep={selected} onUpdateSlots={onUpdateSlots} onClose={onClose} onDismiss={() => setSelectedId(null)} />
      ) : (
        <p className="mt-3 text-center text-xs text-slate-500">Bấm vào một chuyến trên lịch để xem & quản lý.</p>
      )}
    </div>
  )
}

// Bảng chi tiết + thao tác cho chuyến được chọn trên lịch.
function DepartureEditor({
  dep,
  onUpdateSlots,
  onClose,
  onDismiss,
}: {
  dep: Departure
  onUpdateSlots: (dep: Departure, slots: number) => void
  onClose: (dep: Departure) => void
  onDismiss: () => void
}) {
  const closed = dep.status === 'CLOSED' || dep.status === 'CANCELLED'
  const sold = dep.bookedSlots
  const held = dep.heldSlots
  const left = Math.max(0, dep.totalSlots - sold - held)
  const full = left <= 0 && !closed
  const pct = (n: number) => (dep.totalSlots > 0 ? (n / dep.totalSlots) * 100 : 0)
  const date = new Date(dep.departureDate)

  return (
    <div className="mt-3 rounded-xl border border-slate-800 bg-slate-950 p-4">
      <div className="flex flex-wrap items-start justify-between gap-3">
        <div>
          <div className="flex items-center gap-2">
            <span className="text-base font-semibold text-slate-100">{date.toLocaleDateString('vi-VN', { weekday: 'long', day: '2-digit', month: '2-digit', year: 'numeric' })}</span>
            <span className={`rounded-full px-2 py-0.5 text-xs ${closed ? 'bg-slate-800 text-slate-500' : full ? 'bg-red-950 text-red-300' : 'bg-emerald-900 text-emerald-300'}`}>
              {closed ? 'Đã đóng' : full ? 'Hết chỗ' : 'Đang mở'}
            </span>
          </div>
          <div className="mt-1 text-xs text-slate-400">
            Giá: {priceOf(dep, 'ADULT')?.toLocaleString('vi-VN') ?? '-'}₫ / {priceOf(dep, 'CHILD')?.toLocaleString('vi-VN') ?? '-'}₫
            {dep.guideName ? ` · HDV: ${dep.guideName}` : ''}
          </div>
        </div>
        <div className="flex items-center gap-2">
          <label className="flex items-center gap-1 text-xs text-slate-400">
            Số chỗ
            <input
              type="number"
              min={1}
              defaultValue={dep.totalSlots}
              onBlur={(e) => { const v = Number(e.target.value); if (v !== dep.totalSlots) onUpdateSlots(dep, v) }}
              className="w-20 rounded border border-slate-700 bg-slate-800 px-2 py-1 text-slate-100"
              disabled={closed}
            />
          </label>
          {!closed && <button onClick={() => onClose(dep)} className="rounded-lg border border-red-900 px-3 py-1.5 text-sm text-red-400 hover:bg-red-950/40">Đóng chuyến</button>}
          <button onClick={onDismiss} className="rounded-lg border border-slate-700 px-2.5 py-1.5 text-sm text-slate-400 hover:bg-slate-800">✕</button>
        </div>
      </div>

      {/* Thanh lấp đầy chỗ: đã bán (xanh lá) · đang giữ (vàng) · còn trống (xám) */}
      <div className="mt-3">
        <div className="flex h-3 w-full overflow-hidden rounded-full bg-slate-800">
          <div className="h-full bg-emerald-500" style={{ width: `${pct(sold)}%` }} title={`Đã bán: ${sold}`} />
          <div className="h-full bg-amber-500" style={{ width: `${pct(held)}%` }} title={`Đang giữ: ${held}`} />
        </div>
        <div className="mt-1 flex flex-wrap gap-x-4 gap-y-0.5 text-xs">
          <span className="text-emerald-400">● Đã bán {sold}</span>
          {held > 0 && <span className="text-amber-400">● Đang giữ {held}</span>}
          <span className={left <= 0 ? 'text-red-400' : 'text-slate-400'}>● Còn {left}/{dep.totalSlots}</span>
        </div>
      </div>
    </div>
  )
}

function Legend({ className, label }: { className: string; label: string }) {
  return (
    <span className="flex items-center gap-1.5">
      <span className={`inline-block h-3 w-4 rounded border ${className}`} />
      {label}
    </span>
  )
}
