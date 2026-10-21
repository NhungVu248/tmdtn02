import { useEffect, useRef, useState } from 'react'

// Ô "vừa gõ tay vừa chọn": input + dropdown gợi ý CHỌN ĐƯỢC bằng chuột/phím,
// đồng thời cho phép gõ giá trị mới (khi lưu, form tự tạo danh mục nếu chưa có).
// Dùng dropdown tùy biến thay cho <datalist> native (vốn hay không chọn được).
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
  const [open, setOpen] = useState(false)
  const [hi, setHi] = useState(-1) // chỉ số mục đang highlight (điều hướng bàn phím)
  const wrapRef = useRef<HTMLDivElement>(null)
  const field = 'w-full rounded-lg border border-slate-700 bg-slate-800 px-3 py-2 text-sm text-slate-100 placeholder:text-slate-500 focus:border-emerald-500 focus:outline-none'

  // Đóng dropdown khi bấm ra ngoài.
  useEffect(() => {
    function onDoc(e: MouseEvent) {
      if (wrapRef.current && !wrapRef.current.contains(e.target as Node)) setOpen(false)
    }
    document.addEventListener('mousedown', onDoc)
    return () => document.removeEventListener('mousedown', onDoc)
  }, [])

  const q = value.trim().toLowerCase()
  const filtered = q ? options.filter((o) => o.name.toLowerCase().includes(q)) : options
  const exact = options.some((o) => o.name.trim().toLowerCase() === q)

  function pick(name: string) {
    onChange(name)
    setOpen(false)
    setHi(-1)
  }

  function onKey(e: React.KeyboardEvent) {
    if (!open && (e.key === 'ArrowDown' || e.key === 'ArrowUp')) { setOpen(true); return }
    if (e.key === 'ArrowDown') { e.preventDefault(); setHi((h) => Math.min(h + 1, filtered.length - 1)) }
    else if (e.key === 'ArrowUp') { e.preventDefault(); setHi((h) => Math.max(h - 1, 0)) }
    else if (e.key === 'Enter' && hi >= 0 && filtered[hi]) { e.preventDefault(); pick(filtered[hi].name) }
    else if (e.key === 'Escape') setOpen(false)
  }

  return (
    <div ref={wrapRef} className="relative">
      <label className="mb-1 block text-sm text-slate-300">{label}</label>
      <input
        className={field}
        value={value}
        onChange={(e) => { onChange(e.target.value); setOpen(true); setHi(-1) }}
        onFocus={() => setOpen(true)}
        onKeyDown={onKey}
        placeholder={placeholder ?? 'Chọn hoặc gõ để thêm mới'}
        autoComplete="off"
      />
      {open && (filtered.length > 0 || (q && !exact)) && (
        <ul className="absolute z-30 mt-1 max-h-52 w-full overflow-auto rounded-lg border border-slate-700 bg-slate-800 py-1 shadow-xl">
          {filtered.map((o, i) => (
            <li key={o.id}>
              <button
                type="button"
                // onMouseDown + preventDefault để không bị blur làm đóng trước khi chọn.
                onMouseDown={(e) => { e.preventDefault(); pick(o.name) }}
                onMouseEnter={() => setHi(i)}
                className={`block w-full px-3 py-1.5 text-left text-sm ${i === hi ? 'bg-slate-700 text-white' : 'text-slate-200 hover:bg-slate-700'}`}
              >
                {o.name}
              </button>
            </li>
          ))}
          {q && !exact && (
            <li className="border-t border-slate-700">
              <button type="button" onMouseDown={(e) => { e.preventDefault(); pick(value.trim()) }} className="block w-full px-3 py-1.5 text-left text-sm text-emerald-400 hover:bg-slate-700">
                + Thêm mới: “{value.trim()}”
              </button>
            </li>
          )}
        </ul>
      )}
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
