import { Link, useParams } from 'react-router-dom'

// Các trang thuộc use case khác của Nhóm A, tạo sẵn để luồng điều hướng hoạt động.
// Sẽ được hiện thực ở UC-03, UC-04.

function Stub({ title, note }: { title: string; note: string }) {
  return (
    <div className="mx-auto max-w-3xl px-4 py-16 text-center">
      <h1 className="text-2xl font-bold">{title}</h1>
      <p className="mt-2 text-slate-500">{note}</p>
      <Link
        to="/"
        className="mt-6 inline-block rounded-lg bg-emerald-600 px-4 py-2 text-sm font-medium text-white hover:bg-emerald-700"
      >
        ← Về trang chủ
      </Link>
    </div>
  )
}

// UC-09/UC-10 – Đặt homestay/tour (chưa phát triển). Đích của nút "Đặt ngay" ở UC-03.
export function BookingPage() {
  const { slug } = useParams()
  return <Stub title="Đặt chỗ (UC-09/UC-10)" note={`Sẽ phát triển ở luồng đặt. Sản phẩm: ${slug}`} />
}

export function NotFoundPage() {
  return <Stub title="404 — Không tìm thấy trang" note="Đường dẫn không tồn tại." />
}
