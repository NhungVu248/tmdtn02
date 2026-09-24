import { useState } from 'react'
import { Link, useNavigate, useSearchParams } from 'react-router-dom'
import { OtpInput } from '../components/OtpInput'
import { ApiError, api } from '../lib/api'

// UC-05 – Xác thực email bằng mã OTP (trang độc lập; dùng khi khách quay lại sau khi đăng ký).
export function VerifyEmailPage() {
  const navigate = useNavigate()
  const [params] = useSearchParams()
  const [email, setEmail] = useState(params.get('email') || '')
  const [otp, setOtp] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [info, setInfo] = useState<string | null>(null)
  const [verifying, setVerifying] = useState(false)
  const [verified, setVerified] = useState(false)

  async function verify(e: React.FormEvent) {
    e.preventDefault()
    setError(null)
    if (!email) return setError('Vui lòng nhập email đã đăng ký.')
    if (otp.length !== 6) return setError('Vui lòng nhập đủ 6 chữ số.')
    setVerifying(true)
    try {
      await api.verifyEmail(email, otp)
      setVerified(true)
      setTimeout(() => navigate('/login'), 1500)
    } catch (err) {
      setError(err instanceof ApiError ? err.message : 'Xác thực thất bại. Vui lòng thử lại.')
      setOtp('')
    } finally {
      setVerifying(false)
    }
  }

  async function resend() {
    setInfo(null)
    setError(null)
    if (!email) return setError('Vui lòng nhập email trước khi gửi lại mã.')
    try {
      const r = await api.resendVerification(email)
      setInfo(r.message)
    } catch {
      setError('Không gửi lại được. Vui lòng thử lại sau.')
    }
  }

  if (verified) {
    return (
      <div className="mx-auto max-w-md px-4 py-16 text-center">
        <div className="text-4xl">✅</div>
        <h1 className="mt-3 text-xl font-semibold">Xác thực thành công</h1>
        <p className="mt-2 text-slate-600">Đang chuyển tới trang đăng nhập…</p>
      </div>
    )
  }

  const field = 'w-full rounded-lg border border-slate-300 px-3 py-2 text-sm focus:border-emerald-500 focus:outline-none'
  return (
    <div className="mx-auto max-w-md px-4 py-16 text-center">
      <div className="text-4xl">📧</div>
      <h1 className="mt-3 text-xl font-semibold">Xác thực email</h1>
      <p className="mt-2 text-slate-600">Nhập email và mã OTP gồm 6 chữ số đã gửi tới hộp thư của bạn.</p>

      <form onSubmit={verify} className="mt-6 space-y-4 text-left">
        <input className={field} type="email" placeholder="Email đã đăng ký" value={email} onChange={(e) => setEmail(e.target.value)} />
        <OtpInput value={otp} onChange={setOtp} disabled={verifying} />
        {error && <p className="text-center text-sm text-red-600">{error}</p>}
        {info && <p className="text-center text-sm text-emerald-600">{info}</p>}
        <button type="submit" disabled={verifying || otp.length !== 6} className="w-full rounded-lg bg-emerald-600 px-4 py-2.5 font-semibold text-white hover:bg-emerald-700 disabled:opacity-50">
          {verifying ? 'Đang xác thực...' : 'Xác thực'}
        </button>
      </form>

      <button onClick={resend} className="mt-4 text-sm font-medium text-emerald-700 hover:underline">Gửi lại mã OTP</button>
      <p className="mt-6 text-sm text-slate-500">
        Đã xác thực?{' '}
        <Link to="/login" className="text-emerald-700 hover:underline">Đăng nhập</Link>
      </p>
    </div>
  )
}
