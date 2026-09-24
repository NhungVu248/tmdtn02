import { useCallback, useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { ProductCard } from '../components/ProductCard'
import { ErrorState, Loading } from '../components/StateBlocks'
import { api, type Product, type ProductType } from '../lib/api'
import { useFavorites } from '../lib/favorites'

// Trang "Danh sách yêu thích" (chỉ chủ tài khoản, đã bọc RequireAuth).
export function WishlistPage() {
  const [items, setItems] = useState<Product[]>([])
  const [status, setStatus] = useState<'loading' | 'ok' | 'error'>('loading')
  const [filter, setFilter] = useState<'ALL' | ProductType>('ALL')
  const { ids } = useFavorites()

  const load = useCallback(() => {
    setStatus('loading')
    api
      .getFavorites()
      .then((r) => {
        setItems(r.items)
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
  const hasHomestay = saved.some((p) => p.type === 'HOMESTAY')
  const hasTour = saved.some((p) => p.type === 'TOUR')
  const visible = filter === 'ALL' ? saved : saved.filter((p) => p.type === filter)

  const chip = (active: boolean) =>
    `rounded-full px-4 py-1.5 text-sm font-medium transition ${
      active ? 'bg-forest-700 text-cream-50' : 'bg-white text-forest-600 ring-1 ring-cream-300 hover:bg-cream-100'
    }`

  return (
    <div className="mx-auto max-w-6xl px-6 py-10">
      <header className="mb-8 flex flex-wrap items-end justify-between gap-4">
        <div>
          <h1 className="font-display text-4xl font-semibold text-forest-900">Danh sách yêu thích</h1>
          <p className="mt-2 text-forest-400">
            {saved.length > 0
              ? `Bạn đã lưu ${saved.length} chỗ nghỉ & tour để xem sau.`
              : 'Lưu lại những nơi bạn quan tâm để dễ dàng đặt chỗ về sau.'}
          </p>
        </div>

        {/* Bộ lọc theo loại (chỉ hiện khi có cả hai) */}
        {hasHomestay && hasTour && (
          <div className="flex items-center gap-2">
            <button onClick={() => setFilter('ALL')} className={chip(filter === 'ALL')}>
              Tất cả ({saved.length})
            </button>
            <button onClick={() => setFilter('HOMESTAY')} className={chip(filter === 'HOMESTAY')}>
              Homestay
            </button>
            <button onClick={() => setFilter('TOUR')} className={chip(filter === 'TOUR')}>
              Tour
            </button>
          </div>
        )}
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
        <div className="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">
          {visible.map((p) => (
            <ProductCard key={`${p.type}-${p.id}`} product={p} />
          ))}
        </div>
      )}
    </div>
  )
}
