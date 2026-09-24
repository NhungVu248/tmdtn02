import { useCallback, useEffect, useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import { OrderDetailCard, StatusBadge } from '../components/OrderDetailCard'
import { ErrorState, Loading } from '../components/StateBlocks'
import { ApiError, api, formatPrice, type OrderDetail, type OrderSummary } from '../lib/api'

const fmtDate = (s: string | null) => (s ? new Date(s).toLocaleDateString('vi-VN') : null)

// Thẻ một đơn đặt, hiển thị đầy đủ thông tin theo loại (homestay / tour).
function OrderCard({ o }: { o: OrderSummary }) {
  const isTour = o.type === 'TOUR'
  const meta: string[] = []
  if (!isTour && o.checkIn && o.checkOut) {
    meta.push(`${fmtDate(o.checkIn)} → ${fmtDate(o.checkOut)}`)
    if (o.nights) meta.push(`${o.nights} đêm`)
  } else if (isTour && o.checkIn) {
    meta.push(`Khởi hành ${fmtDate(o.checkIn)}`)
  }
  meta.push(`${o.guests} khách${o.children ? ` · ${o.children} trẻ em` : ''}`)

  return (
    <Link
      to={`/orders/${o.code}`}
      className="group flex overflow-hidden rounded-2xl border border-cream-200 bg-white transition duration-300 hover:-translate-y-0.5 hover:border-forest-300 hover:shadow-lg hover:shadow-forest-900/10"
    >
      <div className="relative w-28 shrink-0 overflow-hidden bg-cream-100 sm:w-36">
        {o.thumbnail && (
          <img
            src={o.thumbnail}
            alt=""
            className="h-full w-full object-cover transition duration-500 group-hover:scale-110"
          />
        )}
      </div>
      <div className="flex min-w-0 flex-1 flex-col p-4">
        <div className="flex items-start justify-between gap-3">
          <div className="min-w-0">
            <h3 className="truncate font-display text-lg font-semibold text-forest-900">{o.productName}</h3>
            <p className="mt-0.5 font-mono text-xs text-forest-400">{o.code}</p>
          </div>
          <StatusBadge status={o.status} />
        </div>

        <div className="mt-2 flex flex-wrap gap-x-3 gap-y-1 text-xs text-forest-500">
          {meta.map((m) => (
            <span key={m} className="inline-flex items-center gap-1">
              • {m}
            </span>
          ))}
        </div>

        <div className="mt-auto flex items-end justify-between pt-3">
          <div>
            <span className="text-xs text-forest-400">Tổng tiền</span>
            <p className="font-semibold text-clay-600">{formatPrice(o.totalPrice)}</p>
          </div>
          {o.status === 'COMPLETED' && (
            <span className="rounded-full bg-gold-400/15 px-3 py-1 text-xs font-medium text-gold-500">★ Viết đánh giá</span>
          )}
        </div>
      </div>
    </Link>
  )
}

// Một nhóm đơn (Homestay hoặc Tour).
function OrderGroup({ icon, title, orders }: { icon: string; title: string; orders: OrderSummary[] }) {
  return (
    <section>
      <div className="mb-4 flex items-center gap-3">
        <span className="grid h-10 w-10 place-items-center rounded-xl bg-forest-100 text-lg text-forest-700">{icon}</span>
        <div>
          <h2 className="font-display text-2xl font-semibold text-forest-900">{title}</h2>
          <p className="text-sm text-forest-400">{orders.length} đơn</p>
        </div>
      </div>
      {orders.length === 0 ? (
        <p className="rounded-2xl border border-dashed border-cream-300 bg-white/50 px-5 py-8 text-center text-sm text-forest-400">
          Chưa có đơn nào trong mục này.
        </p>
      ) : (
        <div className="grid gap-5 lg:grid-cols-2">
          {orders.map((o) => (
            <OrderCard key={o.code} o={o} />
          ))}
        </div>
      )}
    </section>
  )
}

// "Đơn của tôi": danh sách đơn của Customer đã đăng nhập, chia theo Homestay / Tour.
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

  const homestays = orders.filter((o) => o.type === 'HOMESTAY')
  const tours = orders.filter((o) => o.type === 'TOUR')

  return (
    <div className="mx-auto max-w-6xl px-6 py-10">
      <header className="mb-8">
        <h1 className="font-display text-4xl font-semibold text-forest-900">Đơn của tôi</h1>
        <p className="mt-2 text-forest-400">Theo dõi các đơn đặt homestay và tour của bạn tại một nơi.</p>
      </header>

      {orders.length === 0 ? (
        <div className="flex flex-col items-center justify-center rounded-3xl border border-cream-200 bg-white py-20 text-center">
          <div className="text-5xl">🧾</div>
          <p className="mt-4 font-display text-xl font-medium text-forest-800">Bạn chưa có đơn đặt nào</p>
          <p className="mt-1 text-sm text-forest-400">Khám phá homestay và tour để bắt đầu hành trình của bạn.</p>
          <Link
            to="/search"
            className="mt-6 rounded-full bg-forest-700 px-6 py-2.5 text-sm font-medium text-cream-50 transition hover:bg-forest-800"
          >
            Khám phá ngay →
          </Link>
        </div>
      ) : (
        <div className="space-y-12">
          <OrderGroup icon="⌂" title="Đặt phòng Homestay" orders={homestays} />
          <OrderGroup icon="✈" title="Tour du lịch" orders={tours} />
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
        <h1 className="mt-3 font-display text-xl font-semibold text-forest-900">Không tìm thấy đơn</h1>
        <p className="mt-1 text-forest-400">Đơn không tồn tại hoặc không thuộc tài khoản của bạn.</p>
        <Link to="/orders" className="mt-6 inline-block rounded-full bg-forest-700 px-5 py-2 text-sm font-medium text-cream-50 hover:bg-forest-800">
          ← Về Đơn của tôi
        </Link>
      </div>
    )
  }

  return (
    <div className="mx-auto max-w-3xl px-4 py-8">
      <nav className="mb-4 text-sm text-forest-400">
        <Link to="/orders" className="hover:text-forest-700">Đơn của tôi</Link> / <span className="text-forest-700">{order.code}</span>
      </nav>
      <OrderDetailCard order={order} onChanged={setOrder} />
    </div>
  )
}
