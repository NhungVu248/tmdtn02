import { BrowserRouter, Route, Routes } from 'react-router-dom'
import { AuthProvider } from './lib/auth'
import { Layout } from './components/Layout'
import { RequireAuth } from './components/RequireAuth'
import { CategoryPage } from './pages/CategoryPage'
import { HomePage } from './pages/HomePage'
import { SearchPage } from './pages/SearchPage'
import { ProductDetailPage } from './pages/ProductDetailPage'
import { InfoArticlePage, InfoIndexPage } from './pages/InfoPages'
import { RegisterPage } from './pages/RegisterPage'
import { VerifyEmailPage } from './pages/VerifyEmailPage'
import { LoginPage } from './pages/LoginPage'
import { ForgotPasswordPage, ResetPasswordPage } from './pages/PasswordPages'
import { ProfilePage } from './pages/ProfilePage'
import { BookingPage, NotFoundPage } from './pages/Placeholders'

function App() {
  return (
    <AuthProvider>
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
          {/* UC-09/10 – Đặt chỗ (placeholder). BR-19: cần đăng nhập. */}
          <Route
            path="booking/:slug"
            element={
              <RequireAuth>
                <BookingPage />
              </RequireAuth>
            }
          />
          {/* UC-04 – Xem thông tin & chính sách */}
          <Route path="info" element={<InfoIndexPage />} />
          <Route path="info/:slug" element={<InfoArticlePage />} />
          {/* UC-05 – Đăng ký tài khoản & xác thực email */}
          <Route path="register" element={<RegisterPage />} />
          <Route path="verify-email" element={<VerifyEmailPage />} />
          {/* UC-06 – Đăng nhập / quên & đặt lại mật khẩu */}
          <Route path="login" element={<LoginPage />} />
          <Route path="forgot-password" element={<ForgotPasswordPage />} />
          <Route path="reset-password" element={<ResetPasswordPage />} />
          {/* UC-07 – Quản lý hồ sơ (cần đăng nhập) */}
          <Route
            path="profile"
            element={
              <RequireAuth>
                <ProfilePage />
              </RequireAuth>
            }
          />
          <Route path="*" element={<NotFoundPage />} />
        </Route>
        </Routes>
      </BrowserRouter>
    </AuthProvider>
  )
}

export default App
