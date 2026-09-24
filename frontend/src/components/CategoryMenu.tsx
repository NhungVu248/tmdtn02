import { NavLink } from 'react-router-dom'

// Điều hướng chính trên header: hai liên kết Homestay / Tour (đã bỏ dropdown danh mục).
export function CategoryMenu() {
  const cls = ({ isActive }: { isActive: boolean }) =>
    `px-3 py-2 text-sm font-medium transition ${
      isActive ? 'text-forest-900' : 'text-forest-600 hover:text-forest-900'
    }`

  return (
    <nav className="flex items-center gap-1">
      <NavLink to="/homestays" className={cls}>
        Homestay
      </NavLink>
      <NavLink to="/tours" className={cls}>
        Tour
      </NavLink>
    </nav>
  )
}
