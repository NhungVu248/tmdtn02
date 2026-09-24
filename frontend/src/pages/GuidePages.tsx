import { useCallback, useEffect, useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import { ErrorState, Loading } from '../components/StateBlocks'
import { ApiError, api, formatPrice, type GuideDetail, type GuideSummary } from '../lib/api'

function formatDate(d: string | null) {
  return d ? new Date(d).toLocaleDateString('vi-VN', { day: '2-digit', month: '2-digit', year: 'numeric' }) : ''
}

// Danh sách cẩm nang du lịch (công khai) — bố cục tạp chí: bài nổi bật + lưới bài viết.
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

  const [featured, ...rest] = items

  return (
    <div>
      {/* Banner đầu trang */}
      <section className="border-b border-cream-200 bg-gradient-to-b from-forest-50 to-cream-50">
        <div className="mx-auto max-w-6xl px-6 py-14 text-center">
          <p className="text-sm font-medium uppercase tracking-[0.25em] text-clay-500">StayTour Blog</p>
          <h1 className="mt-3 font-display text-5xl font-semibold text-forest-900">Cẩm nang du lịch</h1>
          <p className="mx-auto mt-3 max-w-xl text-forest-400">
            Kinh nghiệm, gợi ý điểm đến và mẹo hữu ích cho hành trình tiếp theo của bạn.
          </p>
        </div>
      </section>

      <div className="mx-auto max-w-6xl px-6 py-12">
        {items.length === 0 ? (
          <div className="flex flex-col items-center justify-center rounded-3xl border border-cream-200 bg-white py-20 text-center">
            <div className="text-4xl">📖</div>
            <p className="mt-3 font-display text-xl font-medium text-forest-800">Chưa có bài cẩm nang nào</p>
            <p className="mt-1 text-sm text-forest-400">Hãy quay lại sau để đọc những chia sẻ mới nhất.</p>
          </div>
        ) : (
          <>
            {/* Bài nổi bật */}
            <Link
              to={`/guides/${featured.slug}`}
              className="group mb-12 grid overflow-hidden rounded-3xl border border-cream-200 bg-white transition hover:shadow-xl hover:shadow-forest-900/10 md:grid-cols-2"
            >
              <div className="aspect-[16/10] overflow-hidden bg-cream-100 md:aspect-auto">
                {featured.coverImage && (
                  <img src={featured.coverImage} alt={featured.title} className="h-full w-full object-cover transition duration-500 group-hover:scale-105" />
                )}
              </div>
              <div className="flex flex-col justify-center p-8">
                <span className="mb-3 inline-flex w-fit items-center rounded-full bg-clay-500/10 px-3 py-1 text-xs font-medium text-clay-600">
                  ★ Bài nổi bật
                </span>
                {featured.locationName && (
                  <span className="mb-2 text-sm font-medium text-forest-500">📍 {featured.locationName}</span>
                )}
                <h2 className="font-display text-3xl font-semibold leading-snug text-forest-900 group-hover:text-forest-700">
                  {featured.title}
                </h2>
                {featured.excerpt && <p className="mt-3 line-clamp-3 text-forest-500">{featured.excerpt}</p>}
                <div className="mt-5 flex items-center gap-2 text-sm text-forest-400">
                  {featured.authorName && <span>✍️ {featured.authorName}</span>}
                  {featured.publishedAt && <span>· {formatDate(featured.publishedAt)}</span>}
                </div>
                <span className="mt-4 text-sm font-medium text-clay-600">Đọc bài viết →</span>
              </div>
            </Link>

            {/* Các bài còn lại */}
            {rest.length > 0 && (
              <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
                {rest.map((g) => (
                  <Link
                    key={g.id}
                    to={`/guides/${g.slug}`}
                    className="group flex flex-col overflow-hidden rounded-2xl border border-cream-200 bg-white transition duration-300 hover:-translate-y-1 hover:shadow-lg hover:shadow-forest-900/10"
                  >
                    <div className="aspect-[16/9] overflow-hidden bg-cream-100">
                      {g.coverImage && (
                        <img src={g.coverImage} alt={g.title} loading="lazy" className="h-full w-full object-cover transition duration-500 group-hover:scale-110" />
                      )}
                    </div>
                    <div className="flex flex-1 flex-col p-5">
                      {g.locationName && <span className="mb-1.5 text-xs font-medium text-clay-500">📍 {g.locationName}</span>}
                      <h3 className="line-clamp-2 font-display text-lg font-semibold text-forest-900">{g.title}</h3>
                      {g.excerpt && <p className="mt-1.5 line-clamp-2 text-sm text-forest-400">{g.excerpt}</p>}
                      <div className="mt-4 flex items-center gap-2 border-t border-cream-100 pt-3 text-xs text-forest-400">
                        {g.authorName && <span>✍️ {g.authorName}</span>}
                        {g.publishedAt && <span>· {formatDate(g.publishedAt)}</span>}
                      </div>
                    </div>
                  </Link>
                ))}
              </div>
            )}
          </>
        )}
      </div>
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
        <h1 className="mt-3 font-display text-xl font-semibold text-forest-900">Không tìm thấy bài cẩm nang</h1>
        <Link to="/guides" className="mt-6 inline-block rounded-full bg-forest-700 px-5 py-2 text-sm font-medium text-cream-50 hover:bg-forest-800">← Xem cẩm nang du lịch</Link>
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
    <article className="mx-auto max-w-3xl px-6 py-10">
      <nav className="mb-6 text-sm text-forest-400">
        <Link to="/" className="hover:text-forest-700">Trang chủ</Link> /{' '}
        <Link to="/guides" className="hover:text-forest-700">Cẩm nang du lịch</Link> /{' '}
        <span className="text-forest-700">{guide.title}</span>
      </nav>

      {guide.locationName && (
        <span className="inline-flex items-center rounded-full bg-clay-500/10 px-3 py-1 text-xs font-medium text-clay-600">
          📍 {guide.locationName}
        </span>
      )}
      <h1 className="mt-3 font-display text-4xl font-semibold leading-tight text-forest-900">{guide.title}</h1>
      <div className="mt-3 flex flex-wrap items-center gap-2 text-sm text-forest-400">
        {guide.authorName && <span>✍️ {guide.authorName}</span>}
        {guide.publishedAt && <span>· {formatDate(guide.publishedAt)}</span>}
      </div>

      {guide.coverImage && (
        <img src={guide.coverImage} alt={guide.title} className="mt-6 aspect-[16/9] w-full rounded-3xl object-cover" />
      )}

      <div className="mt-8 space-y-4 text-lg leading-relaxed text-forest-700">
        {guide.content.split('\n').filter((p) => p.trim()).map((para, i) => (
          <p key={i}>{para}</p>
        ))}
      </div>

      {hasMap && (
        <div className="mt-10">
          <h2 className="mb-3 font-display text-xl font-semibold text-forest-900">📍 Địa điểm{guide.locationName ? `: ${guide.locationName}` : ''}</h2>
          <div className="overflow-hidden rounded-2xl border border-cream-200">
            <iframe title="Bản đồ địa điểm" src={mapSrc} className="h-72 w-full" loading="lazy" />
          </div>
          <a
            href={`https://www.openstreetmap.org/?mlat=${lat}&mlon=${lon}#map=13/${lat}/${lon}`}
            target="_blank"
            rel="noreferrer"
            className="mt-2 inline-block text-sm font-medium text-clay-600 hover:underline"
          >
            Mở bản đồ lớn hơn ↗
          </a>
        </div>
      )}

      {guide.relatedTours.length > 0 && (
        <div className="mt-12 border-t border-cream-200 pt-8">
          <h2 className="mb-4 font-display text-2xl font-semibold text-forest-900">Tour liên quan</h2>
          <div className="grid gap-4 sm:grid-cols-2">
            {guide.relatedTours.map((t) => (
              <Link key={t.id} to={`/tour/${t.slug}`} className="group flex gap-3 rounded-2xl border border-cream-200 bg-white p-3 transition hover:border-forest-300 hover:shadow-md">
                <div className="h-20 w-24 shrink-0 overflow-hidden rounded-xl bg-cream-100">
                  {t.thumbnail && <img src={t.thumbnail} alt={t.title} className="h-full w-full object-cover transition group-hover:scale-105" />}
                </div>
                <div className="min-w-0">
                  <h3 className="line-clamp-2 text-sm font-semibold text-forest-900">{t.title}</h3>
                  <p className="mt-1 text-xs text-forest-400">{t.durationDays}N{t.durationNights}Đ · ★ {t.avgRating.toFixed(1)}</p>
                  <p className="mt-1 text-sm font-semibold text-clay-600">{formatPrice(t.basePrice)}<span className="text-xs font-normal text-forest-400">/khách</span></p>
                </div>
              </Link>
            ))}
          </div>
        </div>
      )}
    </article>
  )
}
