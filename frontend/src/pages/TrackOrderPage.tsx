import { useEffect, useState } from 'react'
import { useSearchParams } from 'react-router-dom'
import { OrderDetailCard } from '../components/OrderDetailCard'
import { Loading } from '../components/StateBlocks'
import { ApiError, api, type OrderDetail } from '../lib/api'

const field = 'w-full rounded-lg border border-slate-300 px-3 py-2 text-sm focus:border-emerald-500 focus:outline-none'

// UC-13 – Guest tra cứu đơn bằng mã đơn + PIN (hoặc email). BR-50/51/3a/3b.
export function TrackOrderPage() {
  const [params] = useSearchParams()
  const [code, setCode] = useState(params.get('code') ?? '')
  const [pin, setPin] = useState(params.get('pin') ?? '')
  const [email, setEmail] = useState('')
  const [order, setOrder] = useState<OrderDetail | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [loading, setLoading] = useState(false)
  const [autoRan, setAutoRan] = useState(false)

  async function submit(e?: React.FormEvent) {
    e?.preventDefault()
    setError(null)
    setOrder(null)
    if (!code.trim() || (!pin.trim() && !email.trim())) {
      setError('Vui lòng nhập mã đơn và PIN hoặc email') // BR-50
      return
    }
    setLoading(true)
    try {
      const r = await api.lookupOrder({
        code: code.trim(),
        pin: pin.trim() || undefined,
        email: email.trim() || undefined,
      })
      setOrder(r.order)
    } catch (err) {
      setError(err instanceof ApiError ? err.message : 'Không tra cứu được đơn. Vui lòng thử lại.')
    } finally {
      setLoading(false)
    }
  }

  // 3a: đến từ liên kết trong email (đã có sẵn code + pin) -> tự tra cứu, không cần nhập lại.
  useEffect(() => {
    if (!autoRan && params.get('code') && params.get('pin')) {
      setAutoRan(true)
      submit()
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [autoRan])

  return (
    <div className="mx-auto max-w-2xl px-4 py-8">
      <h1 className="mb-2 text-2xl font-bold">Tra cứu đơn hàng</h1>
      <p className="mb-6 text-sm text-slate-500">
        Dành cho khách đặt không đăng nhập. Nhập mã đơn cùng PIN hoặc email đã dùng khi đặt.
      </p>

      <form onSubmit={submit} className="space-y-3 rounded-xl border border-slate-200 bg-white p-5">
        <input className={`${field} font-mono uppercase`} placeholder="Mã đơn (VD: BK-XXXXXXXXX)" value={code} onChange={(e) => setCode(e.target.value.toUpperCase())} />
        <div className="grid grid-cols-2 gap-3">
          <input className={field} placeholder="Mã PIN" value={pin} onChange={(e) => setPin(e.target.value)} />
          <input className={field} type="email" placeholder="hoặc Email đã đặt" value={email} onChange={(e) => setEmail(e.target.value)} />
        </div>
        {error && <div className="rounded-lg border border-red-300 bg-red-50 px-3 py-2 text-sm text-red-700">{error}</div>}
        <button
          type="submit"
          disabled={loading}
          className="w-full rounded-lg bg-emerald-600 px-4 py-2.5 font-semibold text-white hover:bg-emerald-700 disabled:opacity-50"
        >
          {loading ? 'Đang tra cứu...' : 'Tra cứu'}
        </button>
      </form>

      {loading && !order && <div className="mt-6"><Loading /></div>}

      {order && (
        <div className="mt-6">
          <OrderDetailCard
            order={order}
            guestAuth={{ pin: pin.trim() || undefined, email: email.trim() || undefined }}
            onChanged={setOrder}
          />
        </div>
      )}
    </div>
  )
}
