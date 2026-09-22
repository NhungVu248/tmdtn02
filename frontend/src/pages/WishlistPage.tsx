import { useCallback, useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { ProductCard } from '../components/ProductCard'
import { ErrorState, Loading } from '../components/StateBlocks'
import { api, type Product } from '../lib/api'
import { useFavorites } from '../lib/favorites'

// UC-08 – Trang "Danh sách yêu thích" (BR-22: chỉ chủ tài khoản, đã bọc RequireAuth).
export function WishlistPage() {
  const [items, setItems] = useState<Product[]>([])
  const [status, setStatus] = useState<'loading' | 'ok' | 'error'>('loading')
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

  // Khi bỏ tim ở trang này, đồng bộ danh sách hiển thị theo context.
  const visible = items.filter((p) => ids.has(p.id))

  if (status === 'loading') return <Loading />
  if (status === 'error') return <ErrorState onRetry={load} />

  return (
    <div className="mx-auto max-w-6xl px-4 py-8">
      <h1 className="mb-6 text-2xl font-bold">Danh sách yêu thích</h1>

      {visible.length === 0 ? (
        <div className="flex flex-col items-center justify-center py-16 text-center text-slate-500">
          <div className="text-4xl">♡</div>
          <p className="mt-3 font-medium text-slate-700">Chưa có sản phẩm yêu thích</p>
          <p className="mt-1 text-sm">Bấm biểu tượng ♡ trên homestay/tour để lưu lại xem sau.</p>
          <Link
            to="/search"
            className="mt-5 rounded-lg bg-emerald-600 px-4 py-2 text-sm font-medium text-white hover:bg-emerald-700"
          >
            Khám phá sản phẩm
          </Link>
        </div>
      ) : (
        <div className="grid grid-cols-2 gap-4 sm:grid-cols-3 lg:grid-cols-4">
          {visible.map((p) => (
            <ProductCard key={p.id} product={p} />
          ))}
        </div>
      )}
    </div>
  )
}
