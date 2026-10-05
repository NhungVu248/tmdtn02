===============================================================================
 STAYTOUR — WEBSITE ĐẶT PHÒNG HOMESTAY VÀ TOUR DU LỊCH NỘI ĐỊA
 Đồ án học phần: THƯƠNG MẠI ĐIỆN TỬ
===============================================================================

-------------------------------------------------------------------------------
1. THÔNG TIN NHÓM
-------------------------------------------------------------------------------
Trường      : Đại học Phenikaa — Trường Công nghệ Thông tin Phenikaa
Học phần    : Thương mại điện tử
Lớp tín chỉ : CSE703102-1-1-26 (N02) — Khoá K17
GVHD        : TS. Nguyễn Văn Tánh
Đề tài      : Website đặt phòng Homestay và Tour du lịch nội địa

Thành viên nhóm (Nhóm 09):
  1. Vũ Hồng Nhung    - 23010221  (Nhóm trưởng · Front-end · Back-end/CSDL)
  2. Trần Thiên Đạt   - 23010128  (Phân tích – Thiết kế)
  3. Vũ Thị Hải Yến   - 23010421  (Phân tích – Thiết kế · Bảo mật – Kiểm thử/QA)
  4. Đào Quỳnh Nga    - 23010272  (Phân tích – Thiết kế)
  5. Đoàn Thị Thu Thảo- 23010260  (Bảo mật – Kiểm thử/QA)

-------------------------------------------------------------------------------
2. CÔNG NGHỆ SỬ DỤNG
-------------------------------------------------------------------------------
Back-end  : Node.js + Express 5, Prisma ORM, JWT, bcrypt, Nodemailer
Front-end : React 19 + Vite + TailwindCSS + React Router
CSDL      : MySQL 8 (ví dụ chạy bằng XAMPP)
Thanh toán: VNPAY (môi trường sandbox) + COD
Đăng nhập : Email/mật khẩu + Google OAuth (tuỳ chọn cấu hình)

-------------------------------------------------------------------------------
3. ĐỊA CHỈ TRIỂN KHAI THỬ
-------------------------------------------------------------------------------
- Chạy nội bộ (local):
    Front-end (web khách)  : http://localhost:5173
    Khu vực quản trị (admin): http://localhost:5173/admin
    Back-end API           : http://localhost:4000
- Địa chỉ triển khai công khai (nếu có): ......................................

-------------------------------------------------------------------------------
4. TÀI KHOẢN ĐĂNG NHẬP
-------------------------------------------------------------------------------
* Tài khoản QUẢN TRỊ (tạo sẵn bởi lệnh seed):
    URL      : http://localhost:5173/admin/login
    Username : admin
    Password : Admin@123456
    (Có thể đổi bằng biến môi trường SEED_ADMIN_USERNAME / SEED_ADMIN_PASSWORD
     trong file backend/.env trước khi chạy seed. Nên đổi mật khẩu sau lần
     đăng nhập đầu tiên.)

* Tài khoản KHÁCH HÀNG (customer):
    - Hệ thống KHÔNG seed sẵn tài khoản khách. Người chấm vui lòng tự đăng ký
      tại: http://localhost:5173/register (xác thực email bằng mã OTP; ở chế độ
      DEV khi chưa cấu hình SMTP, mã OTP/đường liên kết sẽ được in ra console
      của back-end để sử dụng).
    - Hoặc đặt phòng/tour với tư cách KHÁCH (guest checkout) không cần tài khoản;
      hệ thống cấp Mã đơn + Mã PIN để tra cứu/hủy đơn.
    - Tài khoản khách mẫu đã tạo khi demo (nếu có):
        Email   : ......................................
        Password: ......................................

-------------------------------------------------------------------------------
5. YÊU CẦU MÔI TRƯỜNG
-------------------------------------------------------------------------------
- Node.js 18 trở lên và npm
- MySQL 8 (khuyến nghị dùng XAMPP; tạo sẵn database rỗng tên "tmdt")
- Cổng mặc định: Back-end 4000, Front-end 5173, MySQL 3306

-------------------------------------------------------------------------------
6. HƯỚNG DẪN CHẠY NHANH (LOCAL)
-------------------------------------------------------------------------------
Bước 0 — Chuẩn bị CSDL
    - Khởi động MySQL (XAMPP) và tạo database rỗng tên: tmdt

Bước 1 — Back-end
    cd backend
    copy .env.example .env            (Windows)  |  cp .env.example .env (macOS/Linux)
    # Mở file .env, sửa DATABASE_URL cho đúng user/mật khẩu MySQL, ví dụ:
    #   DATABASE_URL="mysql://root:123456@localhost:3306/tmdt"
    # Đặt JWT_SECRET và ADMIN_JWT_SECRET là chuỗi ngẫu nhiên bất kỳ.
    npm install
    npx prisma db push                # tạo bảng theo schema
    npx prisma generate               # sinh Prisma Client
    npm run db:seed                   # tạo dữ liệu mẫu + tài khoản admin
    npm run dev                       # chạy API tại http://localhost:4000

Bước 2 — Front-end (mở cửa sổ terminal mới)
    cd frontend
    copy .env.example .env            (Windows)  |  cp .env.example .env (macOS/Linux)
    # Đảm bảo VITE_API_URL=http://localhost:4000
    npm install
    npm run dev                       # chạy web tại http://localhost:5173

Bước 3 — Truy cập
    - Trang khách  : http://localhost:5173
    - Trang quản trị: http://localhost:5173/admin  (đăng nhập bằng tài khoản mục 4)

* Lưu ý Prisma: dự án dùng "npx prisma db push" để đồng bộ schema (không dùng
  "prisma migrate dev"). Nếu khi chạy "prisma generate" báo lỗi EPERM trên
  Windows, hãy TẮT tiến trình back-end đang chạy rồi chạy lại.

* Nhập dữ liệu từ file .sql (nếu dùng bản xuất trong 02_Database/):
    - Tạo database "tmdt", rồi import file .sql bằng phpMyAdmin hoặc:
        mysql -u root -p tmdt < 02_Database/tmdt.sql
    - Khi đó có thể bỏ qua bước "npm run db:seed".

-------------------------------------------------------------------------------
7. CẤU HÌNH TUỲ CHỌN (không bắt buộc để chạy demo cơ bản)
-------------------------------------------------------------------------------
- Gửi email thật (OTP, mời đánh giá): cấu hình SMTP_* trong backend/.env.
  Bỏ trống => mã OTP in ra console (chế độ DEV).
- Đăng nhập Google: đặt GOOGLE_CLIENT_ID (backend) và VITE_GOOGLE_CLIENT_ID
  (frontend). Bỏ trống => nút Google tự ẩn.
- Thanh toán VNPAY sandbox: đặt VNP_TMN_CODE, VNP_HASH_SECRET, VNP_URL,
  BACKEND_URL trong backend/.env. Bỏ trống => chỉ dùng COD.

-------------------------------------------------------------------------------
8. CẤU TRÚC THƯ MỤC MÃ NGUỒN
-------------------------------------------------------------------------------
backend/   — máy chủ Node/Express + Prisma (API, xác thực, thanh toán, quản trị)
frontend/  — giao diện React (web khách + khu vực quản trị /admin)

===============================================================================
 © 2026 StayTour — Đồ án Thương mại điện tử, Nhóm 09.
===============================================================================
