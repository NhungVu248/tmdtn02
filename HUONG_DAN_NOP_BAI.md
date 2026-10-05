# HƯỚNG DẪN ĐÓNG GÓI & CHECKLIST NỘP BÀI — STAYTOUR (Nhóm 09)

Cấu trúc thư mục nộp đã được dựng sẵn trong dự án:

```
01_SourceCode/   → README (mã nguồn ở backend/ & frontend/ — chép vào, bỏ node_modules/dist/.env)
02_Database/      → tmdt.sql (cấu trúc + dữ liệu mẫu) + TAI_KHOAN_THU.md (tài khoản theo vai trò)  ✅
03_Deployment/    → HUONG_DAN_TRIEN_KHAI.md + Docker (ở gốc: docker-compose.yml, backend/Dockerfile, frontend/Dockerfile)  ✅
04_Testing/       → TestCase_TMDT.xlsx (50 ca chức năng + 10 ca bảo mật, đã có kết quả)  ✅
05_Documents/     → BaoCao_ThuongMaiDienTu.docx + BienBanHop/ (3 biên bản)  ⚠️ còn thiếu bản PDF
06_Media/         → (TỰ BỔ SUNG) ảnh minh chứng + video demo 5–10 phút  ❌
README.txt        → thông tin nhóm, tài khoản, hướng dẫn chạy nhanh  ✅
```

## ✅ CHECKLIST

- [x] **01_SourceCode** — mã nguồn backend/ + frontend/ (nhớ bỏ node_modules, dist, .env khi nén)
- [x] **02_Database** — `tmdt.sql` + bảng tài khoản thử theo vai trò
- [x] **03_Deployment** — Docker + hướng dẫn cài đặt, cấu hình, xử lý sự cố
- [x] **04_Testing** — bộ ca kiểm thử chức năng + rà soát bảo mật (đã điền kết quả)
- [x] **05_Documents** — báo cáo .docx + bảng phân công (trong báo cáo) + 3 biên bản họp
- [ ] **05_Documents** — **xuất bản PDF** của báo cáo (mở .docx → Save as PDF)
- [ ] **06_Media** — **ảnh chụp minh chứng** các chức năng
- [ ] **06_Media** — **video demo 5–10 phút**
- [x] **README.txt** — thông tin nhóm, tài khoản đăng nhập, hướng dẫn chạy nhanh

## 📦 CÁCH TẠO GÓI NỘP (gợi ý)
1. Chép `backend/` và `frontend/` vào `01_SourceCode/` (xóa `node_modules/`, `frontend/dist/`, các file `.env`).
2. Mở `05_Documents/BaoCao_ThuongMaiDienTu.docx` bằng Word → xuất `BaoCao_ThuongMaiDienTu.pdf` vào cùng thư mục.
3. Thêm ảnh minh chứng + video vào `06_Media/`.
4. Nén toàn bộ 6 thư mục + `README.txt` thành 1 file `.zip` để nộp.

> Chỉ còn 3 việc cần làm thủ công (đánh dấu [ ] ở trên): xuất PDF báo cáo, chụp ảnh minh chứng, quay video demo.
