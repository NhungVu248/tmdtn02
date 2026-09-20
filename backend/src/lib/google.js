import { OAuth2Client } from 'google-auth-library'

const clientId = process.env.GOOGLE_CLIENT_ID
const client = clientId ? new OAuth2Client(clientId) : null

export function isGoogleConfigured() {
  return Boolean(clientId)
}

// Xác minh ID token do Google Identity Services trả về ở frontend.
// Trả về thông tin hồ sơ nếu hợp lệ, ném lỗi nếu không.
export async function verifyGoogleIdToken(credential) {
  if (!client) {
    const err = new Error('Đăng nhập Google chưa được cấu hình trên máy chủ')
    err.status = 501
    throw err
  }
  const ticket = await client.verifyIdToken({ idToken: credential, audience: clientId })
  const payload = ticket.getPayload()
  return {
    googleId: payload.sub,
    email: payload.email,
    emailVerified: Boolean(payload.email_verified),
    name: payload.name,
    avatar: payload.picture,
  }
}
