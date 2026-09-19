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
- MySQL đang chạy (ví dụ XAMPP). Mặc định cấu hình: user `root`, không mật khẩu, `localhost:3306`.

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
khớp với MySQL của bạn. Với XAMPP mặc định:

```
DATABASE_URL="mysql://root:@localhost:3306/tmdt"
```

Nếu MySQL của bạn có mật khẩu cho root, sửa thành:

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
| POST   | `/api/auth/register` | Đăng ký (email, password, name) | Không |
| POST   | `/api/auth/login`    | Đăng nhập (email, password)  | Không |
| GET    | `/api/auth/me`       | Thông tin user hiện tại       | Bearer token |

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
