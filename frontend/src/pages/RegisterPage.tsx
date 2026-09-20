import { useState } from 'react'
import { Link } from 'react-router-dom'
import { GoogleSignInButton } from '../components/GoogleSignInButton'
import { ApiError, api, type RegisterResult } from '../lib/api'

const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/

export function RegisterPage() {
  const [name, setName] = useState('')
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [confirm, setConfirm] = useState('')
  const [terms, setTerms] = useState(false)

  const [error, setError] = useState<string | null>(null)
  const [emailExists, setEmailExists] = useState(false)
  const [loading, setLoading] = useState(false)
  const [done, setDone] = useState<RegisterResult | null>(null)
  const [resendMsg, setResendMsg] = useState<string | null>(null)

  // Kiểm tra hợp lệ phía client (đồng bộ với server).
  function clientValidate(): string | null {
    if (!EMAIL_RE.test(email)) return 'Định dạng email không hợp lệ'
    if (password.length < 8) return 'Mật khẩu phải có ít nhất 8 ký tự'
    if (!/[a-zA-Z]/.test(password) || !/[0-9]/.test(password)) return 'Mật khẩu phải gồm cả chữ và số'
    if (password !== confirm) return 'Xác nhận mật khẩu không khớp'
    if (!terms) return 'Bạn cần đồng ý điều khoản và chính sách bảo vệ dữ liệu cá nhân'
    return null
  }

  async function submit(e: React.FormEvent) {
    e.preventDefault()
    setError(null)
    setEmailExists(false)
    const v = clientValidate()
    if (v) {
      setError(v)
      return
    }
    setLoading(true)
    try {
      const res = await api.register({ email, password, confirmPassword: confirm, name, acceptedTerms: terms })
      setDone(res)
    } catch (err) {
      if (err instanceof ApiError) {
        setError(err.message)
        if (err.code === 'EMAIL_EXISTS') setEmailExists(true) // 3a
      } else {
        setError('Đăng ký thất bại. Vui lòng thử lại.')
      }
    } finally {
      setLoading(false)
    }
  }

  async function resend() {
    setResendMsg(null)
    try {
      const r = await api.resendVerification(done!.email)
      setResendMsg(r.message)
      if (r.devVerifyUrl) setDone({ ...done!, devVerifyUrl: r.devVerifyUrl, emailSent: true })
    } catch {
      setResendMsg('Không gửi lại được. Vui lòng thử lại sau.')
    }
  }

  // Màn hình sau khi đăng ký: nhắc kiểm tra email + gửi lại.
  if (done) {
    return (
      <div className="mx-auto max-w-md px-4 py-16 text-center">
        <div className="text-4xl">📧</div>
        <h1 className="mt-3 text-xl font-semibold">Kiểm tra email của bạn</h1>
        <p className="mt-2 text-slate-600">
          Chúng tôi đã gửi liên kết kích hoạt tới <strong>{done.email}</strong>. Vui lòng bấm liên kết để
          hoàn tất đăng ký.
        </p>
        {!done.emailSent && (
          <p className="mt-3 rounded-lg border border-amber-300 bg-amber-50 px-3 py-2 text-sm text-amber-800">
            Chưa gửi được email xác thực. Hãy thử gửi lại.
          </p>
        )}
        {/* Môi trường dev không có SMTP: hiện liên kết để hoàn tất luồng. */}
        {done.devVerifyUrl && (
          <p className="mt-3 break-all rounded-lg bg-slate-100 px-3 py-2 text-xs text-slate-600">
            [DEV] Liên kết xác thực:{' '}
            <a href={done.devVerifyUrl} className="text-emerald-700 underline">
              {done.devVerifyUrl}
            </a>
          </p>
        )}
        <button
          onClick={resend}
          className="mt-4 rounded-lg border border-slate-300 px-4 py-2 text-sm font-medium hover:bg-slate-50"
        >
          Gửi lại email xác thực
        </button>
        {resendMsg && <p className="mt-2 text-sm text-slate-500">{resendMsg}</p>}
        <p className="mt-6 text-sm text-slate-500">
          Đã xác thực?{' '}
          <Link to="/login" className="text-emerald-700 hover:underline">
            Đăng nhập
          </Link>
        </p>
      </div>
    )
  }

  const field = 'w-full rounded-lg border border-slate-300 px-3 py-2 text-sm focus:border-emerald-500 focus:outline-none'

  return (
    <div className="mx-auto max-w-md px-4 py-10">
      <h1 className="text-2xl font-bold">Đăng ký tài khoản</h1>
      <p className="mt-1 text-sm text-slate-500">Tạo tài khoản để lưu yêu thích, xem lịch sử đơn và đặt nhanh hơn.</p>

      <form onSubmit={submit} className="mt-6 space-y-4">
        <label className="block">
          <span className="mb-1 block text-sm font-medium">Họ tên</span>
          <input className={field} value={name} onChange={(e) => setName(e.target.value)} placeholder="Nguyễn Văn A" />
        </label>
        <label className="block">
          <span className="mb-1 block text-sm font-medium">Email *</span>
          <input className={field} type="email" value={email} onChange={(e) => setEmail(e.target.value)} placeholder="ban@example.com" />
        </label>
        <label className="block">
          <span className="mb-1 block text-sm font-medium">Mật khẩu *</span>
          <input className={field} type="password" value={password} onChange={(e) => setPassword(e.target.value)} placeholder="Tối thiểu 8 ký tự, gồm chữ và số" />
        </label>
        <label className="block">
          <span className="mb-1 block text-sm font-medium">Xác nhận mật khẩu *</span>
          <input className={field} type="password" value={confirm} onChange={(e) => setConfirm(e.target.value)} />
        </label>

        <label className="flex items-start gap-2 text-sm text-slate-600">
          <input type="checkbox" className="mt-1" checked={terms} onChange={(e) => setTerms(e.target.checked)} />
          <span>
            Tôi đồng ý với{' '}
            <Link to="/info/dieu-kien-giao-dich" className="text-emerald-700 hover:underline" target="_blank">
              Điều khoản sử dụng
            </Link>{' '}
            và{' '}
            <Link to="/info/bao-mat-du-lieu" className="text-emerald-700 hover:underline" target="_blank">
              Chính sách bảo vệ dữ liệu cá nhân
            </Link>
            .
          </span>
        </label>

        {error && (
          <div className="rounded-lg border border-red-300 bg-red-50 px-3 py-2 text-sm text-red-700">
            {error}
            {emailExists && (
              <>
                {' '}
                <Link to="/login" className="font-medium underline">
                  Đăng nhập
                </Link>
              </>
            )}
          </div>
        )}

        <button
          type="submit"
          disabled={loading}
          className="w-full rounded-lg bg-emerald-600 px-4 py-2.5 font-semibold text-white hover:bg-emerald-700 disabled:opacity-50"
        >
          {loading ? 'Đang tạo tài khoản...' : 'Đăng ký'}
        </button>
      </form>

      <div className="my-5 flex items-center gap-3 text-xs text-slate-400">
        <span className="h-px flex-1 bg-slate-200" /> hoặc <span className="h-px flex-1 bg-slate-200" />
      </div>
      <GoogleSignInButton />

      <p className="mt-6 text-center text-sm text-slate-500">
        Đã có tài khoản?{' '}
        <Link to="/login" className="text-emerald-700 hover:underline">
          Đăng nhập
        </Link>
      </p>
    </div>
  )
}
