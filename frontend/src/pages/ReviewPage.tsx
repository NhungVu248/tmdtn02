import { useEffect, useState } from 'react'
import { Link, useSearchParams } from 'react-router-dom'
import { ReviewForm } from '../components/ReviewForm'
import { Loading } from '../components/StateBlocks'
import { ApiError, api } from '../lib/api'

// UC-15 (luồng thay thế 1a) – Guest mở biểu mẫu đánh giá qua liên kết token trong email mời đánh giá.
export function ReviewPage() {
  const [params] = useSearchParams()
  const token = params.get('token') ?? ''

  const [context, setContext] = useState<{ productName: string; productSlug: string; thumbnail: string | null } | null>(null)
  const [status, setStatus] = useState<'loading' | 'ok' | 'error'>('loading')
  const [errorMsg, setErrorMsg] = useState('')
  const [done, setDone] = useState<string | null>(null)

  useEffect(() => {
    if (!token) {
      setStatus('error')
      setErrorMsg('Thiếu mã đánh giá trong liên kết.')
      return
    }
    api
      .getReviewContext(token)
      .then((c) => {
        setContext(c)
        setStatus('ok')
      })
      .catch((err) => {
        // 4a/4b: đơn chưa hoàn tất / đã đánh giá / token hết hạn hoặc đã dùng.
        setErrorMsg(err instanceof ApiError ? err.message : 'Liên kết đánh giá không hợp lệ.')
        setStatus('error')
      })
  }, [token])

  async function submit(rating: number, comment: string, images: string[]) {
    const r = await api.submitGuestReview({ token, rating, comment: comment || undefined, images })
    setDone(r.message)
  }

  if (status === 'loading') return <Loading />

  if (status === 'error') {
    return (
      <div className="mx-auto max-w-md px-4 py-16 text-center">
        <div className="text-4xl">⚠️</div>
        <h1 className="mt-3 text-xl font-semibold">Không thể mở biểu mẫu đánh giá</h1>
        <p className="mt-2 text-slate-500">{errorMsg}</p>
        <Link to="/" className="mt-6 inline-block rounded-lg bg-emerald-600 px-4 py-2 text-sm font-medium text-white hover:bg-emerald-700">
          Về trang chủ
        </Link>
      </div>
    )
  }

  if (done) {
    return (
      <div className="mx-auto max-w-md px-4 py-16 text-center">
        <div className="text-4xl">🎉</div>
        <h1 className="mt-3 text-xl font-semibold">Đã gửi đánh giá</h1>
        <p className="mt-2 text-slate-500">{done}</p>
        <Link to="/" className="mt-6 inline-block rounded-lg bg-emerald-600 px-4 py-2 text-sm font-medium text-white hover:bg-emerald-700">
          Về trang chủ
        </Link>
      </div>
    )
  }

  return (
    <div className="mx-auto max-w-md px-4 py-10">
      <h1 className="mb-1 text-2xl font-bold">Chia sẻ trải nghiệm của bạn</h1>
      {context && (
        <div className="mb-6 flex items-center gap-3">
          {context.thumbnail && <img src={context.thumbnail} alt="" className="h-14 w-16 rounded-lg object-cover" />}
          <Link to={`/product/${context.productSlug}`} className="font-medium hover:text-emerald-700">
            {context.productName}
          </Link>
        </div>
      )}
      <div className="rounded-xl border border-slate-200 bg-white p-5">
        <ReviewForm onSubmit={submit} />
      </div>
    </div>
  )
}
