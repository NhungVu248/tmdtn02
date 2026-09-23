// UC-24 (BR-67) – API client RIÊNG cho khu vực quản trị: token admin không bao giờ
// đi qua cùng một biến/hàm với api.ts của Customer, tránh dùng lẫn giữa hai bên.
const API_URL = import.meta.env.VITE_API_URL ?? 'http://localhost:4000'

export class AdminApiError extends Error {
  status: number
  code?: string
  body?: unknown // toàn bộ JSON lỗi trả về (vd: chi tiết xung đột 409 ở UC-16 BR-75)
  constructor(status: number, message: string, code?: string, body?: unknown) {
    super(message)
    this.status = status
    this.code = code
    this.body = body
  }
}

let adminToken: string | null = null
export function setAdminToken(token: string | null) {
  adminToken = token
}

async function request<T>(path: string, init?: RequestInit): Promise<T> {
  const headers = new Headers(init?.headers)
  if (adminToken) headers.set('Authorization', `Bearer ${adminToken}`)
  const res = await fetch(`${API_URL}${path}`, { ...init, headers })
  if (!res.ok) {
    let message = `Yêu cầu thất bại (${res.status})`
    let code: string | undefined
    let body: unknown
    try {
      body = await res.json()
      const b = body as { message?: string; code?: string }
      if (b?.message) message = b.message
      if (b?.code) code = b.code
    } catch {
      // giữ message mặc định
    }
    throw new AdminApiError(res.status, message, code, body)
  }
  return res.json() as Promise<T>
}

const get = <T>(path: string) => request<T>(path)
const post = <T>(path: string, body: unknown) =>
  request<T>(path, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
  })

export interface AdminInfo {
  id: number
  username: string
  name: string | null
  role: 'SUPER_ADMIN' | 'MANAGER'
}

export interface AdminLoginResult {
  token: string
  admin: AdminInfo
}

const putReq = <T>(path: string, body: unknown) =>
  request<T>(path, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
  })
const patchReq = <T>(path: string, body: unknown) =>
  request<T>(path, {
    method: 'PATCH',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
  })
const del = <T>(path: string) => request<T>(path, { method: 'DELETE' })

export interface AdminProduct {
  id: number
  name: string
  slug: string
  status: 'VISIBLE' | 'HIDDEN'
  location: string | null
  price: number
  thumbnail: string | null
  categoryId: number | null
  category?: { name: string } | null
  updatedAt: string
}

export interface AdminProductDetail extends AdminProduct {
  description: string | null
  amenities: string | null
  cancellationPolicy: string | null
  images: { id: number; url: string; order: number }[]
}

export interface AvailabilityDay {
  date: string
  totalRooms: number
  bookedRooms: number
  priceOverride: number | null
  saved: boolean
}

export interface AvailabilityConflict {
  message: string
  conflictDates: string[]
  bookings: { code: string; checkIn: string; checkOut: string; status: string }[]
}

