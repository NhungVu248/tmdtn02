import { createContext, useContext, useMemo, useState, type ReactNode } from 'react'
import { setAdminToken, type AdminInfo } from './adminApi'

// UC-24 (BR-67) – Phiên quản trị hoàn toàn tách biệt khỏi AuthProvider (Customer):
// khóa localStorage riêng, context riêng, không chia sẻ state với website chính.
const STORAGE_KEY = 'staytour.admin.auth'

interface AdminAuthState {
  token: string | null
  admin: AdminInfo | null
  login: (token: string, admin: AdminInfo) => void
  logout: () => void
}

const AdminAuthContext = createContext<AdminAuthState | null>(null)

function readStored(): { token: string; admin: AdminInfo } | null {
  try {
    const raw = localStorage.getItem(STORAGE_KEY)
    return raw ? JSON.parse(raw) : null
  } catch {
    return null
  }
}

export function AdminAuthProvider({ children }: { children: ReactNode }) {
  // Hydrate đồng bộ (tránh bug RequireAuth từng gặp ở Customer: đẩy nhầm về login khi reload).
  const [token, setToken] = useState<string | null>(() => {
    const stored = readStored()
    if (stored) setAdminToken(stored.token)
    return stored?.token ?? null
  })
  const [admin, setAdmin] = useState<AdminInfo | null>(() => readStored()?.admin ?? null)

  const value = useMemo<AdminAuthState>(
    () => ({
      token,
      admin,
      login(t, a) {
        setToken(t)
        setAdmin(a)
        setAdminToken(t)
        try {
          localStorage.setItem(STORAGE_KEY, JSON.stringify({ token: t, admin: a }))
        } catch {
          // bỏ qua nếu không lưu được
        }
      },
      logout() {
        setToken(null)
        setAdmin(null)
        setAdminToken(null)
        try {
          localStorage.removeItem(STORAGE_KEY)
        } catch {
          // bỏ qua
        }
      },
    }),
    [token, admin],
  )

  return <AdminAuthContext.Provider value={value}>{children}</AdminAuthContext.Provider>
}

// eslint-disable-next-line react-refresh/only-export-components
export function useAdminAuth() {
  const ctx = useContext(AdminAuthContext)
  if (!ctx) throw new Error('useAdminAuth phải dùng trong AdminAuthProvider')
  return ctx
}
