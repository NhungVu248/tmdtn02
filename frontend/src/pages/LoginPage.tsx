import { useState } from 'react'
import { Link, useNavigate, useSearchParams } from 'react-router-dom'
import { GoogleSignInButton } from '../components/GoogleSignInButton'
import { ApiError, api } from '../lib/api'
import { useAuth } from '../lib/auth'

// UC-06 – Đăng nhập email/mật khẩu + Google. Xử lý khóa (2b), chưa xác thực (2c), returnTo (3a).
export function LoginPage() {
  const navigate = useNavigate()
  const [params] = useSearchParams()
  const returnTo = params.get('returnTo') || '/'
  const { login } = useAuth()

  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [needVerify, setNeedVerify] = useState(false) // 2c
  const [resendMsg, setResendMsg] = useState<string | null>(null)
  const [loading, setLoading] = useState(false)

  async function submit(e: React.FormEvent) {
    e.preventDefault()
    setError(null)
    setNeedVerify(false)
    setResendMsg(null)
    setLoading(true)
    try {
      const r = await api.login(email, password)
      login(r.token, r.user)
      navigate(returnTo)
    } catch (err) {
      if (err instanceof ApiError) {
        setError(err.message)
        if (err.code === 'EMAIL_NOT_VERIFIED') setNeedVerify(true) // 2c
      } else {
        setError('Sai email hoặc mật khẩu') // BR-17
      }
    } finally {
      setLoading(false)
    }
  }

  async function resend() {
    setResendMsg(null)
    try {
      const r = await api.resendVerification(email)
      setResendMsg(r.message)
    } catch {
      setResendMsg('Không gửi lại được. Vui lòng thử lại sau.')
    }
  }

  const field = 'w-full rounded-lg border border-slate-300 px-3 py-2 text-sm focus:border-emerald-500 focus:outline-none'

  return (
    <div className="mx-auto max-w-md px-4 py-10">
      <h1 className="text-2xl font-bold">Đăng nhập</h1>

      <form onSubmit={submit} className="mt-6 space-y-4">
        <label className="block">
          <span className="mb-1 block text-sm font-medium">Email</span>
          <input className={field} type="email" value={email} onChange={(e) => setEmail(e.target.value)} />
        </label>
        <label className="block">
          <div className="mb-1 flex items-center justify-between">
            <span className="text-sm font-medium">Mật khẩu</span>
            <Link to="/forgot-password" className="text-xs text-emerald-700 hover:underline">
              Quên mật khẩu?
            </Link>
          </div>
          <input className={field} type="password" value={password} onChange={(e) => setPassword(e.target.value)} />
        </label>

        {error && (
          <div className="rounded-lg border border-red-300 bg-red-50 px-3 py-2 text-sm text-red-700">
            {error}
            {needVerify && (
              <div className="mt-2">
                <button type="button" onClick={resend} className="font-medium text-emerald-700 underline">
                  Gửi lại email xác thực
                </button>
                {resendMsg && <p className="mt-1 text-slate-600">{resendMsg}</p>}
              </div>
            )}
          </div>
        )}

        <button
          type="submit"
          disabled={loading}
          className="w-full rounded-lg bg-emerald-600 px-4 py-2.5 font-semibold text-white hover:bg-emerald-700 disabled:opacity-50"
        >
          {loading ? 'Đang đăng nhập...' : 'Đăng nhập'}
        </button>
      </form>

      <div className="my-5 flex items-center gap-3 text-xs text-slate-400">
        <span className="h-px flex-1 bg-slate-200" /> hoặc <span className="h-px flex-1 bg-slate-200" />
      </div>
      <GoogleSignInButton />

      <p className="mt-6 text-center text-sm text-slate-500">
        Chưa có tài khoản?{' '}
        <Link to="/register" className="text-emerald-700 hover:underline">
          Đăng ký
        </Link>
      </p>
    </div>
  )
}
