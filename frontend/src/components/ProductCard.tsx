import { Link } from 'react-router-dom'
import { formatPrice, type Product } from '../lib/api'
import { FavoriteButton } from './FavoriteButton'

// Thẻ sản phẩm. Bấm vào -> UC-03 (Xem chi tiết) theo luồng thay thế 3a.
export function ProductCard({ product }: { product: Product }) {
  const isTour = product.type === 'TOUR'
  const unit = isTour ? '/khách' : '/đêm'
  return (
    <Link
      to={isTour ? `/tour/${product.slug}` : `/product/${product.slug}`}
      className="group block overflow-hidden rounded-xl border border-slate-200 bg-white transition hover:shadow-md"
    >
      <div className="relative aspect-[4/3] overflow-hidden bg-slate-100">
        {product.thumbnail && (
          <img
            src={product.thumbnail}
            alt={product.name}
            loading="lazy"
            className="h-full w-full object-cover transition duration-300 group-hover:scale-105"
          />
        )}
        <span className="absolute left-2 top-2 rounded-full bg-black/60 px-2 py-0.5 text-xs font-medium text-white">
          {isTour ? 'Tour' : 'Homestay'}
        </span>
        {/* UC-08: yêu thích hiện chỉ áp dụng cho homestay */}
        {!isTour && <FavoriteButton productId={product.id} className="absolute right-2 top-2" />}
      </div>
      <div className="p-3">
        <h3 className="line-clamp-1 font-semibold text-slate-900">{product.name}</h3>
        <p className="mt-0.5 line-clamp-1 text-sm text-slate-500">📍 {product.location}</p>
        <div className="mt-2 flex items-center justify-between">
          <span className="font-semibold text-emerald-600">
            {formatPrice(product.price)}
            <span className="text-xs font-normal text-slate-400">{unit}</span>
          </span>
          <span className="text-sm text-amber-500">★ {product.rating.toFixed(1)}</span>
        </div>
      </div>
    </Link>
  )
}
