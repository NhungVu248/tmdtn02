import { useState } from 'react'
import { Link, useNavigate, useSearchParams } from 'react-router-dom'
import { ApiError, api } from '../lib/api'

const field = 'w-full rounded-lg border border-slate-300 px-3 py-2 text-sm focus:border-emerald-500 focus:outline-none'

// UC-06 (1a) – Quên mật khẩu: nhập email để nhận liên kết đặt lại.
export function ForgotPasswordPage() {
  const [email, setEmail] = useState('')
  const [sent, setSent] = useState<{ message: string; devResetUrl?: string } | null>(null)
  const [loading, setLoading] = useState(false)

  async function submit(e: React.FormEvent) {
    e.preventDefault()
    setLoading(true)
    try {
      setSent(await api.forgotPassword(email))
    } catch {
      setSent({ message: 'Nếu email tồn tại, chúng tôi đã gửi liên kết đặt lại mật khẩu.' })
    } finally {
      setLoading(false)
    }
  }

  if (sent) {
    return (
      <div className="mx-auto max-w-md px-4 py-16 text-center">
        <div className="text-4xl">📧</div>
        <h1 className="mt-3 text-xl font-semibold">Kiểm tra email</h1>
        <p className="mt-2 text-slate-600">{sent.message}</p>
        {sent.devResetUrl && (
          <p className="mt-3 break-all rounded-lg bg-slate-100 px-3 py-2 text-xs text-slate-600">
            [DEV] Liên kết đặt lại:{' '}
            <a href={sent.devResetUrl} className="text-emerald-700 underline">
              {sent.devResetUrl}
            </a>
          </p>
        )}
        <Link to="/login" className="mt-6 inline-block text-sm text-emerald-700 hover:underline">
          ← Về đăng nhập
        </Link>
      </div>
    )
  }

  return (
    <div className="mx-auto max-w-md px-4 py-10">
      <h1 className="text-2xl font-bold">Quên mật khẩu</h1>
      <p className="mt-1 text-sm text-slate-500">Nhập email đã đăng ký, chúng tôi sẽ gửi liên kết đặt lại mật khẩu.</p>
      <form onSubmit={submit} className="mt-6 space-y-4">
        <input className={field} type="email" placeholder="Email" value={email} onChange={(e) => setEmail(e.target.value)} required />
        <button
          type="submit"
          disabled={loading}
          className="w-full rounded-lg bg-emerald-600 px-4 py-2.5 font-semibold text-white hover:bg-emerald-700 disabled:opacity-50"
        >
          {loading ? 'Đang gửi...' : 'Gửi liên kết đặt lại'}
        </button>
      </form>
      <Link to="/login" className="mt-4 block text-center text-sm text-slate-500 hover:text-emerald-700">
        ← Về đăng nhập
      </Link>
    </div>
  )
}

// UC-06 (1a) – Đặt lại mật khẩu bằng token trong liên kết.
export function ResetPasswordPage() {
  const [params] = useSearchParams()
  const token = params.get('token')
  const navigate = useNavigate()
  const [password, setPassword] = useState('')
  const [confirm, setConfirm] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [done, setDone] = useState(false)
  const [loading, setLoading] = useState(false)

  async function submit(e: React.FormEvent) {
    e.preventDefault()
    setError(null)
    if (password.length < 8 || !/[a-zA-Z]/.test(password) || !/[0-9]/.test(password)) {
      setError('Mật khẩu phải có ít nhất 8 ký tự, gồm cả chữ và số')
      return
    }
    if (password !== confirm) {
      setError('Xác nhận mật khẩu không khớp')
      return
    }
    if (!token) {
      setError('Thiếu mã đặt lại trong liên kết')
      return
    }
    setLoading(true)
    try {
      await api.resetPassword(token, password)
      setDone(true)
    } catch (err) {
      setError(err instanceof ApiError ? err.message : 'Đặt lại mật khẩu thất bại')
    } finally {
      setLoading(false)
    }
  }

  if (done) {
    return (
      <div className="mx-auto max-w-md px-4 py-16 text-center">
        <div className="text-4xl">✅</div>
        <h1 className="mt-3 text-xl font-semibold">Đặt lại mật khẩu thành công</h1>
        <button
          onClick={() => navigate('/login')}
          className="mt-6 rounded-lg bg-emerald-600 px-4 py-2 text-sm font-medium text-white hover:bg-emerald-700"
        >
          Đăng nhập
        </button>
      </div>
    )
  }

  return (
    <div className="mx-auto max-w-md px-4 py-10">
      <h1 className="text-2xl font-bold">Đặt lại mật khẩu</h1>
      <form onSubmit={submit} className="mt-6 space-y-4">
        <label className="block">
          <span className="mb-1 block text-sm font-medium">Mật khẩu mới</span>
          <input className={field} type="password" value={password} onChange={(e) => setPassword(e.target.value)} placeholder="Tối thiểu 8 ký tự, gồm chữ và số" />
        </label>
        <label className="block">
          <span className="mb-1 block text-sm font-medium">Xác nhận mật khẩu</span>
          <input className={field} type="password" value={confirm} onChange={(e) => setConfirm(e.target.value)} />
        </label>
        {error && <div className="rounded-lg border border-red-300 bg-red-50 px-3 py-2 text-sm text-red-700">{error}</div>}
        <button
          type="submit"
          disabled={loading}
          className="w-full rounded-lg bg-emerald-600 px-4 py-2.5 font-semibold text-white hover:bg-emerald-700 disabled:opacity-50"
        >
          {loading ? 'Đang lưu...' : 'Đặt lại mật khẩu'}
        </button>
      </form>
    </div>
  )
}
