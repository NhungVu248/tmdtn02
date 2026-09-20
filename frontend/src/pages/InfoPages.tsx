import { useCallback, useEffect, useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import { ErrorState, Loading } from '../components/StateBlocks'
import { ApiError, api, type InfoArticle, type InfoCategory, type InfoSummary } from '../lib/api'

const CATEGORY_LABEL: Record<InfoCategory, string> = {
  ABOUT: 'Thông tin',
  POLICY: 'Chính sách',
  GUIDE: 'Cẩm nang du lịch',
}
const CATEGORY_ORDER: InfoCategory[] = ['ABOUT', 'POLICY', 'GUIDE']

// UC-04 – Trang tổng hợp các mục thông tin & chính sách.
export function InfoIndexPage() {
  const [articles, setArticles] = useState<InfoSummary[]>([])
  const [status, setStatus] = useState<'loading' | 'ok' | 'error'>('loading')

  const load = useCallback(() => {
    setStatus('loading')
    api
      .getInfoList()
      .then((d) => {
        setArticles(d.articles)
        setStatus('ok')
      })
      .catch(() => setStatus('error'))
  }, [])

  useEffect(() => {
    load()
  }, [load])

  if (status === 'loading') return <Loading />
  if (status === 'error') return <ErrorState onRetry={load} />

  return (
    <div className="mx-auto max-w-4xl px-4 py-8">
      <h1 className="mb-6 text-2xl font-bold">Thông tin & chính sách</h1>
      <div className="space-y-8">
        {CATEGORY_ORDER.map((cat) => {
          const list = articles.filter((a) => a.category === cat)
          if (list.length === 0) return null
          return (
            <section key={cat}>
              <h2 className="mb-3 text-lg font-semibold text-slate-800">{CATEGORY_LABEL[cat]}</h2>
              <div className="grid gap-3 sm:grid-cols-2">
                {list.map((a) => (
                  <Link
                    key={a.id}
                    to={`/info/${a.slug}`}
                    className="rounded-xl border border-slate-200 bg-white p-4 transition hover:border-emerald-400 hover:shadow-sm"
                  >
                    <h3 className="font-medium text-slate-900">{a.title}</h3>
                    {a.excerpt && <p className="mt-1 text-sm text-slate-500">{a.excerpt}</p>}
                  </Link>
                ))}
              </div>
            </section>
          )
        })}
      </div>
    </div>
  )
}

// UC-04 – Nội dung một bài viết. Ngoại lệ 2a: không tìm thấy nội dung.
export function InfoArticlePage() {
  const { slug } = useParams<{ slug: string }>()
  const [article, setArticle] = useState<InfoArticle | null>(null)
  const [status, setStatus] = useState<'loading' | 'ok' | 'error' | 'notfound'>('loading')

  const load = useCallback(() => {
    if (!slug) return
    setStatus('loading')
    api
      .getInfoArticle(slug)
      .then((d) => {
        setArticle(d.article)
        setStatus('ok')
      })
      .catch((err) => {
        setStatus(err instanceof ApiError && err.status === 404 ? 'notfound' : 'error')
      })
  }, [slug])

  useEffect(() => {
    load()
  }, [load])

  if (status === 'loading') return <Loading />
  if (status === 'error') return <ErrorState onRetry={load} />
  if (status === 'notfound') {
    return (
      <div className="mx-auto max-w-3xl px-4 py-16 text-center">
        <div className="text-4xl">📄</div>
        <h1 className="mt-3 text-xl font-semibold">Không tìm thấy nội dung</h1>
        <p className="mt-1 text-slate-500">Trang hoặc bài viết không tồn tại hoặc đã được gỡ.</p>
        <Link
          to="/info"
          className="mt-6 inline-block rounded-lg bg-emerald-600 px-4 py-2 text-sm font-medium text-white hover:bg-emerald-700"
        >
          ← Xem thông tin & chính sách
        </Link>
      </div>
    )
  }
  if (!article) return null

  return (
    <div className="mx-auto max-w-3xl px-4 py-8">
      <nav className="mb-4 text-sm text-slate-500">
        <Link to="/" className="hover:text-emerald-700">Trang chủ</Link> /{' '}
        <Link to="/info" className="hover:text-emerald-700">Thông tin & chính sách</Link> /{' '}
        <span className="text-slate-700">{article.title}</span>
      </nav>

      <article>
        <span className="rounded-full bg-slate-100 px-2 py-0.5 text-xs font-medium text-slate-600">
          {CATEGORY_LABEL[article.category]}
        </span>
        <h1 className="mt-2 text-2xl font-bold">{article.title}</h1>
        <p className="mt-1 text-xs text-slate-400">
          Cập nhật: {new Date(article.updatedAt).toLocaleDateString('vi-VN')}
        </p>
        <div className="mt-6 space-y-4 leading-relaxed text-slate-700">
          {article.content.split('\n\n').map((para, i) => (
            <p key={i}>{para}</p>
          ))}
        </div>
      </article>
    </div>
  )
}
