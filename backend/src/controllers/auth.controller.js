import bcrypt from 'bcryptjs'
import jwt from 'jsonwebtoken'
import { prisma } from '../lib/prisma.js'

function signToken(user) {
  return jwt.sign(
    { sub: user.id, email: user.email },
    process.env.JWT_SECRET,
    { expiresIn: process.env.JWT_EXPIRES_IN || '7d' },
  )
}

export async function register(req, res, next) {
  try {
    const { email, password, name } = req.body

    if (!email || !password) {
      return res.status(400).json({ message: 'Email và mật khẩu là bắt buộc' })
    }
    if (password.length < 6) {
      return res.status(400).json({ message: 'Mật khẩu phải có ít nhất 6 ký tự' })
    }

    const existing = await prisma.user.findUnique({ where: { email } })
    if (existing) {
      return res.status(409).json({ message: 'Email đã được sử dụng' })
    }

    const hashed = await bcrypt.hash(password, 10)
    const user = await prisma.user.create({
      data: { email, password: hashed, name },
    })

    const token = signToken(user)
    res.status(201).json({
      token,
      user: { id: user.id, email: user.email, name: user.name },
    })
  } catch (err) {
    next(err)
  }
}

export async function login(req, res, next) {
  try {
    const { email, password } = req.body

    if (!email || !password) {
      return res.status(400).json({ message: 'Email và mật khẩu là bắt buộc' })
    }

    const user = await prisma.user.findUnique({ where: { email } })
    if (!user) {
      return res.status(401).json({ message: 'Sai email hoặc mật khẩu' })
    }

    const valid = await bcrypt.compare(password, user.password)
    if (!valid) {
      return res.status(401).json({ message: 'Sai email hoặc mật khẩu' })
    }

    const token = signToken(user)
    res.json({
      token,
      user: { id: user.id, email: user.email, name: user.name },
    })
  } catch (err) {
    next(err)
  }
}

export async function me(req, res, next) {
  try {
    const user = await prisma.user.findUnique({
      where: { id: req.user.sub },
      select: { id: true, email: true, name: true, createdAt: true },
    })
    if (!user) {
      return res.status(404).json({ message: 'Không tìm thấy người dùng' })
    }
    res.json({ user })
  } catch (err) {
    next(err)
  }
}
