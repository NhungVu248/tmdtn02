import { useRef, useState } from 'react'
import { api } from '../lib/api'

// UC-15 – Biểu mẫu đánh giá (chấm sao + nhận xét + ảnh đính kèm), dùng chung cho Customer và Guest.
export function ReviewForm({
  onSubmit,
}: {
  onSubmit: (rating: number, comment: string, images: string[]) => Promise<void>
}) {
  const [rating, setRating] = useState(0)
  const [hoverRating, setHoverRating] = useState(0)
  const [comment, setComment] = useState('')
  const [images, setImages] = useState<string[]>([])
  const [uploading, setUploading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [submitting, setSubmitting] = useState(false)
  const fileInput = useRef<HTMLInputElement>(null)

  async function onPickFiles(e: React.ChangeEvent<HTMLInputElement>) {
    const files = Array.from(e.target.files ?? [])
    if (!files.length) return
    const room = 6 - images.length
    if (room <= 0) {
      setError('Tối đa 6 ảnh cho mỗi đánh giá')
      return
    }
    setUploading(true)
    setError(null)
    try {
      const { images: urls } = await api.uploadReviewImages(files.slice(0, room))
      setImages((prev) => [...prev, ...urls].slice(0, 6))
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Tải ảnh thất bại')
    } finally {
      setUploading(false)
      if (fileInput.current) fileInput.current.value = ''
    }
  }

  function removeImage(url: string) {
    setImages((prev) => prev.filter((u) => u !== url))
  }

  async function submit(e: React.FormEvent) {
    e.preventDefault()
    setError(null)
    if (rating < 1) {
      setError('Vui lòng chọn số sao')
      return
    }
    setSubmitting(true)
    try {
      await onSubmit(rating, comment.trim(), images)
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

      {/* Ảnh đính kèm */}
      <div>
        <div className="flex flex-wrap gap-2">
          {images.map((url) => (
            <div key={url} className="group relative h-16 w-16 overflow-hidden rounded-lg border border-slate-200">
              <img src={url} alt="" className="h-full w-full object-cover" />
              <button
                type="button"
                onClick={() => removeImage(url)}
                className="absolute right-0.5 top-0.5 hidden rounded-full bg-black/70 px-1.5 text-xs text-white group-hover:block"
                aria-label="Xóa ảnh"
              >
                ✕
              </button>
            </div>
          ))}
          {images.length < 6 && (
            <label className="flex h-16 w-16 cursor-pointer flex-col items-center justify-center rounded-lg border border-dashed border-slate-300 text-center text-[11px] leading-tight text-slate-500 hover:border-emerald-500">
              {uploading ? '...' : <><span className="text-lg leading-none">＋</span>Ảnh</>}
              <input
                ref={fileInput}
                type="file"
                accept="image/jpeg,image/png,image/webp"
                multiple
                className="hidden"
                onChange={onPickFiles}
                disabled={uploading}
              />
            </label>
          )}
        </div>
        <p className="mt-1 text-xs text-slate-400">Thêm tối đa 6 ảnh (JPEG/PNG/WEBP, ≤5MB mỗi ảnh).</p>
      </div>

      {error && <p className="text-sm text-red-600">{error}</p>}
      <button
        type="submit"
        disabled={submitting || uploading}
        className="rounded-lg bg-amber-500 px-4 py-2 text-sm font-semibold text-white hover:bg-amber-600 disabled:opacity-50"
      >
        {submitting ? 'Đang gửi...' : 'Gửi đánh giá'}
      </button>
    </form>
  )
}
