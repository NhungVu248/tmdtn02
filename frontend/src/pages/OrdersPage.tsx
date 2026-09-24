import { useCallback, useEffect, useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import { OrderDetailCard, StatusBadge } from '../components/OrderDetailCard'
import { ErrorState, Loading } from '../components/StateBlocks'
import { ApiError, api, formatPrice, type OrderDetail, type OrderSummary } from '../lib/api'

// UC-13 – "Đơn của tôi": danh sách đơn của Customer đã đăng nhập (BR-49).
export function OrdersPage() {
  const [orders, setOrders] = useState<OrderSummary[]>([])
  const [status, setStatus] = useState<'loading' | 'ok' | 'error'>('loading')

  const load = useCallback(() => {
    setStatus('loading')
    api
      .getMyOrders()
      .then((r) => {
        setOrders(r.orders)
        setStatus('ok')
      })
      .catch(() => setStatus('error'))
  }, [])

  useEffect(() => {
    load()
  }, [load])

  if (status === 'loading') return <Loading />
  if (status === 'error') return <ErrorState onRetry={load} />

  return (
    <div className="mx-auto max-w-3xl px-4 py-8">
      <h1 className="mb-6 text-2xl font-bold">Đơn của tôi</h1>

      {orders.length === 0 ? (
        // 2a: Customer không có đơn nào.
        <div className="flex flex-col items-center justify-center py-16 text-center text-slate-500">
          <div className="text-4xl">🧾</div>
          <p className="mt-3 font-medium text-slate-700">Bạn chưa có đơn đặt nào</p>
          <Link to="/search" className="mt-5 rounded-lg bg-emerald-600 px-4 py-2 text-sm font-medium text-white hover:bg-emerald-700">
            Khám phá sản phẩm
          </Link>
        </div>
      ) : (
        <div className="space-y-3">
          {orders.map((o) => (
            <Link
              key={o.code}
              to={`/orders/${o.code}`}
              className="flex items-center gap-4 rounded-xl border border-slate-200 bg-white p-4 transition hover:border-emerald-400 hover:shadow-sm"
            >
              {o.thumbnail && <img src={o.thumbnail} alt="" className="h-16 w-20 shrink-0 rounded-lg object-cover" />}
              <div className="min-w-0 flex-1">
                <p className="truncate font-medium">{o.productName}</p>
                <p className="font-mono text-xs text-slate-400">{o.code}</p>
              </div>
              <div className="shrink-0 text-right">
                <StatusBadge status={o.status} />
                <p className="mt-1 text-sm font-semibold text-slate-700">{formatPrice(o.totalPrice)}</p>
                {/* UC-15: đơn đã hoàn tất -> gợi ý viết đánh giá ngay trên danh sách */}
                {o.status === 'COMPLETED' && (
                  <span className="mt-1 inline-block rounded-full bg-amber-100 px-2 py-0.5 text-xs font-medium text-amber-700">★ Viết đánh giá</span>
                )}
              </div>
            </Link>
          ))}
        </div>
      )}
    </div>
  )
}

// UC-13 – Chi tiết một đơn của Customer.
export function OrderDetailPage() {
  const { code } = useParams<{ code: string }>()
  const [order, setOrder] = useState<OrderDetail | null>(null)
  const [status, setStatus] = useState<'loading' | 'ok' | 'error' | 'notfound'>('loading')

  const load = useCallback(() => {
    if (!code) return
    setStatus('loading')
    api
      .getMyOrder(code)
      .then((r) => {
        setOrder(r.order)
        setStatus('ok')
      })
      .catch((err) => setStatus(err instanceof ApiError && err.status === 404 ? 'notfound' : 'error'))
  }, [code])

  useEffect(() => {
    load()
  }, [load])

  if (status === 'loading') return <Loading />
  if (status === 'error') return <ErrorState onRetry={load} />
  if (status === 'notfound' || !order) {
    return (
      <div className="mx-auto max-w-lg px-4 py-16 text-center">
        <div className="text-4xl">🔒</div>
        <h1 className="mt-3 text-xl font-semibold">Không tìm thấy đơn</h1>
        <p className="mt-1 text-slate-500">Đơn không tồn tại hoặc không thuộc tài khoản của bạn.</p>
        <Link to="/orders" className="mt-6 inline-block rounded-lg bg-emerald-600 px-4 py-2 text-sm font-medium text-white hover:bg-emerald-700">
          ← Về Đơn của tôi
        </Link>
      </div>
    )
  }

  return (
    <div className="mx-auto max-w-2xl px-4 py-8">
      <nav className="mb-4 text-sm text-slate-500">
        <Link to="/orders" className="hover:text-emerald-700">Đơn của tôi</Link> / <span className="text-slate-700">{order.code}</span>
      </nav>
      <OrderDetailCard order={order} onChanged={setOrder} />
    </div>
  )
}
