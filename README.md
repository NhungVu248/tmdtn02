# StayTour — Nền tảng đặt Homestay & Tour

Dự án web full-stack (Bài tập lớn môn Thương mại điện tử — CSE703102, Đề số 09, Nhóm 09).
Nền tảng đặt **homestay & tour du lịch** hoàn chỉnh: duyệt/tìm kiếm/đặt chỗ/thanh toán (VNPAY sandbox thật + COD) phía khách hàng, và khu vực **quản trị** `/admin` riêng biệt để quản lý sản phẩm, đơn hàng, người dùng, khuyến mại, đánh giá, báo cáo và cấu hình hệ thống. Đã hoàn thành đầy đủ **24/24 use case** theo đặc tả (xem [mục 7](#7-tính-năng)).

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

# Chuỗi bí mật ký JWT (Customer) — đổi thành chuỗi ngẫu nhiên dài
JWT_SECRET="doi_thanh_mot_chuoi_ngau_nhien_that_dai"
JWT_EXPIRES_IN="7d"

# Chuỗi bí mật RIÊNG cho token khu vực quản trị /admin (UC-24) — phải KHÁC JWT_SECRET ở trên
ADMIN_JWT_SECRET="doi_thanh_mot_chuoi_ngau_nhien_khac_that_dai"
ADMIN_JWT_EXPIRES_IN="8h"

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

Lệnh này cũng tạo **tài khoản quản trị mặc định** (chỉ khi chưa tồn tại): đăng nhập tại `http://localhost:5173/admin/login`.

| Tài khoản | Mật khẩu |
|---|---|
| `admin` | `Admin@123456` |

> Đổi mật khẩu ngay sau khi đăng nhập lần đầu, hoặc đặt `SEED_ADMIN_USERNAME`/`SEED_ADMIN_PASSWORD` trong `.env` trước khi seed để dùng thông tin khác.

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

### 6.3. Thanh toán VNPAY (sandbox)

Mặc định (không cấu hình), luồng đặt chỗ chỉ hiện phương thức **COD** (thanh toán khi nhận). Để bật thêm cổng thanh toán online sandbox:

1. Đăng ký tài khoản merchant sandbox tại https://sandbox.vnpayment.vn (miễn phí, dùng cho mục đích học tập/thử nghiệm).
2. Lấy **Terminal ID (TmnCode)** và **Secret Key (HashSecret)** từ email xác nhận/trang quản trị merchant.
3. Thêm vào `backend/.env`:

```env
BACKEND_URL="http://localhost:4000"
VNP_TMN_CODE="xxxxxxxx"
VNP_HASH_SECRET="xxxxxxxxxxxxxxxx"
VNP_URL="https://sandbox.vnpayment.vn/paymentv2/vpcpay.html"
```

Khởi động lại backend, sẽ báo `• VNPAY: BẬT`. Trang thanh toán sẽ hiện thêm lựa chọn VNPAY bên cạnh COD; dùng [thẻ test do VNPAY cung cấp](https://sandbox.vnpayment.vn/apis/vnpay-demo/) để thử giao dịch (không phải thẻ thật).

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

### Nhóm C — Đặt chỗ & Vòng đời đơn
- **UC-09** Đặt homestay (giữ chỗ tạm chống đặt trùng, tính tiền + đặt cọc, hỗ trợ guest checkout với mã đơn + PIN)
- **UC-10** Đặt tour (theo chuyến khởi hành, giá theo người lớn/trẻ em, giữ chỗ chống vượt số chỗ)
- **UC-11** Thanh toán & đặt cọc (đặt cọc một phần, COD + VNPAY sandbox có xác minh chữ ký, chống thanh toán lặp)
- **UC-12** Áp dụng mã giảm giá (kiểm tra hiệu lực/lượt dùng/điều kiện, tính lại cọc trên tổng sau giảm)
- **UC-13** Tra cứu & theo dõi đơn ("Đơn của tôi" cho Customer, tra cứu bằng mã+PIN/email cho Guest, chống dò mã và IDOR)
- **UC-14** Hủy đơn & nhận hoàn tiền (hoàn tiền tự động theo mốc thời gian, giải phóng chỗ, ghi nhận yêu cầu hoàn tiền)
- **UC-15** Đánh giá sau lưu trú (chấm sao + nhận xét cho đơn đã hoàn tất, Guest qua token email, chờ kiểm duyệt trước khi hiển thị công khai)

### Nhóm D — Quản trị (`/admin`, tách biệt hoàn toàn khỏi website chính)
- **UC-24** Đăng nhập/Đăng xuất quản trị (bảng tài khoản riêng, secret JWT riêng, khóa sau 5 lần sai, ghi vết đăng nhập)
- **UC-16** Quản lý homestay & lịch tồn phòng (thêm/sửa/gỡ hiển thị, tải ảnh có kiểm soát, mở/chặn ngày + giá theo mùa, chặn xung đột với đơn đang giữ chỗ)
- **UC-17** Quản lý tour & ngày khởi hành (thêm/sửa/gỡ hiển thị, lịch trình + bao gồm/không bao gồm, quản lý chuyến khởi hành với số chỗ + giá riêng theo loại khách, chặn giảm chỗ dưới số đã bán và đóng chuyến đang có đơn)
- **UC-18** Quản lý đơn & xử lý hủy/hoàn tiền (danh sách/chi tiết đơn kèm lọc, chuyển trạng thái đúng vòng đời chờ cọc→đã cọc→đã xác nhận→hoàn tất/đã hủy, tiếp nhận & xác nhận hoàn tiền từ UC-14 với đối soát số tiền, thông báo email khi đơn/hoàn tiền thay đổi)
- **UC-19** Quản lý người dùng & phân quyền (khóa/mở khóa tài khoản khách hàng với cảnh báo nếu còn đơn đang xử lý, tạo/đổi vai trò/khóa tài khoản quản trị chỉ dành cho SUPER_ADMIN, luôn giữ tối thiểu 1 quản trị viên đang hoạt động)
- **UC-20** Quản lý mã khuyến mại (tạo/sửa/bật-tắt mã, loại chiết khấu %/số tiền, điều kiện áp dụng đầy đủ, chặn mã trùng và dữ liệu không hợp lệ, sửa/tắt không hồi tố các đơn đã áp mã trước đó)
- **UC-21** Kiểm duyệt đánh giá (danh sách chờ duyệt/đã duyệt/từ chối, duyệt cho hiển thị công khai, từ chối hoặc ẩn đánh giá đã duyệt trước đó khi phát hiện vi phạm)
- **UC-22** Xem báo cáo & thống kê (chỉ đọc: doanh thu theo ngày trừ hoàn tiền, đơn theo trạng thái, tour bán chạy, công suất phòng homestay theo khoảng thời gian tùy chọn)
- **UC-23** Cấu hình hệ thống & nhật ký (tỷ lệ đặt cọc và chính sách hủy/hoàn tiền nay do admin cấu hình thay vì hard-code, thông tin người bán, xem nhật ký thao tác quản trị + lịch sử đăng nhập, chỉ đọc và chỉ SUPER_ADMIN)

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
| GET | `/api/bookings/config` | UC-09: tỷ lệ cọc + hạn giữ chỗ | Không |
| POST | `/api/bookings/homestay` | UC-09: đặt homestay (giữ chỗ, tạo đơn chờ cọc; hỗ trợ guest) | Tùy chọn |
| POST | `/api/bookings/tour` | UC-10: đặt tour (theo chuyến khởi hành, giá người lớn/trẻ em) | Tùy chọn |
| GET | `/api/payments/config` | UC-11: phương thức thanh toán khả dụng (COD, VNPAY) | Không |
| POST | `/api/payments/create` | UC-11: tạo thanh toán cọc (`{code, method}`) | Tùy chọn |
| GET | `/api/payments/vnpay-return` | UC-11: callback VNPAY (xác minh chữ ký) | Không |
| GET | `/api/payments/status/:code` | UC-11: trạng thái thanh toán của đơn | Không |
| POST | `/api/discounts/apply` | UC-12: kiểm tra & xem trước mã giảm giá (`{code, type, subtotal, slug}`) | Tùy chọn |
| GET | `/api/orders/my` | UC-13: danh sách đơn của Customer ("Đơn của tôi") | Bearer |
| GET | `/api/orders/my/:code` | UC-13: chi tiết đơn của Customer (chống IDOR) | Bearer |
| POST | `/api/orders/lookup` | UC-13: Guest tra cứu bằng mã đơn + PIN/email (`{code, pin?, email?}`) | Không |
| POST | `/api/orders/:code/cancel` | UC-14: hủy đơn + tính hoàn tiền tự động theo mốc thời gian | Tùy chọn (Customer hoặc Guest kèm pin/email) |
| GET | `/api/reviews/token/:token` | UC-15: xem trước thông tin đơn qua token đánh giá (Guest) | Không |
| POST | `/api/reviews/guest` | UC-15: Guest gửi đánh giá qua token dùng một lần (`{token, rating, comment?}`) | Không |
| POST | `/api/reviews/my` | UC-15: Customer gửi đánh giá cho đơn của mình (`{code, rating, comment?}`) | Bearer |
| POST | `/api/admin/auth/login` | UC-24: đăng nhập quản trị (`{username, password}`) | Không |
| GET | `/api/admin/auth/me` | UC-24: thông tin quản trị viên hiện tại | Bearer (admin) |
| GET | `/api/admin/homestays` | UC-16: danh sách homestay (mọi trạng thái, lọc `?status=&search=`) | Bearer (admin) |
| POST | `/api/admin/homestays` | UC-16: tạo homestay mới (mặc định ẩn) | Bearer (admin) |
| GET/PUT | `/api/admin/homestays/:id` | UC-16: xem/cập nhật chi tiết homestay | Bearer (admin) |
| PATCH | `/api/admin/homestays/:id/visibility` | UC-16: hiển thị/gỡ hiển thị (`{status}`) | Bearer (admin) |
| POST | `/api/admin/homestays/uploads/image` | UC-16: tải ảnh lên (multipart, JPEG/PNG/WEBP ≤5MB) | Bearer (admin) |
| POST/DELETE | `/api/admin/homestays/:id/images(/:imageId)` | UC-16: gắn/gỡ ảnh khỏi homestay | Bearer (admin) |
| GET/PUT | `/api/admin/homestays/:id/availability` | UC-16: xem/thiết lập lịch tồn phòng theo khoảng ngày (mở/chặn + giá riêng) | Bearer (admin) |
| GET | `/api/admin/tours` | UC-17: danh sách tour (mọi trạng thái, lọc `?status=&search=`) | Bearer (admin) |
| POST | `/api/admin/tours` | UC-17: tạo tour mới (mặc định ẩn) | Bearer (admin) |
| GET/PUT | `/api/admin/tours/:id` | UC-17: xem/cập nhật chi tiết tour | Bearer (admin) |
| PATCH | `/api/admin/tours/:id/visibility` | UC-17: hiển thị/gỡ hiển thị (`{status}`) | Bearer (admin) |
| POST | `/api/admin/tours/uploads/image` | UC-17: tải ảnh lên (multipart, JPEG/PNG/WEBP ≤5MB) | Bearer (admin) |
| POST/DELETE | `/api/admin/tours/:id/images(/:imageId)` | UC-17: gắn/gỡ ảnh khỏi tour | Bearer (admin) |
| POST | `/api/admin/tours/:id/departures` | UC-17: thêm chuyến khởi hành (số chỗ + giá riêng theo loại khách) | Bearer (admin) |
| PUT | `/api/admin/tours/:id/departures/:depId` | UC-17: cập nhật số chỗ/giá của một chuyến | Bearer (admin) |
| PATCH | `/api/admin/tours/:id/departures/:depId/close` | UC-17: đóng/hủy chuyến (chặn nếu còn đơn) | Bearer (admin) |
| GET | `/api/admin/orders` | UC-18: danh sách đơn (lọc `?status=&type=&from=&to=&search=`) | Bearer (admin) |
| GET | `/api/admin/orders/:code` | UC-18: chi tiết đơn + lịch sử thanh toán + yêu cầu hoàn tiền | Bearer (admin) |
| PATCH | `/api/admin/orders/:code/status` | UC-18: chuyển trạng thái đơn theo vòng đời (BR-85, `{status}`) | Bearer (admin) |
| POST | `/api/admin/orders/:code/refunds/:refundId/process` | UC-18: xác nhận đã hoàn tiền (đối soát `{amount, referenceCode}`) | Bearer (admin) |
| GET | `/api/admin/users/customers` | UC-19: danh sách khách hàng (lọc `?status=&search=`) | Bearer (admin) |
| GET | `/api/admin/users/customers/:id` | UC-19: chi tiết khách hàng + đơn đang xử lý | Bearer (admin) |
| PATCH | `/api/admin/users/customers/:id/lock` | UC-19: khóa/mở khóa khách hàng (`{disabled}`, BR-95) | Bearer (admin) |
| GET | `/api/admin/users/admins` | UC-19: danh sách tài khoản quản trị | Bearer (SUPER_ADMIN) |
| POST | `/api/admin/users/admins` | UC-19: tạo tài khoản quản trị mới (`{username,password,name,role}`) | Bearer (SUPER_ADMIN) |
| PATCH | `/api/admin/users/admins/:id/role` | UC-19: đổi vai trò (BR-94 chặn hạ SUPER_ADMIN cuối cùng) | Bearer (SUPER_ADMIN) |
| PATCH | `/api/admin/users/admins/:id/active` | UC-19: khóa/mở khóa quản trị viên (BR-94 chặn khóa admin hoạt động cuối cùng) | Bearer (SUPER_ADMIN) |
| GET | `/api/admin/discounts` | UC-20: danh sách mã khuyến mại (lọc `?status=&search=`) | Bearer (admin) |
| POST | `/api/admin/discounts` | UC-20: tạo mã mới (BR-99 chặn trùng, 4a validate) | Bearer (admin) |
| GET/PUT | `/api/admin/discounts/:id` | UC-20: xem/cập nhật mã (BR-100 không hồi tố đơn cũ) | Bearer (admin) |
| PATCH | `/api/admin/discounts/:id/active` | UC-20: bật/tắt mã (giữ lại để không mất dữ liệu thống kê) | Bearer (admin) |
| GET | `/api/admin/reviews` | UC-21: danh sách đánh giá (lọc `?status=PENDING\|APPROVED\|REJECTED`) | Bearer (admin) |
| PATCH | `/api/admin/reviews/:id/approve` | UC-21: duyệt cho hiển thị công khai (BR-103/105) | Bearer (admin) |
| PATCH | `/api/admin/reviews/:id/reject` | UC-21: từ chối/ẩn đánh giá kể cả đã duyệt trước đó (BR-104/106) | Bearer (admin) |
| GET | `/api/admin/reports` | UC-22: báo cáo doanh thu/đơn/tour bán chạy/công suất phòng (`?from=&to=`, mặc định 30 ngày gần nhất) | Bearer (admin) |
| GET | `/api/admin/config` | UC-23: xem cấu hình hệ thống hiện tại | Bearer (admin) |
| PUT | `/api/admin/config` | UC-23: cập nhật tỷ lệ cọc/chính sách hủy/thông tin người bán (BR-115 không hồi tố) | Bearer (SUPER_ADMIN) |
| GET | `/api/admin/config/audit-logs` | UC-23: nhật ký thao tác quản trị + lịch sử đăng nhập, chỉ đọc (`?action=&from=&to=`) | Bearer (SUPER_ADMIN) |
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
├── backend/                    # Express + Prisma (MySQL)
│   ├── prisma/
│   │   ├── schema.prisma       # Mô hình dữ liệu (Customer + Admin tách biệt hoàn toàn — BR-67)
│   │   ├── migrations/         # Lịch sử migration
│   │   └── seed.js             # Dữ liệu mẫu + tài khoản admin mặc định
│   └── src/
│       ├── index.js            # Điểm khởi động server
│       ├── app.js              # Cấu hình Express + đăng ký toàn bộ routes
│       ├── controllers/        # Nghiệp vụ Customer (auth, catalog, bookings, payments, discounts, orders, reviews, info...)
│       │   └── admin/          # Nghiệp vụ khu vực quản trị (Nhóm D, UC-16→23)
│       ├── routes/              # Định nghĩa endpoint phía Customer
│       │   └── admin/          # Định nghĩa endpoint khu vực quản trị (/api/admin/*)
│       ├── middleware/         # Xác thực JWT (Customer + Admin riêng), xử lý lỗi
│       └── lib/                # prisma, mailer, google, vnpay, config (UC-23), auditLog, uploads...
│
└── frontend/                   # React + Vite + TS + Tailwind
    └── src/
        ├── main.tsx             # Điểm khởi động React
        ├── App.tsx               # Định tuyến (2 cây route: website chính + /admin/*)
        ├── components/          # Layout, AdminLayout, thẻ sản phẩm, nút Google...
        ├── pages/                # Trang chủ, tìm kiếm, chi tiết, đặt chỗ, hồ sơ...
        │   └── admin/           # Các trang khu vực quản trị (Nhóm D, UC-16→23)
        └── lib/                 # api.ts (Customer) + adminApi.ts (Admin) — tách biệt hoàn toàn
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
