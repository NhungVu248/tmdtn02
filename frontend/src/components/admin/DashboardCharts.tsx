// Biểu đồ dashboard admin vẽ bằng SVG thuần (không thêm thư viện), nền tối.
// Dữ liệu thật từ /api/admin/reports — KHÔNG tạo dữ liệu giả.

export const CHART_COLORS = ['#34d399', '#60a5fa', '#fbbf24', '#f97316', '#a78bfa', '#f472b6', '#22d3ee', '#94a3b8']

export function vnd(n: number) {
  return (n || 0).toLocaleString('vi-VN') + '₫'
}
export function vndShort(n: number) {
  if (n >= 1e9) return (n / 1e9).toFixed(n % 1e9 ? 1 : 0) + ' tỷ'
  if (n >= 1e6) return (n / 1e6).toFixed(n % 1e6 ? 1 : 0) + ' tr'
  if (n >= 1e3) return Math.round(n / 1e3) + 'k'
  return String(n)
}

// ---------- Biểu đồ tròn (donut) ----------
export function DonutChart({ data }: { data: { label: string; amount: number }[] }) {
  const total = data.reduce((s, d) => s + d.amount, 0)
  const R = 54, SW = 22, C = 2 * Math.PI * R
  let offset = 0
  if (total <= 0) return <Empty label="Chưa có doanh thu trong kỳ" />
  return (
    <div className="flex flex-wrap items-center gap-5">
      <svg viewBox="0 0 150 150" className="h-40 w-40 shrink-0">
        <g transform="rotate(-90 75 75)">
          {data.map((d, i) => {
            const len = (d.amount / total) * C
            const el = (
              <circle key={i} cx={75} cy={75} r={R} fill="none" stroke={CHART_COLORS[i % CHART_COLORS.length]} strokeWidth={SW} strokeDasharray={`${len} ${C - len}`} strokeDashoffset={-offset} />
            )
            offset += len
            return el
          })}
        </g>
        <text x={75} y={70} textAnchor="middle" className="fill-slate-400" style={{ fontSize: 9 }}>Tổng</text>
        <text x={75} y={84} textAnchor="middle" className="fill-white" style={{ fontSize: 12, fontWeight: 700 }}>{vndShort(total)}</text>
      </svg>
      <ul className="flex-1 space-y-1.5 text-sm">
        {data.map((d, i) => (
          <li key={i} className="flex items-center gap-2">
            <span className="inline-block h-3 w-3 shrink-0 rounded-sm" style={{ background: CHART_COLORS[i % CHART_COLORS.length] }} />
            <span className="flex-1 truncate text-slate-300">{d.label}</span>
            <span className="font-medium text-slate-100">{vnd(d.amount)}</span>
            <span className="w-12 text-right text-xs text-slate-500">{((d.amount / total) * 100).toFixed(1)}%</span>
          </li>
        ))}
      </ul>
    </div>
  )
}

// ---------- Biểu đồ vùng/đường (xu hướng theo ngày) ----------
export function AreaChart({ data }: { data: { date: string; amount: number }[] }) {
  if (!data.length) return <Empty label="Chưa có dữ liệu doanh thu theo ngày" />
  const W = 640, H = 200, P = 28
  const max = Math.max(...data.map((d) => d.amount), 1)
  const n = data.length
  const x = (i: number) => P + (n <= 1 ? (W - 2 * P) / 2 : (i / (n - 1)) * (W - 2 * P))
  const y = (v: number) => H - P - (v / max) * (H - 2 * P)
  const line = data.map((d, i) => `${i ? 'L' : 'M'}${x(i).toFixed(1)},${y(d.amount).toFixed(1)}`).join(' ')
  const area = `${line} L${x(n - 1).toFixed(1)},${H - P} L${x(0).toFixed(1)},${H - P} Z`
  const ticks = [0, Math.floor((n - 1) / 2), n - 1].filter((v, idx, a) => a.indexOf(v) === idx)
  const fmtDate = (s: string) => { const d = new Date(s); return `${d.getUTCDate()}/${d.getUTCMonth() + 1}` }
  return (
    <svg viewBox={`0 0 ${W} ${H}`} className="w-full" preserveAspectRatio="none" style={{ height: 200 }}>
      <defs>
        <linearGradient id="areaFill" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0%" stopColor="#34d399" stopOpacity="0.35" />
          <stop offset="100%" stopColor="#34d399" stopOpacity="0" />
        </linearGradient>
      </defs>
      {[0, 0.5, 1].map((t, i) => (
        <g key={i}>
          <line x1={P} x2={W - P} y1={y(max * t)} y2={y(max * t)} stroke="#334155" strokeWidth="0.6" strokeDasharray="3 3" />
          <text x={4} y={y(max * t) + 3} className="fill-slate-500" style={{ fontSize: 9 }}>{vndShort(max * t)}</text>
        </g>
      ))}
      <path d={area} fill="url(#areaFill)" />
      <path d={line} fill="none" stroke="#34d399" strokeWidth="2" strokeLinejoin="round" strokeLinecap="round" />
      {data.map((d, i) => <circle key={i} cx={x(i)} cy={y(d.amount)} r={n > 40 ? 0 : 2.2} fill="#34d399" />)}
      {ticks.map((i) => <text key={i} x={x(i)} y={H - 8} textAnchor="middle" className="fill-slate-500" style={{ fontSize: 9 }}>{fmtDate(data[i].date)}</text>)}
    </svg>
  )
}

// ---------- Danh sách thanh ngang (top bán chạy) ----------
export function BarList({ data, unit = '' }: { data: { label: string; value: number; sub?: string }[]; unit?: string }) {
  if (!data.length) return <Empty label="Chưa có dữ liệu" />
  const max = Math.max(...data.map((d) => d.value), 1)
  return (
    <ul className="space-y-2.5">
      {data.map((d, i) => (
        <li key={i} className="text-sm">
          <div className="mb-1 flex items-center justify-between gap-2">
            <span className="flex min-w-0 items-center gap-2">
              <span className="inline-block h-2.5 w-2.5 shrink-0 rounded-full" style={{ background: CHART_COLORS[i % CHART_COLORS.length] }} />
              <span className="truncate text-slate-300">{d.label}</span>
            </span>
            <span className="shrink-0 font-medium text-slate-100">{d.value.toLocaleString('vi-VN')}{unit}{d.sub ? <span className="ml-1 text-xs text-slate-500">{d.sub}</span> : null}</span>
          </div>
          <div className="h-2 w-full overflow-hidden rounded-full bg-slate-800">
            <div className="h-full rounded-full" style={{ width: `${(d.value / max) * 100}%`, background: CHART_COLORS[i % CHART_COLORS.length] }} />
          </div>
        </li>
      ))}
    </ul>
  )
}

function Empty({ label }: { label: string }) {
  return <p className="py-10 text-center text-sm text-slate-500">{label}</p>
}
