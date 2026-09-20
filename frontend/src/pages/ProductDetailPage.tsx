import { useCallback, useEffect, useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import { AvailabilityChecker } from '../components/AvailabilityChecker'
import { ProductCard } from '../components/ProductCard'
import { ErrorState, Loading } from '../components/StateBlocks'
import { ApiError, api, type DetailResponse } from '../lib/api'

export function ProductDetailPage() {
  const { slug } = useParams<{ slug: string }>()
  const [data, setData] = useState<DetailResponse | null>(null)
  const [status, setStatus] = useState<'loading' | 'ok' | 'error' | 'gone'>('loading')
  const [activeImg, setActiveImg] = useState(0)

  const load = useCallback(() => {
    if (!slug) return
    setStatus('loading')
    setActiveImg(0)
    api
      .getProductDetail(slug)
      .then((d) => {
        setData(d)
        setStatus('ok')
      })
      .catch((err) => {
        // Ngoại lệ 1a: sản phẩm không còn khả dụng.
        setStatus(err instanceof ApiError && err.status === 404 ? 'gone' : 'error')
      })
  }, [slug])

  useEffect(() => {
    load()
  }, [load])

  if (status === 'loading') return <Loading />
  if (status === 'error') return <ErrorState onRetry={load} />
  if (status === 'gone') {
    return (
      <div className="mx-auto max-w-3xl px-4 py-16 text-center">
        <div className="text-4xl">🚫</div>
        <h1 className="mt-3 text-xl font-semibold">Sản phẩm không còn khả dụng</h1>
        <p className="mt-1 text-slate-500">Sản phẩm có thể đã được gỡ khỏi hệ thống.</p>
        <Link
          to="/search"
          className="mt-6 inline-block rounded-lg bg-emerald-600 px-4 py-2 text-sm font-medium text-white hover:bg-emerald-700"
        >
          ← Xem sản phẩm khác
        </Link>
      </div>
    )
  }
  if (!data) return null

  const { product, reviews, similar } = data
  const isHomestay = product.type === 'HOMESTAY'
  const images = product.images.length ? product.images : product.thumbnail ? [{ id: 0, url: product.thumbnail, order: 0 }] : []

  return (
    <div className="mx-auto max-w-6xl px-4 py-6">
      <nav className="mb-4 text-sm text-slate-500">
        <Link to="/" className="hover:text-emerald-700">Trang chủ</Link> /{' '}
        {product.category && (
          <>
            <Link to={`/category/${product.category.slug}`} className="hover:text-emerald-700">
              {product.category.name}
            </Link>{' '}
            /{' '}
          </>
        )}
        <span className="text-slate-700">{product.name}</span>
      </nav>

      {/* Thư viện ảnh */}
      {images.length > 0 && (
        <div className="mb-6">
          <div className="aspect-[16/9] overflow-hidden rounded-2xl bg-slate-100">
            <img src={images[activeImg].url} alt={product.name} className="h-full w-full object-cover" />
          </div>
          {images.length > 1 && (
            <div className="mt-2 flex gap-2">
              {images.map((im, i) => (
                <button
                  key={im.id}
                  onClick={() => setActiveImg(i)}
                  className={`h-16 w-24 overflow-hidden rounded-lg border-2 ${
                    i === activeImg ? 'border-emerald-500' : 'border-transparent'
                  }`}
                >
                  <img src={im.url} alt="" className="h-full w-full object-cover" />
                </button>
              ))}
            </div>
          )}
        </div>
      )}

      <div className="gap-8 lg:flex">
        {/* Nội dung chính */}
        <div className="flex-1 space-y-8">
          <div>
            <span className="rounded-full bg-slate-100 px-2 py-0.5 text-xs font-medium text-slate-600">
              {isHomestay ? 'Homestay' : 'Tour'}
            </span>
            <h1 className="mt-2 text-2xl font-bold">{product.name}</h1>
            <p className="mt-1 text-slate-500">
              📍 {product.location} · <span className="text-amber-500">★ {product.rating.toFixed(1)}</span>
              {reviews.length > 0 && <span className="text-slate-400"> ({reviews.length} đánh giá)</span>}
              {!isHomestay && product.durationDays && <span> · {product.durationDays} ngày</span>}
            </p>
          </div>

          {product.description && (
            <section>
              <h2 className="mb-2 text-lg font-semibold">Mô tả</h2>
              <p className="text-slate-600">{product.description}</p>
            </section>
          )}

          {/* Tiện nghi (homestay) */}
          {isHomestay && product.amenities && (
            <section>
              <h2 className="mb-2 text-lg font-semibold">Tiện nghi</h2>
              <div className="flex flex-wrap gap-2">
                {product.amenities.split(',').map((a) => (
                  <span key={a} className="rounded-lg bg-slate-100 px-3 py-1 text-sm text-slate-700">
                    {a.trim()}
                  </span>
                ))}
              </div>
            </section>
          )}

          {/* Lịch trình (tour) */}
          {!isHomestay && product.itinerary && (
            <section>
              <h2 className="mb-2 text-lg font-semibold">Lịch trình</h2>
              <div className="space-y-1 text-slate-600">
                {product.itinerary.split('\n').map((line, i) => (
                  <p key={i}>{line}</p>
                ))}
              </div>
            </section>
          )}

          {/* Chính sách hủy */}
          {product.cancellationPolicy && (
            <section>
              <h2 className="mb-2 text-lg font-semibold">Chính sách hủy</h2>
              <p className="text-sm text-slate-600">{product.cancellationPolicy}</p>
            </section>
          )}

          {/* Đánh giá (BR-08: đã duyệt) */}
          <section>
            <h2 className="mb-3 text-lg font-semibold">Đánh giá của khách</h2>
            {reviews.length === 0 ? (
              <p className="text-sm text-slate-500">Chưa có đánh giá.</p>
            ) : (
              <div className="space-y-3">
                {reviews.map((r) => (
                  <div key={r.id} className="rounded-lg border border-slate-200 p-3">
                    <div className="flex items-center justify-between">
                      <span className="font-medium">{r.authorName}</span>
                      <span className="text-sm text-amber-500">{'★'.repeat(r.rating)}</span>
                    </div>
                    {r.comment && <p className="mt-1 text-sm text-slate-600">{r.comment}</p>}
                  </div>
                ))}
              </div>
            )}
          </section>
        </div>

        {/* Cột kiểm tra tình trạng còn trống */}
        <aside className="mt-6 w-full lg:mt-0 lg:w-80 lg:shrink-0">
          <div className="lg:sticky lg:top-20">
            <AvailabilityChecker product={product} />
          </div>
        </aside>
      </div>

      {/* AF-07: gợi ý tương tự cùng khu vực */}
      {similar.length > 0 && (
        <section className="mt-12">
          <h2 className="mb-4 text-xl font-semibold">Có thể bạn cũng thích</h2>
          <div className="grid grid-cols-2 gap-4 sm:grid-cols-4">
            {similar.map((p) => (
              <ProductCard key={p.id} product={p} />
            ))}
          </div>
        </section>
      )}
    </div>
  )
}
