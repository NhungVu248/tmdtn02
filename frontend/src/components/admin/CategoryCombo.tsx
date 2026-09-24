import { useId } from 'react'

// Ô "vừa gõ tay vừa chọn": input gắn <datalist> để gợi ý danh mục có sẵn,
// đồng thời cho phép gõ giá trị mới (khi lưu, form sẽ tự tạo danh mục nếu chưa có).
export function CategoryCombo({
  label,
  value,
  onChange,
  options,
  placeholder,
}: {
  label: string
  value: string
  onChange: (v: string) => void
  options: { id: number; name: string }[]
  placeholder?: string
}) {
  const listId = useId()
  const field = 'w-full rounded-lg border border-slate-700 bg-slate-800 px-3 py-2 text-sm text-slate-100 placeholder:text-slate-500 focus:border-emerald-500 focus:outline-none'
  return (
    <div>
      <label className="mb-1 block text-sm text-slate-300">{label}</label>
      <input
        className={field}
        list={listId}
        value={value}
        onChange={(e) => onChange(e.target.value)}
        placeholder={placeholder ?? 'Chọn hoặc gõ để thêm mới'}
      />
      <datalist id={listId}>
        {options.map((o) => (
          <option key={o.id} value={o.name} />
        ))}
      </datalist>
    </div>
  )
}

// Giải quyết tên -> id: nếu trùng danh mục có sẵn (không phân biệt hoa/thường) thì dùng id;
// nếu là giá trị mới thì gọi hàm tạo và trả id mới. Rỗng -> undefined.
export async function resolveCategoryId(
  name: string,
  options: { id: number; name: string }[],
  create: (name: string) => Promise<{ id: number }>,
): Promise<number | undefined> {
  const trimmed = name.trim()
  if (!trimmed) return undefined
  const found = options.find((o) => o.name.trim().toLowerCase() === trimmed.toLowerCase())
  if (found) return found.id
  const created = await create(trimmed)
  return created.id
}
