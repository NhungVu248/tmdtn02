import { useCallback, useEffect, useMemo, useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import { ProductCard } from '../components/ProductCard'
import { EmptyState, ErrorState, Loading } from '../components/StateBlocks'
import { api, type Category, type Product, type ProductList } from '../lib/api'

// Tìm một node theo id trong cây danh mục.
function findNode(nodes: Category[], id: number): Category | null {
  for (const n of nodes) {
    if (n.id === id) return n
    const found = findNode(n.children, id)
    if (found) return found
  }
  return null
}

type SortKey = 'featured' | 'price-asc' | 'price-desc' | 'rating'

const SORTS: { key: SortKey; label: string }[] = [
  { key: 'featured', label: 'Nổi bật' },
  { key: 'price-asc', label: 'Giá: Thấp → Cao' },
  { key: 'price-desc', label: 'Giá: Cao → Thấp' },
  { key: 'rating', label: 'Đánh giá cao' },
]

export function CategoryPage() {
  const { slug } = useParams<{ slug: string }>()
  const [data, setData] = useState<ProductList | null>(null)
  const [children, setChildren] = useState<Category[]>([])
  const [status, setStatus] = useState<'loading' | 'ok' | 'error' | 'notfound'>('loading')
  const [sort, setSort] = useState<SortKey>('featured')

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

  // Sắp xếp phía client theo lựa chọn của người dùng.
  const items = useMemo<Product[]>(() => {
    const list = [...(data?.items ?? [])]
    switch (sort) {
      case 'price-asc':
        return list.sort((a, b) => a.price - b.price)
      case 'price-desc':
        return list.sort((a, b) => b.price - a.price)
      case 'rating':
        return list.sort((a, b) => b.rating - a.rating)
      default:
        return list
    }
  }, [data, sort])

  return (
    <div className="mx-auto max-w-7xl px-6 py-8">
      <nav className="mb-6 text-sm text-forest-400">
        <Link to="/" className="hover:text-forest-700">Trang chủ</Link>
        {' / '}
        <span className="text-forest-700">{data?.category?.name ?? 'Danh mục'}</span>
      </nav>

      {status === 'loading' && <Loading />}
      {status === 'error' && <ErrorState onRetry={load} />}
      {status === 'notfound' && <EmptyState message="Không tìm thấy danh mục này" />}

      {status === 'ok' && data && (
        <>
          <header className="mb-8">
            <h1 className="font-display text-4xl font-semibold text-forest-900">{data.category?.name}</h1>
            <p className="mt-2 text-forest-400">{data.count} lựa chọn dành cho bạn</p>
          </header>

          <div className="grid gap-8 lg:grid-cols-[16rem_1fr]">
            {/* ── Sidebar bộ lọc (phong cách Headout) ── */}
            <aside className="space-y-6 lg:sticky lg:top-24 lg:self-start">
              <div className="flex items-center justify-between">
                <h2 className="font-display text-lg font-semibold text-forest-900">Bộ lọc</h2>
                <Link to={`/category/${slug}`} className="text-xs text-clay-500 hover:text-clay-600">Đặt lại</Link>
              </div>

              {/* Danh mục con (BR-02) */}
              <div className="rounded-2xl border border-cream-200 bg-white p-5">
                <h3 className="mb-3 text-sm font-semibold uppercase tracking-wide text-forest-500">Danh mục</h3>
                {children.length > 0 ? (
                  <ul className="space-y-1.5 text-sm">
                    <li>
                      <Link to={`/category/${slug}`} className="font-medium text-forest-700 hover:text-clay-600">
                        Tất cả ({data.count})
                      </Link>
                    </li>
                    {children.map((c) => (
                      <li key={c.id}>
                        <Link to={`/category/${c.slug}`} className="text-forest-500 hover:text-clay-600">
                          {c.name}
                        </Link>
                      </li>
                    ))}
                  </ul>
                ) : (
                  <p className="text-sm text-forest-300">Không có danh mục con.</p>
                )}
              </div>

              {/* Loại hình */}
              <div className="rounded-2xl border border-cream-200 bg-white p-5">
                <h3 className="mb-3 text-sm font-semibold uppercase tracking-wide text-forest-500">Loại hình</h3>
                <div className="space-y-2 text-sm text-forest-600">
                  <Link to="/search?type=HOMESTAY" className="block hover:text-clay-600">Homestay</Link>
                  <Link to="/search?type=TOUR" className="block hover:text-clay-600">Tour du lịch</Link>
                </div>
              </div>

              {/* Tìm kiếm nâng cao */}
              <div className="rounded-2xl border border-cream-200 bg-white p-5">
                <h3 className="mb-2 text-sm font-semibold uppercase tracking-wide text-forest-500">Cần thêm bộ lọc?</h3>
                <p className="mb-3 text-sm text-forest-400">Lọc theo ngày, giá, số khách và tiện nghi ở trang tìm kiếm.</p>
                <Link
                  to="/search"
                  className="inline-block rounded-full bg-forest-700 px-4 py-2 text-sm font-medium text-cream-50 hover:bg-forest-800"
                >
                  Tìm kiếm nâng cao →
                </Link>
              </div>
            </aside>

            {/* ── Cột sản phẩm ── */}
            <div>
              {/* Thanh sắp xếp */}
              <div className="mb-6 flex flex-wrap items-center justify-between gap-3 rounded-2xl border border-cream-200 bg-white px-5 py-3">
                <span className="text-sm text-forest-500">
                  Hiển thị <span className="font-semibold text-forest-800">{items.length}</span> kết quả
                </span>
                <div className="flex items-center gap-2 text-sm">
                  <span className="text-forest-400">Sắp xếp:</span>
                  {SORTS.map((s) => (
                    <button
                      key={s.key}
                      onClick={() => setSort(s.key)}
                      className={`rounded-full px-3 py-1 font-medium transition ${
                        sort === s.key
                          ? 'bg-forest-700 text-cream-50'
                          : 'text-forest-500 hover:bg-cream-100'
                      }`}
                    >
                      {s.label}
                    </button>
                  ))}
                </div>
              </div>

              {/* Ngoại lệ 4a: danh mục rỗng */}
              {items.length === 0 ? (
                <EmptyState />
              ) : (
                <div className="grid grid-cols-1 gap-6 sm:grid-cols-2 xl:grid-cols-3">
                  {items.map((p) => (
                    <ProductCard key={p.id} product={p} />
                  ))}
                </div>
              )}
            </div>
          </div>
        </>
      )}
    </div>
  )
}
