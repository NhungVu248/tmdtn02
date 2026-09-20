// Các khối trạng thái dùng chung: đang tải, lỗi (kèm nút Thử lại), rỗng.

export function Loading({ label = 'Đang tải...' }: { label?: string }) {
  return (
    <div className="flex items-center justify-center py-20 text-slate-500">
      <span className="h-4 w-4 mr-3 rounded-full border-2 border-slate-300 border-t-emerald-500 animate-spin" />
      {label}
    </div>
  )
}

// Ngoại lệ 2a (UC-01): không tải được dữ liệu -> thông báo lỗi + nút "Thử lại".
export function ErrorState({ message, onRetry }: { message?: string; onRetry: () => void }) {
  return (
    <div className="flex flex-col items-center justify-center py-20 text-center">
      <p className="text-red-600 font-medium">Không tải được dữ liệu</p>
      {message && <p className="mt-1 text-sm text-slate-500">{message}</p>}
      <button
        onClick={onRetry}
        className="mt-4 rounded-lg bg-emerald-600 px-4 py-2 text-white text-sm font-medium hover:bg-emerald-700"
      >
        Thử lại
      </button>
    </div>
  )
}

// Ngoại lệ 4a (UC-01): danh mục rỗng.
export function EmptyState({ message = 'Chưa có sản phẩm trong danh mục này' }: { message?: string }) {
  return (
    <div className="flex flex-col items-center justify-center py-20 text-center text-slate-500">
      <div className="text-4xl">🗂️</div>
      <p className="mt-3">{message}</p>
    </div>
  )
}
