# HƯỚNG DẪN TRIỂN KHAI — STAYTOUR

Website đặt phòng Homestay & Tour du lịch nội địa.
Kiến trúc: **Frontend (React/Vite)** + **Backend (Node/Express + Prisma)** + **MySQL**.

---

## 1. YÊU CẦU MÔI TRƯỜNG

**Cách A — Dùng Docker (khuyến nghị):**
- Docker Engine 24+ và Docker Compose v2
  (Windows/macOS: cài **Docker Desktop**; Linux: `docker` + `docker compose`)

**Cách B — Chạy thủ công (không Docker):**
- Node.js 18+ và npm
- MySQL 8 (ví dụ XAMPP)

---

## 2. TRIỂN KHAI BẰNG DOCKER (1 LỆNH)

Toàn bộ cấu hình nằm ở `docker-compose.yml` (thư mục gốc dự án) cùng
`backend/Dockerfile` và `frontend/Dockerfile`.

### Bước 1 — Mở terminal tại thư mục gốc dự án (chứa docker-compose.yml)

### Bước 2 — Khởi chạy
```bash
docker compose up -d --build
```
Lần đầu sẽ: tạo MySQL → đồng bộ schema (prisma db push) → seed dữ liệu mẫu +
tài khoản admin → chạy API và web.

### Bước 3 — Truy cập
| Thành phần        | Địa chỉ                          |
|-------------------|----------------------------------|
| Web khách         | http://localhost:8080            |
| Khu vực quản trị  | http://localhost:8080/admin      |
| API (back-end)    | http://localhost:8080/api/health |

> API đi qua chính cổng web 8080 (nginx chuyển tiếp `/api` và `/uploads` sang
> backend nội bộ). **Không cần mở cổng 4000** — nhờ vậy tránh được lỗi trùng cổng
> 4000 trên Windows/Docker Desktop.

**Tài khoản quản trị mặc định:** `admin` / `Admin@123456`
Khách hàng tự đăng ký tại `/register`, hoặc đặt với tư cách khách (guest).

### Các lệnh hữu ích
```bash
docker compose logs -f backend     # xem log API
docker compose ps                  # trạng thái các service
docker compose down                # dừng (giữ dữ liệu trong volume)
docker compose down -v             # dừng và XOÁ dữ liệu (reset sạch)
docker compose up -d --build       # build lại sau khi sửa code
```

> Dữ liệu MySQL lưu ở volume `db_data`, ảnh tải lên ở `uploads_data` — không
> mất khi `docker compose down` (chỉ mất khi dùng `down -v`).

---

## 3. CẤU HÌNH (BIẾN MÔI TRƯỜNG)

Các biến đã đặt sẵn trong `docker-compose.yml`. **Khi deploy thật, hãy đổi:**

| Biến                 | Ý nghĩa                                   | Gợi ý khi deploy thật                    |
|----------------------|-------------------------------------------|------------------------------------------|
| `JWT_SECRET`         | Khoá ký token khách hàng                  | Chuỗi ngẫu nhiên dài, giữ bí mật         |
| `ADMIN_JWT_SECRET`   | Khoá ký token quản trị (tách riêng)       | Chuỗi ngẫu nhiên khác                    |
| `SEED_ADMIN_PASSWORD`| Mật khẩu admin tạo lần đầu                | Đổi mật khẩu mạnh                        |
| `CLIENT_URL`         | Origin của web (CORS)                     | http://localhost:8080 hoặc domain thật   |
| `BACKEND_URL`        | Dùng để tạo URL ảnh tải lên               | Trùng địa chỉ web công khai (qua :8080)  |
| `VITE_API_URL` (build arg của frontend) | URL API mà trình duyệt gọi | Để trống = cùng origin với web (khuyên dùng) |

### Triển khai lên VPS có IP/tên miền
1. Chỉ cần mở **cổng 8080** (web) trên VPS/tường lửa — API đi chung cổng này.
2. Sửa trong `docker-compose.yml`:
   - `backend.environment.CLIENT_URL` → `http://<IP-hoặc-domain>:8080`
   - `backend.environment.BACKEND_URL` → `http://<IP-hoặc-domain>:8080`
   - `frontend.build.args.VITE_API_URL` → để trống `""` (web gọi API cùng origin).
3. Chạy lại: `docker compose up -d --build`.

### Tuỳ chọn (không bắt buộc để demo)
Thêm vào `backend.environment` nếu muốn bật:
- **Email thật (OTP/mời đánh giá):** `SMTP_HOST, SMTP_PORT, SMTP_USER, SMTP_PASS, MAIL_FROM`
- **Đăng nhập Google:** `GOOGLE_CLIENT_ID` (backend) + build arg `VITE_GOOGLE_CLIENT_ID` (frontend)
- **VNPAY sandbox:** `VNP_TMN_CODE, VNP_HASH_SECRET, VNP_URL` (+ `BACKEND_URL` để nhận redirect)

---

## 4. NHẬP DỮ LIỆU TỪ FILE .SQL (tuỳ chọn)
Nếu muốn dùng dữ liệu trong `02_Database/*.sql` thay cho seed:
```bash
# Khi container db đang chạy:
docker compose exec -T db mysql -uroot -pstaytour123 tmdt < 02_Database/tmdt.sql
```

---

## 5. CHẠY THỦ CÔNG KHÔNG DOCKER (dự phòng)

**Back-end**
```bash
cd backend
cp .env.example .env         # sửa DATABASE_URL, JWT_SECRET, ADMIN_JWT_SECRET
npm install
npx prisma db push
npx prisma generate
npm run db:seed
npm run dev                  # http://localhost:4000
```

**Front-end** (terminal khác)
```bash
cd frontend
cp .env.example .env         # VITE_API_URL=http://localhost:4000
npm install
npm run dev                  # http://localhost:5173
# hoặc build production: npm run build  (kết quả trong dist/)
```

---

## 6. XỬ LÝ SỰ CỐ THƯỜNG GẶP

| Hiện tượng | Cách khắc phục |
|---|---|
| `backend` thoát ngay / lỗi kết nối DB | DB chưa sẵn sàng — entrypoint sẽ tự thử lại; xem `docker compose logs -f backend` |
| Web mở được nhưng gọi API lỗi CORS | Kiểm tra `VITE_API_URL` (frontend) và `CLIENT_URL` (backend) đúng origin |
| Ảnh tải lên không hiển thị | Đặt `BACKEND_URL` đúng địa chỉ API công khai rồi build lại |
| Muốn reset toàn bộ dữ liệu | `docker compose down -v` rồi `docker compose up -d --build` |
| Lỗi `EPERM ... query_engine` (chỉ khi chạy thủ công trên Windows) | Tắt tiến trình back-end rồi chạy lại `npx prisma generate` |

---

## 7. THÀNH PHẦN LIÊN QUAN TRONG MÃ NGUỒN
- `docker-compose.yml` — điều phối 3 service (db, backend, frontend)
- `backend/Dockerfile`, `backend/docker-entrypoint.sh` — build & khởi chạy API
- `frontend/Dockerfile`, `frontend/nginx.conf` — build web và phục vụ tĩnh
- `backend/.env.example`, `frontend/.env.example` — mẫu biến môi trường
