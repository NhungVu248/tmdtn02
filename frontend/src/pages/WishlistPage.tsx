import { useCallback, useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { ProductCard } from '../components/ProductCard'
import { ErrorState, Loading } from '../components/StateBlocks'
import { api, formatPrice, type Product, type ProductType } from '../lib/api'
import { useFavorites } from '../lib/favorites'

// Trang "Danh sách yêu thích" (chỉ chủ tài khoản, đã bọc RequireAuth).
export function WishlistPage() {
  const [items, setItems] = useState<Product[]>([])
  const [suggested, setSuggested] = useState<Product[]>([])
  const [status, setStatus] = useState<'loading' | 'ok' | 'error'>('loading')
  const [filter, setFilter] = useState<'ALL' | ProductType>('ALL')
  const { ids } = useFavorites()

  const load = useCallback(() => {
    setStatus('loading')
    Promise.all([api.getFavorites(), api.getHome().catch(() => ({ featured: [] as Product[] }))])
      .then(([fav, home]) => {
        setItems(fav.items)
        setSuggested(home.featured ?? [])
        setStatus('ok')
      })
      .catch(() => setStatus('error'))
  }, [])

  useEffect(() => {
    load()
  }, [load])

  if (status === 'loading') return <Loading />
  if (status === 'error') return <ErrorState onRetry={load} />

  // Khi bỏ tim ở trang này, đồng bộ danh sách hiển thị theo context.
  const saved = items.filter((p) => ids.has(p.id))
  const homestayCount = saved.filter((p) => p.type === 'HOMESTAY').length
  const tourCount = saved.filter((p) => p.type === 'TOUR').length
  const totalValue = saved.reduce((sum, p) => sum + p.price, 0)
  const hasBoth = homestayCount > 0 && tourCount > 0
  const visible = filter === 'ALL' ? saved : saved.filter((p) => p.type === filter)

  // Gợi ý: sản phẩm nổi bật chưa nằm trong danh sách yêu thích.
  const suggestions = suggested.filter((p) => !ids.has(p.id)).slice(0, 4)

  const chip = (active: boolean) =>
    `rounded-full px-4 py-1.5 text-sm font-medium transition ${
      active ? 'bg-forest-700 text-cream-50' : 'bg-white text-forest-600 ring-1 ring-cream-300 hover:bg-cream-100'
    }`

  return (
    <div className="mx-auto max-w-6xl px-6 py-10">
      <header className="mb-8">
        <h1 className="font-display text-4xl font-semibold text-forest-900">Danh sách yêu thích</h1>
        <p className="mt-2 text-forest-400">
          {saved.length > 0
            ? 'Những chỗ nghỉ & tour bạn đã lưu để đặt sau.'
            : 'Lưu lại những nơi bạn quan tâm để dễ dàng đặt chỗ về sau.'}
        </p>
      </header>

      {saved.length === 0 ? (
        <div className="flex flex-col items-center justify-center rounded-3xl border border-cream-200 bg-white py-20 text-center">
          <div className="grid h-16 w-16 place-items-center rounded-full bg-clay-400/15 text-3xl text-clay-500">♥</div>
          <p className="mt-4 font-display text-xl font-medium text-forest-800">Chưa có mục yêu thích nào</p>
          <p className="mt-1 text-sm text-forest-400">Bấm biểu tượng ♡ trên homestay/tour để lưu lại xem sau.</p>
          <Link
            to="/search"
            className="mt-6 rounded-full bg-forest-700 px-6 py-2.5 text-sm font-medium text-cream-50 transition hover:bg-forest-800"
          >
            Khám phá ngay →
          </Link>
        </div>
      ) : (
        <>
          {/* Dải thống kê tóm tắt */}
          <div className="mb-6 grid grid-cols-2 gap-4 sm:grid-cols-3">
            <StatCard icon="♥" label="Tổng đã lưu" value={String(saved.length)} />
            <StatCard icon="⌂ ✈" label="Homestay · Tour" value={`${homestayCount} · ${tourCount}`} />
            <StatCard icon="₫" label="Từ mức giá" value={formatPrice(totalValue)} />
          </div>

          {/* Bộ lọc theo loại (chỉ hiện khi có cả hai) */}
          {hasBoth && (
            <div className="mb-6 flex items-center gap-2">
              <button onClick={() => setFilter('ALL')} className={chip(filter === 'ALL')}>
                Tất cả ({saved.length})
              </button>
              <button onClick={() => setFilter('HOMESTAY')} className={chip(filter === 'HOMESTAY')}>
                Homestay ({homestayCount})
              </button>
              <button onClick={() => setFilter('TOUR')} className={chip(filter === 'TOUR')}>
                Tour ({tourCount})
              </button>
            </div>
          )}

          <div className="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">
            {visible.map((p) => (
              <ProductCard key={`${p.type}-${p.id}`} product={p} />
            ))}
          </div>
        </>
      )}

      {/* Gợi ý cho bạn */}
      {suggestions.length > 0 && (
        <section className="mt-16">
          <div className="mb-6 flex items-end justify-between">
            <div>
              <p className="text-sm font-medium uppercase tracking-[0.2em] text-clay-500">Có thể bạn thích</p>
              <h2 className="mt-2 font-display text-3xl font-semibold text-forest-900">Gợi ý cho bạn</h2>
            </div>
            <Link to="/search" className="hidden text-sm font-medium text-forest-600 hover:text-forest-800 sm:block">
              Xem tất cả →
            </Link>
          </div>
          <div className="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-4">
            {suggestions.map((p) => (
              <ProductCard key={`${p.type}-${p.id}`} product={p} />
            ))}
          </div>
        </section>
      )}
    </div>
  )
}

function StatCard({ icon, label, value }: { icon: string; label: string; value: string }) {
  return (
    <div className="flex items-center gap-3 rounded-2xl border border-cream-200 bg-white px-5 py-4">
      <span className="grid h-11 w-11 shrink-0 place-items-center rounded-xl bg-forest-100 text-base text-forest-700">
        {icon}
      </span>
      <div className="min-w-0">
        <p className="truncate text-xs text-forest-400">{label}</p>
        <p className="truncate font-display text-lg font-semibold text-forest-900">{value}</p>
      </div>
    </div>
  )
}
