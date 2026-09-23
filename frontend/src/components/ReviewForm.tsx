import { useState } from 'react'

// UC-15 – Biểu mẫu đánh giá (chấm sao + nhận xét), dùng chung cho Customer và Guest.
export function ReviewForm({
  onSubmit,
}: {
  onSubmit: (rating: number, comment: string) => Promise<void>
}) {
  const [rating, setRating] = useState(0)
  const [hoverRating, setHoverRating] = useState(0)
  const [comment, setComment] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [submitting, setSubmitting] = useState(false)

  async function submit(e: React.FormEvent) {
    e.preventDefault()
    setError(null)
    if (rating < 1) {
      setError('Vui lòng chọn số sao')
      return
    }
    setSubmitting(true)
    try {
      await onSubmit(rating, comment.trim())
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Gửi đánh giá thất bại. Vui lòng thử lại.')
    } finally {
      setSubmitting(false)
    }
  }

  return (
    <form onSubmit={submit} className="space-y-3">
      <div className="flex gap-1">
        {[1, 2, 3, 4, 5].map((n) => (
          <button
            key={n}
            type="button"
            onClick={() => setRating(n)}
            onMouseEnter={() => setHoverRating(n)}
            onMouseLeave={() => setHoverRating(0)}
            className="text-2xl leading-none"
            aria-label={`${n} sao`}
          >
            <span className={n <= (hoverRating || rating) ? 'text-amber-500' : 'text-slate-300'}>★</span>
          </button>
        ))}
      </div>
      <textarea
        value={comment}
        onChange={(e) => setComment(e.target.value)}
        placeholder="Chia sẻ trải nghiệm của bạn (không bắt buộc)..."
        rows={3}
        className="w-full rounded-lg border border-slate-300 px-3 py-2 text-sm focus:border-emerald-500 focus:outline-none"
      />
      {error && <p className="text-sm text-red-600">{error}</p>}
      <button
        type="submit"
        disabled={submitting}
        className="rounded-lg bg-amber-500 px-4 py-2 text-sm font-semibold text-white hover:bg-amber-600 disabled:opacity-50"
      >
        {submitting ? 'Đang gửi...' : 'Gửi đánh giá'}
      </button>
    </form>
  )
}
