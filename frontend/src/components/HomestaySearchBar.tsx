import { useEffect, useMemo, useRef, useState } from 'react'
import { useNavigate, useSearchParams } from 'react-router-dom'

// Thanh tìm kiếm homestay chuyên biệt (phong cách Traveloka):
// Điểm đến · Ngày nhận/trả phòng (kèm số đêm) · Khách & Phòng (người lớn/trẻ em/phòng).
// Xác nhận -> UC-02 (/search?type=HOMESTAY). Số khách gửi lên = người lớn + trẻ em.
export function HomestaySearchBar() {
  const navigate = useNavigate()
  const [params] = useSearchParams()

  const [destination, setDestination] = useState(params.get('destination') ?? '')
  const [dateFrom, setDateFrom] = useState(params.get('from') ?? '')
  const [dateTo, setDateTo] = useState(params.get('to') ?? '')
  const [adults, setAdults] = useState(Math.max(1, Number(params.get('guests')) || 2))
  const [children, setChildren] = useState(0)
  const [rooms, setRooms] = useState(Number(params.get('rooms')) || 1)
  const [guestsOpen, setGuestsOpen] = useState(false)

  const guestsRef = useRef<HTMLDivElement>(null)

  // Đóng popover khách & phòng khi bấm ra ngoài.
  useEffect(() => {
    function onClick(e: MouseEvent) {
      if (guestsRef.current && !guestsRef.current.contains(e.target as Node)) setGuestsOpen(false)
    }
    document.addEventListener('mousedown', onClick)
    return () => document.removeEventListener('mousedown', onClick)
  }, [])

  // Số đêm giữa nhận & trả phòng (BR-05).
  const nights = useMemo(() => {
    if (!dateFrom || !dateTo) return 0
    const ms = new Date(dateTo).getTime() - new Date(dateFrom).getTime()
    return ms > 0 ? Math.round(ms / 86_400_000) : 0
  }, [dateFrom, dateTo])

  function submit(e: React.FormEvent) {
    e.preventDefault()
    const qs = new URLSearchParams({ type: 'HOMESTAY' })
    if (destination) qs.set('destination', destination)
    qs.set('guests', String(adults + children))
    qs.set('rooms', String(rooms))
    if (dateFrom) qs.set('from', dateFrom)
    if (dateTo) qs.set('to', dateTo)
    navigate(`/search?${qs.toString()}`)
  }

  const label = 'text-[11px] font-medium uppercase tracking-wide text-forest-400'
  const bare = 'w-full bg-transparent text-sm text-forest-900 placeholder:text-forest-300 focus:outline-none'

  return (
    <form
      onSubmit={submit}
      className="flex flex-col gap-2 rounded-2xl bg-white p-2 shadow-2xl shadow-forest-900/15 ring-1 ring-cream-200 md:flex-row md:items-stretch md:gap-0"
    >
      {/* Điểm đến */}
      <div className="flex flex-1 items-center gap-3 rounded-xl px-4 py-2.5 transition hover:bg-cream-50 md:border-r md:border-cream-200">
        <span className="text-lg text-clay-500">◍</span>
        <div className="min-w-0 flex-1">
          <span className={label}>Thành phố, địa điểm hoặc tên homestay</span>
          <input
            className={bare}
            placeholder="Đà Lạt, Sa Pa, Hội An..."
            value={destination}
            onChange={(e) => setDestination(e.target.value)}
          />
        </div>
      </div>

      {/* Ngày nhận & trả phòng */}
      <div className="flex flex-1 items-center gap-3 rounded-xl px-4 py-2.5 transition hover:bg-cream-50 md:border-r md:border-cream-200">
        <span className="text-lg text-clay-500">▤</span>
        <div className="min-w-0 flex-1">
          <span className={label}>
            Ngày nhận & trả phòng {nights > 0 && <span className="text-forest-600">· {nights} đêm</span>}
          </span>
          <div className="flex items-center gap-2">
            <input type="date" className={bare} value={dateFrom} onChange={(e) => setDateFrom(e.target.value)} />
            <span className="text-forest-300">→</span>
            <input type="date" className={bare} value={dateTo} onChange={(e) => setDateTo(e.target.value)} />
          </div>
        </div>
      </div>

      {/* Khách & Phòng */}
      <div ref={guestsRef} className="relative flex items-center md:w-64">
        <button
          type="button"
          onClick={() => setGuestsOpen((v) => !v)}
          className="flex w-full items-center gap-3 rounded-xl px-4 py-2.5 text-left transition hover:bg-cream-50"
        >
          <span className="text-lg text-clay-500">☺</span>
          <div className="min-w-0 flex-1">
            <span className={label}>Khách và phòng</span>
            <p className="truncate text-sm text-forest-900">
              {adults} người lớn, {children} trẻ em, {rooms} phòng
            </p>
          </div>
          <span className="text-forest-300">▾</span>
        </button>

        {guestsOpen && (
          <div className="absolute right-0 top-full z-30 mt-2 w-72 rounded-2xl border border-cream-200 bg-white p-4 shadow-xl">
            <Stepper label="Người lớn" hint="Từ 13 tuổi" value={adults} min={1} onChange={setAdults} />
            <Stepper label="Trẻ em" hint="0–12 tuổi" value={children} min={0} onChange={setChildren} />
            <Stepper label="Phòng" value={rooms} min={1} onChange={setRooms} />
            <button
              type="button"
              onClick={() => setGuestsOpen(false)}
              className="mt-3 w-full rounded-full bg-forest-700 py-2 text-sm font-medium text-cream-50 hover:bg-forest-800"
            >
              Xong
            </button>
          </div>
        )}
      </div>

      {/* Nút tìm kiếm */}
      <button
        type="submit"
        className="flex items-center justify-center gap-2 rounded-2xl bg-clay-500 px-8 py-3 text-sm font-semibold text-white shadow-lg transition hover:bg-clay-600"
      >
        Tìm kiếm 🔍
      </button>
    </form>
  )
}

function Stepper({
  label,
  hint,
  value,
  min,
  onChange,
}: {
  label: string
  hint?: string
  value: number
  min: number
  onChange: (v: number) => void
}) {
  return (
    <div className="flex items-center justify-between py-2">
      <div>
        <p className="text-sm font-medium text-forest-900">{label}</p>
        {hint && <p className="text-xs text-forest-400">{hint}</p>}
      </div>
      <div className="flex items-center gap-3">
        <button
          type="button"
          onClick={() => onChange(Math.max(min, value - 1))}
          disabled={value <= min}
          className="grid h-8 w-8 place-items-center rounded-full border border-forest-300 text-forest-700 transition hover:bg-forest-50 disabled:cursor-not-allowed disabled:opacity-40"
        >
          −
        </button>
        <span className="w-6 text-center text-sm font-semibold text-forest-900">{value}</span>
        <button
          type="button"
          onClick={() => onChange(value + 1)}
          className="grid h-8 w-8 place-items-center rounded-full border border-forest-300 text-forest-700 transition hover:bg-forest-50"
        >
          +
        </button>
      </div>
    </div>
  )
}
