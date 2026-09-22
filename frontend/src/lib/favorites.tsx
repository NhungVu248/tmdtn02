import { createContext, useCallback, useContext, useEffect, useMemo, useState, type ReactNode } from 'react'
import { ApiError, api } from './api'
import { useAuth } from './auth'

interface ToggleResult {
  needLogin?: boolean
  message?: string
  favorited?: boolean
}

interface FavoritesState {
  ids: Set<number>
  isFavorite: (id: number) => boolean
  toggle: (id: number) => Promise<ToggleResult>
  refresh: () => void
}

const FavoritesContext = createContext<FavoritesState | null>(null)

export function FavoritesProvider({ children }: { children: ReactNode }) {
  const { token } = useAuth()
  const [ids, setIds] = useState<Set<number>>(new Set())

  const refresh = useCallback(() => {
    if (!token) {
      setIds(new Set())
      return
    }
    api
      .getFavoriteIds()
      .then((r) => setIds(new Set(r.ids)))
      .catch(() => setIds(new Set()))
  }, [token])

  // Nạp lại danh sách id mỗi khi đăng nhập/đăng xuất.
  useEffect(() => {
    refresh()
  }, [refresh])

  const toggle = useCallback(
    async (id: number): Promise<ToggleResult> => {
      if (!token) return { needLogin: true } // 1a-1: yêu cầu đăng nhập

      const currently = ids.has(id)
      // Cập nhật lạc quan.
      setIds((prev) => {
        const next = new Set(prev)
        if (currently) next.delete(id)
        else next.add(id)
        return next
      })

      try {
        if (currently) await api.removeFavorite(id)
        else await api.addFavorite(id)
        return { favorited: !currently }
      } catch (err) {
        // Hoàn tác nếu lỗi (vd 2a: sản phẩm không còn khả dụng).
        setIds((prev) => {
          const next = new Set(prev)
          if (currently) next.add(id)
          else next.delete(id)
          return next
        })
        return { message: err instanceof ApiError ? err.message : 'Không cập nhật được yêu thích' }
      }
    },
    [token, ids],
  )

  const value = useMemo<FavoritesState>(
    () => ({ ids, isFavorite: (id) => ids.has(id), toggle, refresh }),
    [ids, toggle, refresh],
  )

  return <FavoritesContext.Provider value={value}>{children}</FavoritesContext.Provider>
}

// eslint-disable-next-line react-refresh/only-export-components
export function useFavorites() {
  const ctx = useContext(FavoritesContext)
  if (!ctx) throw new Error('useFavorites phải dùng trong FavoritesProvider')
  return ctx
}
