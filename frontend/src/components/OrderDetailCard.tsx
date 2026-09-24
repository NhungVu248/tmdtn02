import { useState } from 'react'
import { Link } from 'react-router-dom'
import { ApiError, api, formatPrice, type OrderDetail } from '../lib/api'
import { ReviewForm } from './ReviewForm'

// UC-13 – Nhãn trạng thái đơn theo đúng vòng đời (chờ cọc → đã cọc → đã xác nhận → hoàn tất → đã hủy).
export const STATUS_LABEL: Record<string, string> = {
  PENDING_DEPOSIT: 'Chờ đặt cọc',
  DEPOSITED: 'Đã đặt cọc',
  CONFIRMED: 'Đã xác nhận',
  COMPLETED: 'Hoàn tất',
  CANCELLED: 'Đã hủy',
}

export const STATUS_COLOR: Record<string, string> = {
  PENDING_DEPOSIT: 'bg-amber-100 text-amber-700',
  DEPOSITED: 'bg-blue-100 text-blue-700',
  CONFIRMED: 'bg-emerald-100 text-emerald-700',
  COMPLETED: 'bg-slate-200 text-slate-700',
  CANCELLED: 'bg-red-100 text-red-700',
}

export function StatusBadge({ status }: { status: string }) {
  return (
    <span className={`rounded-full px-2.5 py-0.5 text-xs font-medium ${STATUS_COLOR[status] ?? 'bg-slate-100 text-slate-600'}`}>
      {STATUS_LABEL[status] ?? status}
    </span>
  )
}

interface Props {
  order: OrderDetail
  // Guest cần mã PIN hoặc email để xác thực khi hủy (UC-13/BR-58). Bỏ trống nếu là Customer đã đăng nhập.
  guestAuth?: { pin?: string; email?: string }
  onChanged?: (order: OrderDetail) => void
}

