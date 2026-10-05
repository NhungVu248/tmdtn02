# TÀI KHOẢN THỬ NGHIỆM & DỮ LIỆU MẪU — STAYTOUR

## 1. Tệp cơ sở dữ liệu
- `tmdt.sql` — bản xuất đầy đủ (cấu trúc + dữ liệu mẫu) của CSDL MySQL `tmdt`.

### Cách nhập (import)
- Bằng phpMyAdmin: tạo database `tmdt` rồi Import `tmdt.sql`.
- Hoặc dòng lệnh:
  ```bash
  mysql -u root -p < tmdt.sql
  ```
- Hoặc khi chạy Docker (container db đang chạy):
  ```bash
  docker compose exec -T db mysql -uroot -pstaytour123 tmdt < 02_Database/tmdt.sql
  ```

## 2. Tài khoản thử nghiệm phân theo vai trò

| Vai trò            | Đăng nhập tại                 | Tài khoản | Mật khẩu       |
|--------------------|-------------------------------|-----------|----------------|
| Quản trị (Admin)   | /admin/login                  | `admin`   | `Admin@123456` |
| Khách hàng (Customer) | /register → /login         | *(tự đăng ký)* | *(tự đặt)*  |
| Khách vãng lai (Guest) | Đặt chỗ không cần đăng nhập | — (nhận Mã đơn + PIN) | — |

> - Tài khoản **Admin** có quyền SUPER_ADMIN (toàn quyền): quản lý homestay, tour,
>   đơn hàng, người dùng, mã khuyến mại, chương trình khuyến mại, kiểm duyệt đánh giá,
>   báo cáo và cấu hình hệ thống.
> - **Khách hàng**: hệ thống không tạo sẵn (bảo mật). Người chấm đăng ký tại `/register`;
>   mã OTP xác thực email được in ra console back-end khi chưa cấu hình SMTP (chế độ DEV).
> - **Guest checkout**: đặt homestay/tour không cần tài khoản; hệ thống cấp Mã đơn và
>   Mã PIN để tra cứu/hủy đơn tại `/track`.

## 3. Dữ liệu mẫu đã có sẵn
- 4 homestay (9 loại phòng) + lịch tồn phòng 120 ngày
- 4 tour + 12 chuyến khởi hành (kèm bảng giá người lớn/trẻ em)
- 4 khu vực du lịch, 2 chương trình khuyến mại (banner), 2 mã giảm giá
  (`STAYTOUR10` giảm 10%, `HE2026` giảm 150.000đ cho homestay)
- Bài thông tin/chính sách, 1 bài cẩm nang du lịch

> Có thể tạo lại dữ liệu mẫu bất kỳ lúc nào bằng: `cd backend && npm run db:seed`.
