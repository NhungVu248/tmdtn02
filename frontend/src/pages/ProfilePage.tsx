import { useEffect, useState } from 'react'
import { ApiError, api } from '../lib/api'
import { useAuth } from '../lib/auth'

const field = 'w-full rounded-lg border border-slate-300 px-3 py-2 text-sm focus:border-emerald-500 focus:outline-none'

// UC-07 – Quản lý hồ sơ cá nhân (BR-20: chỉ chủ tài khoản đã đăng nhập).
export function ProfilePage() {
  const { user, setUser } = useAuth()

  // ----- Hồ sơ -----
  const [name, setName] = useState('')
  const [phone, setPhone] = useState('')
  const [address, setAddress] = useState('')
  const [profileMsg, setProfileMsg] = useState<{ ok: boolean; text: string } | null>(null)
  const [savingProfile, setSavingProfile] = useState(false)

  // Nạp hồ sơ đầy đủ (phone/address) từ máy chủ.
  useEffect(() => {
    api
      .getMe()
      .then(({ user: u }) => {
        setName(u.name ?? '')
        setPhone(u.phone ?? '')
        setAddress(u.address ?? '')
        setUser(u)
      })
      .catch(() => {
        // giữ dữ liệu từ context nếu không tải được
        setName(user?.name ?? '')
      })
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

  async function saveProfile(e: React.FormEvent) {
    e.preventDefault()
    setProfileMsg(null)
    setSavingProfile(true)
    try {
      const { user: u } = await api.updateProfile({ name, phone, address })
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
      ? 'rounded-lg border border-emerald-300 bg-emerald-50 px-3 py-2 text-sm text-emerald-800'
      : 'rounded-lg border border-red-300 bg-red-50 px-3 py-2 text-sm text-red-700'

  return (
    <div className="mx-auto max-w-2xl px-4 py-8">
      <h1 className="text-2xl font-bold">Hồ sơ cá nhân</h1>

      {/* Thông tin cơ bản */}
      <section className="mt-6 rounded-xl border border-slate-200 bg-white p-5">
        <h2 className="mb-4 font-semibold">Thông tin cá nhân</h2>
        <form onSubmit={saveProfile} className="space-y-4">
          <div>
            <label className="mb-1 block text-sm font-medium">Email</label>
            <input className={`${field} bg-slate-50 text-slate-500`} value={user?.email ?? ''} disabled />
            {user && (
              <span className={`mt-1 inline-block text-xs ${user.emailVerified ? 'text-emerald-600' : 'text-amber-600'}`}>
                {user.emailVerified ? '✓ Email đã xác thực' : '⚠ Email chưa xác thực'}
              </span>
            )}
          </div>
          <div>
            <label className="mb-1 block text-sm font-medium">Họ tên</label>
            <input className={field} value={name} onChange={(e) => setName(e.target.value)} />
          </div>
          <div>
            <label className="mb-1 block text-sm font-medium">Số điện thoại</label>
            <input className={field} value={phone} onChange={(e) => setPhone(e.target.value)} placeholder="VD: 0901234567" />
          </div>
          <div>
            <label className="mb-1 block text-sm font-medium">Địa chỉ / liên hệ</label>
            <input className={field} value={address} onChange={(e) => setAddress(e.target.value)} />
          </div>
          {profileMsg && <div className={msgClass(profileMsg.ok)}>{profileMsg.text}</div>}
          <button
            type="submit"
            disabled={savingProfile}
            className="rounded-lg bg-emerald-600 px-4 py-2 text-sm font-semibold text-white hover:bg-emerald-700 disabled:opacity-50"
          >
            {savingProfile ? 'Đang lưu...' : 'Lưu thay đổi'}
          </button>
        </form>
      </section>

      {/* Đổi mật khẩu */}
      <section className="mt-6 rounded-xl border border-slate-200 bg-white p-5">
        <h2 className="mb-4 font-semibold">Đổi mật khẩu</h2>
        <form onSubmit={changePassword} className="space-y-4">
          <div>
            <label className="mb-1 block text-sm font-medium">Mật khẩu hiện tại</label>
            <input className={field} type="password" value={current} onChange={(e) => setCurrent(e.target.value)} />
          </div>
          <div>
            <label className="mb-1 block text-sm font-medium">Mật khẩu mới</label>
            <input className={field} type="password" value={newPass} onChange={(e) => setNewPass(e.target.value)} placeholder="Tối thiểu 8 ký tự, gồm chữ và số" />
          </div>
          <div>
            <label className="mb-1 block text-sm font-medium">Xác nhận mật khẩu mới</label>
            <input className={field} type="password" value={confirmPass} onChange={(e) => setConfirmPass(e.target.value)} />
          </div>
          {pwMsg && <div className={msgClass(pwMsg.ok)}>{pwMsg.text}</div>}
          <button
            type="submit"
            disabled={savingPw}
            className="rounded-lg bg-slate-800 px-4 py-2 text-sm font-semibold text-white hover:bg-slate-900 disabled:opacity-50"
          >
            {savingPw ? 'Đang đổi...' : 'Đổi mật khẩu'}
          </button>
        </form>
      </section>
    </div>
  )
}
