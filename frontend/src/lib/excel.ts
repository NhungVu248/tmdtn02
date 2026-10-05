import * as XLSX from 'xlsx'

// Xuất một mảng object thành file .xlsx và tải về trình duyệt.
export function exportToExcel(rows: Record<string, unknown>[], filename: string, sheetName = 'Sheet1') {
  const ws = XLSX.utils.json_to_sheet(rows)
  const wb = XLSX.utils.book_new()
  XLSX.utils.book_append_sheet(wb, ws, sheetName)
  XLSX.writeFile(wb, filename.endsWith('.xlsx') ? filename : `${filename}.xlsx`)
}

// Đọc file .xlsx/.csv người dùng chọn -> mảng object theo hàng tiêu đề của sheet đầu tiên.
// CSV đọc bằng text UTF-8 (giữ đúng dấu tiếng Việt); .xlsx đọc bằng arrayBuffer.
export async function readExcel(file: File): Promise<Record<string, unknown>[]> {
  const isCsv = /\.csv$/i.test(file.name) || file.type === 'text/csv'
  const wb = isCsv
    ? XLSX.read(await file.text(), { type: 'string' })
    : XLSX.read(await file.arrayBuffer(), { type: 'array' })
  const first = wb.SheetNames[0]
  if (!first) return []
  const ws = wb.Sheets[first]
  return XLSX.utils.sheet_to_json<Record<string, unknown>>(ws, { defval: '' })
}
