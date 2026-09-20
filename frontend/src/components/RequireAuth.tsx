import { Navigate, useLocation } from 'react-router-dom'
import { useAuth } from '../lib/auth'
import type { ReactNode } from 'react'

// BR-19: các chức năng cần đăng nhập được bọc bởi RequireAuth.
// Chưa đăng nhập -> chuyển tới /login kèm returnTo để quay lại đúng chỗ (UC-06 3a).
export function RequireAuth({ children }: { children: ReactNode }) {
  const { token } = useAuth()
  const location = useLocation()

  if (!token) {
    const returnTo = encodeURIComponent(location.pathname + location.search)
    return <Navigate to={`/login?returnTo=${returnTo}`} replace />
  }
  return <>{children}</>
}
