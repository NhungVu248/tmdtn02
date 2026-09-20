import { useCallback, useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { DualSearchBar } from '../components/DualSearchBar'
import { ProductCard } from '../components/ProductCard'
import { ErrorState, Loading } from '../components/StateBlocks'
import { api, type HomeData } from '../lib/api'

export function HomePage() {
  const [data, setData] = useState<HomeData | null>(null)
  const [status, setStatus] = useState<'loading' | 'ok' | 'error'>('loading')

  const load = useCallback(() => {
    setStatus('loading')
    api
      .getHome()
      .then((d) => {
        setData(d)
        setStatus('ok')
      })
      .catch(() => setStatus('error'))
  }, [])

  useEffect(() => {
    load()
  }, [load])

  return (
    <div>
      {/* Banner + thanh tìm kiếm kép */}
      <section className="relative overflow-hidden bg-slate-800">
        <img
          src="https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?auto=format&fit=crop&w=1600&q=70"
          alt=""
          className="absolute inset-0 h-full w-full object-cover opacity-60"
        />
        <div className="relative mx-auto max-w-6xl px-4 py-16">
          <h1 className="max-w-xl text-3xl font-bold text-white sm:text-4xl">
            Khám phá homestay & tour khắp Việt Nam
          </h1>
          <p className="mt-2 max-w-xl text-white/80">
            Đặt phòng homestay và tour du lịch dễ dàng, giá tốt.
          </p>
          <div className="mt-6 max-w-3xl">
            <DualSearchBar />
          </div>
        </div>
      </section>

      {status === 'loading' && <Loading />}
      {status === 'error' && (
        <ErrorState message="Không thể tải nội dung trang chủ." onRetry={load} />
      )}

      {status === 'ok' && data && (
        <div className="mx-auto max-w-6xl space-y-12 px-4 py-10">
          {/* Khuyến mại đang chạy */}
          {data.promotions.length > 0 && (
            <section>
              <h2 className="mb-4 text-xl font-semibold">Khuyến mại đang chạy</h2>
              <div className="grid gap-4 sm:grid-cols-2">
                {data.promotions.map((p) => (
                  <div
                    key={p.id}
                    className="relative overflow-hidden rounded-xl border border-slate-200 bg-white"
                  >
                    {p.image && (
                      <img src={p.image} alt="" className="h-32 w-full object-cover" />
                    )}
                    <div className="p-4">
                      <h3 className="font-semibold text-emerald-700">{p.title}</h3>
                      {p.description && (
                        <p className="mt-1 text-sm text-slate-500">{p.description}</p>
                      )}
                    </div>
                  </div>
                ))}
              </div>
            </section>
          )}

          {/* Sản phẩm nổi bật */}
          <section>
            <h2 className="mb-4 text-xl font-semibold">Homestay & tour nổi bật</h2>
            <div className="grid grid-cols-2 gap-4 sm:grid-cols-3 lg:grid-cols-4">
              {data.featured.map((p) => (
                <ProductCard key={p.id} product={p} />
              ))}
            </div>
          </section>

          {/* Khu vực du lịch phổ biến */}
          {data.areas.length > 0 && (
            <section>
              <h2 className="mb-4 text-xl font-semibold">Khu vực du lịch phổ biến</h2>
              <div className="grid grid-cols-2 gap-4 sm:grid-cols-4">
                {data.areas.map((a) => (
                  <Link
                    key={a.id}
                    to={`/search?destination=${encodeURIComponent(a.name)}`}
                    className="group relative aspect-[3/2] overflow-hidden rounded-xl"
                  >
                    {a.image && (
                      <img
                        src={a.image}
                        alt={a.name}
                        className="h-full w-full object-cover transition group-hover:scale-105"
                      />
                    )}
                    <div className="absolute inset-0 bg-black/30" />
                    <span className="absolute bottom-2 left-3 font-semibold text-white">
                      {a.name}
                    </span>
                  </Link>
                ))}
              </div>
            </section>
          )}
        </div>
      )}
    </div>
  )
}
