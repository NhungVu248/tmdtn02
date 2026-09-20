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
  constructor(status: number, message: string) {
    super(message)
    this.status = status
  }
}

async function get<T>(path: string): Promise<T> {
  const res = await fetch(`${API_URL}${path}`)
  if (!res.ok) {
    let message = `Yêu cầu thất bại (${res.status})`
    try {
      const body = await res.json()
      if (body?.message) message = body.message
    } catch {
      // giữ message mặc định
    }
    throw new ApiError(res.status, message)
  }
  return res.json() as Promise<T>
}

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
}

export function formatPrice(v: number): string {
  return v.toLocaleString('vi-VN') + '₫'
}
