import cors from 'cors'
import express from 'express'
import { errorHandler, notFoundHandler } from './middleware/error.middleware.js'
import authRoutes from './routes/auth.routes.js'

const app = express()

app.use(cors({ origin: process.env.CLIENT_URL || '*' }))
app.use(express.json())

app.get('/api/health', (req, res) => {
  res.json({ status: 'ok' })
})

app.use('/api/auth', authRoutes)

app.use(notFoundHandler)
app.use(errorHandler)

export default app
