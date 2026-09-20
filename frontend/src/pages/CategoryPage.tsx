import { useCallback, useEffect, useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import { ProductCard } from '../components/ProductCard'
import { EmptyState, ErrorState, Loading } from '../components/StateBlocks'
import { api, type Category, type ProductList } from '../lib/api'

// Tìm một node theo id trong cây danh mục.
function findNode(nodes: Category[], id: number): Category | null {
  for (const n of nodes) {
    if (n.id === id) return n
    const found = findNode(n.children, id)
    if (found) return found
  }
  return null
}

export function CategoryPage() {
  const { slug } = useParams<{ slug: string }>()
  const [data, setData] = useState<ProductList | null>(null)
  const [children, setChildren] = useState<Category[]>([])
  const [status, setStatus] = useState<'loading' | 'ok' | 'error' | 'notfound'>('loading')

  const load = useCallback(() => {
    if (!slug) return
    setStatus('loading')
    api
      .getProducts({ categorySlug: slug })
      .then(async (d) => {
        setData(d)
        setStatus('ok')
        // Lấy danh mục con để hiển thị (BR-02).
        if (d.category) {
          try {
            const tree = await api.getCategories(d.category.type)
            const node = findNode(tree.categories, d.category.id)
            setChildren(node?.children ?? [])
          } catch {
            setChildren([])
          }
        }
      })
      .catch((err: Error) => {
        setStatus(err.message.includes('404') ? 'notfound' : 'error')
      })
  }, [slug])

  useEffect(() => {
    load()
  }, [load])

  return (
    <div className="mx-auto max-w-6xl px-4 py-8">
      <nav className="mb-4 text-sm text-slate-500">
        <Link to="/" className="hover:text-emerald-700">
          Trang chủ
        </Link>{' '}
        / <span className="text-slate-700">{data?.category?.name ?? 'Danh mục'}</span>
      </nav>

      {status === 'loading' && <Loading />}
      {status === 'error' && <ErrorState onRetry={load} />}
      {status === 'notfound' && <EmptyState message="Không tìm thấy danh mục này" />}

      {status === 'ok' && data && (
        <>
          <div className="mb-4 flex items-end justify-between">
            <h1 className="text-2xl font-bold">{data.category?.name}</h1>
            <span className="text-sm text-slate-500">{data.count} sản phẩm</span>
          </div>

          {/* Danh mục con (nếu có) */}
          {children.length > 0 && (
            <div className="mb-6 flex flex-wrap gap-2">
              {children.map((c) => (
                <Link
                  key={c.id}
                  to={`/category/${c.slug}`}
                  className="rounded-full border border-slate-300 bg-white px-3 py-1 text-sm text-slate-700 hover:border-emerald-500 hover:text-emerald-700"
                >
                  {c.name}
                </Link>
              ))}
            </div>
          )}

          {/* Ngoại lệ 4a: danh mục rỗng */}
          {data.items.length === 0 ? (
            <EmptyState />
          ) : (
            <div className="grid grid-cols-2 gap-4 sm:grid-cols-3 lg:grid-cols-4">
              {data.items.map((p) => (
                <ProductCard key={p.id} product={p} />
              ))}
            </div>
          )}
        </>
      )}
    </div>
  )
}
