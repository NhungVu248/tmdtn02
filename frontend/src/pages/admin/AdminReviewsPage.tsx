import { useCallback, useEffect, useState } from 'react'
import { AdminApiError, adminApi, type AdminReview } from '../../lib/adminApi'

const field = 'rounded-lg border border-slate-700 bg-slate-800 px-3 py-2 text-sm text-slate-100 focus:border-emerald-500 focus:outline-none'

const STATUS_LABEL: Record<string, string> = { PENDING: 'Chờ kiểm duyệt', APPROVED: 'Đã duyệt', REJECTED: 'Từ chối/ẩn' }

function Stars({ n }: { n: number }) {
  return <span className="text-amber-400">{'★'.repeat(n)}{'☆'.repeat(5 - n)}</span>
}

// UC-21 – Kiểm duyệt đánh giá: duyệt / từ chối / ẩn (BR-103→107).
export function AdminReviewsPage() {
  const [items, setItems] = useState<AdminReview[]>([])
  const [status, setStatus] = useState('PENDING')
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [busyId, setBusyId] = useState<number | null>(null)

  const load = useCallback(() => {
    setLoading(true)
    adminApi
      .listReviews({ status: status || undefined })
      .then((r) => setItems(r.items))
      .catch(() => setError('Không tải được danh sách đánh giá'))
      .finally(() => setLoading(false))
  }, [status])

  useEffect(() => {
    load()
  }, [load])

  async function approve(r: AdminReview) {
    setError(null)
    setBusyId(r.id)
    try {
      await adminApi.approveReview(r.id)
      load()
    } catch (err) {
      setError(err instanceof AdminApiError ? err.message : 'Duyệt thất bại')
    } finally {
      setBusyId(null)
    }
  }

  async function reject(r: AdminReview) {
    setError(null)
    setBusyId(r.id)
    try {
      await adminApi.rejectReview(r.id)
      load()
    } catch (err) {
      setError(err instanceof AdminApiError ? err.message : 'Thao tác thất bại')
    } finally {
      setBusyId(null)
    }
  }

  return (
    <div>
      <h1 className="mb-6 text-2xl font-bold text-white">Kiểm duyệt đánh giá</h1>

      <div className="mb-4 flex gap-3">
        <select value={status} onChange={(e) => setStatus(e.target.value)} className={field}>
          <option value="PENDING">Chờ kiểm duyệt</option>
          <option value="APPROVED">Đã duyệt</option>
          <option value="REJECTED">Từ chối/ẩn</option>
          <option value="">Tất cả</option>
        </select>
      </div>

      {error && <div className="mb-4 rounded-lg border border-red-800 bg-red-950/40 px-4 py-2 text-sm text-red-300">⚠️ {error}</div>}

      {loading ? (
        <p className="text-slate-500">Đang tải...</p>
      ) : items.length === 0 ? (
        <p className="text-slate-500">Không có đánh giá nào ở trạng thái này.</p>
      ) : (
        <div className="space-y-3">
          {items.map((r) => (
            <div key={r.id} className="rounded-xl border border-slate-800 bg-slate-950 p-4">
              <div className="mb-2 flex flex-wrap items-center justify-between gap-2">
                <div>
                  <span className="font-semibold text-slate-200">{r.authorName}</span>{' '}
                  <span className="text-xs text-slate-500">
                    · {r.product?.name} · {new Date(r.createdAt).toLocaleString('vi-VN')}
                  </span>
                </div>
                <span
                  className={`rounded-full px-2 py-0.5 text-xs ${
                    r.approved ? 'bg-emerald-900 text-emerald-300' : r.rejected ? 'bg-red-950 text-red-300' : 'bg-amber-900 text-amber-300'
                  }`}
                >
                  {STATUS_LABEL[r.approved ? 'APPROVED' : r.rejected ? 'REJECTED' : 'PENDING']}
                </span>
              </div>
              <div className="mb-2">
                <Stars n={r.rating} />
              </div>
              {r.comment && <p className="mb-3 text-sm text-slate-300">{r.comment}</p>}
              <div className="flex gap-2">
                {!r.approved && (
                  <button
                    disabled={busyId === r.id}
                    onClick={() => approve(r)}
                    className="rounded-lg bg-emerald-600 px-3 py-1.5 text-sm font-semibold text-white hover:bg-emerald-700 disabled:opacity-50"
                  >
                    Duyệt hiển thị
                  </button>
                )}
                {!r.rejected && (
                  <button
                    disabled={busyId === r.id}
                    onClick={() => reject(r)}
                    className="rounded-lg border border-red-800 px-3 py-1.5 text-sm text-red-300 hover:bg-red-950/40 disabled:opacity-50"
                  >
                    {r.approved ? 'Ẩn (vi phạm)' : 'Từ chối'}
                  </button>
                )}
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}
