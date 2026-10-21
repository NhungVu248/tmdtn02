import { useCallback, useEffect, useMemo, useState } from 'react'
import { Link } from 'react-router-dom'
import { adminApi, type TimelineDeparture, type TimelineTour } from '../../lib/adminApi'

// Giao diện LỊCH KHỞI HÀNH dạng timeline (hàng = tour, cột = ngày). Dữ liệu thật từ
// /api/admin/tours/timeline — KHÔNG tạo dữ liệu giả. Mỗi chuyến vẽ thành 1 thanh kéo dài
// theo số ngày của tour (durationDays), tô theo tình trạng chỗ.

const DAYS = 14 // số ngày hiển thị mỗi khung
const WD = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7']

function iso(d: Date) {
  return d.toISOString().slice(0, 10)
}
function addDays(d: Date, n: number) {
  const x = new Date(d)
  x.setUTCDate(x.getUTCDate() + n)
  return x
}
function startOfTodayUTC() {
  const n = new Date()
  return new Date(Date.UTC(n.getUTCFullYear(), n.getUTCMonth(), n.getUTCDate()))
}
// Số ngày (nguyên) từ a -> b theo UTC.
function dayIndex(from: Date, dateStr: string) {
  const d = new Date(dateStr)
  const day = Date.UTC(d.getUTCFullYear(), d.getUTCMonth(), d.getUTCDate())
  return Math.round((day - from.getTime()) / 86400000)
}

// Màu thanh theo tình trạng chỗ của chuyến.
function barStyle(dep: TimelineDeparture) {
  const left = dep.totalSlots - dep.bookedSlots - dep.heldSlots
  if (dep.status === 'CLOSED' || dep.status === 'CANCELLED')
    return { bar: 'bg-slate-700/60 border-slate-600 text-slate-300', fill: 'bg-slate-500/40' }
  if (left <= 0 || dep.status === 'FULL')
    return { bar: 'bg-red-900/70 border-red-600 text-red-100', fill: 'bg-red-500/50' }
  if (dep.bookedSlots > 0)
    return { bar: 'bg-emerald-900/70 border-emerald-500 text-emerald-100', fill: 'bg-emerald-500/50' }
  return { bar: 'bg-slate-800 border-slate-600 text-slate-300', fill: 'bg-emerald-500/25' } // mở, chưa có khách
}

