import { useEffect, useMemo, useState } from 'react'
import { Link, useNavigate, useParams } from 'react-router-dom'
import { FavoriteButton } from '../components/FavoriteButton'
import { ProductCard } from '../components/ProductCard'
import { ErrorState, Loading } from '../components/StateBlocks'
import { ApiError, api, formatPrice, type PropertyDetailResponse } from '../lib/api'

const POLICY_LABEL: Record<string, string> = { HOUSE_RULE: 'Nội quy', NOTE: 'Ghi chú', FAQ: 'Câu hỏi thường gặp' }

function todayPlus(n: number) {
  const d = new Date()
  d.setDate(d.getDate() + n)
  return d.toISOString().slice(0, 10)
}

// UC-03 – Chi tiết chỗ nghỉ (Property): thư viện ảnh, loại phòng, tiện nghi, nội quy, đánh giá.
export function ProductDetailPage() {
  const { slug } = useParams<{ slug: string }>()
  const navigate = useNavigate()
  const [data, setData] = useState<PropertyDetailResponse | null>(null)
  const [status, setStatus] = useState<'loading' | 'ok' | 'error' | 'gone'>('loading')
  const [rtId, setRtId] = useState<number | null>(null)
  const [from, setFrom] = useState(todayPlus(1))
  const [to, setTo] = useState(todayPlus(3))
  const [guests, setGuests] = useState(2)

  useEffect(() => {
    if (!slug) return
    setStatus('loading')
    api
      .getPropertyDetail(slug)
      .then((d) => {
        setData(d)
        setRtId(d.property.roomTypes[0]?.id ?? null)
        setStatus('ok')
      })
      .catch((err) => setStatus(err instanceof ApiError && err.status === 404 ? 'gone' : 'error'))
  }, [slug])

  const property = data?.property
  const rt = useMemo(() => property?.roomTypes.find((r) => r.id === rtId) ?? null, [property, rtId])
  const nights = Math.max(0, Math.round((new Date(to).getTime() - new Date(from).getTime()) / 86400000))
  const tentative = rt ? rt.basePricePerNight * nights : 0

  function book() {
    if (!rt || !slug || nights <= 0) return
    navigate(`/booking/${slug}?from=${from}&to=${to}&guests=${guests}&roomTypeId=${rt.id}`)
  }

  if (status === 'loading') return <Loading />
  if (status === 'error') return <ErrorState onRetry={() => location.reload()} />
  if (status === 'gone' || !property) {
    return (
      <div className="mx-auto max-w-3xl px-4 py-16 text-center">
        <div className="text-4xl">🚫</div>
        <h1 className="mt-3 text-xl font-semibold">Chỗ nghỉ không còn khả dụng</h1>
        <Link to="/search" className="mt-6 inline-block rounded-lg bg-emerald-600 px-4 py-2 text-sm font-medium text-white hover:bg-emerald-700">← Xem chỗ nghỉ khác</Link>
      </div>
    )
  }

  const cover = property.images.find((i) => i.isCover)?.url || property.images[0]?.url || property.thumbnail
  const gallery = property.images.slice(0, 5)

  return (
    <div className="mx-auto max-w-6xl px-4 py-6">
      <nav className="mb-3 text-sm text-slate-500">
        <Link to="/" className="hover:text-emerald-700">Trang chủ</Link> / <Link to="/search?type=HOMESTAY" className="hover:text-emerald-700">Chỗ nghỉ</Link> / {property.name}
      </nav>

      <div className="grid grid-cols-4 gap-2 overflow-hidden rounded-2xl">
        <div className="relative col-span-4 aspect-[16/7] bg-slate-100 sm:col-span-2 sm:row-span-2 sm:aspect-auto">
          {cover && <img src={cover} alt={property.name} className="h-full w-full object-cover" />}
          <FavoriteButton productId={property.id} className="absolute right-3 top-3" />
        </div>
        {gallery.slice(1, 5).map((img) => (
          <div key={img.id} className="hidden aspect-[4/3] bg-slate-100 sm:block">
            <img src={img.url} alt={img.caption || ''} className="h-full w-full object-cover" />
          </div>
        ))}
      </div>

      <div className="mt-6 gap-8 lg:flex">
        <div className="min-w-0 flex-1">
          <div className="flex flex-wrap items-center gap-2">
            {property.province && <span className="rounded-full bg-emerald-50 px-2 py-0.5 text-xs font-medium text-emerald-700">{property.province.name}</span>}
            {property.area && <span className="rounded-full bg-blue-50 px-2 py-0.5 text-xs font-medium text-blue-700">{property.area.name}</span>}
            <span className="rounded-full bg-slate-100 px-2 py-0.5 text-xs text-slate-600">{property.propertyType}</span>
            {property.starRating ? <span className="text-xs text-amber-500">{'★'.repeat(property.starRating)}</span> : null}
          </div>
          <h1 className="mt-2 text-2xl font-bold text-slate-900">{property.name}</h1>
          <div className="mt-1 flex items-center gap-3 text-sm text-slate-500">
            <span className="text-amber-500">★ {property.avgRating.toFixed(1)}</span>
            <span>({property.reviewCount} đánh giá)</span>
            {property.address && <span>📍 {property.address}</span>}
          </div>
          {property.shortDescription && <p className="mt-3 text-slate-600">{property.shortDescription}</p>}

          <div className="mt-3 flex flex-wrap gap-4 text-sm text-slate-600">
            {property.checkInTime && <span>Nhận phòng: <b>{property.checkInTime}</b></span>}
            {property.checkOutTime && <span>Trả phòng: <b>{property.checkOutTime}</b></span>}
            {property.contactPhone && <span>☎ {property.contactPhone}</span>}
          </div>

          {property.amenities.length > 0 && (
            <Section title="Tiện nghi">
              <div className="flex flex-wrap gap-2">
                {property.amenities.map((a) => <span key={a.id} className="rounded-lg border border-slate-200 px-3 py-1 text-sm text-slate-700">{a.name}</span>)}
              </div>
            </Section>
          )}

          {property.description && (
            <Section title="Giới thiệu"><p className="whitespace-pre-line text-sm text-slate-700">{property.description}</p></Section>
          )}

          <Section title="Các loại phòng">
            <div className="space-y-3">
              {property.roomTypes.map((r) => (
                <label key={r.id} className={`block cursor-pointer rounded-xl border p-4 ${rtId === r.id ? 'border-emerald-500 ring-1 ring-emerald-500' : 'border-slate-200'}`}>
                  <div className="flex items-start justify-between gap-3">
                    <div>
                      <div className="flex items-center gap-2">
                        <input type="radio" checked={rtId === r.id} onChange={() => setRtId(r.id)} />
                        <span className="font-semibold text-slate-800">{r.name}</span>
                      </div>
                      <div className="mt-1 flex flex-wrap gap-3 text-xs text-slate-500">
                        {r.bedType && <span>🛏 {r.bedType}</span>}
                        <span>👥 Tối đa {r.maxOccupancy} khách</span>
                        {r.roomSize && <span>📐 {r.roomSize}m²</span>}
                        {r.breakfastIncluded && <span className="text-emerald-600">✓ Kèm bữa sáng</span>}
                      </div>
                      {r.description && <p className="mt-1 text-sm text-slate-600">{r.description}</p>}
                    </div>
                    <div className="shrink-0 text-right">
                      <div className="font-semibold text-emerald-600">{formatPrice(r.basePricePerNight)}</div>
                      <div className="text-xs text-slate-400">/đêm</div>
                    </div>
                  </div>
                </label>
              ))}
            </div>
          </Section>

          {property.cancellationPolicy && (
            <Section title={`Chính sách hủy — ${property.cancellationPolicy.name}`}>
              <ul className="space-y-1 text-sm text-slate-700">
                {property.cancellationPolicy.freeHours > 0 && <li>• Miễn phí hủy trong {property.cancellationPolicy.freeHours} giờ đầu sau khi đặt.</li>}
                {property.cancellationPolicy.milestones.map((m, i) => <li key={i}>• Hủy trước ≥ {m.daysBefore} ngày: hoàn {m.refundRate}%.</li>)}
                <li>• Hủy sát ngày hơn: không hoàn tiền.</li>
              </ul>
            </Section>
          )}

          {property.policies.length > 0 &&
            property.policies.map((p) => (
              <Section key={p.id} title={p.title || POLICY_LABEL[p.type] || 'Nội quy'}>
                <p className="whitespace-pre-line text-sm text-slate-600">{p.content}</p>
              </Section>
            ))}

          <Section title={`Đánh giá (${data?.reviews.length ?? 0})`}>
            {data && data.reviews.length > 0 ? (
              <div className="space-y-3">
                {data.reviews.map((r) => (
                  <div key={r.id} className="rounded-lg border border-slate-200 p-3">
                    <div className="flex items-center justify-between">
                      <span className="font-medium text-slate-800">{r.authorName}</span>
                      <span className="text-amber-500">{'★'.repeat(r.rating)}</span>
                    </div>
                    {r.comment && <p className="mt-1 text-sm text-slate-600">{r.comment}</p>}
                    {r.images && r.images.length > 0 && (
                      <div className="mt-2 flex flex-wrap gap-2">
                        {r.images.map((im) => (
                          <a key={im.id} href={im.url} target="_blank" rel="noreferrer" className="block h-20 w-20 overflow-hidden rounded-lg border border-slate-200">
                            <img src={im.url} alt="" className="h-full w-full object-cover transition hover:scale-105" />
                          </a>
                        ))}
                      </div>
                    )}
                  </div>
                ))}
              </div>
            ) : (
              <p className="text-sm text-slate-500">Chưa có đánh giá.</p>
            )}
          </Section>
        </div>

        <aside className="mt-6 w-full lg:mt-0 lg:w-80 lg:shrink-0">
          <div className="sticky top-4 rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
            <p className="text-sm text-slate-500">Chỉ từ</p>
            <p className="text-2xl font-bold text-emerald-600">{formatPrice(property.basePrice)}<span className="text-sm font-normal text-slate-400">/đêm</span></p>

            <div className="mt-4 grid grid-cols-2 gap-2">
              <label className="text-xs text-slate-500">Nhận phòng
                <input type="date" value={from} onChange={(e) => setFrom(e.target.value)} className="mt-1 w-full rounded-lg border border-slate-300 px-2 py-2 text-sm" />
              </label>
              <label className="text-xs text-slate-500">Trả phòng
                <input type="date" value={to} onChange={(e) => setTo(e.target.value)} className="mt-1 w-full rounded-lg border border-slate-300 px-2 py-2 text-sm" />
              </label>
            </div>
            <label className="mt-2 block text-xs text-slate-500">Số khách
              <input type="number" min={1} value={guests} onChange={(e) => setGuests(Math.max(1, Number(e.target.value)))} className="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2 text-sm" />
            </label>

            {rt && nights > 0 && (
              <div className="mt-3 space-y-1 border-t border-slate-100 pt-3 text-sm">
                <Row label={rt.name} value="" />
                <Row label={`${formatPrice(rt.basePricePerNight)} × ${nights} đêm`} value={formatPrice(tentative)} strong />
              </div>
            )}
            {nights <= 0 && <p className="mt-2 text-xs text-red-600">Ngày trả phòng phải sau ngày nhận phòng.</p>}

            <button onClick={book} disabled={!rt || nights <= 0} className="mt-4 w-full rounded-lg bg-emerald-600 px-4 py-3 font-semibold text-white hover:bg-emerald-700 disabled:opacity-50">
              Đặt phòng
            </button>
          </div>
        </aside>
      </div>

      {data && data.similar.length > 0 && (
        <div className="mt-10">
          <h2 className="mb-3 text-lg font-bold text-slate-900">Chỗ nghỉ tương tự</h2>
          <div className="grid grid-cols-2 gap-4 md:grid-cols-4">{data.similar.map((p) => <ProductCard key={`${p.type}-${p.id}`} product={p} />)}</div>
        </div>
      )}
    </div>
  )
}

function Section({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <section className="mt-6">
      <h2 className="mb-2 text-lg font-bold text-slate-900">{title}</h2>
      {children}
    </section>
  )
}
function Row({ label, value, strong }: { label: string; value: string; strong?: boolean }) {
  return (
    <div className="flex items-center justify-between">
      <span className="text-slate-500">{label}</span>
      <span className={strong ? 'font-bold text-emerald-700' : 'text-slate-800'}>{value}</span>
    </div>
  )
}