export const adminApi = {
  login: (username: string, password: string) => post<AdminLoginResult>('/api/admin/auth/login', { username, password }),
  me: () => get<{ admin: AdminInfo & { active: boolean } }>('/api/admin/auth/me'),

  // UC-16 – Quản lý homestay
  listHomestays: (params: { status?: string; search?: string } = {}) => {
    const qs = new URLSearchParams()
    if (params.status) qs.set('status', params.status)
    if (params.search) qs.set('search', params.search)
    return get<{ items: AdminProduct[] }>(`/api/admin/homestays?${qs.toString()}`)
  },
  getHomestay: (id: number) => get<{ product: AdminProductDetail }>(`/api/admin/homestays/${id}`),
  createHomestay: (data: Record<string, unknown>) => post<{ product: AdminProductDetail }>('/api/admin/homestays', data),
  updateHomestay: (id: number, data: Record<string, unknown>) =>
    putReq<{ product: AdminProductDetail }>(`/api/admin/homestays/${id}`, data),
  setHomestayVisibility: (id: number, status: 'VISIBLE' | 'HIDDEN') =>
    patchReq<{ product: AdminProduct; warning: { message: string; bookings: unknown[] } | null }>(
      `/api/admin/homestays/${id}/visibility`,
      { status },
    ),
  uploadImage: async (file: File) => {
    const form = new FormData()
    form.append('file', file)
    const res = await fetch(`${API_URL}/api/admin/homestays/uploads/image`, {
      method: 'POST',
      headers: adminToken ? { Authorization: `Bearer ${adminToken}` } : undefined,
      body: form,
    })
    if (!res.ok) {
      const body = await res.json().catch(() => ({}))
      throw new AdminApiError(res.status, body.message || 'Tải ảnh thất bại')
    }
    return res.json() as Promise<{ filename: string; url: string }>
  },
  addImage: (productId: number, filename: string) =>
    post<{ image: { id: number; url: string; order: number } }>(`/api/admin/homestays/${productId}/images`, { filename }),
  removeImage: (productId: number, imageId: number) =>
    del<{ ok: boolean }>(`/api/admin/homestays/${productId}/images/${imageId}`),
  getAvailability: (productId: number, from: string, to: string) =>
    get<{ basePrice: number; calendar: AvailabilityDay[] }>(
      `/api/admin/homestays/${productId}/availability?from=${from}&to=${to}`,
    ),
  setAvailability: (productId: number, data: { from: string; to: string; totalRooms: number; priceOverride?: number | null }) =>
    putReq<{ ok: boolean; days: number }>(`/api/admin/homestays/${productId}/availability`, data),

  // UC-17 – Quản lý tour
  listTours: (params: { status?: string; search?: string } = {}) => {
    const qs = new URLSearchParams()
    if (params.status) qs.set('status', params.status)
    if (params.search) qs.set('search', params.search)
    return get<{ items: AdminTour[] }>(`/api/admin/tours?${qs.toString()}`)
  },
  getTour: (id: number) => get<{ product: AdminTourDetail }>(`/api/admin/tours/${id}`),
  createTour: (data: Record<string, unknown>) => post<{ product: AdminTourDetail }>('/api/admin/tours', data),
  updateTour: (id: number, data: Record<string, unknown>) => putReq<{ product: AdminTourDetail }>(`/api/admin/tours/${id}`, data),
  setTourVisibility: (id: number, status: 'VISIBLE' | 'HIDDEN') =>
    patchReq<{ product: AdminTour; warning: { message: string; bookings: unknown[] } | null }>(
      `/api/admin/tours/${id}/visibility`,
      { status },
    ),
  uploadTourImage: async (file: File) => {
    const form = new FormData()
    form.append('file', file)
    const res = await fetch(`${API_URL}/api/admin/tours/uploads/image`, {
      method: 'POST',
      headers: adminToken ? { Authorization: `Bearer ${adminToken}` } : undefined,
      body: form,
    })
    if (!res.ok) {
      const body = await res.json().catch(() => ({}))
      throw new AdminApiError(res.status, body.message || 'Tải ảnh thất bại')
    }
    return res.json() as Promise<{ filename: string; url: string }>
  },
  addTourImage: (productId: number, filename: string) =>
    post<{ image: { id: number; url: string; order: number } }>(`/api/admin/tours/${productId}/images`, { filename }),
  removeTourImage: (productId: number, imageId: number) =>
    del<{ ok: boolean }>(`/api/admin/tours/${productId}/images/${imageId}`),
  createDeparture: (productId: number, data: { date: string; totalSeats: number; priceAdultOverride?: number | null; priceChildOverride?: number | null }) =>
    post<{ departure: Departure }>(`/api/admin/tours/${productId}/departures`, data),
  updateDeparture: (
    productId: number,
    depId: number,
    data: { totalSeats?: number; priceAdultOverride?: number | null; priceChildOverride?: number | null },
  ) => putReq<{ departure: Departure }>(`/api/admin/tours/${productId}/departures/${depId}`, data),
  closeDeparture: (productId: number, depId: number) =>
    patchReq<{ departure: Departure }>(`/api/admin/tours/${productId}/departures/${depId}/close`, {}),

  // UC-18 – Quản lý đơn & xử lý hủy/hoàn tiền
  listOrders: (params: { status?: string; type?: string; from?: string; to?: string; search?: string } = {}) => {
    const qs = new URLSearchParams()
    if (params.status) qs.set('status', params.status)
    if (params.type) qs.set('type', params.type)
    if (params.from) qs.set('from', params.from)
    if (params.to) qs.set('to', params.to)
    if (params.search) qs.set('search', params.search)
    return get<{ items: AdminOrder[] }>(`/api/admin/orders?${qs.toString()}`)
  },
  getOrder: (code: string) =>
    get<{ order: AdminOrderDetail; payments: AdminPayment[]; refundRequests: AdminRefundRequest[] }>(
      `/api/admin/orders/${code}`,
    ),
  updateOrderStatus: (code: string, status: string) =>
    patchReq<{ order: AdminOrderDetail }>(`/api/admin/orders/${code}/status`, { status }),
  processRefund: (code: string, refundId: number, data: { amount?: number; referenceCode?: string }) =>
    post<{ refund: AdminRefundRequest }>(`/api/admin/orders/${code}/refunds/${refundId}/process`, data),

  // UC-19 – Quản lý người dùng & phân quyền
  listCustomers: (params: { status?: string; search?: string } = {}) => {
    const qs = new URLSearchParams()
    if (params.status) qs.set('status', params.status)
    if (params.search) qs.set('search', params.search)
    return get<{ items: AdminCustomer[] }>(`/api/admin/users/customers?${qs.toString()}`)
  },
  getCustomer: (id: number) =>
    get<{ user: AdminCustomerDetail; activeBookings: { code: string; status: string; type: string }[] }>(
      `/api/admin/users/customers/${id}`,
    ),
  setCustomerLock: (id: number, disabled: boolean) =>
    patchReq<{ user: { id: number; disabled: boolean }; warning: { message: string; bookings: unknown[] } | null }>(
      `/api/admin/users/customers/${id}/lock`,
      { disabled },
    ),
  listAdmins: (params: { role?: string; status?: string; search?: string } = {}) => {
    const qs = new URLSearchParams()
    if (params.role) qs.set('role', params.role)
    if (params.status) qs.set('status', params.status)
    if (params.search) qs.set('search', params.search)
    return get<{ items: AdminAccount[] }>(`/api/admin/users/admins?${qs.toString()}`)
  },
  createAdmin: (data: { username: string; password: string; name?: string; role: 'SUPER_ADMIN' | 'MANAGER' }) =>
    post<{ admin: AdminAccount }>('/api/admin/users/admins', data),
  updateAdminRole: (id: number, role: 'SUPER_ADMIN' | 'MANAGER') =>
    patchReq<{ admin: AdminAccount }>(`/api/admin/users/admins/${id}/role`, { role }),
  setAdminActive: (id: number, active: boolean) =>
    patchReq<{ admin: AdminAccount }>(`/api/admin/users/admins/${id}/active`, { active }),

  // UC-20 – Quản lý mã khuyến mại
  listDiscounts: (params: { status?: string; search?: string } = {}) => {
    const qs = new URLSearchParams()
    if (params.status) qs.set('status', params.status)
    if (params.search) qs.set('search', params.search)
    return get<{ items: AdminDiscount[] }>(`/api/admin/discounts?${qs.toString()}`)
  },
  getDiscount: (id: number) => get<{ item: AdminDiscount }>(`/api/admin/discounts/${id}`),
  createDiscount: (data: Record<string, unknown>) => post<{ item: AdminDiscount }>('/api/admin/discounts', data),
  updateDiscount: (id: number, data: Record<string, unknown>) => putReq<{ item: AdminDiscount }>(`/api/admin/discounts/${id}`, data),
  setDiscountActive: (id: number, active: boolean) =>
    patchReq<{ item: AdminDiscount }>(`/api/admin/discounts/${id}/active`, { active }),

  // UC-21 – Kiểm duyệt đánh giá
  listReviews: (params: { status?: string } = {}) => {
    const qs = new URLSearchParams()
    if (params.status) qs.set('status', params.status)
    return get<{ items: AdminReview[] }>(`/api/admin/reviews?${qs.toString()}`)
  },
  approveReview: (id: number) => patchReq<{ item: AdminReview }>(`/api/admin/reviews/${id}/approve`, {}),
  rejectReview: (id: number) => patchReq<{ item: AdminReview }>(`/api/admin/reviews/${id}/reject`, {}),

  // UC-22 – Báo cáo & thống kê
  getReports: (params: { from?: string; to?: string } = {}) => {
    const qs = new URLSearchParams()
    if (params.from) qs.set('from', params.from)
    if (params.to) qs.set('to', params.to)
    return get<AdminReports>(`/api/admin/reports?${qs.toString()}`)
  },

  // UC-23 – Cấu hình hệ thống & nhật ký
  getSystemConfig: () => get<{ config: AdminSystemConfig }>('/api/admin/config'),
  updateSystemConfig: (data: Partial<AdminSystemConfig>) => putReq<{ config: AdminSystemConfig }>('/api/admin/config', data),
  listAuditLogs: (params: { action?: string; from?: string; to?: string } = {}) => {
    const qs = new URLSearchParams()
    if (params.action) qs.set('action', params.action)
    if (params.from) qs.set('from', params.from)
    if (params.to) qs.set('to', params.to)
    return get<{ items: AdminAuditLogEntry[]; loginAttempts: AdminLoginAttemptEntry[] }>(`/api/admin/config/audit-logs?${qs.toString()}`)
  },
}

