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

| Vai trò            | Đăng nhập tại     | Tài khoản              | Mật khẩu       |
|--------------------|-------------------|------------------------|----------------|
| Quản trị (Admin)   | `/admin/login`    | `admin`                | `Admin@123456` |
| Khách hàng A       | `/login`          | `khachhang@gmail.com`  | `Khach@123`    |
| Khách hàng B       | `/login`          | `ha.tran@gmail.com`    | `Khach@123`    |
| Khách vãng lai     | Đặt không cần đăng nhập | — (nhận Mã đơn + PIN) | —          |

> - **Admin** quyền SUPER_ADMIN (toàn quyền): quản lý homestay, tour, đơn hàng,
>   người dùng, mã/chương trình khuyến mại, kiểm duyệt đánh giá, báo cáo, cấu hình.
> - **Khách hàng A — Nguyễn Minh Anh**: đã có sẵn 5 đơn ở đủ trạng thái + 1 yêu thích
>   homestay + 1 yêu thích tour (dùng để demo "Đơn của tôi", hồ sơ, yêu thích, đánh giá).
> - **Khách hàng B — Trần Thu Hà**: có 1 đơn tour đã hủy kèm yêu cầu hoàn tiền (demo hoàn tiền).
> - **Guest checkout**: đặt homestay/tour không cần tài khoản; hệ thống cấp Mã đơn + PIN
>   để tra cứu/hủy tại `/track`.
> - Vẫn có thể **đăng ký tài khoản mới** tại `/register`; ở chế độ DEV (chưa cấu hình SMTP)
>   mã OTP được in ra console back-end.

## 3. Dữ liệu demo sẵn sàng cho buổi bảo vệ

### 3.1 Đơn hàng mẫu (đủ mọi trạng thái)

| Mã đơn | Loại | Trạng thái | Chủ đơn | Dùng để demo |
|--------|------|-----------|---------|--------------|
| `BK-HMKV8BQEK` | Homestay | Đã cọc (DEPOSITED) | Khách hàng A | thanh toán cọc VNPAY thành công |
| `BK-CXKPF4N3C` | Homestay | Chờ cọc (PENDING) | Khách hàng A | đơn đang giữ chỗ, chờ thanh toán |
| `BK-9N2AK384J` | Homestay | Hoàn tất (COMPLETED) | Khách hàng A | **đã có đánh giá 5★** (hiển thị công khai) |
| `BK-CVAE5JWN9` | Tour | Đã xác nhận (CONFIRMED) | Khách hàng A | đơn tour sắp khởi hành |
| `BK-QZRKWLDVE` | Tour | Hoàn tất (COMPLETED) | Khách hàng A | **đánh giá đang CHỜ DUYỆT** (demo kiểm duyệt admin) |
| `BK-U7USS2QZQ` | Tour | Đã hủy (CANCELLED) | Khách hàng B | **có yêu cầu hoàn tiền 50%** chờ xử lý |
| `BK-DSYCDVJMW` | Homestay | Hoàn tất (COMPLETED) | Khách vãng lai | đã gửi **mail mời đánh giá (UC-15)** — xem 3.2 |
| `BK-DKJ9F8QPE` | Homestay | Chờ cọc (PENDING) | Khách vãng lai | **tra cứu đơn (UC-13)** — PIN `123456` |

### 3.2 Luồng khách vãng lai đánh giá sau trải nghiệm (UC-15)
Đơn khách vãng lai `BK-DSYCDVJMW` đã hoàn tất và được cấp sẵn token đánh giá (dùng 1 lần).
Để demo trang viết đánh giá, mở trực tiếp liên kết:
```
/review?token=75850b91c504819fb141f73e9ad419d821f5692554bb137cd5836493088bf52c
```
(Ví dụ đầy đủ khi chạy Docker: `http://localhost:8080/review?token=75850b91...88bf52c`)

> Trong vận hành thực tế, liên kết này được gửi tự động qua email sau khi kỳ lưu trú/chuyến
> đi kết thúc (tác vụ nền quét mỗi 30 phút). Ở chế độ DEV, nội dung mail (kèm link) được in
> ra console back-end thay vì gửi đi.

### 3.3 Tra cứu đơn của khách vãng lai (UC-13)
- Vào `/track`, nhập **Mã đơn** `BK-DKJ9F8QPE` và **PIN** `123456`.

### 3.4 Mã giảm giá (áp dụng khi đặt)
- `STAYTOUR10` — giảm 10% tổng đơn.
- `HE2026` — giảm 150.000đ cho đơn homestay.

### 3.5 Catalog & nội dung
- 4 homestay (9 loại phòng) + lịch tồn phòng 120 ngày (có hiển thị "sắp hết phòng").
- 4 tour + 12 chuyến khởi hành (bảng giá người lớn/trẻ em).
- 4 khu vực du lịch, 2 chương trình khuyến mại (banner trang chủ).
- 8 đánh giá (7 đã duyệt hiển thị công khai + 1 chờ duyệt), các bài thông tin/chính sách,
  1 bài cẩm nang du lịch.

> Lưu ý: nếu chạy lại `npm run db:seed` hoặc script tạo dữ liệu demo, các **mã đơn và token
> ở trên sẽ thay đổi**. Để demo đúng theo bảng này, hãy **import `tmdt.sql`** (đã kèm sẵn
> toàn bộ dữ liệu demo), đừng seed lại.
