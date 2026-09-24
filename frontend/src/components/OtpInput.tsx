import { useRef } from 'react'

// Ô nhập mã OTP nhiều số. Sửa lỗi "nhập số sau hiện số trước":
// - Khi ô đã có số, gõ số mới sẽ LẤY KÝ TỰ CUỐI (value.slice(-1)) để thay thế, rồi tự nhảy ô kế.
// - Backspace ở ô rỗng thì lùi về ô trước; hỗ trợ dán (paste) cả mã.
export function OtpInput({ length = 6, value, onChange, disabled }: { length?: number; value: string; onChange: (v: string) => void; disabled?: boolean }) {
  const refs = useRef<(HTMLInputElement | null)[]>([])
  const digits = Array.from({ length }, (_, i) => value[i] ?? '')

  function setAt(i: number, ch: string) {
    const arr = value.split('')
    while (arr.length < length) arr.push('')
    arr[i] = ch
    onChange(arr.join('').slice(0, length))
  }

  function handleChange(i: number, raw: string) {
    const digit = raw.replace(/\D/g, '').slice(-1) // chỉ lấy 1 chữ số cuối cùng vừa gõ
    if (!digit) {
      setAt(i, '')
      return
    }
    setAt(i, digit)
    if (i < length - 1) refs.current[i + 1]?.focus()
  }

  function handleKeyDown(i: number, e: React.KeyboardEvent<HTMLInputElement>) {
    if (e.key === 'Backspace') {
      if (digits[i]) {
        setAt(i, '')
      } else if (i > 0) {
        refs.current[i - 1]?.focus()
        setAt(i - 1, '')
      }
    } else if (e.key === 'ArrowLeft' && i > 0) {
      refs.current[i - 1]?.focus()
    } else if (e.key === 'ArrowRight' && i < length - 1) {
      refs.current[i + 1]?.focus()
    }
  }

  function handlePaste(e: React.ClipboardEvent<HTMLInputElement>) {
    e.preventDefault()
    const pasted = e.clipboardData.getData('text').replace(/\D/g, '').slice(0, length)
    if (!pasted) return
    onChange(pasted)
    refs.current[Math.min(pasted.length, length - 1)]?.focus()
  }

  return (
    <div className="flex justify-center gap-2" onPaste={handlePaste}>
      {digits.map((d, i) => (
        <input
          key={i}
          ref={(el) => { refs.current[i] = el }}
          type="text"
          inputMode="numeric"
          autoComplete="one-time-code"
          maxLength={1}
          value={d}
          disabled={disabled}
          onChange={(e) => handleChange(i, e.target.value)}
          onKeyDown={(e) => handleKeyDown(i, e)}
          onFocus={(e) => e.target.select()}
          className="h-12 w-11 rounded-lg border border-slate-300 text-center text-xl font-bold focus:border-emerald-500 focus:outline-none disabled:bg-slate-100"
        />
      ))}
    </div>
  )
}