export function TourTimeline() {
  // Bắt đầu từ hôm qua để nhìn thấy cả hôm nay ở gần đầu khung.
  const [anchor, setAnchor] = useState<Date>(() => addDays(startOfTodayUTC(), -1))
  const [tours, setTours] = useState<TimelineTour[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  const days = useMemo(() => Array.from({ length: DAYS }, (_, i) => addDays(anchor, i)), [anchor])
  const from = iso(days[0])
  const to = iso(days[DAYS - 1])
  const todayStr = iso(startOfTodayUTC())

  const load = useCallback(() => {
    setLoading(true)
    setError(null)
    adminApi
      .toursTimeline(from, to)
      .then((r) => setTours(r.tours))
      .catch(() => setError('Không tải được lịch khởi hành'))
      .finally(() => setLoading(false))
  }, [from, to])

  useEffect(() => {
    load()
  }, [load])

  const cols = `180px repeat(${DAYS}, minmax(44px, 1fr))`
  const totalDepartures = tours.reduce((s, t) => s + t.departures.length, 0)

  return (
    <div>
      {/* Thanh điều hướng khung ngày + chú thích */}
      <div className="mb-3 flex flex-wrap items-center justify-between gap-3">
        <div className="flex items-center gap-2">
          <button onClick={() => setAnchor(addDays(anchor, -DAYS))} className="rounded-lg border border-slate-700 bg-slate-800 px-3 py-1.5 text-sm text-slate-200 hover:bg-slate-700">‹</button>
          <span className="min-w-[180px] text-center text-sm font-semibold text-slate-200">
            {days[0].toLocaleDateString('vi-VN', { day: '2-digit', month: 'short' })} – {days[DAYS - 1].toLocaleDateString('vi-VN', { day: '2-digit', month: 'short', year: 'numeric' })}
          </span>
          <button onClick={() => setAnchor(addDays(anchor, DAYS))} className="rounded-lg border border-slate-700 bg-slate-800 px-3 py-1.5 text-sm text-slate-200 hover:bg-slate-700">›</button>
          <button onClick={() => setAnchor(addDays(startOfTodayUTC(), -1))} className="ml-1 rounded-lg border border-slate-700 bg-slate-800 px-3 py-1.5 text-xs text-slate-300 hover:bg-slate-700">Hôm nay</button>
        </div>
        <div className="flex flex-wrap items-center gap-3 text-xs text-slate-400">
          <Legend className="bg-emerald-900/70 border-emerald-500" label="Còn chỗ" />
          <Legend className="bg-red-900/70 border-red-600" label="Hết chỗ" />
          <Legend className="bg-slate-700/60 border-slate-600" label="Đã đóng" />
          <span className="text-slate-500">· thanh = số ngày tour · số = đã bán/tổng chỗ</span>
        </div>
      </div>

      {error && <div className="mb-3 rounded-lg border border-red-800 bg-red-950/40 px-4 py-2 text-sm text-red-300">⚠️ {error} <button onClick={load} className="ml-2 underline">Thử lại</button></div>}

      {loading ? (
        <p className="text-slate-500">Đang tải lịch khởi hành...</p>
      ) : tours.length === 0 ? (
        <p className="py-10 text-center text-slate-500">Chưa có tour nào (đang hiển thị/ẩn) để xếp lịch.</p>
      ) : (
        <div className="overflow-x-auto rounded-xl border border-slate-800 bg-slate-950">
          {/* Hàng tiêu đề ngày */}
          <div className="grid border-b border-slate-800 bg-slate-900" style={{ gridTemplateColumns: cols }}>
            <div className="sticky left-0 z-10 bg-slate-900 px-3 py-2 text-xs font-semibold uppercase tracking-wide text-slate-500">Tour</div>
            {days.map((d) => {
              const isToday = iso(d) === todayStr
              const dow = d.getUTCDay()
              const weekend = dow === 0 || dow === 6
              return (
                <div key={iso(d)} className={`border-l border-slate-800 py-2 text-center text-xs ${isToday ? 'bg-emerald-950/50 text-emerald-300' : weekend ? 'text-clay-300' : 'text-slate-400'}`}>
                  <div className="font-medium">{WD[dow]}</div>
                  <div className={isToday ? 'font-bold' : ''}>{d.getUTCDate()}</div>
                </div>
              )
            })}
          </div>

          {/* Mỗi tour một hàng */}
          {tours.map((t) => (
            <div key={t.id} className="grid border-b border-slate-800 last:border-b-0 hover:bg-slate-900/40" style={{ gridTemplateColumns: cols }}>
              {/* Cột tên tour (sticky) */}
              <Link to={`/admin/tours/${t.id}/departures`} className="sticky left-0 z-10 flex items-center gap-2 bg-slate-950 px-3 py-2 hover:bg-slate-900">
                {t.thumbnail && <img src={t.thumbnail} alt="" className="h-8 w-11 shrink-0 rounded object-cover" />}
                <span className="min-w-0">
                  <span className="block truncate text-sm text-slate-200">{t.title}</span>
                  <span className="block truncate text-[11px] text-slate-500">{t.tourCode}{t.region?.name ? ` · ${t.region.name}` : ''}</span>
                </span>
              </Link>

              {/* Rãnh thời gian: nền lưới ngày + các thanh chuyến đặt tuyệt đối */}
              <div className="relative" style={{ gridColumn: `2 / span ${DAYS}` }}>
                {/* nền lưới */}
                <div className="absolute inset-0 grid" style={{ gridTemplateColumns: `repeat(${DAYS}, minmax(0,1fr))` }}>
                  {days.map((d) => (
                    <div key={iso(d)} className={`border-l border-slate-800 ${iso(d) === todayStr ? 'bg-emerald-950/30' : ''}`} />
                  ))}
                </div>
                {/* các thanh chuyến */}
                <div className="relative min-h-[46px] py-1.5">
                  {t.departures.map((dep) => {
                    const i = dayIndex(days[0], dep.departureDate)
                    if (i < 0 || i >= DAYS) return null
                    const span = Math.max(1, Math.min(t.durationDays || 1, DAYS - i))
                    const left = (i / DAYS) * 100
                    const width = (span / DAYS) * 100
                    const st = barStyle(dep)
                    const sold = `${dep.bookedSlots}/${dep.totalSlots}`
                    return (
                      <Link
                        key={dep.id}
                        to={`/admin/tours/${t.id}/departures`}
                        title={`${new Date(dep.departureDate).toLocaleDateString('vi-VN')} · ${sold} chỗ${dep.guideName ? ` · HDV ${dep.guideName}` : ''} · ${dep.status}`}
                        className={`absolute top-1.5 flex h-8 items-center overflow-hidden rounded-md border px-2 text-[11px] font-medium shadow-sm transition hover:brightness-110 ${st.bar}`}
                        style={{ left: `calc(${left}% + 2px)`, width: `calc(${width}% - 4px)` }}
                      >
                        {/* lớp tô theo tỉ lệ đã bán */}
                        <span className={`absolute inset-y-0 left-0 ${st.fill}`} style={{ width: `${dep.totalSlots ? Math.min(100, (dep.bookedSlots / dep.totalSlots) * 100) : 0}%` }} />
                        <span className="relative truncate">🧳 {sold}</span>
                      </Link>
                    )
                  })}
                </div>
              </div>
            </div>
          ))}
        </div>
      )}

      {!loading && tours.length > 0 && (
        <p className="mt-3 text-xs text-slate-500">{tours.length} tour · {totalDepartures} chuyến trong khung ngày. Bấm vào thanh/tên tour để mở quản lý chuyến khởi hành.</p>
      )}
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
