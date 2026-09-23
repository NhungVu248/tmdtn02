import { useEffect, useRef, useState } from 'react'
import { useNavigate, useParams } from 'react-router-dom'
import { AdminApiError, adminApi, type AdminTourDetail } from '../../lib/adminApi'

const field = 'w-full rounded-lg border border-slate-700 bg-slate-800 px-3 py-2 text-sm text-slate-100 placeholder:text-slate-500 focus:border-emerald-500 focus:outline-none'

// UC-17 – Tạo mới / chỉnh sửa tour + quản lý ảnh (BR-82).
export function AdminTourFormPage() {
  const { id } = useParams<{ id: string }>()
  const isEdit = Boolean(id)
  const navigate = useNavigate()
  const fileInput = useRef<HTMLInputElement>(null)

  const [name, setName] = useState('')
  const [slug, setSlug] = useState('')
  const [location, setLocation] = useState('')
  const [price, setPrice] = useState('')
  const [priceChild, setPriceChild] = useState('')
  const [durationDays, setDurationDays] = useState('')
  const [description, setDescription] = useState('')
  const [itinerary, setItinerary] = useState('')
  const [included, setIncluded] = useState('')
  const [excluded, setExcluded] = useState('')
  const [cancellationPolicy, setCancellationPolicy] = useState('')
  const [images, setImages] = useState<{ id: number; url: string }[]>([])
  const [productId, setProductId] = useState<number | null>(null)

  const [error, setError] = useState<string | null>(null)
  const [saving, setSaving] = useState(false)
  const [uploading, setUploading] = useState(false)
  const [loaded, setLoaded] = useState(!isEdit)

  useEffect(() => {
    if (!id) return
    adminApi.getTour(Number(id)).then(({ product }) => {
      fillForm(product)
      setLoaded(true)
    })
  }, [id])

  function fillForm(p: AdminTourDetail) {
    setName(p.name)
    setSlug(p.slug)
    setLocation(p.location ?? '')
    setPrice(String(p.price))
    setPriceChild(p.priceChild != null ? String(p.priceChild) : '')
    setDurationDays(p.durationDays != null ? String(p.durationDays) : '')
    setDescription(p.description ?? '')
    setItinerary(p.itinerary ?? '')
    setIncluded(p.included ?? '')
    setExcluded(p.excluded ?? '')
    setCancellationPolicy(p.cancellationPolicy ?? '')
    setImages(p.images.map((im) => ({ id: im.id, url: im.url })))
    setProductId(p.id)
  }

  async function submit(e: React.FormEvent) {
    e.preventDefault()
    setError(null)
    setSaving(true)
    try {
      const payload = {
        name,
        slug: slug || undefined,
        location,
        price: Number(price),
        priceChild: priceChild || undefined,
        durationDays: durationDays || undefined,
        description: description || undefined,
        itinerary: itinerary || undefined,
        included: included || undefined,
        excluded: excluded || undefined,
        cancellationPolicy: cancellationPolicy || undefined,
      }
      if (isEdit && id) {
        const { product } = await adminApi.updateTour(Number(id), payload)
        fillForm(product)
      } else {
        const { product } = await adminApi.createTour(payload)
        navigate(`/admin/tours/${product.id}/edit`, { replace: true })
        return
      }
    } catch (err) {
      setError(err instanceof AdminApiError ? err.message : 'Lưu thất bại. Vui lòng thử lại.') // 5a
    } finally {
      setSaving(false)
    }
  }

  async function onPickFile(e: React.ChangeEvent<HTMLInputElement>) {
    const file = e.target.files?.[0]
    if (!file || !productId) return
    setUploading(true)
    setError(null)
    try {
      const up = await adminApi.uploadTourImage(file) // BR-82: kiểm soát loại/kích thước ở server
      const { image } = await adminApi.addTourImage(productId, up.filename)
      setImages((prev) => [...prev, { id: image.id, url: image.url }])
    } catch (err) {
      setError(err instanceof AdminApiError ? err.message : 'Tải ảnh thất bại') // 5a
    } finally {
      setUploading(false)
      if (fileInput.current) fileInput.current.value = ''
    }
  }

  async function removeImage(imageId: number) {
    if (!productId) return
    await adminApi.removeTourImage(productId, imageId)
    setImages((prev) => prev.filter((im) => im.id !== imageId))
  }

  if (!loaded) return <p className="text-slate-500">Đang tải...</p>

  return (
    <div className="max-w-2xl">
      <h1 className="mb-6 text-2xl font-bold text-white">{isEdit ? 'Chỉnh sửa tour' : 'Thêm tour mới'}</h1>

      <form onSubmit={submit} className="space-y-4 rounded-xl border border-slate-800 bg-slate-950 p-5">
        <div>
          <label className="mb-1 block text-sm text-slate-300">Tên tour *</label>
          <input className={field} value={name} onChange={(e) => setName(e.target.value)} required />
        </div>
        <div>
          <label className="mb-1 block text-sm text-slate-300">Đường dẫn (slug)</label>
          <input className={field} value={slug} onChange={(e) => setSlug(e.target.value)} placeholder="Để trống -> tự sinh từ tên" />
        </div>
        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="mb-1 block text-sm text-slate-300">Vùng miền / Điểm đến *</label>
            <input className={field} value={location} onChange={(e) => setLocation(e.target.value)} required />
          </div>
          <div>
            <label className="mb-1 block text-sm text-slate-300">Thời lượng (số ngày)</label>
            <input className={field} type="number" min={1} value={durationDays} onChange={(e) => setDurationDays(e.target.value)} />
          </div>
          <div>
            <label className="mb-1 block text-sm text-slate-300">Giá người lớn *</label>
            <input className={field} type="number" min={0} value={price} onChange={(e) => setPrice(e.target.value)} required />
          </div>
          <div>
            <label className="mb-1 block text-sm text-slate-300">Giá trẻ em</label>
            <input className={field} type="number" min={0} value={priceChild} onChange={(e) => setPriceChild(e.target.value)} placeholder="Để trống = dùng giá người lớn" />
          </div>
        </div>
        <div>
          <label className="mb-1 block text-sm text-slate-300">Mô tả</label>
          <textarea className={field} rows={3} value={description} onChange={(e) => setDescription(e.target.value)} />
        </div>
        <div>
          <label className="mb-1 block text-sm text-slate-300">Lịch trình (theo ngày)</label>
          <textarea className={field} rows={4} value={itinerary} onChange={(e) => setItinerary(e.target.value)} placeholder={'Ngày 1: ...\nNgày 2: ...'} />
        </div>
        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="mb-1 block text-sm text-slate-300">Bao gồm</label>
            <textarea className={field} rows={3} value={included} onChange={(e) => setIncluded(e.target.value)} placeholder={'Xe đưa đón\nHướng dẫn viên'} />
          </div>
          <div>
            <label className="mb-1 block text-sm text-slate-300">Không bao gồm</label>
            <textarea className={field} rows={3} value={excluded} onChange={(e) => setExcluded(e.target.value)} placeholder={'Vé tham quan\nChi phí cá nhân'} />
          </div>
        </div>
        <div>
          <label className="mb-1 block text-sm text-slate-300">Chính sách hủy</label>
          <textarea className={field} rows={3} value={cancellationPolicy} onChange={(e) => setCancellationPolicy(e.target.value)} />
        </div>

        {productId && (
          <div>
            <label className="mb-1 block text-sm text-slate-300">Thư viện ảnh</label>
            <div className="flex flex-wrap gap-2">
              {images.map((im) => (
                <div key={im.id} className="group relative h-20 w-28 overflow-hidden rounded-lg border border-slate-700">
                  <img src={im.url} alt="" className="h-full w-full object-cover" />
                  <button
                    type="button"
                    onClick={() => removeImage(im.id)}
                    className="absolute right-1 top-1 hidden rounded-full bg-black/70 px-1.5 text-xs text-white group-hover:block"
                  >
                    ✕
                  </button>
                </div>
              ))}
              <label className="flex h-20 w-28 cursor-pointer items-center justify-center rounded-lg border border-dashed border-slate-700 text-xs text-slate-500 hover:border-emerald-500">
                {uploading ? 'Đang tải...' : '+ Thêm ảnh'}
                <input ref={fileInput} type="file" accept="image/jpeg,image/png,image/webp" className="hidden" onChange={onPickFile} disabled={uploading} />
              </label>
            </div>
            <p className="mt-1 text-xs text-slate-500">JPEG/PNG/WEBP, tối đa 5MB mỗi ảnh.</p>
          </div>
        )}
        {!productId && <p className="text-xs text-slate-500">Lưu tour trước để có thể tải ảnh lên.</p>}

        {error && <div className="rounded-lg border border-red-800 bg-red-950/40 px-3 py-2 text-sm text-red-300">{error}</div>}

        <button
          type="submit"
          disabled={saving}
          className="rounded-lg bg-emerald-600 px-4 py-2 text-sm font-semibold text-white hover:bg-emerald-700 disabled:opacity-50"
        >
          {saving ? 'Đang lưu...' : isEdit ? 'Lưu thay đổi' : 'Tạo tour'}
        </button>
      </form>
    </div>
  )
}
