import { useState } from 'react'
import { useLocation, useNavigate, useSearchParams } from 'react-router-dom'
import { AdminApiError, adminApi } from '../../lib/adminApi'
import { useAdminAuth } from '../../lib/adminAuth'

// UC-24 – Đăng nhập quản trị (/admin/login), tách biệt hoàn toàn với /login của Customer.
export function AdminLoginPage() {
  const navigate = useNavigate()
  const location = useLocation()
  const [params] = useSearchParams()
  const expired = params.get('expired') === '1'
  const { login } = useAdminAuth()

  const [username, setUsername] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [loading, setLoading] = useState(false)

  async function submit(e: React.FormEvent) {
    e.preventDefault()
    setError(null)
    setLoading(true)
    try {
      const r = await adminApi.login(username, password)
      login(r.token, r.admin)
      const from = (location.state as { from?: string } | null)?.from || '/admin'
      navigate(from, { replace: true })
    } catch (err) {
      // 3a: sai tài khoản/mật khẩu (thông báo chung). 3c: tạm khóa (423, kèm số phút).
      setError(err instanceof AdminApiError ? err.message : 'Đăng nhập thất bại. Vui lòng thử lại.')
    } finally {
      setLoading(false)
    }
  }

  const field = 'w-full rounded-lg border border-slate-700 bg-slate-800 px-3 py-2 text-sm text-slate-100 placeholder:text-slate-500 focus:border-emerald-500 focus:outline-none'

  return (
    <div className="flex min-h-screen items-center justify-center bg-slate-900 px-4">
      <div className="w-full max-w-sm rounded-xl border border-slate-800 bg-slate-950 p-6">
        <h1 className="text-center text-xl font-bold text-white">🛠️ StayTour Admin</h1>
        <p className="mt-1 text-center text-sm text-slate-500">Đăng nhập khu vực quản trị</p>

        {expired && (
          <div className="mt-4 rounded-lg border border-amber-700 bg-amber-950/40 px-3 py-2 text-sm text-amber-300">
            Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại để tiếp tục.
          </div>
        )}

        <form onSubmit={submit} className="mt-6 space-y-4">
          <label className="block">
            <span className="mb-1 block text-sm text-slate-300">Tài khoản</span>
            <input className={field} value={username} onChange={(e) => setUsername(e.target.value)} autoFocus />
          </label>
          <label className="block">
            <span className="mb-1 block text-sm text-slate-300">Mật khẩu</span>
            <input className={field} type="password" value={password} onChange={(e) => setPassword(e.target.value)} />
          </label>

          {error && (
            <div className="rounded-lg border border-red-800 bg-red-950/50 px-3 py-2 text-sm text-red-300">{error}</div>
          )}

          <button
            type="submit"
            disabled={loading}
            className="w-full rounded-lg bg-emerald-600 px-4 py-2.5 font-semibold text-white hover:bg-emerald-700 disabled:opacity-50"
          >
            {loading ? 'Đang đăng nhập...' : 'Đăng nhập'}
          </button>
        </form>

        <p className="mt-6 text-center text-xs text-slate-600">
          Khu vực này dành riêng cho quản trị viên, tách biệt với tài khoản thành viên website chính.
        </p>
      </div>
    </div>
  )
}
