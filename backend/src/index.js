import 'dotenv/config'
import app from './app.js'
import { isEmailConfigured } from './lib/mailer.js'
import { isGoogleConfigured } from './lib/google.js'
import { isVnpayConfigured } from './lib/vnpay.js'
import { sweepCompletedBookings } from './lib/booking.js'

const PORT = process.env.PORT || 4000

// UC-15 (BR-64) – Tác vụ nền định kỳ: tự hoàn tất đơn khi kết thúc trải nghiệm + gửi thư mời đánh giá,
// không phụ thuộc việc khách có mở đơn hay không. Chạy sau khi khởi động và lặp lại theo chu kỳ.
const SWEEP_MINUTES = Number(process.env.REVIEW_SWEEP_MINUTES || 30)
function startReviewSweep() {
  const run = () => sweepCompletedBookings().catch((e) => console.error('[UC-15 sweep] lỗi:', e))
  setTimeout(run, 10_000) // chạy lần đầu ~10s sau khi khởi động
  setInterval(run, SWEEP_MINUTES * 60_000)
}

app.listen(PORT, () => {
  console.log(`Backend đang chạy tại http://localhost:${PORT}`)
  console.log(`  • Email: ${isEmailConfigured() ? 'SMTP (gửi thật)' : 'DEV (log link ra console)'}`)
  console.log(`  • Google login: ${isGoogleConfigured() ? 'BẬT' : 'TẮT (chưa cấu hình GOOGLE_CLIENT_ID)'}`)
  console.log(`  • VNPAY: ${isVnpayConfigured() ? 'BẬT' : 'TẮT (dùng COD; cấu hình VNP_TMN_CODE để bật)'}`)
  console.log(`  • Quét đánh giá (UC-15): mỗi ${SWEEP_MINUTES} phút`)
  startReviewSweep()
})
