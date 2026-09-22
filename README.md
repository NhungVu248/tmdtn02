# StayTour — Nền tảng đặt Homestay & Tour

Dự án web full-stack (Bài tập lớn môn Thương mại điện tử — CSE703102, Đề số 09, Nhóm 09).
Nền tảng cho phép người dùng **duyệt, tìm kiếm, xem chi tiết** homestay/tour và **quản lý tài khoản** (đăng ký, đăng nhập, hồ sơ).

- **Frontend:** React 19 + Vite + TypeScript + Tailwind CSS + React Router
- **Backend:** Express.js + Prisma + JWT + Nodemailer + Google OAuth
- **Database:** MySQL

---

## Mục lục

- [Yêu cầu môi trường](#1-yêu-cầu-môi-trường)
- [Clone dự án](#2-clone-dự-án)
- [Cài đặt Backend](#3-cài-đặt-backend)
- [Cài đặt Frontend](#4-cài-đặt-frontend)
- [Chạy dự án](#5-chạy-dự-án)
- [Cấu hình nâng cao (email & Google)](#6-cấu-hình-nâng-cao-tùy-chọn)
- [Tính năng](#7-tính-năng)
- [Danh sách API](#8-danh-sách-api)
- [Cấu trúc thư mục](#9-cấu-trúc-thư-mục)
- [Xử lý sự cố](#10-xử-lý-sự-cố-troubleshooting)

---

## 1. Yêu cầu môi trường

| Công cụ | Phiên bản khuyến nghị |
|--------|------------------------|
| [Node.js](https://nodejs.org/) | >= 18 (khuyến nghị 20+) |
| npm | đi kèm Node.js |
| [MySQL](https://www.mysql.com/) | 8.x (hoặc [XAMPP](https://www.apachefriends.org/)) |
| [Git](https://git-scm.com/) | mới nhất |

> MySQL phải đang chạy trước khi cài đặt. Ví dụ với XAMPP: mở **XAMPP Control Panel** → **Start** ở dòng **MySQL**.

---

## 2. Clone dự án

```bash
git clone https://github.com/<tên-tài-khoản>/tmdtn02.git
cd tmdtn02
```

> Thay `<tên-tài-khoản>` bằng chủ repository. Dự án gồm 2 thư mục con: `backend/` và `frontend/`, cài đặt độc lập.

---

## 3. Cài đặt Backend

### 3.1. Cài dependencies

```bash
cd backend
npm install
```

### 3.2. Tạo file `.env`

Sao chép file mẫu rồi chỉnh lại cho khớp máy của bạn:

```bash
cp .env.example .env
```

Nội dung tối thiểu cần có trong `backend/.env`:

```env
# Kết nối MySQL — sửa user/mật khẩu/tên DB cho khớp máy bạn
DATABASE_URL="mysql://root:123456@localhost:3306/tmdt"

# Chuỗi bí mật ký JWT — đổi thành chuỗi ngẫu nhiên dài
JWT_SECRET="doi_thanh_mot_chuoi_ngau_nhien_that_dai"
JWT_EXPIRES_IN="7d"

PORT=4000
CLIENT_URL="http://localhost:5173"
```

> **Chỉnh `DATABASE_URL` theo MySQL của bạn:** dạng `mysql://<user>:<mật_khẩu>@<host>:<port>/<tên_db>`.
> Nếu `root` **không có mật khẩu**: `mysql://root:@localhost:3306/tmdt`.
> Sinh nhanh một `JWT_SECRET` ngẫu nhiên: `node -e "console.log(require('crypto').randomBytes(48).toString('base64url'))"`

### 3.3. Tạo database + bảng (Prisma)

Prisma sẽ tự tạo database `tmdt` nếu chưa có và dựng toàn bộ bảng:

```bash
npx prisma migrate deploy
npx prisma generate
```

### 3.4. Nạp dữ liệu mẫu

Tạo sẵn homestay, tour, danh mục, khu vực, khuyến mại, bài viết chính sách... để xem giao diện có dữ liệu:

```bash
npm run db:seed
```

---

## 4. Cài đặt Frontend

Mở terminal **mới** (giữ terminal backend), rồi:

```bash
cd frontend
npm install
```

Tạo file `.env` cho frontend:

```bash
cp .env.example .env
```

Nội dung `frontend/.env`:

```env
VITE_API_URL=http://localhost:4000

# (Tùy chọn) Client ID để bật nút "Đăng nhập bằng Google" — xem mục 6
VITE_GOOGLE_CLIENT_ID=
```

---

## 5. Chạy dự án

Mở **2 terminal**.

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

Mở trình duyệt tại **http://localhost:5173**. Nếu thấy trang chủ hiển thị homestay/tour nổi bật nghĩa là frontend và backend đã kết nối với nhau.

> Nếu cổng 5173 bị chiếm, Vite tự chuyển sang 5174. Backend đã cho phép mọi cổng `localhost` khi phát triển nên vẫn hoạt động. Nếu dùng cổng khác 5173, hãy đổi `CLIENT_URL` trong `backend/.env` cho khớp (ảnh hưởng link trong email).

---

## 6. Cấu hình nâng cao (tùy chọn)

Các tính năng dưới đây **không bắt buộc** để chạy dự án — nếu bỏ trống, hệ thống tự chuyển sang chế độ dev an toàn.

### 6.1. Gửi email thật (SMTP — Gmail)

Mặc định (không cấu hình SMTP), link xác thực/đặt lại mật khẩu được **in ra console** và hiển thị ngay trên giao diện (`[DEV] Liên kết...`), không cần hộp thư thật.

Để gửi email thật qua Gmail, thêm vào `backend/.env`:

```env
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_SECURE=false
SMTP_USER=email_cua_ban@gmail.com
SMTP_PASS=app_password_16_ky_tu_khong_dau_cach
MAIL_FROM=StayTour <email_cua_ban@gmail.com>
```

> `SMTP_PASS` là **Mật khẩu ứng dụng** (App Password), KHÔNG phải mật khẩu Gmail thường:
> 1. Bật xác minh 2 bước: https://myaccount.google.com/security
> 2. Tạo App Password: https://myaccount.google.com/apppasswords → copy 16 ký tự (viết liền, bỏ dấu cách).

Khi khởi động backend sẽ báo `• Email: SMTP (gửi thật)`.

### 6.2. Đăng nhập bằng Google (OAuth)

1. Vào [Google Cloud Console](https://console.cloud.google.com/) → tạo project.
2. **APIs & Services → OAuth consent screen** → chọn *External*, điền thông tin (thêm email của bạn vào *Test users* nếu ở chế độ Testing).
3. **Credentials → Create credentials → OAuth client ID** → *Web application*.
4. **Authorized JavaScript origins** — thêm `http://localhost:5173` và `http://localhost:5174`.
5. Copy **Client ID** (dạng `xxxx.apps.googleusercontent.com`) — *không cần client secret* — rồi điền vào:
   - `backend/.env`: `GOOGLE_CLIENT_ID=xxxx.apps.googleusercontent.com`
   - `frontend/.env`: `VITE_GOOGLE_CLIENT_ID=xxxx.apps.googleusercontent.com`

Khởi động lại cả 2 server. Nút **"Đăng nhập bằng Google"** sẽ tự hiện ở trang đăng ký/đăng nhập (nếu để trống thì nút tự ẩn).

---

## 7. Tính năng

### Nhóm A — Duyệt & Tìm kiếm (không cần đăng nhập)
- **UC-01** Duyệt trang chủ & danh mục nhiều cấp (homestay theo tỉnh/khu vực/loại hình; tour theo vùng/chủ đề/thời lượng)
- **UC-02** Tìm kiếm & lọc (theo điểm đến, ngày, số khách, giá, khu vực, tiện nghi, đánh giá, thời lượng) + sắp xếp
- **UC-03** Xem chi tiết & tình trạng còn trống theo thời gian thực (giá tạm tính theo đêm/khách), đánh giá, gợi ý tương tự
- **UC-04** Xem trang thông tin & chính sách (điều khoản, đổi–trả–hủy, bảo mật, cẩm nang)

### Nhóm B — Tài khoản & Xác thực
- **UC-05** Đăng ký tài khoản + xác thực email + đăng ký bằng Google
- **UC-06** Đăng nhập/đăng xuất (khóa sau 5 lần sai, quên/đặt lại mật khẩu, đăng nhập Google)
- **UC-07** Quản lý hồ sơ cá nhân (cập nhật thông tin + đổi mật khẩu)
- **UC-08** Quản lý danh sách yêu thích (lưu/bỏ homestay/tour, xem lại theo tài khoản)

---

## 8. Danh sách API

| Method | Endpoint | Mô tả | Auth |
|--------|----------|-------|------|
| GET | `/api/health` | Kiểm tra server | Không |
| POST | `/api/auth/register` | UC-05: đăng ký + gửi email xác thực | Không |
| POST | `/api/auth/verify-email` | UC-05: xác thực email (`{token}`) | Không |
| POST | `/api/auth/resend-verification` | UC-05: gửi lại email xác thực | Không |
| POST | `/api/auth/google` | UC-05/06: đăng ký/đăng nhập Google | Không |
| POST | `/api/auth/login` | UC-06: đăng nhập | Không |
| POST | `/api/auth/forgot-password` | UC-06: gửi email đặt lại mật khẩu | Không |
| POST | `/api/auth/reset-password` | UC-06: đặt lại mật khẩu | Không |
| GET | `/api/auth/me` | Thông tin user hiện tại | Bearer |
| PUT | `/api/auth/profile` | UC-07: cập nhật hồ sơ | Bearer |
| PUT | `/api/auth/password` | UC-07: đổi mật khẩu | Bearer |
| GET | `/api/favorites` | UC-08: danh sách yêu thích | Bearer |
| GET | `/api/favorites/ids` | UC-08: id sản phẩm đã yêu thích | Bearer |
| POST | `/api/favorites` | UC-08: thêm yêu thích (`{productId}`) | Bearer |
| DELETE | `/api/favorites/:productId` | UC-08: bỏ yêu thích | Bearer |
| GET | `/api/catalog/home` | UC-01: nổi bật + khu vực + khuyến mại | Không |
| GET | `/api/catalog/categories` | UC-01: cây danh mục (`?type=HOMESTAY\|TOUR`) | Không |
| GET | `/api/catalog/products` | UC-01/02: danh sách sản phẩm | Không |
| GET | `/api/catalog/search` | UC-02: tìm kiếm & lọc | Không |
| GET | `/api/catalog/products/:slug` | UC-03: chi tiết + đánh giá + gợi ý | Không |
| GET | `/api/catalog/products/:slug/availability` | UC-03: tình trạng còn trống + giá tạm tính | Không |
| GET | `/api/info` | UC-04: danh sách bài viết thông tin/chính sách | Không |
| GET | `/api/info/:slug` | UC-04: nội dung một bài viết | Không |

---

## 9. Cấu trúc thư mục

```
tmdtn02/
├── backend/                # Express + Prisma (MySQL)
│   ├── prisma/
│   │   ├── schema.prisma   # Mô hình dữ liệu
│   │   ├── migrations/     # Lịch sử migration
│   │   └── seed.js         # Dữ liệu mẫu
│   └── src/
│       ├── index.js        # Điểm khởi động server
│       ├── app.js          # Cấu hình Express + routes
│       ├── controllers/    # Xử lý nghiệp vụ (auth, catalog, info)
│       ├── routes/         # Định nghĩa endpoint
│       ├── middleware/      # Xác thực JWT, xử lý lỗi
│       └── lib/            # prisma, mailer, google, verification
│
└── frontend/               # React + Vite + TS + Tailwind
    └── src/
        ├── main.tsx        # Điểm khởi động React
        ├── App.tsx         # Định tuyến (React Router)
        ├── components/     # Layout, thẻ sản phẩm, nút Google...
        ├── pages/          # Trang chủ, tìm kiếm, chi tiết, hồ sơ...
        └── lib/            # api client, auth context
```

---

## 10. Xử lý sự cố (Troubleshooting)

| Triệu chứng | Cách xử lý |
|-------------|-----------|
| `Can't reach database server` khi migrate | MySQL chưa chạy, hoặc `DATABASE_URL` sai user/mật khẩu/port. Kiểm tra lại MySQL và chuỗi kết nối. |
| Frontend báo lỗi CORS | Kiểm tra backend đang chạy ở cổng 4000 và `VITE_API_URL` trỏ đúng. |
| `Access blocked` khi bấm nút Google | Chưa thêm đúng origin (`http://localhost:5173`/`5174`) vào Authorized JavaScript origins trong Google Cloud. |
| Không nhận được email | Chưa cấu hình SMTP → dùng link `[DEV]` hiển thị trên màn hình. Nếu đã cấu hình, kiểm tra thư mục Spam. |
| Trang trắng / lỗi module | Chạy lại `npm install` ở thư mục tương ứng; đảm bảo Node >= 18. |
| Muốn xem/sửa dữ liệu trực quan | Trong `backend/`: `npx prisma studio` |

### Ghi chú Prisma
- Sau khi sửa `backend/prisma/schema.prisma`, chạy `npx prisma migrate dev --name <ten_thay_doi>` để cập nhật database.
- Nạp lại dữ liệu mẫu bất kỳ lúc nào: `npm run db:seed` (sẽ xóa dữ liệu catalog cũ và tạo lại).

---

## Ghi chú bảo mật

- File `.env` (chứa mật khẩu DB, JWT secret, SMTP) **không được commit** — đã nằm trong `.gitignore`.
- Mật khẩu người dùng được **băm bằng bcrypt**, không lưu dạng rõ.
- Phiên đăng nhập dùng **JWT** (lưu ở `localStorage`).
