import { useEffect, useRef, useState } from 'react'
import { Link, useSearchParams } from 'react-router-dom'
import { Loading } from '../components/StateBlocks'
import { api } from '../lib/api'

// UC-05 – Xác thực email từ liên kết trong thư (bước 5-6).
export function VerifyEmailPage() {
  const [params] = useSearchParams()
  const token = params.get('token')
  const [status, setStatus] = useState<'loading' | 'ok' | 'error'>('loading')
  const [message, setMessage] = useState('')
  // Token dùng một lần: chống gọi 2 lần (React StrictMode dev double-invoke effect).
  const ran = useRef(false)

  useEffect(() => {
    if (ran.current) return
    ran.current = true

    if (!token) {
      setStatus('error')
      setMessage('Thiếu mã xác thực trong liên kết.')
      return
    }
    api
      .verifyEmail(token)
      .then((r) => {
        setStatus('ok')
        setMessage(r.message)
      })
      .catch((err) => {
        setStatus('error')
        setMessage(err?.message || 'Liên kết xác thực không hợp lệ hoặc đã hết hạn.')
      })
  }, [token])

  if (status === 'loading') return <Loading label="Đang xác thực email..." />

  return (
    <div className="mx-auto max-w-md px-4 py-16 text-center">
      <div className="text-4xl">{status === 'ok' ? '✅' : '⚠️'}</div>
      <h1 className="mt-3 text-xl font-semibold">
        {status === 'ok' ? 'Xác thực thành công' : 'Xác thực không thành công'}
      </h1>
      <p className="mt-2 text-slate-600">{message}</p>
      {status === 'ok' ? (
        <Link
          to="/login"
          className="mt-6 inline-block rounded-lg bg-emerald-600 px-4 py-2 text-sm font-medium text-white hover:bg-emerald-700"
        >
          Đăng nhập
        </Link>
      ) : (
        <Link
          to="/register"
          className="mt-6 inline-block rounded-lg border border-slate-300 px-4 py-2 text-sm font-medium hover:bg-slate-50"
        >
          Quay lại đăng ký
        </Link>
      )}
    </div>
  )
}
