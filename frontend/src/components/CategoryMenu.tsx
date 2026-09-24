import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { api, type Category, type ProductType } from '../lib/api'

// Menu danh mục nhiều cấp (BR-02) trên thanh điều hướng. Hover để mở.
function CategoryNode({ node, depth = 0 }: { node: Category; depth?: number }) {
  const hasChildren = node.children && node.children.length > 0
  return (
    <div className="group/item relative">
      <Link
        to={`/category/${node.slug}`}
        className="flex items-center justify-between gap-4 rounded-md px-3 py-2 text-sm text-slate-700 hover:bg-emerald-50 hover:text-emerald-700"
      >
        {node.name}
        {hasChildren && <span className="text-slate-400">›</span>}
      </Link>
      {hasChildren && (
        <div className="invisible absolute left-full top-0 z-20 ml-1 w-56 rounded-lg border border-slate-200 bg-white p-1 opacity-0 shadow-lg transition group-hover/item:visible group-hover/item:opacity-100">
          {node.children.map((c) => (
            <CategoryNode key={c.id} node={c} depth={depth + 1} />
          ))}
        </div>
      )}
    </div>
  )
}

function Dropdown({ label, type, to }: { label: string; type: ProductType; to: string }) {
  const [roots, setRoots] = useState<Category[]>([])

  useEffect(() => {
    api.getCategories(type).then((r) => setRoots(r.categories)).catch(() => setRoots([]))
  }, [type])

  return (
    <div className="group relative">
      <Link to={to} className="block px-3 py-2 text-sm font-medium text-slate-700 hover:text-emerald-700">
        {label} ▾
      </Link>
      <div className="invisible absolute left-0 top-full z-20 w-56 rounded-lg border border-slate-200 bg-white p-1 opacity-0 shadow-lg transition group-hover:visible group-hover:opacity-100">
        {roots.length === 0 ? (
          <p className="px-3 py-2 text-sm text-slate-400">Chưa có danh mục</p>
        ) : (
          roots.map((c) => <CategoryNode key={c.id} node={c} />)
        )}
      </div>
    </div>
  )
}

export function CategoryMenu() {
  return (
    <nav className="flex items-center gap-1">
      <Dropdown label="Homestay" type="HOMESTAY" to="/homestays" />
      <Dropdown label="Tour" type="TOUR" to="/tours" />
    </nav>
  )
}
