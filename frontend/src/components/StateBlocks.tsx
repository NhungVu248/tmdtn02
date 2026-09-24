// Các khối trạng thái dùng chung: đang tải, lỗi (kèm nút Thử lại), rỗng.

export function Loading({ label = 'Đang tải...' }: { label?: string }) {
  return (
    <div className="flex items-center justify-center py-20 text-forest-400">
      <span className="h-4 w-4 mr-3 rounded-full border-2 border-cream-300 border-t-forest-500 animate-spin" />
      {label}
    </div>
  )
}

// Ngoại lệ 2a (UC-01): không tải được dữ liệu -> thông báo lỗi + nút "Thử lại".
export function ErrorState({ message, onRetry }: { message?: string; onRetry: () => void }) {
  return (
    <div className="flex flex-col items-center justify-center py-20 text-center">
      <p className="font-display text-lg font-medium text-clay-600">Không tải được dữ liệu</p>
      {message && <p className="mt-1 text-sm text-forest-400">{message}</p>}
      <button
        onClick={onRetry}
        className="mt-4 rounded-full bg-forest-700 px-5 py-2 text-sm font-medium text-cream-50 transition hover:bg-forest-800"
      >
        Thử lại
      </button>
    </div>
  )
}

// Ngoại lệ 4a (UC-01): danh mục rỗng.
export function EmptyState({ message = 'Chưa có sản phẩm trong danh mục này' }: { message?: string }) {
  return (
    <div className="flex flex-col items-center justify-center py-20 text-center text-forest-400">
      <div className="text-4xl">🗂️</div>
      <p className="mt-3">{message}</p>
    </div>
  )
}
