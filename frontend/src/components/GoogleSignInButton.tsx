import { useEffect, useRef, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { api } from '../lib/api'
import { useAuth } from '../lib/auth'

const CLIENT_ID = import.meta.env.VITE_GOOGLE_CLIENT_ID as string | undefined
const GSI_SRC = 'https://accounts.google.com/gsi/client'

// Tải script GIS một lần.
function loadGsi(): Promise<void> {
  return new Promise((resolve, reject) => {
    if (window.google?.accounts?.id) return resolve()
    const existing = document.querySelector(`script[src="${GSI_SRC}"]`)
    if (existing) {
      existing.addEventListener('load', () => resolve())
      existing.addEventListener('error', () => reject(new Error('load error')))
      return
    }
    const s = document.createElement('script')
    s.src = GSI_SRC
    s.async = true
    s.defer = true
    s.onload = () => resolve()
    s.onerror = () => reject(new Error('Không tải được Google Identity Services'))
    document.head.appendChild(s)
  })
}

// UC-05 (1a) / UC-06 (1b) – Nút Google gộp: đăng ký nếu chưa có, đăng nhập nếu đã có.
export function GoogleSignInButton() {
  const navigate = useNavigate()
  const { login } = useAuth()
  const ref = useRef<HTMLDivElement>(null)
  const [enabled, setEnabled] = useState<boolean | null>(null)
  const [error, setError] = useState<string | null>(null)

  // Chỉ hiện nút khi cả frontend (client id) và backend đều bật Google.
  useEffect(() => {
    if (!CLIENT_ID) {
      setEnabled(false)
      return
    }
    api
      .getAuthConfig()
      .then((c) => setEnabled(c.googleEnabled))
      .catch(() => setEnabled(false))
  }, [])

  useEffect(() => {
    if (!enabled || !CLIENT_ID) return
    let cancelled = false
    loadGsi()
      .then(() => {
        if (cancelled || !ref.current) return
        window.google!.accounts.id.initialize({
          client_id: CLIENT_ID,
          callback: async (resp: { credential: string }) => {
            try {
              const r = await api.googleAuth(resp.credential)
              login(r.token, r.user)
              navigate('/')
            } catch (err) {
              setError(err instanceof Error ? err.message : 'Đăng nhập Google thất bại')
            }
          },
        })
        window.google!.accounts.id.renderButton(ref.current, {
          theme: 'outline',
          size: 'large',
          width: 320,
          text: 'continue_with',
          locale: 'vi',
        })
      })
      .catch(() => setError('Không tải được Google Identity Services'))
    return () => {
      cancelled = true
    }
  }, [enabled, login, navigate])

  if (enabled === false) return null // Google chưa cấu hình -> ẩn nút

  return (
    <div className="flex flex-col items-center">
      <div ref={ref} />
      {error && <p className="mt-2 text-sm text-red-600">{error}</p>}
    </div>
  )
}
