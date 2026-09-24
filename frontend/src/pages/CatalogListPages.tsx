import { useCallback, useEffect, useState } from 'react'
import { ProductCard } from '../components/ProductCard'
import { ErrorState, Loading } from '../components/StateBlocks'
import { api, type Product } from '../lib/api'

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

  const title = kind === 'HOMESTAY' ? 'Homestay & chỗ nghỉ' : 'Tour du lịch'
  const subtitle =
    kind === 'HOMESTAY'
      ? 'Khám phá các homestay, villa, căn hộ đa dạng trên khắp Việt Nam.'
      : 'Những hành trình trọn gói theo vùng miền và chủ đề yêu thích.'

  const filtered = q.trim()
    ? items.filter((i) => (i.name + ' ' + (i.location ?? '')).toLowerCase().includes(q.trim().toLowerCase()))
    : items

  return (
    <div className="mx-auto max-w-6xl px-4 py-8">
      <div className="mb-6">
        <h1 className="text-2xl font-bold text-slate-900">{title}</h1>
        <p className="mt-1 text-slate-500">{subtitle}</p>
      </div>

      <div className="mb-6">
        <input
          value={q}
          onChange={(e) => setQ(e.target.value)}
          placeholder={kind === 'HOMESTAY' ? 'Tìm theo tên hoặc địa điểm...' : 'Tìm tour theo tên hoặc điểm đến...'}
          className="w-full max-w-md rounded-lg border border-slate-300 px-4 py-2 text-sm focus:border-emerald-500 focus:outline-none"
        />
      </div>

      {status === 'loading' ? (
        <Loading />
      ) : status === 'error' ? (
        <ErrorState onRetry={load} />
      ) : filtered.length === 0 ? (
        <p className="py-16 text-center text-slate-500">Chưa có {kind === 'HOMESTAY' ? 'chỗ nghỉ' : 'tour'} nào phù hợp.</p>
      ) : (
        <>
          <p className="mb-3 text-sm text-slate-500">{filtered.length} kết quả</p>
          <div className="grid grid-cols-2 gap-4 sm:grid-cols-3 lg:grid-cols-4">
            {filtered.map((p) => (
              <ProductCard key={`${p.type}-${p.id}`} product={p} />
            ))}
          </div>
        </>
      )}
    </div>
  )
}

export function HomestayListPage() {
  return <CatalogList kind="HOMESTAY" />
}
export function TourListPage() {
  return <CatalogList kind="TOUR" />
}
