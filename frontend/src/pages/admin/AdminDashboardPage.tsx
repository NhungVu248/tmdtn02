import { useAdminAuth } from '../../lib/adminAuth'

// UC-24 – Trang tổng quan sau khi đăng nhập quản trị thành công.
// Các chức năng nghiệp vụ (UC-16→23) sẽ được xây dựng ở các bước tiếp theo.
export function AdminDashboardPage() {
  const { admin } = useAdminAuth()

  return (
    <div>
      <h1 className="text-2xl font-bold text-white">Xin chào, {admin?.name || admin?.username} 👋</h1>
      <p className="mt-1 text-slate-400">
        Bạn đã đăng nhập khu vực quản trị với quyền{' '}
        <span className="font-medium text-emerald-400">
          {admin?.role === 'SUPER_ADMIN' ? 'Toàn quyền (Super Admin)' : 'Quản lý (Manager)'}
        </span>
        .
      </p>

      <div className="mt-8 grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
        {[
          ['UC-16', 'Quản lý homestay & lịch tồn phòng'],
          ['UC-17', 'Quản lý tour & ngày khởi hành'],
          ['UC-18', 'Quản lý đơn & xử lý hủy/hoàn tiền'],
          ['UC-19', 'Quản lý người dùng & phân quyền'],
          ['UC-20', 'Quản lý mã khuyến mại'],
          ['UC-21', 'Kiểm duyệt đánh giá'],
          ['UC-22', 'Xem báo cáo & thống kê'],
          ['UC-23', 'Cấu hình hệ thống & nhật ký'],
        ].map(([code, label]) => (
          <div key={code} className="rounded-xl border border-slate-800 bg-slate-950 p-4">
            <span className="text-xs font-mono text-slate-500">{code}</span>
            <p className="mt-1 text-sm text-slate-300">{label}</p>
            <span className="mt-2 inline-block rounded-full bg-slate-800 px-2 py-0.5 text-xs text-slate-500">
              Sắp triển khai
            </span>
          </div>
        ))}
      </div>
    </div>
  )
}
