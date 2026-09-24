import { useEffect, useMemo, useState } from 'react'
import { Link, useParams, useSearchParams } from 'react-router-dom'
import { ErrorState, Loading } from '../components/StateBlocks'
import { ApiError, api, formatPrice, type BookingResult, type DetailResponse } from '../lib/api'
import { useAuth } from '../lib/auth'

function nightsCount(from: string, to: string): number {
  const a = new Date(from).getTime()
  const b = new Date(to).getTime()
  if (isNaN(a) || isNaN(b)) return 0
  return Math.max(0, Math.round((b - a) / 86400000))
}

// UC-09/UC-10 – Đặt homestay/tour (hỗ trợ guest checkout). Đến từ nút "Đặt ngay" ở UC-03.
export function BookingPage() {
  const { slug } = useParams<{ slug: string }>()
  const [params] = useSearchParams()
  // Homestay: from/to; Tour: date (ngày khởi hành) + children.
  const from = params.get('from') || ''
  const to = params.get('to') || ''
  const date = params.get('date') || ''
  const guests = Number(params.get('guests')) || 2
  const children = Number(params.get('children')) || 0
  const roomTypeId = Number(params.get('roomTypeId')) || 0
  const { user } = useAuth()

  const [detail, setDetail] = useState<DetailResponse | null>(null)
  const [depositRate, setDepositRate] = useState(0.3)
  const [vnpayEnabled, setVnpayEnabled] = useState(false)
  const [status, setStatus] = useState<'loading' | 'ok' | 'error'>('loading')

  // Bước thanh toán cọc (UC-11)
  const [paying, setPaying] = useState<'COD' | 'VNPAY' | null>(null)
  const [paid, setPaid] = useState(false)
  const [payError, setPayError] = useState<string | null>(null)

  const [name, setName] = useState('')
  const [email, setEmail] = useState('')
  const [phone, setPhone] = useState('')
  const [terms, setTerms] = useState(false)
  const [submitting, setSubmitting] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [result, setResult] = useState<BookingResult | null>(null)

  // UC-12 (extend UC-09/10) – Mã giảm giá.
  const [discountInput, setDiscountInput] = useState('')
  const [applied, setApplied] = useState<{ code: string; discount: number } | null>(null)
  const [discountMsg, setDiscountMsg] = useState<string | null>(null)
  const [applyingDiscount, setApplyingDiscount] = useState(false)

  useEffect(() => {
    if (!slug) return
    Promise.all([api.getBookingConfig(), api.getPaymentConfig()])
      .then(async ([cfg, pay]) => {
        setDepositRate(cfg.depositRate)
        setVnpayEnabled(pay.vnpayEnabled)
        // Homestay (Property) hay Tour (bảng riêng)? Thử homestay trước, 404 -> tour.
        try {
          const pd = await api.getPropertyDetail(slug)
          const rt = roomTypeId ? pd.property.roomTypes.find((r) => r.id === roomTypeId) : pd.property.roomTypes[0]
          const policyText = pd.property.cancellationPolicy
            ? [
                pd.property.cancellationPolicy.freeHours > 0 ? `Miễn phí hủy trong ${pd.property.cancellationPolicy.freeHours} giờ đầu.` : '',
                ...pd.property.cancellationPolicy.milestones.map((m) => `Hủy trước ≥ ${m.daysBefore} ngày: hoàn ${m.refundRate}%.`),
                'Hủy sát ngày hơn: không hoàn tiền.',
              ].filter(Boolean).join(' ')
            : ''
          if (pd.property.depositRate != null) setDepositRate(pd.property.depositRate / 100)
          setDetail({
            product: {
              id: pd.property.id,
              name: pd.property.name,
              slug: pd.property.slug,
              type: 'HOMESTAY',
              location: pd.property.address,
              price: rt?.basePricePerNight ?? pd.property.basePrice,
              priceChild: null,
              rating: pd.property.avgRating,
              thumbnail: pd.property.thumbnail,
              isFeatured: false,
              categoryId: null,
              description: pd.property.description,
              cancellationPolicy: policyText,
              itinerary: null,
              images: [],
              category: null,
              departures: [],
            } as unknown as DetailResponse['product'],
            reviews: [],
            similar: [],
          })
        } catch {
          // Tour: dựng product-shape tương thích từ chuyến khớp `date` + giá theo loại khách.
          const td = await api.getTourDetail(slug)
          const dep = td.tour.departures.find((x) => x.departureDate.slice(0, 10) === date) ?? td.tour.departures[0]
          const priceOf = (t: 'ADULT' | 'CHILD') => dep?.prices.find((p) => p.paxType === t)?.price ?? td.tour.basePrice
          const policyText = td.tour.cancellationPolicy
            ? [
                td.tour.cancellationPolicy.freeHours > 0 ? `Miễn phí hủy trong ${td.tour.cancellationPolicy.freeHours} giờ đầu.` : '',
                ...td.tour.cancellationPolicy.milestones.map((m) => `Hủy trước ≥ ${m.daysBefore} ngày: hoàn ${m.refundRate}%.`),
                'Hủy sát ngày hơn: không hoàn tiền.',
              ]
                .filter(Boolean)
                .join(' ')
            : ''
          if (td.tour.depositRate != null) setDepositRate(td.tour.depositRate / 100)
          setDetail({
            product: {
              id: td.tour.id,
              name: td.tour.title,
              slug: td.tour.slug,
              type: 'TOUR',
              location: td.tour.destination,
              price: priceOf('ADULT'),
              priceChild: priceOf('CHILD'),
              rating: td.tour.avgRating,
              thumbnail: td.tour.thumbnail,
              isFeatured: false,
              categoryId: null,
              description: td.tour.description,
              cancellationPolicy: policyText,
              itinerary: null,
              images: [],
              category: null,
              departures: [],
            } as unknown as DetailResponse['product'],
            reviews: [],
            similar: [],
          })
        }
        setStatus('ok')
      })
      .catch(() => setStatus('error'))
  }, [slug, date, roomTypeId])

  useEffect(() => {
    if (user) {
      setName(user.name ?? '')
      setEmail(user.email ?? '')
      setPhone(user.phone ?? '')
    }
  }, [user])

  const product = detail?.product
  const isTour = product?.type === 'TOUR'
  const nights = useMemo(() => nightsCount(from, to), [from, to])

  const priceChild = product?.priceChild ?? product?.price ?? 0
  const total = product
    ? isTour
      ? product.price * guests + priceChild * children
      : product.price * nights
    : 0
  // BR-46: cọc tính trên tổng SAU khi trừ mã giảm giá (nếu có).
  const payableTotal = applied ? Math.max(0, total - applied.discount) : total
  const deposit = Math.round(payableTotal * depositRate)
  const remaining = payableTotal - deposit

  // 1a: gỡ mã đã áp dụng -> khôi phục tổng tiền/cọc ban đầu.
  function removeDiscount() {
    setApplied(null)
    setDiscountMsg(null)
    setDiscountInput('')
  }

  // Nhập mã & bấm "Áp dụng" (1b: nhập mã khác sẽ tự thay thế mã cũ — BR-44 chỉ 1 mã/đơn).
  async function applyDiscountCode() {
    if (!discountInput.trim() || !product || !slug) return
    setApplyingDiscount(true)
    setDiscountMsg(null)
    try {
      const r = await api.applyDiscount({ code: discountInput.trim(), type: product.type, subtotal: total, slug })
      if (r.applied && r.code && r.discount != null) {
        setApplied({ code: r.code, discount: r.discount })
        setDiscountMsg(null)
      } else {
        setApplied(null)
        setDiscountMsg(r.message || 'Mã không hợp lệ hoặc đã hết hạn') // 2a/2b/3a
      }
    } catch (err) {
      setApplied(null)
      setDiscountMsg(err instanceof ApiError ? err.message : 'Không áp dụng được mã. Vui lòng thử lại.')
    } finally {
      setApplyingDiscount(false)
    }
  }

  async function submit(e: React.FormEvent) {
    e.preventDefault()
    setError(null)
    if (!terms) {
      setError('Vui lòng đồng ý điều khoản và chính sách trước khi đặt') // 5a
      return
    }
    if (!name || !email || !phone) {
      setError('Vui lòng nhập đầy đủ họ tên, email và số điện thoại')
      return
    }
    setSubmitting(true)
    try {
      const contact = {
        guestName: name,
        guestEmail: email,
        guestPhone: phone,
        acceptedTerms: terms,
        discountCode: applied?.code,
      }
      const r = isTour
        ? await api.createTourBooking({ slug: slug!, date, guests, children, ...contact })
        : await api.createHomestayBooking({ slug: slug!, checkIn: from, checkOut: to, guests, roomTypeId: roomTypeId || undefined, ...contact })
      setResult(r)
    } catch (err) {
      setError(err instanceof ApiError ? err.message : 'Đặt chỗ thất bại. Vui lòng thử lại.')
    } finally {
      setSubmitting(false)
    }
  }

  async function pay(method: 'COD' | 'VNPAY') {
    if (!result) return
    setPayError(null)
    setPaying(method)
    try {
      const r = await api.createPayment(result.booking.code, method)
      if (r.status === 'redirect' && r.redirectUrl) {
        window.location.href = r.redirectUrl // sang trang cổng VNPAY (BR-38)
        return
      }
      if (r.status === 'success' || r.status === 'already_paid') {
        setPaid(true)
      } else {
        setPayError('Không thể tạo thanh toán. Vui lòng thử lại.')
      }
    } catch (err) {
      setPayError(err instanceof ApiError ? err.message : 'Thanh toán thất bại. Vui lòng thử lại.')
    } finally {
      setPaying(null)
    }
  }

  if (status === 'loading') return <Loading />
  if (status === 'error' || !product) return <ErrorState onRetry={() => location.reload()} />

  // Sau khi tạo đơn: bước thanh toán đặt cọc (UC-11), rồi màn hình hoàn tất.
  if (result) {
    const b = result.booking
    return (
      <div className="mx-auto max-w-lg px-4 py-12">
        <div className="text-center">
          <div className="text-4xl">{paid ? '✅' : '🧾'}</div>
          <h1 className="mt-3 text-2xl font-bold">{paid ? 'Đặt cọc thành công' : 'Xác nhận & đặt cọc'}</h1>
          <p className="mt-1 text-slate-500">
            {paid ? 'Đơn đã được xác nhận. Cảm ơn bạn!' : 'Đơn đang chờ đặt cọc để hoàn tất.'}
          </p>
        </div>

        <div className="mt-6 rounded-xl border border-slate-200 bg-white p-5">
          <div className="flex items-center justify-between">
            <span className="text-slate-500">Mã đơn</span>
            <span className="font-mono text-lg font-bold text-emerald-700">{b.code}</span>
          </div>
          {result.pin && (
            <>
              <div className="mt-2 flex items-center justify-between">
                <span className="text-slate-500">Mã PIN tra cứu</span>
                <span className="font-mono text-lg font-bold">{result.pin}</span>
              </div>
              <p className="mt-1 text-xs text-amber-600">
                Lưu lại mã đơn và PIN để tra cứu/hủy đơn sau này (chỉ hiển thị một lần).
              </p>
            </>
          )}
          <hr className="my-3 border-slate-100" />
          <p className="font-medium">{b.productName}</p>
          <p className="text-sm text-slate-500">
            {isTour
              ? `${b.guests} người lớn${b.children ? ` · ${b.children} trẻ em` : ''}`
              : `${b.nights} đêm · ${b.guests} khách`}
          </p>
          <div className="mt-3 space-y-1 text-sm">
            {!!b.discountAmount && (
              <Row label={`Mã giảm giá (${b.discountCode})`} value={`-${formatPrice(b.discountAmount)}`} />
            )}
            <Row label="Tổng tiền" value={formatPrice(b.totalPrice)} />
            <Row label={paid ? 'Đã đặt cọc' : 'Cần đặt cọc'} value={formatPrice(b.depositAmount)} strong />
            <Row label="Còn lại (trả sau)" value={formatPrice(b.remainingAmount)} />
          </div>
        </div>

        {!paid ? (
          <div className="mt-5">
            <h2 className="mb-2 font-semibold">Chọn phương thức thanh toán cọc</h2>
            {payError && <div className="mb-3 rounded-lg border border-red-300 bg-red-50 px-3 py-2 text-sm text-red-700">{payError}</div>}
            <div className="space-y-2">
              {vnpayEnabled && (
                <button
                  onClick={() => pay('VNPAY')}
                  disabled={paying !== null}
                  className="w-full rounded-lg bg-blue-600 px-4 py-3 font-semibold text-white hover:bg-blue-700 disabled:opacity-50"
                >
                  {paying === 'VNPAY' ? 'Đang chuyển tới VNPAY...' : `Thanh toán VNPAY ${formatPrice(b.depositAmount)}`}
                </button>
              )}
              <button
                onClick={() => pay('COD')}
                disabled={paying !== null}
                className="w-full rounded-lg border border-emerald-600 px-4 py-3 font-semibold text-emerald-700 hover:bg-emerald-50 disabled:opacity-50"
              >
                {paying === 'COD' ? 'Đang xử lý...' : 'Thanh toán khi nhận (COD)'}
              </button>
            </div>
            <p className="mt-2 text-xs text-slate-400">
              Cổng VNPAY chạy ở môi trường sandbox — không dùng thẻ thật. {!vnpayEnabled && 'Hiện chỉ bật COD (chưa cấu hình VNPAY).'}
            </p>
          </div>
        ) : (
          <Link to="/" className="mt-6 block rounded-lg bg-emerald-600 px-4 py-2 text-center text-sm font-medium text-white hover:bg-emerald-700">
            Về trang chủ
          </Link>
        )}
      </div>
    )
  }

  // Thiếu thông tin ngày (không đến từ luồng UC-03).
  const missingInfo = isTour ? !date : nights <= 0
  if (missingInfo) {
    return (
      <div className="mx-auto max-w-lg px-4 py-16 text-center">
        <h1 className="text-xl font-semibold">Thiếu thông tin đặt chỗ</h1>
        <p className="mt-2 text-slate-500">
          Vui lòng chọn {isTour ? 'ngày khởi hành' : 'khoảng ngày'} ở trang chi tiết trước khi đặt.
        </p>
        <Link to={isTour ? `/tour/${slug}` : `/product/${slug}`} className="mt-6 inline-block rounded-lg bg-emerald-600 px-4 py-2 text-sm font-medium text-white hover:bg-emerald-700">
          ← Về trang {isTour ? 'tour' : 'sản phẩm'}
        </Link>
      </div>
    )
  }

  const field = 'w-full rounded-lg border border-slate-300 px-3 py-2 text-sm focus:border-emerald-500 focus:outline-none'

  return (
    <div className="mx-auto max-w-5xl px-4 py-8">
      <h1 className="mb-6 text-2xl font-bold">Xác nhận đặt {isTour ? 'tour' : 'homestay'}</h1>

      <div className="gap-6 lg:flex">
        <form onSubmit={submit} className="flex-1 space-y-4">
          {!user && (
            <div className="rounded-lg border border-slate-200 bg-slate-50 px-4 py-3 text-sm text-slate-600">
              Bạn đang đặt với tư cách khách.{' '}
              <Link to={`/login?returnTo=${encodeURIComponent(location.pathname + location.search)}`} className="font-medium text-emerald-700 hover:underline">
                Đăng nhập
              </Link>{' '}
              để lưu đơn vào tài khoản.
            </div>
          )}
          <div className="rounded-xl border border-slate-200 bg-white p-5">
            <h2 className="mb-4 font-semibold">Thông tin người đặt</h2>
            <div className="space-y-3">
              <input className={field} placeholder="Họ tên *" value={name} onChange={(e) => setName(e.target.value)} />
              <input className={field} type="email" placeholder="Email *" value={email} onChange={(e) => setEmail(e.target.value)} />
              <input className={field} placeholder="Số điện thoại *" value={phone} onChange={(e) => setPhone(e.target.value)} />
            </div>
          </div>

          <div className="rounded-xl border border-slate-200 bg-white p-5 text-sm text-slate-600">
            <h2 className="mb-2 font-semibold text-slate-900">Chính sách hủy</h2>
            <p>{product.cancellationPolicy}</p>
          </div>

          {/* UC-12 – Áp dụng mã giảm giá (extend UC-09/10) */}
          <div className="rounded-xl border border-slate-200 bg-white p-5">
            <h2 className="mb-3 font-semibold">Mã giảm giá</h2>
            {applied ? (
              <div className="flex items-center justify-between rounded-lg bg-emerald-50 px-3 py-2 text-sm">
                <span className="font-medium text-emerald-700">
                  ✓ Đã áp dụng <span className="font-mono">{applied.code}</span> · giảm {formatPrice(applied.discount)}
                </span>
                <button type="button" onClick={removeDiscount} className="text-emerald-700 underline hover:text-emerald-800">
                  Gỡ mã
                </button>
              </div>
            ) : (
              <div className="flex gap-2">
                <input
                  className={`${field} flex-1 uppercase`}
                  placeholder="Nhập mã giảm giá"
                  value={discountInput}
                  onChange={(e) => setDiscountInput(e.target.value.toUpperCase())}
                />
                <button
                  type="button"
                  onClick={applyDiscountCode}
                  disabled={applyingDiscount || !discountInput.trim()}
                  className="shrink-0 rounded-lg border border-emerald-600 px-4 py-2 text-sm font-medium text-emerald-700 hover:bg-emerald-50 disabled:opacity-50"
                >
                  {applyingDiscount ? 'Đang kiểm tra...' : 'Áp dụng'}
                </button>
              </div>
            )}
            {discountMsg && <p className="mt-2 text-sm text-red-600">{discountMsg}</p>}
          </div>

          <label className="flex items-start gap-2 text-sm text-slate-600">
            <input type="checkbox" className="mt-1" checked={terms} onChange={(e) => setTerms(e.target.checked)} />
            <span>
              Tôi đã đọc và đồng ý với{' '}
              <Link to="/info/dieu-kien-giao-dich" target="_blank" className="text-emerald-700 hover:underline">Điều khoản</Link> và{' '}
              <Link to="/info/bao-mat-du-lieu" target="_blank" className="text-emerald-700 hover:underline">Chính sách bảo vệ dữ liệu cá nhân</Link>.
            </span>
          </label>

          {error && <div className="rounded-lg border border-red-300 bg-red-50 px-3 py-2 text-sm text-red-700">{error}</div>}

          <button
            type="submit"
            disabled={submitting}
            className="w-full rounded-lg bg-emerald-600 px-4 py-3 font-semibold text-white hover:bg-emerald-700 disabled:opacity-50 lg:w-auto"
          >
            {submitting ? 'Đang xử lý...' : `Xác nhận & đặt cọc ${formatPrice(deposit)}`}
          </button>
        </form>

        <aside className="mt-6 w-full lg:mt-0 lg:w-80 lg:shrink-0">
          <div className="rounded-xl border border-slate-200 bg-white p-5">
            <h2 className="mb-3 font-semibold">{product.name}</h2>
            <div className="space-y-1 text-sm text-slate-600">
              {isTour ? (
                <>
                  <Row label="Ngày khởi hành" value={new Date(date).toLocaleDateString('vi-VN')} />
                  <Row label="Người lớn" value={`${guests}`} />
                  {children > 0 && <Row label="Trẻ em" value={`${children}`} />}
                </>
              ) : (
                <>
                  <Row label="Nhận phòng" value={new Date(from).toLocaleDateString('vi-VN')} />
                  <Row label="Trả phòng" value={new Date(to).toLocaleDateString('vi-VN')} />
                  <Row label="Số đêm" value={`${nights} đêm`} />
                  <Row label="Số khách" value={`${guests} khách`} />
                </>
              )}
            </div>
            <hr className="my-3 border-slate-100" />
            <div className="space-y-1 text-sm">
              {isTour ? (
                <>
                  <Row label={`Người lớn ${formatPrice(product.price)} × ${guests}`} value={formatPrice(product.price * guests)} />
                  {children > 0 && (
                    <Row label={`Trẻ em ${formatPrice(priceChild)} × ${children}`} value={formatPrice(priceChild * children)} />
                  )}
                </>
              ) : (
                <Row label={`Giá ${formatPrice(product.price)} × ${nights} đêm`} value={formatPrice(total)} />
              )}
              {applied && (
                <>
                  <Row label={`Mã giảm giá (${applied.code})`} value={`-${formatPrice(applied.discount)}`} />
                  <Row label="Tổng sau giảm" value={formatPrice(payableTotal)} />
                </>
              )}
              <Row label={`Đặt cọc (${Math.round(depositRate * 100)}%)`} value={formatPrice(deposit)} strong />
              <Row label="Còn lại (trả sau)" value={formatPrice(remaining)} />
            </div>
          </div>
        </aside>
      </div>
    </div>
  )
}

function Row({ label, value, strong }: { label: string; value: string; strong?: boolean }) {
  return (
    <div className="flex items-center justify-between">
      <span className="text-slate-500">{label}</span>
      <span className={strong ? 'font-bold text-emerald-700' : 'text-slate-800'}>{value}</span>
    </div>
  )
}
