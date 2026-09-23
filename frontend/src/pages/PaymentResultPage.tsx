import { useEffect, useState } from 'react'
import { Link, useSearchParams } from 'react-router-dom'
import { Loading } from '../components/StateBlocks'
import { api, formatPrice } from '../lib/api'

// UC-11 – Trang kết quả sau khi VNPAY chuyển hướng về (?code=&status=success|failed|invalid).
export function PaymentResultPage() {
  const [params] = useSearchParams()
  const code = params.get('code') || ''
  const statusParam = params.get('status') || 'failed'
  const [info, setInfo] = useState<Awaited<ReturnType<typeof api.getPaymentStatus>> | null>(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    if (!code) {
      setLoading(false)
      return
    }
    api
      .getPaymentStatus(code)
      .then(setInfo)
      .catch(() => setInfo(null))
      .finally(() => setLoading(false))
  }, [code])

  if (loading) return <Loading label="Đang kiểm tra kết quả thanh toán..." />

  const ok = statusParam === 'success'
  const invalid = statusParam === 'invalid'

  return (
    <div className="mx-auto max-w-lg px-4 py-16 text-center">
      <div className="text-4xl">{ok ? '✅' : '❌'}</div>
      <h1 className="mt-3 text-2xl font-bold">
        {ok ? 'Đặt cọc thành công' : invalid ? 'Chữ ký không hợp lệ' : 'Thanh toán không thành công'}
      </h1>
      <p className="mt-1 text-slate-500">
        {ok
          ? 'Đơn của bạn đã được xác nhận.'
          : invalid
            ? 'Kết quả trả về không xác thực được (nghi ngờ giả mạo). Giao dịch bị từ chối.'
            : 'Giao dịch bị hủy hoặc thất bại. Bạn có thể thử lại trong thời hạn giữ chỗ.'}
      </p>

      {info && (
        <div className="mt-6 rounded-xl border border-slate-200 bg-white p-5 text-left text-sm">
          <div className="flex items-center justify-between">
            <span className="text-slate-500">Mã đơn</span>
            <span className="font-mono font-bold text-emerald-700">{info.code}</span>
          </div>
          <div className="mt-1 flex items-center justify-between">
            <span className="text-slate-500">Sản phẩm</span>
            <span>{info.productName}</span>
          </div>
          <div className="mt-1 flex items-center justify-between">
            <span className="text-slate-500">Đặt cọc</span>
            <span className="font-semibold">{formatPrice(info.depositAmount)}</span>
          </div>
          <div className="mt-1 flex items-center justify-between">
            <span className="text-slate-500">Trạng thái</span>
            <span>{info.status}</span>
          </div>
        </div>
      )}

      <Link to="/" className="mt-6 inline-block rounded-lg bg-emerald-600 px-4 py-2 text-sm font-medium text-white hover:bg-emerald-700">
        Về trang chủ
      </Link>
    </div>
  )
}
