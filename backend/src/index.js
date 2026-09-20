import 'dotenv/config'
import app from './app.js'
import { isEmailConfigured } from './lib/mailer.js'
import { isGoogleConfigured } from './lib/google.js'

const PORT = process.env.PORT || 4000

app.listen(PORT, () => {
  console.log(`Backend đang chạy tại http://localhost:${PORT}`)
  console.log(`  • Email: ${isEmailConfigured() ? 'SMTP (gửi thật)' : 'DEV (log link ra console)'}`)
  console.log(`  • Google login: ${isGoogleConfigured() ? 'BẬT' : 'TẮT (chưa cấu hình GOOGLE_CLIENT_ID)'}`)
})
