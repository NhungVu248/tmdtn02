import { useCallback, useEffect, useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import { ErrorState, Loading } from '../components/StateBlocks'
import { ApiError, api, formatPrice, type GuideDetail, type GuideSummary } from '../lib/api'

function formatDate(d: string | null) {
  return d ? new Date(d).toLocaleDateString('vi-VN', { day: '2-digit', month: '2-digit', year: 'numeric' }) : ''
}

// Danh sách cẩm nang du lịch (công khai).
export function GuideListPage() {
  const [items, setItems] = useState<GuideSummary[]>([])
  const [status, setStatus] = useState<'loading' | 'ok' | 'error'>('loading')

  const load = useCallback(() => {
    setStatus('loading')
    api.getGuides().then((d) => { setItems(d.items); setStatus('ok') }).catch(() => setStatus('error'))
  }, [])
  useEffect(() => { load() }, [load])

  if (status === 'loading') return <Loading />
  if (status === 'error') return <ErrorState onRetry={load} />

  return (
    <div className="mx-auto max-w-6xl px-4 py-8">
      <div className="mb-6">
        <h1 className="text-2xl font-bold text-slate-900">Cẩm nang du lịch</h1>
        <p className="mt-1 text-slate-500">Kinh nghiệm, gợi ý điểm đến và mẹo cho hành trình của bạn.</p>
      </div>

      {items.length === 0 ? (
        <p className="py-16 text-center text-slate-500">Chưa có bài cẩm nang nào.</p>
      ) : (
        <div className="grid gap-5 sm:grid-cols-2 lg:grid-cols-3">
          {items.map((g) => (
            <Link
              key={g.id}
              to={`/guides/${g.slug}`}
              className="group flex flex-col overflow-hidden rounded-xl border border-slate-200 bg-white transition hover:shadow-md"
            >
              <div className="aspect-[16/9] overflow-hidden bg-slate-100">
                {g.coverImage && <img src={g.coverImage} alt={g.title} loading="lazy" className="h-full w-full object-cover transition duration-300 group-hover:scale-105" />}
              </div>
              <div className="flex flex-1 flex-col p-4">
                {g.locationName && <span className="mb-1 text-xs font-medium text-emerald-600">📍 {g.locationName}</span>}
                <h3 className="line-clamp-2 font-semibold text-slate-900">{g.title}</h3>
                {g.excerpt && <p className="mt-1 line-clamp-2 text-sm text-slate-500">{g.excerpt}</p>}
                <div className="mt-3 flex items-center gap-2 text-xs text-slate-400">
                  {g.authorName && <span>✍️ {g.authorName}</span>}
                  {g.publishedAt && <span>· {formatDate(g.publishedAt)}</span>}
                </div>
              </div>
            </Link>
          ))}
        </div>
      )}
    </div>
  )
}

// Chi tiết một bài cẩm nang: nội dung + bản đồ địa điểm + tour liên quan.
export function GuideDetailPage() {
  const { slug } = useParams<{ slug: string }>()
  const [guide, setGuide] = useState<GuideDetail | null>(null)
  const [status, setStatus] = useState<'loading' | 'ok' | 'error' | 'notfound'>('loading')

  const load = useCallback(() => {
    if (!slug) return
    setStatus('loading')
    api.getGuide(slug)
      .then((d) => { setGuide(d.guide); setStatus('ok') })
      .catch((err) => setStatus(err instanceof ApiError && err.status === 404 ? 'notfound' : 'error'))
  }, [slug])
  useEffect(() => { load() }, [load])

  if (status === 'loading') return <Loading />
  if (status === 'error') return <ErrorState onRetry={load} />
  if (status === 'notfound') {
    return (
      <div className="mx-auto max-w-3xl px-4 py-16 text-center">
        <div className="text-4xl">📄</div>
        <h1 className="mt-3 text-xl font-semibold">Không tìm thấy bài cẩm nang</h1>
        <Link to="/guides" className="mt-6 inline-block rounded-lg bg-emerald-600 px-4 py-2 text-sm font-medium text-white hover:bg-emerald-700">← Xem cẩm nang du lịch</Link>
      </div>
    )
  }
  if (!guide) return null

  const hasMap = guide.latitude != null && guide.longitude != null
  const lat = guide.latitude ?? 0
  const lon = guide.longitude ?? 0
  const d = 0.02
  const bbox = `${lon - d}%2C${lat - d}%2C${lon + d}%2C${lat + d}`
  const mapSrc = `https://www.openstreetmap.org/export/embed.html?bbox=${bbox}&layer=mapnik&marker=${lat}%2C${lon}`

  return (
    <div className="mx-auto max-w-3xl px-4 py-8">
      <nav className="mb-4 text-sm text-slate-500">
        <Link to="/" className="hover:text-emerald-700">Trang chủ</Link> /{' '}
        <Link to="/guides" className="hover:text-emerald-700">Cẩm nang du lịch</Link> /{' '}
        <span className="text-slate-700">{guide.title}</span>
      </nav>

      <article>
        <h1 className="text-2xl font-bold text-slate-900 sm:text-3xl">{guide.title}</h1>
        <div className="mt-2 flex flex-wrap items-center gap-2 text-sm text-slate-400">
          {guide.authorName && <span>✍️ {guide.authorName}</span>}
          {guide.publishedAt && <span>· {formatDate(guide.publishedAt)}</span>}
          {guide.locationName && <span>· 📍 {guide.locationName}</span>}
        </div>

        {guide.coverImage && (
          <img src={guide.coverImage} alt={guide.title} className="mt-5 aspect-[16/9] w-full rounded-xl object-cover" />
        )}

        <div className="mt-6 space-y-4 leading-relaxed text-slate-700">
          {guide.content.split('\n').filter((p) => p.trim()).map((para, i) => (
            <p key={i}>{para}</p>
          ))}
        </div>

        {hasMap && (
          <div className="mt-8">
            <h2 className="mb-2 text-lg font-semibold text-slate-800">📍 Địa điểm{guide.locationName ? `: ${guide.locationName}` : ''}</h2>
            <div className="overflow-hidden rounded-xl border border-slate-200">
              <iframe title="Bản đồ địa điểm" src={mapSrc} className="h-72 w-full" loading="lazy" />
            </div>
            <a
              href={`https://www.openstreetmap.org/?mlat=${lat}&mlon=${lon}#map=13/${lat}/${lon}`}
              target="_blank"
              rel="noreferrer"
              className="mt-1 inline-block text-sm text-emerald-700 hover:underline"
            >
              Mở bản đồ lớn hơn ↗
            </a>
          </div>
        )}

        {guide.relatedTours.length > 0 && (
          <div className="mt-10">
            <h2 className="mb-3 text-lg font-semibold text-slate-800">Tour liên quan</h2>
            <div className="grid gap-4 sm:grid-cols-2">
              {guide.relatedTours.map((t) => (
                <Link key={t.id} to={`/tour/${t.slug}`} className="group flex gap-3 rounded-xl border border-slate-200 bg-white p-3 transition hover:shadow-md">
                  <div className="h-20 w-24 shrink-0 overflow-hidden rounded-lg bg-slate-100">
                    {t.thumbnail && <img src={t.thumbnail} alt={t.title} className="h-full w-full object-cover transition group-hover:scale-105" />}
                  </div>
                  <div className="min-w-0">
                    <h3 className="line-clamp-2 text-sm font-semibold text-slate-900">{t.title}</h3>
                    <p className="mt-1 text-xs text-slate-500">{t.durationDays}N{t.durationNights}Đ · ★ {t.avgRating.toFixed(1)}</p>
                    <p className="mt-1 text-sm font-semibold text-emerald-600">{formatPrice(t.basePrice)}<span className="text-xs font-normal text-slate-400">/khách</span></p>
                  </div>
                </Link>
              ))}
            </div>
          </div>
        )}
      </article>
    </div>
  )
}
