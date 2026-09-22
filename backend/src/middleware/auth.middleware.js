import jwt from 'jsonwebtoken'

// Gắn req.user nếu có token hợp lệ, nhưng KHÔNG bắt buộc (dùng cho guest checkout).
export function optionalAuth(req, res, next) {
  const header = req.headers.authorization
  if (header && header.startsWith('Bearer ')) {
    try {
      req.user = jwt.verify(header.slice('Bearer '.length), process.env.JWT_SECRET)
    } catch {
      // token sai -> coi như khách (guest)
    }
  }
  next()
}

export function authenticate(req, res, next) {
  const header = req.headers.authorization

  if (!header || !header.startsWith('Bearer ')) {
    return res.status(401).json({ message: 'Thiếu hoặc sai định dạng token' })
  }

  const token = header.slice('Bearer '.length)

  try {
    const payload = jwt.verify(token, process.env.JWT_SECRET)
    req.user = payload
    next()
  } catch (err) {
    return res.status(401).json({ message: 'Token không hợp lệ hoặc đã hết hạn' })
  }
}
