import { useCallback, useEffect, useMemo, useState } from 'react'
import { useSearchParams } from 'react-router-dom'
import { DualSearchBar } from '../components/DualSearchBar'
import { ProductCard } from '../components/ProductCard'
import { ErrorState, Loading } from '../components/StateBlocks'
import { ApiError, api, formatPrice, type SearchResult } from '../lib/api'

interface Filters {
  minPrice: string
  maxPrice: string
  locations: string[]
  amenities: string[]
  minRating: string
  durations: number[]
  sort: string
}

const emptyFilters: Filters = {
  minPrice: '',
  maxPrice: '',
  locations: [],
  amenities: [],
  minRating: '',
  durations: [],
  sort: '',
}

export function SearchPage() {
  const [params] = useSearchParams()
  // Tiêu chí tìm kiếm cơ bản lấy từ URL (do thanh tìm kiếm kép đẩy lên).
  const criteriaKey = params.toString()
  const type = params.get('type') === 'TOUR' ? 'TOUR' : 'HOMESTAY'

  const [filters, setFilters] = useState<Filters>(emptyFilters)
  const [data, setData] = useState<SearchResult | null>(null)
  const [status, setStatus] = useState<'loading' | 'ok' | 'error'>('loading')
  const [invalid, setInvalid] = useState<string | null>(null) // ngoại lệ 2a

  // Khi tiêu chí cơ bản đổi (người dùng tìm lại - luồng 4a) thì reset bộ lọc.
  useEffect(() => {
    setFilters(emptyFilters)
  }, [criteriaKey])

  const load = useCallback(() => {
    const qs = new URLSearchParams()
    // tiêu chí cơ bản
    for (const k of ['type', 'destination', 'guests', 'from', 'to', 'depart']) {
      const v = params.get(k)
      if (v) qs.set(k, v)
    }
    // bộ lọc thứ cấp
    if (filters.minPrice) qs.set('minPrice', filters.minPrice)
    if (filters.maxPrice) qs.set('maxPrice', filters.maxPrice)
    if (filters.minRating) qs.set('minRating', filters.minRating)
    if (filters.locations.length) qs.set('location', filters.locations.join(',')) // 1 khu vực/lần cho đơn giản
    if (filters.amenities.length) qs.set('amenities', filters.amenities.join(','))
    if (filters.durations.length) qs.set('duration', filters.durations.join(','))
    if (filters.sort) qs.set('sort', filters.sort)

    setStatus('loading')
    setInvalid(null)
    api
      .search(qs)
      .then((d) => {
        setData(d)
        setStatus('ok')
      })
      .catch((err) => {
        if (err instanceof ApiError && err.status === 400) {
          setInvalid(err.message) // ngoại lệ 2a: tiêu chí không hợp lệ
          setStatus('ok')
        } else {
          setStatus('error')
        }
      })
  }, [params, filters])

  useEffect(() => {
    load()
  }, [load])

  const facets = data?.facets
  const summary = useMemo(() => {
    const dest = params.get('destination')
    return [type === 'HOMESTAY' ? 'Homestay' : 'Tour', dest ? `tại "${dest}"` : ''].filter(Boolean).join(' ')
  }, [params, type])

  function toggle<T>(list: T[], value: T): T[] {
    return list.includes(value) ? list.filter((x) => x !== value) : [...list, value]
  }

  return (
    <div>
      <section className="border-b border-slate-200 bg-white">
        <div className="mx-auto max-w-6xl px-4 py-5">
          <DualSearchBar compact />
        </div>
      </section>

      <div className="mx-auto max-w-6xl gap-6 px-4 py-6 lg:flex">
        {/* Cột bộ lọc */}
        <aside className="mb-6 w-full shrink-0 lg:mb-0 lg:w-64">
          <div className="rounded-xl border border-slate-200 bg-white p-4">
            <div className="mb-4 flex items-center justify-between">
              <h2 className="font-semibold">Bộ lọc</h2>
              <button
                onClick={() => setFilters(emptyFilters)}
                className="text-xs text-slate-500 hover:text-emerald-700"
              >
                Xóa lọc
              </button>
            </div>

            {/* Giá */}
            <div className="mb-4">
              <p className="mb-2 text-sm font-medium">Khoảng giá (₫)</p>
              <div className="flex items-center gap-2">
                <input
                  type="number"
                  min={0}
                  placeholder={facets ? String(facets.priceMin) : 'Từ'}
                  value={filters.minPrice}
                  onChange={(e) => setFilters((f) => ({ ...f, minPrice: e.target.value }))}
                  className="w-full rounded-lg border border-slate-300 px-2 py-1 text-sm"
                />
                <span className="text-slate-400">–</span>
                <input
                  type="number"
                  min={0}
                  placeholder={facets ? String(facets.priceMax) : 'Đến'}
                  value={filters.maxPrice}
                  onChange={(e) => setFilters((f) => ({ ...f, maxPrice: e.target.value }))}
                  className="w-full rounded-lg border border-slate-300 px-2 py-1 text-sm"
                />
              </div>
            </div>

            {/* Đánh giá */}
            <div className="mb-4">
              <p className="mb-2 text-sm font-medium">Đánh giá</p>
              {['4.5', '4', '0'].map((r) => (
                <label key={r} className="flex cursor-pointer items-center gap-2 py-0.5 text-sm">
                  <input
                    type="radio"
                    name="rating"
                    checked={filters.minRating === (r === '0' ? '' : r)}
                    onChange={() => setFilters((f) => ({ ...f, minRating: r === '0' ? '' : r }))}
                  />
                  {r === '0' ? 'Tất cả' : `${r}★ trở lên`}
                </label>
              ))}
            </div>

            {/* Khu vực */}
            {facets && facets.locations.length > 0 && (
              <div className="mb-4">
                <p className="mb-2 text-sm font-medium">Khu vực</p>
                {facets.locations.map((loc) => (
                  <label key={loc} className="flex cursor-pointer items-center gap-2 py-0.5 text-sm">
                    <input
                      type="checkbox"
                      checked={filters.locations.includes(loc)}
                      onChange={() => setFilters((f) => ({ ...f, locations: toggle(f.locations, loc) }))}
                    />
                    {loc}
                  </label>
                ))}
              </div>
            )}

            {/* Tiện nghi (homestay) */}
            {type === 'HOMESTAY' && facets && facets.amenities.length > 0 && (
              <div className="mb-4">
                <p className="mb-2 text-sm font-medium">Tiện nghi</p>
                {facets.amenities.map((a) => (
                  <label key={a} className="flex cursor-pointer items-center gap-2 py-0.5 text-sm">
                    <input
                      type="checkbox"
                      checked={filters.amenities.includes(a)}
                      onChange={() => setFilters((f) => ({ ...f, amenities: toggle(f.amenities, a) }))}
                    />
                    {a}
                  </label>
                ))}
              </div>
            )}

            {/* Thời lượng (tour) */}
            {type === 'TOUR' && facets && facets.durations.length > 0 && (
              <div className="mb-1">
                <p className="mb-2 text-sm font-medium">Thời lượng</p>
                {facets.durations.map((d) => (
                  <label key={d} className="flex cursor-pointer items-center gap-2 py-0.5 text-sm">
                    <input
                      type="checkbox"
                      checked={filters.durations.includes(d)}
                      onChange={() => setFilters((f) => ({ ...f, durations: toggle(f.durations, d) }))}
                    />
                    {d} ngày
                  </label>
                ))}
              </div>
            )}
          </div>
        </aside>

        {/* Cột kết quả */}
        <div className="flex-1">
          <div className="mb-4 flex flex-wrap items-center justify-between gap-3">
            <h1 className="text-lg font-semibold">
              Tìm kiếm {summary}
              {status === 'ok' && !invalid && (
                <span className="ml-2 text-sm font-normal text-slate-500">
                  ({data?.count ?? 0} kết quả
                  {data?.nights ? `, ${data.nights} đêm` : ''})
                </span>
              )}
            </h1>
            <select
              value={filters.sort}
              onChange={(e) => setFilters((f) => ({ ...f, sort: e.target.value }))}
              className="rounded-lg border border-slate-300 px-3 py-1.5 text-sm"
            >
              <option value="">Sắp xếp: Mới nhất</option>
              <option value="price_asc">Giá tăng dần</option>
              <option value="price_desc">Giá giảm dần</option>
              <option value="rating_desc">Đánh giá cao nhất</option>
            </select>
          </div>

          {/* Ngoại lệ 2a: tiêu chí không hợp lệ */}
          {invalid && (
            <div className="rounded-lg border border-amber-300 bg-amber-50 px-4 py-3 text-sm text-amber-800">
              ⚠️ {invalid}. Vui lòng chỉnh lại tiêu chí tìm kiếm.
            </div>
          )}

          {!invalid && status === 'loading' && <Loading />}
          {!invalid && status === 'error' && <ErrorState onRetry={load} />}

          {/* Ngoại lệ 3a: không có kết quả */}
          {!invalid && status === 'ok' && data && data.count === 0 && (
            <div className="flex flex-col items-center justify-center py-16 text-center text-slate-500">
              <div className="text-4xl">🔍</div>
              <p className="mt-3 font-medium text-slate-700">Không tìm thấy sản phẩm phù hợp</p>
              <p className="mt-1 text-sm">Hãy thử nới lỏng tiêu chí: mở rộng khoảng giá, bỏ bớt bộ lọc hoặc đổi khu vực.</p>
            </div>
          )}

          {!invalid && status === 'ok' && data && data.count > 0 && (
            <div className="grid grid-cols-2 gap-4 sm:grid-cols-3">
              {data.items.map((p) => (
                <div key={p.id}>
                  <ProductCard product={p} />
                  {p.totalPrice != null && (
                    <p className="mt-1 px-1 text-xs text-slate-500">
                      Tạm tính {p.nights} đêm:{' '}
                      <span className="font-semibold text-emerald-700">{formatPrice(p.totalPrice)}</span>
                    </p>
                  )}
                </div>
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  )
}
