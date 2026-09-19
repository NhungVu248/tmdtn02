import { useEffect, useState } from 'react'

const API_URL = import.meta.env.VITE_API_URL ?? 'http://localhost:4000'

function App() {
  const [status, setStatus] = useState<'loading' | 'ok' | 'error'>('loading')

  useEffect(() => {
    fetch(`${API_URL}/api/health`)
      .then((res) => {
        if (!res.ok) throw new Error('Backend responded with an error')
        setStatus('ok')
      })
      .catch(() => setStatus('error'))
  }, [])

  return (
    <div className="min-h-screen bg-slate-50 flex items-center justify-center px-4">
      <div className="max-w-md w-full bg-white rounded-2xl shadow-sm border border-slate-200 p-8 text-center">
        <h1 className="text-2xl font-semibold text-slate-900">
          React + Vite + TypeScript + Tailwind
        </h1>
        <p className="mt-2 text-slate-500">
          Frontend đã sẵn sàng. Trạng thái kết nối backend ({API_URL}):
        </p>

        <div className="mt-6 flex items-center justify-center gap-2">
          {status === 'loading' && (
            <span className="text-slate-500">Đang kiểm tra...</span>
          )}
          {status === 'ok' && (
            <span className="inline-flex items-center gap-2 rounded-full bg-emerald-50 px-3 py-1 text-emerald-700 text-sm font-medium">
              <span className="h-2 w-2 rounded-full bg-emerald-500" />
              Backend đang chạy
            </span>
          )}
          {status === 'error' && (
            <span className="inline-flex items-center gap-2 rounded-full bg-red-50 px-3 py-1 text-red-700 text-sm font-medium">
              <span className="h-2 w-2 rounded-full bg-red-500" />
              Chưa kết nối được backend
            </span>
          )}
        </div>

        <p className="mt-6 text-xs text-slate-400">
          Chỉnh sửa <code className="text-slate-600">src/App.tsx</code> để bắt đầu.
        </p>
      </div>
    </div>
  )
}

export default App
