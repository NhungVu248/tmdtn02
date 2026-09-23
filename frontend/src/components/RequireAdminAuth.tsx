import { Navigate, useLocation } from 'react-router-dom'
import { useAdminAuth } from '../lib/adminAuth'
import type { ReactNode } from 'react'

// UC-24 (BR-68) – Chặn truy cập khu vực /admin khi chưa đăng nhập quản trị.
export function RequireAdminAuth({ children }: { children: ReactNode }) {
  const { token } = useAdminAuth()
  const location = useLocation()

  if (!token) {
    return <Navigate to="/admin/login" state={{ from: location.pathname }} replace />
  }
  return <>{children}</>
}
