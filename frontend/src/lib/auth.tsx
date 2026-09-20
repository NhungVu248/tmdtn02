import { createContext, useContext, useMemo, useState, type ReactNode } from 'react'
import { setAuthToken, type AuthUser } from './api'

interface AuthState {
  token: string | null
  user: AuthUser | null
  login: (token: string, user: AuthUser) => void
  logout: () => void
  setUser: (user: AuthUser) => void
}

const STORAGE_KEY = 'staytour.auth'
const AuthContext = createContext<AuthState | null>(null)

function readStored(): { token: string; user: AuthUser } | null {
  try {
    const raw = localStorage.getItem(STORAGE_KEY)
    return raw ? JSON.parse(raw) : null
  } catch {
    return null
  }
}

export function AuthProvider({ children }: { children: ReactNode }) {
  // Hydrate ĐỒNG BỘ từ localStorage để RequireAuth không hiểu nhầm là chưa đăng nhập
  // ở lần render đầu (khi tải lại trang trên route cần đăng nhập).
  const [token, setToken] = useState<string | null>(() => {
    const stored = readStored()
    if (stored) setAuthToken(stored.token)
    return stored?.token ?? null
  })
  const [user, setUser] = useState<AuthUser | null>(() => readStored()?.user ?? null)

  const value = useMemo<AuthState>(
    () => ({
      token,
      user,
      login(t, u) {
        setToken(t)
        setUser(u)
        setAuthToken(t)
        try {
          localStorage.setItem(STORAGE_KEY, JSON.stringify({ token: t, user: u }))
        } catch {
          // bỏ qua nếu không lưu được (chế độ riêng tư)
        }
      },
      logout() {
        setToken(null)
        setUser(null)
        setAuthToken(null)
        try {
          localStorage.removeItem(STORAGE_KEY)
        } catch {
          // bỏ qua
        }
      },
      setUser(u) {
        setUser(u)
        try {
          localStorage.setItem(STORAGE_KEY, JSON.stringify({ token, user: u }))
        } catch {
          // bỏ qua
        }
      },
    }),
    [token, user],
  )

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>
}

// eslint-disable-next-line react-refresh/only-export-components
export function useAuth() {
  const ctx = useContext(AuthContext)
  if (!ctx) throw new Error('useAuth phải dùng trong AuthProvider')
  return ctx
}
