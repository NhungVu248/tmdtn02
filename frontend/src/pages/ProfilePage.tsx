import { useEffect, useMemo, useState } from 'react'
import { ApiError, api } from '../lib/api'
import { useAuth } from '../lib/auth'

const field =
  'w-full rounded-xl border border-cream-300 bg-white px-3.5 py-2.5 text-sm text-forest-900 placeholder:text-forest-300 focus:border-forest-400 focus:outline-none focus:ring-2 focus:ring-forest-100 disabled:bg-cream-100 disabled:text-forest-400'
const labelCls = 'mb-1.5 block text-sm font-medium text-forest-700'
const req = <span className="text-clay-500"> *</span>

const GENDER_LABEL: Record<string, string> = { MALE: 'Nam', FEMALE: 'Nữ', OTHER: 'Khác' }

// Quản lý hồ sơ cá nhân khách hàng (chỉ chủ tài khoản đã đăng nhập).
export function ProfilePage() {
  const { user, setUser } = useAuth()

  // ----- Hồ sơ -----
  const [name, setName] = useState('')
  const [phone, setPhone] = useState('')
  const [address, setAddress] = useState('')
  const [dateOfBirth, setDateOfBirth] = useState('')
  const [gender, setGender] = useState('')
  const [nationality, setNationality] = useState('')
  const [idNumber, setIdNumber] = useState('')
  const [city, setCity] = useState('')
  const [profileMsg, setProfileMsg] = useState<{ ok: boolean; text: string } | null>(null)
  const [savingProfile, setSavingProfile] = useState(false)

  useEffect(() => {
    api
      .getMe()
      .then(({ user: u }) => {
        setName(u.name ?? '')
        setPhone(u.phone ?? '')
        setAddress(u.address ?? '')
        setDateOfBirth(u.dateOfBirth ? u.dateOfBirth.slice(0, 10) : '')
        setGender(u.gender ?? '')
        setNationality(u.nationality ?? '')
        setIdNumber(u.idNumber ?? '')
        setCity(u.city ?? '')
        setUser(u)
      })
      .catch(() => setName(user?.name ?? ''))
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

  // Các trường bắt buộc phục vụ vận hành đặt phòng/tour.
  const required = useMemo(
    () => ({ name, phone, dateOfBirth, gender, nationality, idNumber }),
    [name, phone, dateOfBirth, gender, nationality, idNumber],
  )
  const filledCount = Object.values(required).filter((v) => v.trim() !== '').length
  const totalRequired = Object.keys(required).length
  const completion = Math.round((filledCount / totalRequired) * 100)

  async function saveProfile(e: React.FormEvent) {
    e.preventDefault()
    setProfileMsg(null)
    // Kiểm tra các trường bắt buộc phía client.
    const missing = Object.entries(required).find(([, v]) => v.trim() === '')
    if (missing) {
      setProfileMsg({ ok: false, text: 'Vui lòng điền đầy đủ các trường bắt buộc (đánh dấu *).' })
      return
    }
    setSavingProfile(true)
    try {
      const { user: u } = await api.updateProfile({ name, phone, address, dateOfBirth, gender, nationality, idNumber, city })
      setUser(u)
      setProfileMsg({ ok: true, text: 'Cập nhật hồ sơ thành công' })
    } catch (err) {
      setProfileMsg({ ok: false, text: err instanceof ApiError ? err.message : 'Cập nhật thất bại' })
    } finally {
      setSavingProfile(false)
    }
  }

  // ----- Đổi mật khẩu -----
  const [current, setCurrent] = useState('')
  const [newPass, setNewPass] = useState('')
  const [confirmPass, setConfirmPass] = useState('')
  const [pwMsg, setPwMsg] = useState<{ ok: boolean; text: string } | null>(null)
  const [savingPw, setSavingPw] = useState(false)

  async function changePassword(e: React.FormEvent) {
    e.preventDefault()
    setPwMsg(null)
    if (newPass !== confirmPass) {
      setPwMsg({ ok: false, text: 'Xác nhận mật khẩu mới không khớp' })
      return
    }
    setSavingPw(true)
    try {
      await api.changePassword(current, newPass)
      setPwMsg({ ok: true, text: 'Đổi mật khẩu thành công' })
      setCurrent('')
      setNewPass('')
      setConfirmPass('')
    } catch (err) {
      setPwMsg({ ok: false, text: err instanceof ApiError ? err.message : 'Đổi mật khẩu thất bại' })
    } finally {
      setSavingPw(false)
    }
  }

  const msgClass = (ok: boolean) =>
    ok
      ? 'rounded-xl border border-forest-300 bg-forest-50 px-3.5 py-2.5 text-sm text-forest-700'
      : 'rounded-xl border border-red-300 bg-red-50 px-3.5 py-2.5 text-sm text-red-700'

  const initial = (name || user?.email || 'U').charAt(0).toUpperCase()

  return (
    <div className="mx-auto max-w-5xl px-6 py-10">
      <header className="mb-8">
        <h1 className="font-display text-4xl font-semibold text-forest-900">Hồ sơ cá nhân</h1>
        <p className="mt-2 text-forest-400">Hoàn thiện thông tin để đặt phòng &amp; tour nhanh chóng hơn.</p>
      </header>

      <div className="grid gap-6 lg:grid-cols-[19rem_1fr]">
        {/* ── Thẻ tóm tắt & độ hoàn thiện ── */}
        <aside className="space-y-6 lg:sticky lg:top-24 lg:self-start">
          <div className="rounded-3xl border border-cream-200 bg-white p-6 text-center">
            <div className="mx-auto grid h-20 w-20 place-items-center rounded-full bg-forest-100 font-display text-3xl font-semibold text-forest-700">
              {user?.avatar ? <img src={user.avatar} alt="" className="h-20 w-20 rounded-full object-cover" /> : initial}
            </div>
            <h2 className="mt-4 font-display text-xl font-semibold text-forest-900">{name || 'Khách hàng'}</h2>
            <p className="mt-0.5 truncate text-sm text-forest-400">{user?.email}</p>
            <span
              className={`mt-3 inline-block rounded-full px-3 py-1 text-xs font-medium ${
                user?.emailVerified ? 'bg-forest-100 text-forest-700' : 'bg-amber-100 text-amber-700'
              }`}
            >
              {user?.emailVerified ? '✓ Email đã xác thực' : '⚠ Email chưa xác thực'}
            </span>
          </div>

          <div className="rounded-3xl border border-cream-200 bg-white p-6">
            <div className="flex items-center justify-between text-sm">
              <span className="font-medium text-forest-700">Độ hoàn thiện hồ sơ</span>
              <span className="font-semibold text-clay-600">{completion}%</span>
            </div>
            <div className="mt-2 h-2 overflow-hidden rounded-full bg-cream-200">
              <div
                className="h-full rounded-full bg-forest-600 transition-all"
                style={{ width: `${completion}%` }}
              />
            </div>
            <p className="mt-3 text-xs leading-relaxed text-forest-400">
              {completion === 100
                ? 'Tuyệt vời! Hồ sơ của bạn đã đầy đủ để đặt phòng & tour.'
                : `Đã điền ${filledCount}/${totalRequired} trường bắt buộc. Hoàn tất để đặt chỗ nhanh hơn.`}
            </p>
          </div>
        </aside>

        {/* ── Cột biểu mẫu ── */}
        <div className="space-y-6">
          {/* Thông tin cá nhân */}
          <section className="rounded-3xl border border-cream-200 bg-white p-6">
            <h2 className="mb-1 font-display text-xl font-semibold text-forest-900">Thông tin cá nhân</h2>
            <p className="mb-5 text-sm text-forest-400">Thông tin định danh dùng khi nhận phòng &amp; khởi hành tour.</p>
            <form onSubmit={saveProfile} className="space-y-5">
              <div className="grid gap-4 sm:grid-cols-2">
                <div className="sm:col-span-2">
                  <label className={labelCls}>Họ và tên{req}</label>
                  <input className={field} value={name} onChange={(e) => setName(e.target.value)} placeholder="Như trên giấy tờ tuỳ thân" />
                </div>
                <div>
                  <label className={labelCls}>Ngày sinh{req}</label>
                  <input type="date" className={field} value={dateOfBirth} max={new Date().toISOString().slice(0, 10)} onChange={(e) => setDateOfBirth(e.target.value)} />
                </div>
                <div>
                  <label className={labelCls}>Giới tính{req}</label>
                  <select className={field} value={gender} onChange={(e) => setGender(e.target.value)}>
                    <option value="">— Chọn —</option>
                    {Object.entries(GENDER_LABEL).map(([v, l]) => (
                      <option key={v} value={v}>{l}</option>
                    ))}
                  </select>
                </div>
                <div>
                  <label className={labelCls}>Quốc tịch{req}</label>
                  <input className={field} value={nationality} onChange={(e) => setNationality(e.target.value)} placeholder="VD: Việt Nam" />
                </div>
                <div>
                  <label className={labelCls}>Số CCCD / Hộ chiếu{req}</label>
                  <input className={field} value={idNumber} onChange={(e) => setIdNumber(e.target.value)} placeholder="Dùng để xác minh khi nhận phòng" />
                </div>
              </div>

              <div className="border-t border-cream-100 pt-5">
                <h3 className="mb-4 text-sm font-semibold uppercase tracking-wide text-forest-500">Thông tin liên hệ</h3>
                <div className="grid gap-4 sm:grid-cols-2">
                  <div className="sm:col-span-2">
                    <label className={labelCls}>Email</label>
                    <input className={field} value={user?.email ?? ''} disabled />
                  </div>
                  <div>
                    <label className={labelCls}>Số điện thoại{req}</label>
                    <input className={field} value={phone} onChange={(e) => setPhone(e.target.value)} placeholder="VD: 0901234567" />
                  </div>
                  <div>
                    <label className={labelCls}>Tỉnh / Thành phố</label>
                    <input className={field} value={city} onChange={(e) => setCity(e.target.value)} placeholder="VD: Đà Nẵng" />
                  </div>
                  <div className="sm:col-span-2">
                    <label className={labelCls}>Địa chỉ liên hệ</label>
                    <input className={field} value={address} onChange={(e) => setAddress(e.target.value)} placeholder="Số nhà, đường, phường/xã..." />
                  </div>
                </div>
              </div>

              {profileMsg && <div className={msgClass(profileMsg.ok)}>{profileMsg.text}</div>}
              <button
                type="submit"
                disabled={savingProfile}
                className="rounded-full bg-forest-700 px-6 py-2.5 text-sm font-semibold text-cream-50 transition hover:bg-forest-800 disabled:opacity-50"
              >
                {savingProfile ? 'Đang lưu...' : 'Lưu thay đổi'}
              </button>
            </form>
          </section>

          {/* Bảo mật */}
          <section className="rounded-3xl border border-cream-200 bg-white p-6">
            <h2 className="mb-1 font-display text-xl font-semibold text-forest-900">Bảo mật</h2>
            <p className="mb-5 text-sm text-forest-400">Đổi mật khẩu định kỳ để bảo vệ tài khoản.</p>
            <form onSubmit={changePassword} className="space-y-4">
              <div>
                <label className={labelCls}>Mật khẩu hiện tại</label>
                <input className={field} type="password" value={current} onChange={(e) => setCurrent(e.target.value)} />
              </div>
              <div className="grid gap-4 sm:grid-cols-2">
                <div>
                  <label className={labelCls}>Mật khẩu mới</label>
                  <input className={field} type="password" value={newPass} onChange={(e) => setNewPass(e.target.value)} placeholder="Tối thiểu 8 ký tự, gồm chữ và số" />
                </div>
                <div>
                  <label className={labelCls}>Xác nhận mật khẩu mới</label>
                  <input className={field} type="password" value={confirmPass} onChange={(e) => setConfirmPass(e.target.value)} />
                </div>
              </div>
              {pwMsg && <div className={msgClass(pwMsg.ok)}>{pwMsg.text}</div>}
              <button
                type="submit"
                disabled={savingPw}
                className="rounded-full border border-forest-300 px-6 py-2.5 text-sm font-semibold text-forest-700 transition hover:bg-forest-50 disabled:opacity-50"
              >
                {savingPw ? 'Đang đổi...' : 'Đổi mật khẩu'}
              </button>
            </form>
          </section>
        </div>
      </div>
    </div>
  )
}
