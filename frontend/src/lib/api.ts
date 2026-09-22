const API_URL = import.meta.env.VITE_API_URL ?? 'http://localhost:4000'

export type ProductType = 'HOMESTAY' | 'TOUR'

export interface Product {
  id: number
  name: string
  slug: string
  type: ProductType
  location: string | null
  price: number
  rating: number
  thumbnail: string | null
  isFeatured: boolean
  categoryId: number | null
  amenities?: string | null
  durationDays?: number | null
  nights?: number // BR-05: số đêm khi tìm homestay theo khoảng ngày
  totalPrice?: number // BR-05: giá theo số đêm
}

export interface SearchFacets {
  locations: string[]
  amenities: string[]
  durations: number[]
  priceMin: number
  priceMax: number
}

export interface SearchResult {
  criteria: Record<string, string | null>
  nights: number | null
  facets: SearchFacets
  count: number
  items: Product[]
}

export interface Category {
  id: number
  name: string
  slug: string
  type: ProductType
  order: number
  parentId: number | null
  children: Category[]
}

export interface Area {
  id: number
  name: string
  slug: string
  image: string | null
  order: number
}

export interface Promotion {
  id: number
  title: string
  description: string | null
  image: string | null
}

export interface HomeData {
  featured: Product[]
  areas: Area[]
  promotions: Promotion[]
}

export interface ProductList {
  category: Category | null
  count: number
  items: Product[]
}

export interface Review {
  id: number
  authorName: string
  rating: number
  comment: string | null
  createdAt: string
}

export interface Departure {
  id: number
  date: string
  totalSeats: number
  seatsLeft: number
}

export interface ProductDetail extends Product {
  description: string | null
  cancellationPolicy: string | null
  itinerary: string | null
  priceChild: number | null
  images: { id: number; url: string; order: number }[]
  category: Category | null
  departures: Departure[]
}

export interface DetailResponse {
  product: ProductDetail
  reviews: Review[]
  similar: Product[]
}

export interface Availability {
  type: ProductType
  available: boolean
  nights?: number
  roomsLeft?: number
  seatsLeft?: number
  tentativePrice: number | null
  message: string | null
}

export class ApiError extends Error {
  status: number
  code?: string
  constructor(status: number, message: string) {
    super(message)
    this.status = status
  }
}

export type InfoCategory = 'ABOUT' | 'POLICY' | 'GUIDE'

export interface InfoSummary {
  id: number
  slug: string
  title: string
  category: InfoCategory
  excerpt: string | null
  updatedAt: string
}

export interface InfoArticle extends InfoSummary {
  content: string
  published: boolean
}

// Token đăng nhập hiện tại (do AuthProvider thiết lập) để gắn vào request cần xác thực.
let authToken: string | null = null
export function setAuthToken(token: string | null) {
  authToken = token
}

async function request<T>(path: string, init?: RequestInit): Promise<T> {
  const headers = new Headers(init?.headers)
  if (authToken) headers.set('Authorization', `Bearer ${authToken}`)
  const res = await fetch(`${API_URL}${path}`, { ...init, headers })
  if (!res.ok) {
    let message = `Yêu cầu thất bại (${res.status})`
    let code: string | undefined
    try {
      const body = await res.json()
      if (body?.message) message = body.message
      if (body?.code) code = body.code
    } catch {
      // giữ message mặc định
    }
    const err = new ApiError(res.status, message)
    err.code = code
    throw err
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
const put = <T>(path: string, body: unknown) =>
  request<T>(path, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
  })

export const api = {
  getHome: () => get<HomeData>('/api/catalog/home'),
  getCategories: (type?: ProductType) =>
    get<{ categories: Category[] }>(`/api/catalog/categories${type ? `?type=${type}` : ''}`),
  getProducts: (params: { categorySlug?: string; type?: ProductType; location?: string }) => {
    const qs = new URLSearchParams()
    if (params.categorySlug) qs.set('categorySlug', params.categorySlug)
    if (params.type) qs.set('type', params.type)
    if (params.location) qs.set('location', params.location)
    return get<ProductList>(`/api/catalog/products?${qs.toString()}`)
  },
  search: (params: URLSearchParams) => get<SearchResult>(`/api/catalog/search?${params.toString()}`),
  getProductDetail: (slug: string) => get<DetailResponse>(`/api/catalog/products/${encodeURIComponent(slug)}`),
  checkAvailability: (slug: string, params: URLSearchParams) =>
    get<Availability>(`/api/catalog/products/${encodeURIComponent(slug)}/availability?${params.toString()}`),
  getInfoList: () => get<{ articles: InfoSummary[] }>('/api/info'),
  getInfoArticle: (slug: string) => get<{ article: InfoArticle }>(`/api/info/${encodeURIComponent(slug)}`),
  register: (body: {
    email: string
    password: string
    confirmPassword: string
    name?: string
    acceptedTerms: boolean
  }) => post<RegisterResult>('/api/auth/register', body),
  verifyEmail: (token: string) => post<{ message: string; email: string }>('/api/auth/verify-email', { token }),
  resendVerification: (email: string) =>
    post<{ message: string; devVerifyUrl?: string }>('/api/auth/resend-verification', { email }),
  login: (email: string, password: string) => post<AuthResult>('/api/auth/login', { email, password }),
  googleAuth: (credential: string) => post<AuthResult & { isNew: boolean }>('/api/auth/google', { credential }),
  getAuthConfig: () => get<{ googleEnabled: boolean }>('/api/auth/config'),
  forgotPassword: (email: string) =>
    post<{ message: string; devResetUrl?: string }>('/api/auth/forgot-password', { email }),
  resetPassword: (token: string, password: string) =>
    post<{ message: string }>('/api/auth/reset-password', { token, password }),
  getMe: () => get<{ user: AuthUser }>('/api/auth/me'),
  updateProfile: (data: { name?: string; phone?: string; address?: string }) =>
    put<{ user: AuthUser }>('/api/auth/profile', data),
  changePassword: (currentPassword: string, newPassword: string) =>
    put<{ message: string }>('/api/auth/password', { currentPassword, newPassword }),
  getFavorites: () => get<{ items: Product[] }>('/api/favorites'),
  getFavoriteIds: () => get<{ ids: number[] }>('/api/favorites/ids'),
  addFavorite: (productId: number) =>
    post<{ favorited: boolean; productId: number }>('/api/favorites', { productId }),
  removeFavorite: (productId: number) =>
    request<{ favorited: boolean; productId: number }>(`/api/favorites/${productId}`, { method: 'DELETE' }),
}

export interface AuthUser {
  id: number
  email: string
  name: string | null
  phone?: string | null
  address?: string | null
  avatar?: string | null
  emailVerified: boolean
}

export interface AuthResult {
  token: string
  user: AuthUser
}

export interface RegisterResult {
  message: string
  emailSent: boolean
  email: string
  devVerifyUrl?: string
}

export function formatPrice(v: number): string {
  return v.toLocaleString('vi-VN') + '₫'
}
