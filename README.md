# tmdtn02

Dự án web full-stack.

- **Frontend:** React + Vite + TypeScript + Tailwind CSS
- **Backend:** Express.js + Prisma + JWT
- **Database:** MySQL

## Cấu trúc

```
tmdtn02/
├── frontend/   # React + Vite + TS + Tailwind
└── backend/    # Express + Prisma + JWT (MySQL)
```

## Yêu cầu

- Node.js >= 18 (khuyến nghị 20+)
- MySQL đang chạy (ví dụ XAMPP). Cấu hình hiện tại: user `root`, mật khẩu `123456`, `localhost:3306`.

---

## 1. Cài đặt

> Chạy các lệnh dưới đây trong terminal trên Windows (PowerShell / CMD),
> vì các gói native (Prisma, Tailwind) phụ thuộc hệ điều hành.

### Backend

```bash
cd backend
npm install
```

Tạo file `.env` (đã có sẵn `.env.example` để tham khảo). Kiểm tra `DATABASE_URL`
khớp với MySQL của bạn. Cấu hình mặc định của dự án (root có mật khẩu `123456`):

```
DATABASE_URL="mysql://root:123456@localhost:3306/tmdt"
```

Nếu root của bạn dùng mật khẩu khác (hoặc không mật khẩu), sửa lại phần sau dấu `:`:

```
DATABASE_URL="mysql://root:MAT_KHAU@localhost:3306/tmdt"
```

Tạo database + bảng bằng Prisma (Prisma sẽ tự tạo database `tmdt` nếu chưa có):

```bash
npx prisma migrate dev --name init
```

### Frontend

```bash
cd frontend
npm install
```

---

## 2. Chạy dự án

Mở 2 terminal.

**Terminal 1 — Backend** (chạy tại http://localhost:4000):

```bash
cd backend
npm run dev
```

**Terminal 2 — Frontend** (chạy tại http://localhost:5173):

```bash
cd frontend
npm run dev
```

Mở http://localhost:5173 — nếu thấy "Backend đang chạy" nghĩa là frontend và
backend đã kết nối được với nhau.

---

## API sẵn có

| Method | Endpoint             | Mô tả                        | Auth |
|--------|----------------------|------------------------------|------|
| GET    | `/api/health`        | Kiểm tra server              | Không |
| POST   | `/api/auth/register` | UC-05: đăng ký (email, password, confirmPassword, name, acceptedTerms) + gửi email xác thực | Không |
| POST   | `/api/auth/verify-email` | UC-05: xác thực email (`{token}` hoặc `?token=`) | Không |
| POST   | `/api/auth/resend-verification` | UC-05: gửi lại email xác thực (`{email}`) | Không |
| POST   | `/api/auth/google`   | UC-05/06: đăng ký/đăng nhập bằng Google (`{credential}`) | Không |
| GET    | `/api/auth/config`   | Cờ `googleEnabled` để frontend hiện/ẩn nút Google | Không |
| POST   | `/api/auth/login`    | UC-06: đăng nhập (khóa sau 5 lần sai, chặn chưa xác thực) | Không |
| POST   | `/api/auth/forgot-password` | UC-06: gửi email đặt lại mật khẩu (`{email}`) | Không |
| POST   | `/api/auth/reset-password`  | UC-06: đặt lại mật khẩu (`{token, password}`) | Không |
| GET    | `/api/auth/me`       | Thông tin user hiện tại       | Bearer token |
| PUT    | `/api/auth/profile`  | UC-07: cập nhật hồ sơ (name, phone, address) | Bearer token |
| PUT    | `/api/auth/password` | UC-07: đổi mật khẩu (currentPassword, newPassword) | Bearer token |
| GET    | `/api/catalog/home`  | UC-01: nổi bật + khu vực + khuyến mại | Không |
| GET    | `/api/catalog/categories` | UC-01: cây danh mục (`?type=HOMESTAY\|TOUR`) | Không |
| GET    | `/api/catalog/products` | UC-01/02: danh sách sản phẩm (`?categorySlug=&type=&location=`) | Không |
| GET    | `/api/catalog/search` | UC-02: tìm kiếm & lọc (`?type=&destination=&from=&to=&depart=&guests=&minPrice=&maxPrice=&location=&amenities=&minRating=&duration=&sort=`) | Không |
| GET    | `/api/catalog/products/:slug` | UC-03: chi tiết + ảnh + đánh giá (đã duyệt) + gợi ý tương tự | Không |
| GET    | `/api/catalog/products/:slug/availability` | UC-03: tình trạng còn trống + giá tạm tính (homestay `?from=&to=&guests=`, tour `?date=&guests=&children=`) | Không |
| GET    | `/api/info` | UC-04: danh sách bài viết thông tin/chính sách đã công bố (`?category=ABOUT\|POLICY\|GUIDE`) | Không |
| GET    | `/api/info/:slug` | UC-04: nội dung một bài viết | Không |

> Sau khi `prisma migrate`, nạp dữ liệu mẫu cho UC-01: `npm run db:seed` (trong `backend/`).

Ví dụ đăng ký:

```bash
curl -X POST http://localhost:4000/api/auth/register \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"test@example.com\",\"password\":\"123456\",\"name\":\"Test\"}"
```

Response trả về `token` (JWT). Dùng token gọi API cần đăng nhập:

```bash
curl http://localhost:4000/api/auth/me -H "Authorization: Bearer <token>"
```

---

## Ghi chú Prisma

- Sửa model trong `backend/prisma/schema.prisma`, sau đó chạy
  `npx prisma migrate dev --name <ten_thay_doi>` để cập nhật database.
- Xem/chỉnh dữ liệu trực quan: `npx prisma studio`.
