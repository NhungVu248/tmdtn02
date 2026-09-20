import cors from 'cors'
import express from 'express'
import { errorHandler, notFoundHandler } from './middleware/error.middleware.js'
import authRoutes from './routes/auth.routes.js'
import catalogRoutes from './routes/catalog.routes.js'

const app = express()

// CORS: cho phép CLIENT_URL cấu hình + mọi cổng localhost khi phát triển
// (Vite có thể đổi cổng 5173 -> 5174... nếu cổng bị chiếm).
const allowedOrigin = process.env.CLIENT_URL || 'http://localhost:5173'
app.use(
  cors({
    origin(origin, callback) {
      if (!origin) return callback(null, true) // curl/Postman (không có Origin)
      if (origin === allowedOrigin || /^https?:\/\/localhost:\d+$/.test(origin)) {
        return callback(null, true)
      }
      return callback(new Error(`Origin không được phép: ${origin}`))
    },
  }),
)
app.use(express.json())

app.get('/api/health', (req, res) => {
  res.json({ status: 'ok' })
})

app.use('/api/auth', authRoutes)
app.use('/api/catalog', catalogRoutes)

app.use(notFoundHandler)
app.use(errorHandler)

export default app
