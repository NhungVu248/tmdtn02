import { Link } from 'react-router-dom'
import { formatPrice, type Product } from '../lib/api'
import { FavoriteButton } from './FavoriteButton'

// Thẻ sản phẩm. Bấm vào -> UC-03 (Xem chi tiết) theo luồng thay thế 3a.
export function ProductCard({ product }: { product: Product }) {
  const isTour = product.type === 'TOUR'
  const unit = isTour ? '/khách' : '/đêm'
  const duration = isTour
    ? product.durationDays
      ? `${product.durationDays} ngày`
      : null
    : product.nights
      ? `${product.nights} đêm`
      : null

  return (
    <Link
      to={isTour ? `/tour/${product.slug}` : `/product/${product.slug}`}
      className="group block overflow-hidden rounded-2xl border border-cream-200 bg-white transition duration-300 hover:-translate-y-1 hover:shadow-xl hover:shadow-forest-900/10"
    >
      <div className="relative aspect-[4/3] overflow-hidden bg-cream-100">
        {product.thumbnail && (
          <img
            src={product.thumbnail}
            alt={product.name}
            loading="lazy"
            className="h-full w-full object-cover transition duration-500 group-hover:scale-110"
          />
        )}
        <span className="absolute left-3 top-3 rounded-full bg-forest-800/85 px-3 py-1 text-xs font-medium text-cream-50 backdrop-blur">
          {isTour ? 'Tour' : 'Homestay'}
        </span>
        {duration && (
          <span className="absolute right-3 bottom-3 rounded-full bg-cream-50/90 px-3 py-1 text-xs font-semibold text-forest-700 backdrop-blur">
            {duration}
          </span>
        )}
        {/* UC-08: yêu thích hiện chỉ áp dụng cho homestay */}
        {!isTour && <FavoriteButton productId={product.id} className="absolute right-3 top-3" />}
      </div>
      <div className="p-4">
        <div className="flex items-center gap-1 text-xs font-medium text-gold-500">
          <span>★</span>
          <span>{product.rating.toFixed(1)}</span>
          <span className="text-forest-300">· Đánh giá</span>
        </div>
        <h3 className="mt-1.5 line-clamp-1 font-display text-lg font-semibold text-forest-900">{product.name}</h3>
        <p className="mt-0.5 line-clamp-1 text-sm text-forest-400">📍 {product.location}</p>
        <div className="mt-3 flex items-end justify-between border-t border-cream-100 pt-3">
          <span className="text-xs text-forest-400">Chỉ từ</span>
          <span className="font-semibold text-clay-600">
            {formatPrice(product.price)}
            <span className="text-xs font-normal text-forest-400">{unit}</span>
          </span>
        </div>
      </div>
    </Link>
  )
}
