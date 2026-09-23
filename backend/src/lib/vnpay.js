import crypto from 'crypto'
import querystring from 'querystring'

const TMN_CODE = process.env.VNP_TMN_CODE
const HASH_SECRET = process.env.VNP_HASH_SECRET
const VNP_URL = process.env.VNP_URL || 'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html'

export function isVnpayConfigured() {
  return Boolean(TMN_CODE && HASH_SECRET)
}

// Sắp xếp khóa và mã hóa giá trị theo cách VNPAY dùng để ký (space -> +).
function sortObject(obj) {
  const sorted = {}
  for (const key of Object.keys(obj).sort()) {
    sorted[key] = encodeURIComponent(String(obj[key])).replace(/%20/g, '+')
  }
  return sorted
}

function pad(n) {
  return String(n).padStart(2, '0')
}
function formatDate(d) {
  return (
    d.getFullYear() +
    pad(d.getMonth() + 1) +
    pad(d.getDate()) +
    pad(d.getHours()) +
    pad(d.getMinutes()) +
    pad(d.getSeconds())
  )
}

// Tạo URL thanh toán VNPAY (BR-38: người dùng nhập thẻ trên trang cổng).
export function buildPaymentUrl({ amount, orderId, orderInfo, ipAddr, returnUrl }) {
  const now = new Date()
  const expire = new Date(now.getTime() + 15 * 60000) // hết hạn sau 15 phút
  // vnp_OrderInfo chỉ cho chữ/số/khoảng trắng (không dấu, không ký tự đặc biệt).
  const safeInfo = String(orderInfo).normalize('NFD').replace(/[^\x20-\x7E]/g, '').replace(/[^a-zA-Z0-9 ]/g, ' ').trim()
  // Chuẩn hóa IP: Express hay trả ::1 / ::ffff:127.0.0.1 (IPv6) -> đưa về IPv4 hợp lệ.
  let ip = String(ipAddr || '').replace('::ffff:', '')
  if (ip.includes(':') || ip.length < 7) ip = '127.0.0.1'
  let params = {
    vnp_Version: '2.1.0',
    vnp_Command: 'pay',
    vnp_TmnCode: TMN_CODE,
    vnp_Locale: 'vn',
    vnp_CurrCode: 'VND',
    vnp_TxnRef: orderId,
    vnp_OrderInfo: safeInfo,
    vnp_OrderType: 'other',
    vnp_Amount: amount * 100, // VNPAY dùng đơn vị x100
    vnp_ReturnUrl: returnUrl,
    vnp_IpAddr: ip,
    vnp_CreateDate: formatDate(now),
    vnp_ExpireDate: formatDate(expire), // BẮT BUỘC ở v2.1.0
  }
  params = sortObject(params)
  const signData = querystring.stringify(params, undefined, undefined, { encodeURIComponent: (x) => x })
  const hmac = crypto.createHmac('sha512', HASH_SECRET)
  const secureHash = hmac.update(Buffer.from(signData, 'utf-8')).digest('hex')
  params.vnp_SecureHash = secureHash
  return VNP_URL + '?' + querystring.stringify(params, undefined, undefined, { encodeURIComponent: (x) => x })
}

// Xác minh chữ ký trên kết quả trả về (BR-40: không tin URL, phải verify checksum).
export function verifyReturn(query) {
  const received = query.vnp_SecureHash
  const params = { ...query }
  delete params.vnp_SecureHash
  delete params.vnp_SecureHashType

  const sorted = sortObject(params)
  const signData = querystring.stringify(sorted, undefined, undefined, { encodeURIComponent: (x) => x })
  const hmac = crypto.createHmac('sha512', HASH_SECRET)
  const signed = hmac.update(Buffer.from(signData, 'utf-8')).digest('hex')

  const valid = signed === received
  const success = valid && query.vnp_ResponseCode === '00' && query.vnp_TransactionStatus === '00'
  return { valid, success, transactionId: query.vnp_TransactionNo, txnRef: query.vnp_TxnRef }
}
