import { useCallback, useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { AdminApiError, adminApi, type CancellationPolicy, type PolicyMilestone } from '../../lib/adminApi'

const field = 'rounded-lg border border-slate-700 bg-slate-800 px-3 py-2 text-sm text-slate-100 focus:border-emerald-500 focus:outline-none'

type Draft = { name: string; isRefundable: boolean; freeHours: number; milestones: PolicyMilestone[] }
const EMPTY: Draft = { name: '', isRefundable: true, freeHours: 24, milestones: [{ daysBefore: 7, refundRate: 100 }, { daysBefore: 3, refundRate: 50 }] }

// UC-14/UC-23 – Quản lý Chính sách hủy dùng chung: miễn phí hủy trong X giờ đầu,
// sau đó hoàn theo mốc (hủy trước ≥ N ngày → hoàn %). Tour/Homestay chọn 1 chính sách;
// không chọn thì áp dụng cấu hình mặc định ở trang Phương thức thanh toán & phí.
export function AdminCancellationPoliciesPage() {
  const [items, setItems] = useState<CancellationPolicy[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [info, setInfo] = useState<string | null>(null)

  // editing: null = không mở form; 'new' = tạo mới; number = sửa chính sách có id đó.
  const [editing, setEditing] = useState<'new' | number | null>(null)
  const [draft, setDraft] = useState<Draft>(EMPTY)
  const [saving, setSaving] = useState(false)
  const [confirmDel, setConfirmDel] = useState<CancellationPolicy | null>(null)

  const load = useCallback(() => {
    setLoading(true)
    adminApi
      .listCancellationPolicies()
      .then((r) => setItems(r.items))
      .catch(() => setError('Không tải được danh sách chính sách hủy'))
      .finally(() => setLoading(false))
  }, [])

  useEffect(() => load(), [load])

  function startNew() {
    setEditing('new')
    setDraft({ ...EMPTY, milestones: EMPTY.milestones.map((m) => ({ ...m })) })
    setInfo(null)
    setError(null)
  }
  function startEdit(p: CancellationPolicy) {
    setEditing(p.id)
    setDraft({ name: p.name, isRefundable: p.isRefundable, freeHours: p.freeHours, milestones: p.milestones.map((m) => ({ ...m })) })
    setInfo(null)
    setError(null)
  }
  function cancelEdit() {
    setEditing(null)
    setDraft(EMPTY)
  }

  function setMilestone(i: number, patch: Partial<PolicyMilestone>) {
    setDraft((d) => ({ ...d, milestones: d.milestones.map((m, j) => (j === i ? { ...m, ...patch } : m)) }))
  }
  function addMilestone() {
    setDraft((d) => ({ ...d, milestones: [...d.milestones, { daysBefore: 0, refundRate: 0 }] }))
  }
  function removeMilestone(i: number) {
    setDraft((d) => ({ ...d, milestones: d.milestones.filter((_, j) => j !== i) }))
  }

  async function save(e: React.FormEvent) {
    e.preventDefault()
    if (!draft.name.trim()) {
      setError('Vui lòng nhập tên chính sách')
      return
    }
    setSaving(true)
    setError(null)
    try {
      const payload = {
        name: draft.name.trim(),
        isRefundable: draft.isRefundable,
        freeHours: Number(draft.freeHours) || 0,
        milestones: draft.isRefundable ? draft.milestones : [],
      }
      if (editing === 'new') {
        await adminApi.createCancellationPolicy(payload)
        setInfo('✓ Đã tạo chính sách hủy mới')
      } else if (typeof editing === 'number') {
        await adminApi.updateCancellationPolicy(editing, payload)
        setInfo('✓ Đã cập nhật chính sách hủy')
      }
      cancelEdit()
      load()
    } catch (err) {
      setError(err instanceof AdminApiError ? err.message : 'Lưu thất bại')
    } finally {
      setSaving(false)
    }
  }

  async function doDelete(p: CancellationPolicy) {
    setConfirmDel(null)
    setError(null)
    try {
      const r = await adminApi.deleteCancellationPolicy(p.id)
      setInfo(r.detached > 0 ? `✓ Đã xóa "${p.name}". ${r.detached} dịch vụ chuyển về cấu hình mặc định.` : `✓ Đã xóa "${p.name}".`)
      if (editing === p.id) cancelEdit()
      load()
    } catch (err) {
      setError(err instanceof AdminApiError ? err.message : 'Xóa thất bại')
    }
  }

  return (
    <div>
      <div className="mb-2 flex flex-wrap items-start justify-between gap-2">
        <h1 className="text-2xl font-bold text-white">Chính sách hủy</h1>
        {editing === null && (
          <button onClick={startNew} className="rounded-lg bg-emerald-600 px-4 py-2 text-sm font-semibold text-white hover:bg-emerald-700">
            + Tạo chính sách
          </button>
        )}
      </div>
      <p className="mb-6 max-w-3xl text-sm text-slate-400">
        Mỗi chính sách gồm thời gian miễn phí hủy và các mốc hoàn tiền. Tour/Homestay chọn một chính sách trong form chỉnh sửa;
        dịch vụ không chọn (<span className="text-slate-300">— Mặc định —</span>) sẽ áp dụng mốc hoàn tiền cấu hình ở{' '}
        <Link to="/admin/payments" className="text-emerald-400 hover:underline">Phương thức thanh toán &amp; phí</Link>.
      </p>

      {error && <div className="mb-4 rounded-lg border border-red-800 bg-red-950/40 px-4 py-2 text-sm text-red-300">⚠️ {error}</div>}
      {info && <div className="mb-4 rounded-lg border border-emerald-800 bg-emerald-950/40 px-4 py-2 text-sm text-emerald-300">{info}</div>}

      {/* Form tạo/sửa */}
      {editing !== null && (
        <form onSubmit={save} className="mb-6 space-y-4 rounded-xl border border-slate-800 bg-slate-950 p-5">
          <h2 className="font-semibold text-slate-200">{editing === 'new' ? 'Tạo chính sách hủy' : 'Chỉnh sửa chính sách'}</h2>

          <div className="grid gap-4 sm:grid-cols-2">
            <div>
              <label className="mb-1 block text-sm text-slate-300">Tên chính sách</label>
              <input autoFocus value={draft.name} onChange={(e) => setDraft((d) => ({ ...d, name: e.target.value }))} placeholder="VD: Linh hoạt, Tiêu chuẩn, Không hoàn..." className={`${field} w-full`} />
            </div>
            <div>
              <label className="mb-1 block text-sm text-slate-300">Miễn phí hủy trong (giờ đầu sau khi đặt)</label>
              <input type="number" min={0} value={draft.freeHours} onChange={(e) => setDraft((d) => ({ ...d, freeHours: Number(e.target.value) }))} className={`${field} w-full`} />
            </div>
          </div>

          <label className="flex items-center gap-2 text-sm text-slate-300">
            <input type="checkbox" checked={draft.isRefundable} onChange={(e) => setDraft((d) => ({ ...d, isRefundable: e.target.checked }))} className="h-4 w-4 rounded border-slate-600 bg-slate-800 accent-emerald-500" />
            Cho phép hoàn tiền (bỏ chọn = không hoàn tiền trong mọi trường hợp)
          </label>

          {draft.isRefundable && (
            <div className="rounded-lg border border-slate-800 bg-slate-900/50 p-4">
              <div className="mb-2 flex items-center justify-between">
                <span className="text-sm font-medium text-slate-300">Mốc hoàn tiền</span>
                <button type="button" onClick={addMilestone} className="rounded-lg border border-slate-700 px-2.5 py-1 text-xs text-slate-300 hover:bg-slate-800">+ Thêm mốc</button>
              </div>
              <p className="mb-3 text-xs text-slate-500">Hủy trước ≥ số ngày → hoàn %. Hệ thống áp dụng mốc có số ngày lớn nhất mà khách còn thỏa mãn.</p>
              {draft.milestones.length === 0 ? (
                <p className="text-xs text-slate-500">Chưa có mốc nào — ngoài thời gian miễn phí sẽ không hoàn tiền.</p>
              ) : (
                <div className="space-y-2">
                  {draft.milestones.map((m, i) => (
                    <div key={i} className="flex flex-wrap items-center gap-2 text-sm text-slate-300">
                      <span>Hủy trước ≥</span>
                      <input type="number" min={0} value={m.daysBefore} onChange={(e) => setMilestone(i, { daysBefore: Number(e.target.value) })} className={`${field} w-20`} />
                      <span>ngày → hoàn</span>
                      <input type="number" min={0} max={100} value={m.refundRate} onChange={(e) => setMilestone(i, { refundRate: Number(e.target.value) })} className={`${field} w-20`} />
                      <span>%</span>
                      <button type="button" onClick={() => removeMilestone(i)} className="ml-auto rounded-lg border border-red-900 px-2 py-1 text-xs text-red-400 hover:bg-red-950/40">Xóa</button>
                    </div>
                  ))}
                </div>
              )}
            </div>
          )}

          <div className="flex gap-2">
            <button disabled={saving} className="rounded-lg bg-emerald-600 px-4 py-2 text-sm font-semibold text-white hover:bg-emerald-700 disabled:opacity-50">
              {saving ? 'Đang lưu...' : 'Lưu'}
            </button>
            <button type="button" onClick={cancelEdit} disabled={saving} className="rounded-lg border border-slate-700 px-4 py-2 text-sm text-slate-300 hover:bg-slate-800 disabled:opacity-50">Hủy</button>
          </div>
        </form>
      )}

      {/* Danh sách */}
      {loading ? (
        <p className="text-slate-500">Đang tải...</p>
      ) : items.length === 0 ? (
        <p className="rounded-xl border border-slate-800 bg-slate-950 px-4 py-6 text-center text-slate-500">Chưa có chính sách hủy nào. Bấm “+ Tạo chính sách” để thêm.</p>
      ) : (
        <div className="space-y-3">
          {items.map((p) => (
            <div key={p.id} className="rounded-xl border border-slate-800 bg-slate-950 p-4">
              <div className="flex flex-wrap items-start justify-between gap-2">
                <div className="min-w-0">
                  <div className="flex flex-wrap items-center gap-2">
                    <span className="font-semibold text-slate-100">{p.name}</span>
                    {p.isRefundable ? (
                      <span className="rounded-full bg-emerald-900/60 px-2 py-0.5 text-[11px] text-emerald-300">Có hoàn tiền</span>
                    ) : (
                      <span className="rounded-full bg-red-950 px-2 py-0.5 text-[11px] text-red-300">Không hoàn tiền</span>
                    )}
                    {p.usage != null && p.usage > 0 && (
                      <span className="rounded-full bg-slate-800 px-2 py-0.5 text-[11px] text-slate-400">{p.usage} dịch vụ đang dùng</span>
                    )}
                  </div>
                  <div className="mt-1 text-xs text-slate-400">Miễn phí hủy trong {p.freeHours} giờ đầu sau khi đặt.</div>
                </div>
                <div className="flex shrink-0 gap-2">
                  <button onClick={() => startEdit(p)} className="rounded-lg border border-slate-700 px-3 py-1.5 text-sm text-slate-300 hover:bg-slate-800">Sửa</button>
                  <button onClick={() => setConfirmDel(p)} className="rounded-lg border border-red-900 px-3 py-1.5 text-sm text-red-400 hover:bg-red-950/40">Xóa</button>
                </div>
              </div>
              {p.isRefundable && (
                <div className="mt-3 flex flex-wrap gap-2">
                  {p.milestones.length === 0 ? (
                    <span className="text-xs text-slate-500">Ngoài thời gian miễn phí: không hoàn tiền.</span>
                  ) : (
                    p.milestones.map((m, i) => (
                      <span key={i} className="rounded-lg border border-slate-800 bg-slate-900 px-2.5 py-1 text-xs text-slate-300">
                        ≥ {m.daysBefore} ngày → <span className="font-semibold text-emerald-400">{m.refundRate}%</span>
                      </span>
                    ))
                  )}
                </div>
              )}
            </div>
          ))}
        </div>
      )}

      {/* Xác nhận xóa */}
      {confirmDel && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 p-4" onClick={() => setConfirmDel(null)}>
          <div className="w-full max-w-md rounded-xl border border-slate-700 bg-slate-900 p-5" onClick={(e) => e.stopPropagation()}>
            <h3 className="mb-2 font-semibold text-white">Xóa chính sách “{confirmDel.name}”?</h3>
            <p className="mb-4 text-sm text-slate-400">
              {confirmDel.usage && confirmDel.usage > 0
                ? `${confirmDel.usage} dịch vụ đang dùng chính sách này sẽ chuyển về cấu hình mặc định.`
                : 'Chính sách này chưa gắn với dịch vụ nào.'}
            </p>
            <div className="flex justify-end gap-2">
              <button onClick={() => setConfirmDel(null)} className="rounded-lg border border-slate-700 px-4 py-2 text-sm text-slate-300 hover:bg-slate-800">Hủy</button>
              <button onClick={() => doDelete(confirmDel)} className="rounded-lg bg-red-600 px-4 py-2 text-sm font-semibold text-white hover:bg-red-700">Xóa</button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
