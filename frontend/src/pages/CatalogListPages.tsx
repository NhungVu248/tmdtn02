import { useCallback, useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { ProductCard } from '../components/ProductCard'
import { HomestaySearchBar } from '../components/HomestaySearchBar'
import { ErrorState, Loading } from '../components/StateBlocks'
import { api, type Product } from '../lib/api'

// Ảnh banner theo loại danh mục.
const BANNER: Record<'HOMESTAY' | 'TOUR', string> = {
  HOMESTAY: 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1600&q=75',
  TOUR: 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1600&q=75',
}

function CatalogList({ kind }: { kind: 'HOMESTAY' | 'TOUR' }) {
  const navigate = useNavigate()
  const [items, setItems] = useState<Product[]>([])
  const [status, setStatus] = useState<'loading' | 'ok' | 'error'>('loading')
  const [idea, setIdea] = useState('') // ô tìm kiếm ý tưởng (trang tour)

  const load = useCallback(() => {
    setStatus('loading')
    const p =
      kind === 'HOMESTAY'
        ? api.getProducts({ type: 'HOMESTAY' }).then((d) => d.items)
        : api.getTours(new URLSearchParams()).then((d) => d.items)
    p.then((list) => { setItems(list); setStatus('ok') }).catch(() => setStatus('error'))
  }, [kind])

  useEffect(() => { load() }, [load])

  const isHomestay = kind === 'HOMESTAY'
  const title = isHomestay ? 'Homestay & chỗ nghỉ' : 'Tour du lịch'
  const subtitle = isHomestay
    ? 'Khám phá các homestay, villa, căn hộ đa dạng trên khắp Việt Nam.'
    : 'Những hành trình trọn gói theo vùng miền và chủ đề yêu thích.'

  function submitIdea(e: React.FormEvent) {
    e.preventDefault()
    const qs = new URLSearchParams({ type: 'TOUR' })
    if (idea.trim()) qs.set('destination', idea.trim())
    navigate(`/search?${qs.toString()}`)
  }

  return (
    <div>
      {isHomestay ? (
        /* ── Banner Homestay (ảnh phủ toàn chiều rộng + thanh tìm kiếm chi tiết) ── */
        <section className="relative">
          <div className="relative overflow-hidden">
            <img src={BANNER.HOMESTAY} alt="" className="absolute inset-0 h-full w-full object-cover" />
            <div className="absolute inset-0 bg-gradient-to-r from-forest-900/85 via-forest-900/55 to-forest-900/25" />
            <div className="relative mx-auto max-w-7xl px-6 pt-16 pb-32 sm:pb-36">
              <p className="mb-3 text-xs font-medium uppercase tracking-[0.25em] text-cream-200">
                Homestay · Villa · Căn hộ
              </p>
              <h1 className="max-w-2xl font-display text-4xl font-semibold leading-tight text-cream-50 sm:text-5xl">
                Điểm đến tiếp theo của bạn? Đặt homestay giá tốt với StayTour
              </h1>
              <p className="mt-4 max-w-xl text-cream-100">
                Khám phá nhiều lựa chọn từ homestay, villa, căn hộ đến resort và hơn thế nữa.
              </p>
            </div>
          </div>
          <div className="relative mx-auto -mt-24 max-w-6xl px-6">
            <HomestaySearchBar />
          </div>
        </section>
      ) : (
        /* ── Banner Tour (tiêu đề trên + ảnh lớn bo góc + ô tìm kiếm ý tưởng nổi giữa đáy) ── */
        <section className="mx-auto max-w-7xl px-6 pt-8">
          <h1 className="font-display text-4xl font-semibold text-forest-900">Tour</h1>
          <div className="relative mt-4">
            <div className="relative h-64 overflow-hidden rounded-3xl sm:h-80 lg:h-96">
              <img src={BANNER.TOUR} alt="" className="absolute inset-0 h-full w-full object-cover" />
              <div className="absolute inset-0 bg-gradient-to-t from-forest-900/70 via-forest-900/15 to-transparent" />
              <div className="absolute left-8 top-8 max-w-lg">
                <p className="mb-2 text-xs font-medium uppercase tracking-[0.25em] text-cream-200">Tour trọn gói</p>
                <h2 className="font-display text-3xl font-semibold leading-tight text-cream-50 sm:text-4xl">
                  Bắt đầu hành trình mơ ước của bạn
                </h2>
              </div>
            </div>

            {/* Ô tìm kiếm ý tưởng nổi giữa đáy banner */}
            <form
              onSubmit={submitIdea}
              className="absolute -bottom-7 left-1/2 flex w-[92%] max-w-3xl -translate-x-1/2 items-center gap-2 rounded-2xl bg-white p-2 shadow-2xl shadow-forest-900/20 ring-1 ring-cream-200"
            >
              <span className="pl-3 text-lg text-clay-500">🔍</span>
              <input
                value={idea}
                onChange={(e) => setIdea(e.target.value)}
                placeholder="Bạn có ý tưởng gì cho chuyến đi tiếp theo không?"
                className="min-w-0 flex-1 bg-transparent px-2 py-2.5 text-sm text-forest-900 placeholder:text-forest-300 focus:outline-none"
              />
              <button
                type="submit"
                className="shrink-0 rounded-xl bg-clay-500 px-6 py-2.5 text-sm font-semibold text-white transition hover:bg-clay-600"
              >
                Tìm kiếm
              </button>
            </form>
          </div>
        </section>
      )}

      <div className={`mx-auto max-w-7xl px-6 pb-12 ${isHomestay ? 'pt-12' : 'pt-16'}`}>
        <div className="mb-6">
          <h2 className="font-display text-3xl font-semibold text-forest-900">{title}</h2>
          <p className="mt-1 text-forest-400">{subtitle}</p>
        </div>

        {status === 'loading' ? (
          <Loading />
        ) : status === 'error' ? (
          <ErrorState onRetry={load} />
        ) : items.length === 0 ? (
          <p className="py-16 text-center text-forest-400">Chưa có {isHomestay ? 'chỗ nghỉ' : 'tour'} nào phù hợp.</p>
        ) : (
          <>
            <p className="mb-4 text-sm text-forest-500">
              <span className="font-semibold text-forest-800">{items.length}</span> kết quả
            </p>
            <div className="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-4">
              {items.map((p) => (
                <ProductCard key={`${p.type}-${p.id}`} product={p} />
              ))}
            </div>
          </>
        )}
      </div>
    </div>
  )
}

export function HomestayListPage() {
  return <CatalogList kind="HOMESTAY" />
}
export function TourListPage() {
  return <CatalogList kind="TOUR" />
}
