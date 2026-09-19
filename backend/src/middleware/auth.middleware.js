import jwt from 'jsonwebtoken'

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
