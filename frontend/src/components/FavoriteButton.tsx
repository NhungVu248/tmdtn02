import { useState } from 'react'
import { useLocation, useNavigate } from 'react-router-dom'
import { useFavorites } from '../lib/favorites'

// Nút tim yêu thích (UC-08). Chưa đăng nhập -> chuyển sang /login kèm returnTo (1a-1).
export function FavoriteButton({ productId, className = '' }: { productId: number; className?: string }) {
  const { isFavorite, toggle } = useFavorites()
  const navigate = useNavigate()
  const location = useLocation()
  const [busy, setBusy] = useState(false)
  const active = isFavorite(productId)

  async function onClick(e: React.MouseEvent) {
    e.preventDefault() // không kích hoạt Link bao ngoài
    e.stopPropagation()
    if (busy) return
    setBusy(true)
    const res = await toggle(productId)
    setBusy(false)
    if (res.needLogin) {
      const returnTo = encodeURIComponent(location.pathname + location.search)
      navigate(`/login?returnTo=${returnTo}`)
    } else if (res.message) {
      alert(res.message) // vd 2a: sản phẩm không còn khả dụng
    }
  }

  return (
    <button
      type="button"
      onClick={onClick}
      aria-label={active ? 'Bỏ yêu thích' : 'Thêm vào yêu thích'}
      title={active ? 'Bỏ yêu thích' : 'Thêm vào yêu thích'}
      className={`flex h-9 w-9 items-center justify-center rounded-full bg-cream-50/90 shadow-sm backdrop-blur transition hover:bg-cream-50 ${className}`}
    >
      <span className={active ? 'text-clay-500' : 'text-forest-400'}>{active ? '♥' : '♡'}</span>
    </button>
  )
}