export interface AdminSystemConfig {
  id: number
  depositRatePercent: number
  cancelFreeHours: number
  cancelTier1Days: number
  cancelTier1Ratio: number
  cancelTier2Days: number
  cancelTier2Ratio: number
  sellerName: string | null
  sellerAddress: string | null
  sellerPhone: string | null
  sellerEmail: string | null
  siteNotice: string | null
  updatedAt: string
}

export interface AdminAuditLogEntry {
  id: number
  type: 'ACTION'
  action: string
  adminUsername?: string
  entityType: string | null
  entityId: number | null
  detail: string | null
  createdAt: string
}

export interface AdminLoginAttemptEntry {
  id: number
  type: 'LOGIN'
  username: string
  success: boolean
  reason: string | null
  ip: string | null
  createdAt: string
}

export interface AdminReports {
  range: { from: string; to: string }
  revenue: { gross: number; refunded: number; net: number; byDay: { date: string; amount: number }[] }
  ordersByStatus: { status: string; count: number }[]
  topTours: { productId: number; name?: string; slug?: string; bookingsCount: number; seats: number }[]
  homestayOccupancy: { productId: number; name?: string; slug?: string; totalRoomNights: number; bookedRoomNights: number; rate: number }[]
}

export interface AdminReview {
  id: number
  productId: number
  bookingId: number | null
  authorName: string
  rating: number
  comment: string | null
  approved: boolean
  rejected: boolean
  createdAt: string
  product?: { name: string; slug: string }
}

