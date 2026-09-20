import { BrowserRouter, Route, Routes } from 'react-router-dom'
import { Layout } from './components/Layout'
import { CategoryPage } from './pages/CategoryPage'
import { HomePage } from './pages/HomePage'
import { SearchPage } from './pages/SearchPage'
import { ProductDetailPage } from './pages/ProductDetailPage'
import { BookingPage, InfoPage, NotFoundPage } from './pages/Placeholders'

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route element={<Layout />}>
          {/* UC-01 – Duyệt trang chủ & danh mục */}
          <Route index element={<HomePage />} />
          <Route path="category/:slug" element={<CategoryPage />} />
          {/* Điều hướng sang các use case khác của Nhóm A */}
          <Route path="search" element={<SearchPage />} />
          {/* UC-03 – Xem chi tiết & tình trạng còn trống */}
          <Route path="product/:slug" element={<ProductDetailPage />} />
          {/* UC-09/10 – Đặt chỗ (placeholder) */}
          <Route path="booking/:slug" element={<BookingPage />} />
          <Route path="info/:slug" element={<InfoPage />} />
          <Route path="*" element={<NotFoundPage />} />
        </Route>
      </Routes>
    </BrowserRouter>
  )
}

export default App