// UC-13 – Chi tiết đơn: sản phẩm, ngày, tiền, trạng thái, chính sách hủy, thao tác khả dụng (BR-52).
// UC-14 – Hủy đơn: xem trước mức hoàn tiền (bước 4) rồi xác nhận (bước 5) hoặc hủy thao tác (5a).
export function OrderDetailCard({ order, guestAuth, onChanged }: Props) {
  const isTour = order.type === 'TOUR'
  const [confirming, setConfirming] = useState(false)
  const [submitting, setSubmitting] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [reviewing, setReviewing] = useState(false)
  const [reviewDone, setReviewDone] = useState<string | null>(null)

  async function confirmCancel() {
    setSubmitting(true)
    setError(null)
    try {
      const r = await api.cancelOrder(order.code, guestAuth)
      onChanged?.(r.order)
      setConfirming(false)
    } catch (err) {
      setError(err instanceof ApiError ? err.message : 'Hủy đơn thất bại. Vui lòng thử lại.') // 2a/6a
    } finally {
      setSubmitting(false)
    }
  }

  // UC-15 – Customer gửi đánh giá trực tiếp từ "Đơn của tôi" (Guest đánh giá qua link email riêng).
  async function submitReview(rating: number, comment: string) {
    const r = await api.submitMyReview({ code: order.code, rating, comment: comment || undefined })
    setReviewDone(r.message)
    setReviewing(false)
  }

  return (
    <div className="rounded-xl border border-slate-200 bg-white p-5">
      <div className="flex items-start justify-between gap-3">
        <div>
          <p className="font-mono text-sm text-slate-500">{order.code}</p>
          <Link to={`${isTour ? '/tour/' : '/product/'}${order.productSlug}`} className="text-lg font-semibold hover:text-emerald-700">
            {order.productName}
          </Link>
        </div>
        <StatusBadge status={order.status} />
      </div>

      <div className="mt-3 space-y-1 text-sm text-slate-600">
        {isTour ? (
          <>
            <Row label="Ngày khởi hành" value={order.checkIn ? new Date(order.checkIn).toLocaleDateString('vi-VN') : '-'} />
            <Row label="Khách" value={`${order.guests} người lớn${order.children ? ` · ${order.children} trẻ em` : ''}`} />
          </>
        ) : (
          <>
            <Row
              label="Nhận / trả phòng"
              value={`${order.checkIn ? new Date(order.checkIn).toLocaleDateString('vi-VN') : '-'} → ${order.checkOut ? new Date(order.checkOut).toLocaleDateString('vi-VN') : '-'}`}
            />
            <Row label="Số đêm / khách" value={`${order.nights} đêm · ${order.guests} khách`} />
          </>
        )}
        <Row label="Người đặt" value={`${order.guestName} · ${order.guestEmail} · ${order.guestPhone}`} />
      </div>

      <hr className="my-3 border-slate-100" />
      <div className="space-y-1 text-sm">
        {!!order.discountAmount && (
          <Row label={`Mã giảm giá (${order.discountCode})`} value={`-${formatPrice(order.discountAmount)}`} />
        )}
        <Row label="Tổng tiền" value={formatPrice(order.totalPrice)} />
        <Row label="Đặt cọc" value={formatPrice(order.depositAmount)} strong />
        <Row label="Còn lại (trả sau)" value={formatPrice(order.remainingAmount)} />
        {order.paymentMethod && <Row label="Phương thức" value={order.paymentMethod} />}
      </div>

      {order.cancellationPolicy && (
        <>
          <hr className="my-3 border-slate-100" />
          <div>
            <h3 className="mb-1 text-sm font-semibold text-slate-900">Chính sách hủy</h3>
            <p className="text-xs text-slate-500">{order.cancellationPolicy}</p>
          </div>
        </>
      )}

      {order.status === 'CANCELLED' && (
        <div className="mt-4 rounded-lg bg-red-50 px-3 py-2 text-sm text-red-700">
          Đơn đã hủy{order.cancelledAt ? ` lúc ${new Date(order.cancelledAt).toLocaleString('vi-VN')}` : ''}.
        </div>
      )}

      {/* BR-52: thao tác khả dụng theo trạng thái. UC-14: hủy đơn với xem trước mức hoàn tiền. */}
      {(order.actions.canCancel || order.actions.canReview) && (
        <div className="mt-4">
          {error && <p className="mb-2 rounded-lg border border-red-300 bg-red-50 px-3 py-2 text-sm text-red-700">{error}</p>}

          {order.actions.canCancel && !confirming && (
            <button
              onClick={() => setConfirming(true)}
              className="rounded-lg border border-red-300 px-3 py-1.5 text-sm font-medium text-red-600 hover:bg-red-50"
            >
              Hủy đơn
            </button>
          )}

          {order.actions.canCancel && confirming && (
            <div className="rounded-lg border border-amber-300 bg-amber-50 p-4">
              <p className="text-sm font-medium text-amber-800">Xác nhận hủy đơn?</p>
              <div className="mt-2 text-sm text-amber-900">
                {order.cancelPreview.amountPaid === 0 ? (
                  <p>Chưa phát sinh khoản thanh toán — hủy sẽ không có hoàn tiền.</p>
                ) : (
                  <p>
                    Mức hoàn tiền dự kiến: <strong>{formatPrice(order.cancelPreview.refundAmount)}</strong> ({order.cancelPreview.ratio}% khoản đã cọc){' '}
                    theo chính sách hủy hiện hành.
                  </p>
                )}
              </div>
              <div className="mt-3 flex gap-2">
                <button
                  onClick={confirmCancel}
                  disabled={submitting}
                  className="rounded-lg bg-red-600 px-3 py-1.5 text-sm font-semibold text-white hover:bg-red-700 disabled:opacity-50"
                >
                  {submitting ? 'Đang hủy...' : 'Xác nhận hủy'}
                </button>
                <button
                  onClick={() => setConfirming(false)} // 5a: không xác nhận -> giữ nguyên đơn
                  disabled={submitting}
                  className="rounded-lg border border-slate-300 px-3 py-1.5 text-sm font-medium hover:bg-white"
                >
                  Đóng
                </button>
              </div>
            </div>
          )}

          {order.actions.canReview && reviewDone && (
            <p className="rounded-lg bg-emerald-50 px-3 py-2 text-sm text-emerald-700">{reviewDone}</p>
          )}

          {order.actions.canReview && !reviewDone && guestAuth && (
            // Guest chỉ đánh giá qua liên kết token trong email mời đánh giá (đặc tả UC-15).
            <p className="rounded-lg border border-amber-200 bg-amber-50 px-3 py-2 text-sm text-amber-700">
              Kiểm tra email <span className="font-medium">{order.guestEmail}</span> để nhận liên kết đánh giá đơn này.
            </p>
          )}

          {order.actions.canReview && !reviewDone && !guestAuth && !reviewing && (
            <button
              onClick={() => setReviewing(true)}
              className="rounded-lg border border-amber-300 px-3 py-1.5 text-sm font-medium text-amber-600 hover:bg-amber-50"
            >
              Đánh giá
            </button>
          )}

          {order.actions.canReview && !reviewDone && !guestAuth && reviewing && (
            <div className="rounded-lg border border-amber-200 bg-amber-50 p-4">
              <ReviewForm onSubmit={submitReview} />
              <button
                onClick={() => setReviewing(false)}
                className="mt-2 text-sm text-slate-500 hover:text-slate-700"
              >
                Hủy
              </button>
            </div>
          )}
        </div>
      )}
    </div>
  )
}

function Row({ label, value, strong }: { label: string; value: string; strong?: boolean }) {
  return (
    <div className="flex items-center justify-between gap-3">
      <span className="text-slate-500">{label}</span>
      <span className={strong ? 'font-bold text-emerald-700' : 'text-right text-slate-800'}>{value}</span>
    </div>
  )
}
