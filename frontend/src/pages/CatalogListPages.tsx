import { useCallback, useEffect, useState } from 'react'
import { ProductCard } from '../components/ProductCard'
import { HomestaySearchBar } from '../components/HomestaySearchBar'
import { ErrorState, Loading } from '../components/StateBlocks'
import { api, type Product } from '../lib/api'

// Ảnh banner theo loại danh mục.
const BANNER: Record<'HOMESTAY' | 'TOUR', string> = {
  HOMESTAY: 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1600&q=75',
  TOUR: 'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1600&q=75',
}

function CatalogList({ kind }: { kind: 'HOMESTAY' | 'TOUR' }) {
  const [items, setItems] = useState<Product[]>([])
  const [status, setStatus] = useState<'loading' | 'ok' | 'error'>('loading')
  const [q, setQ] = useState('')

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
  const heading = isHomestay
    ? 'Điểm đến tiếp theo của bạn? Đặt homestay giá tốt với StayTour'
    : 'Chọn hành trình, để chúng tôi lo phần còn lại'
  const bannerSub = isHomestay
    ? 'Khám phá nhiều lựa chọn từ homestay, villa, căn hộ đến resort và hơn thế nữa.'
    : 'Những tour trọn gói theo vùng miền và chủ đề yêu thích của bạn.'
  const subtitle = isHomestay
    ? 'Khám phá các homestay, villa, căn hộ đa dạng trên khắp Việt Nam.'
    : 'Những hành trình trọn gói theo vùng miền và chủ đề yêu thích.'

  const filtered = q.trim()
    ? items.filter((i) => (i.name + ' ' + (i.location ?? '')).toLowerCase().includes(q.trim().toLowerCase()))
    : items

  return (
    <div>
      {/* ── Banner (phong cách Traveloka) ── */}
      <section className="relative">
        <div className="relative overflow-hidden">
          <img src={BANNER[kind]} alt="" className="absolute inset-0 h-full w-full object-cover" />
          <div className="absolute inset-0 bg-gradient-to-r from-forest-900/85 via-forest-900/55 to-forest-900/25" />
          <div className={`relative mx-auto max-w-7xl px-6 pt-16 ${isHomestay ? 'pb-32 sm:pb-36' : 'pb-16'}`}>
            <p className="mb-3 text-xs font-medium uppercase tracking-[0.25em] text-cream-200">
              {isHomestay ? 'Homestay · Villa · Căn hộ' : 'Tour trọn gói'}
            </p>
            <h1 className="max-w-2xl font-display text-4xl font-semibold leading-tight text-cream-50 sm:text-5xl">
              {heading}
            </h1>
            <p className="mt-4 max-w-xl text-cream-100">{bannerSub}</p>
          </div>
        </div>

        {/* Thanh tìm kiếm nổi đè lên banner (chỉ homestay) */}
        {isHomestay && (
          <div className="relative mx-auto -mt-24 max-w-6xl px-6">
            <HomestaySearchBar />
          </div>
        )}
      </section>

      <div className="mx-auto max-w-7xl px-6 py-12">
        <div className="mb-6">
          <h2 className="font-display text-3xl font-semibold text-forest-900">{title}</h2>
          <p className="mt-1 text-forest-400">{subtitle}</p>
        </div>

        <div className="mb-6">
          <input
            value={q}
            onChange={(e) => setQ(e.target.value)}
            placeholder={isHomestay ? 'Lọc nhanh theo tên hoặc địa điểm...' : 'Tìm tour theo tên hoặc điểm đến...'}
            className="w-full max-w-md rounded-full border border-cream-300 bg-white px-5 py-2.5 text-sm text-forest-900 placeholder:text-forest-300 focus:border-forest-400 focus:outline-none"
          />
        </div>

        {status === 'loading' ? (
          <Loading />
        ) : status === 'error' ? (
          <ErrorState onRetry={load} />
        ) : filtered.length === 0 ? (
          <p className="py-16 text-center text-forest-400">Chưa có {isHomestay ? 'chỗ nghỉ' : 'tour'} nào phù hợp.</p>
        ) : (
          <>
            <p className="mb-4 text-sm text-forest-500">
              <span className="font-semibold text-forest-800">{filtered.length}</span> kết quả
            </p>
            <div className="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-4">
              {filtered.map((p) => (
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
