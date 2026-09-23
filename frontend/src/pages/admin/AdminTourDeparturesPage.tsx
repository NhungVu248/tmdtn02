import { useCallback, useEffect, useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import { AdminApiError, adminApi, type Departure } from '../../lib/adminApi'

const field = 'rounded-lg border border-slate-700 bg-slate-800 px-3 py-2 text-sm text-slate-100 focus:border-emerald-500 focus:outline-none'

function tomorrow() {
  const d = new Date()
  d.setDate(d.getDate() + 1)
  return d.toISOString().slice(0, 10)
}

// UC-17 – Quản lý ngày khởi hành: thêm chuyến, số chỗ tối đa, giá theo loại khách (BR-80).
export function AdminTourDeparturesPage() {
  const { id } = useParams<{ id: string }>()
  const productId = Number(id)

  const [departures, setDepartures] = useState<Departure[]>([])
  const [tourName, setTourName] = useState('')
  const [loading, setLoading] = useState(true)

  const [date, setDate] = useState(tomorrow())
  const [totalSeats, setTotalSeats] = useState('20')
  const [priceAdult, setPriceAdult] = useState('')
  const [priceChild, setPriceChild] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [conflict, setConflict] = useState<{ code: string; guests: number; children: number; status: string }[] | null>(null)
  const [submitting, setSubmitting] = useState(false)

  const load = useCallback(() => {
    setLoading(true)
    adminApi
      .getTour(productId)
      .then(({ product }) => {
        setDepartures(product.departures)
        setTourName(product.name)
      })
      .finally(() => setLoading(false))
  }, [productId])

  useEffect(() => {
    load()
  }, [load])

  async function addDeparture(e: React.FormEvent) {
    e.preventDefault()
    setError(null)
    setConflict(null)
    setSubmitting(true)
    try {
      await adminApi.createDeparture(productId, {
        date,
        totalSeats: Number(totalSeats),
        priceAdultOverride: priceAdult ? Number(priceAdult) : null,
        priceChildOverride: priceChild ? Number(priceChild) : null,
      })
      load()
    } catch (err) {
      setError(err instanceof AdminApiError ? err.message : 'Thêm chuyến thất bại') // 5a
    } finally {
      setSubmitting(false)
    }
  }

  async function updateSeats(dep: Departure, newSeats: number) {
    setError(null)
    setConflict(null)
    try {
      await adminApi.updateDeparture(productId, dep.id, { totalSeats: newSeats })
      load()
    } catch (err) {
      if (err instanceof AdminApiError && err.status === 409) {
        setError(err.message) // BR-81/4a-2
      } else {
        setError('Cập nhật thất bại')
      }
    }
  }

  async function closeDeparture(dep: Departure) {
    setError(null)
    setConflict(null)
    try {
      await adminApi.closeDeparture(productId, dep.id)
      load()
    } catch (err) {
      if (err instanceof AdminApiError && err.status === 409) {
        setError(err.message) // BR-81/4a-1
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
      <h1 className="mb-6 text-2xl font-bold text-white">Chuyến khởi hành — {tourName}</h1>

      <form onSubmit={addDeparture} className="mb-6 rounded-xl border border-slate-800 bg-slate-950 p-5">
        <h2 className="mb-3 font-semibold text-slate-200">Thêm chuyến mới</h2>
        <div className="flex flex-wrap items-end gap-3">
          <label className="flex flex-col gap-1 text-xs text-slate-400">
            Ngày khởi hành
            <input className={field} type="date" value={date} onChange={(e) => setDate(e.target.value)} />
          </label>
          <label className="flex flex-col gap-1 text-xs text-slate-400">
            Số chỗ tối đa
            <input className={`${field} w-32`} type="number" min={1} value={totalSeats} onChange={(e) => setTotalSeats(e.target.value)} />
          </label>
          <label className="flex flex-col gap-1 text-xs text-slate-400">
            Giá người lớn riêng
            <input className={`${field} w-40`} type="number" min={0} value={priceAdult} onChange={(e) => setPriceAdult(e.target.value)} placeholder="Giá cơ bản" />
          </label>
          <label className="flex flex-col gap-1 text-xs text-slate-400">
            Giá trẻ em riêng
            <input className={`${field} w-40`} type="number" min={0} value={priceChild} onChange={(e) => setPriceChild(e.target.value)} placeholder="Giá cơ bản" />
          </label>
          <button
            type="submit"
            disabled={submitting}
            className="rounded-lg bg-emerald-600 px-4 py-2 text-sm font-semibold text-white hover:bg-emerald-700 disabled:opacity-50"
          >
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
                <li key={b.code}>
                  Đơn <span className="font-mono">{b.code}</span> ({b.guests} người lớn{b.children ? ` · ${b.children} trẻ em` : ''}) — xử lý ở Quản lý đơn (UC-18) trước.
                </li>
              ))}
            </ul>
          )}
        </div>
      )}

      {loading ? (
        <p className="text-slate-500">Đang tải...</p>
      ) : departures.length === 0 ? (
        <p className="text-slate-500">Chưa có chuyến khởi hành nào.</p>
      ) : (
        <div className="overflow-hidden rounded-xl border border-slate-800">
          <table className="w-full text-sm">
            <thead className="bg-slate-950 text-left text-slate-400">
              <tr>
                <th className="px-4 py-2">Ngày</th>
                <th className="px-4 py-2">Số chỗ tối đa</th>
                <th className="px-4 py-2">Đã bán</th>
                <th className="px-4 py-2">Còn trống</th>
                <th className="px-4 py-2">Giá riêng (lớn/trẻ)</th>
                <th className="px-4 py-2">Trạng thái</th>
                <th className="px-4 py-2">Thao tác</th>
              </tr>
            </thead>
            <tbody>
              {departures.map((d) => (
                <tr key={d.id} className="border-t border-slate-800">
                  <td className="px-4 py-2 text-slate-200">{new Date(d.date).toLocaleDateString('vi-VN')}</td>
                  <td className="px-4 py-2">
                    <input
                      type="number"
                      min={1}
                      defaultValue={d.totalSeats}
                      onBlur={(e) => {
                        const v = Number(e.target.value)
                        if (v !== d.totalSeats) updateSeats(d, v)
                      }}
                      className="w-20 rounded border border-slate-700 bg-slate-800 px-2 py-1 text-slate-100"
                      disabled={d.closed}
                    />
                  </td>
                  <td className="px-4 py-2 text-slate-400">{d.bookedSeats}</td>
                  <td className={`px-4 py-2 ${d.totalSeats - d.bookedSeats <= 0 ? 'text-red-400' : 'text-emerald-400'}`}>
                    {d.totalSeats - d.bookedSeats}
                  </td>
                  <td className="px-4 py-2 text-slate-400">
                    {d.priceAdultOverride != null || d.priceChildOverride != null
                      ? `${d.priceAdultOverride?.toLocaleString('vi-VN') ?? '-'} / ${d.priceChildOverride?.toLocaleString('vi-VN') ?? '-'}`
                      : <span className="text-slate-600">giá cơ bản</span>}
                  </td>
                  <td className="px-4 py-2">
                    <span className={`rounded-full px-2 py-0.5 text-xs ${d.closed ? 'bg-slate-800 text-slate-500' : 'bg-emerald-900 text-emerald-300'}`}>
                      {d.closed ? 'Đã đóng' : 'Đang mở'}
                    </span>
                  </td>
                  <td className="px-4 py-2">
                    {!d.closed && (
                      <button onClick={() => closeDeparture(d)} className="text-red-400 hover:underline">
                        Đóng chuyến
                      </button>
                    )}
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