export interface AdminDiscount {
  id: number
  code: string
  type: 'PERCENT' | 'FIXED'
  value: number
  minOrderValue: number
  scope: 'ALL' | 'HOMESTAY' | 'TOUR'
  productId: number | null
  product?: { name: string; slug: string } | null
  audience: 'ALL' | 'CUSTOMER'
  startAt: string | null
  endAt: string | null
  maxUses: number | null
  usedCount: number
  active: boolean
  createdAt: string
}

export interface AdminCustomer {
  id: number
  email: string
  name: string | null
  phone: string | null
  disabled: boolean
  emailVerified: boolean
  createdAt: string
  _count: { bookings: number }
}

export interface AdminCustomerDetail {
  id: number
  email: string
  name: string | null
  phone: string | null
  address: string | null
  disabled: boolean
  emailVerified: boolean
  googleId: string | null
  createdAt: string
}

export interface AdminAccount {
  id: number
  username: string
  name: string | null
  role: 'SUPER_ADMIN' | 'MANAGER'
  active: boolean
  createdAt: string
}

export interface AdminOrder {
  code: string
  type: 'HOMESTAY' | 'TOUR'
  status: 'PENDING_DEPOSIT' | 'DEPOSITED' | 'CONFIRMED' | 'COMPLETED' | 'CANCELLED'
  productName: string
  productSlug: string
  guestName: string
  guestEmail: string
  guestPhone: string
  checkIn: string | null
  checkOut: string | null
  guests: number
  children: number
  totalPrice: number
  depositAmount: number
  remainingAmount: number
  paymentMethod: string | null
  createdAt: string
}

export interface AdminOrderDetail extends AdminOrder {
  discountCode: string | null
  discountAmount: number
  transactionId: string | null
  depositPaidAt: string | null
  cancelledAt: string | null
  allowedTransitions: string[]
}

export interface AdminPayment {
  id: number
  method: string
  amount: number
  status: string
  transactionId: string | null
  createdAt: string
}

export interface AdminRefundRequest {
  id: number
  bookingId: number
  amount: number
  ratio: number
  status: string
  createdAt: string
}

export interface AdminTour {
  id: number
  name: string
  slug: string
  status: 'VISIBLE' | 'HIDDEN'
  location: string | null
  price: number
  priceChild: number | null
  durationDays: number | null
  thumbnail: string | null
  categoryId: number | null
  category?: { name: string } | null
  updatedAt: string
}

export interface Departure {
  id: number
  productId: number
  date: string
  totalSeats: number
  bookedSeats: number
  priceAdultOverride: number | null
  priceChildOverride: number | null
  closed: boolean
}

export interface AdminTourDetail extends AdminTour {
  description: string | null
  itinerary: string | null
  included: string | null
  excluded: string | null
  cancellationPolicy: string | null
  images: { id: number; url: string; order: number }[]
  departures: Departure[]
}
