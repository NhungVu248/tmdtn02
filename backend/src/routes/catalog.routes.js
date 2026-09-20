import { Router } from 'express'
import {
  checkAvailability,
  getCategories,
  getHome,
  getProductDetail,
  getProducts,
  searchProducts,
} from '../controllers/catalog.controller.js'

const router = Router()

// UC-01 – không yêu cầu đăng nhập (BR-03).
router.get('/home', getHome)
router.get('/categories', getCategories)
router.get('/products', getProducts)
// UC-02 – Tìm kiếm & lọc.
router.get('/search', searchProducts)
// UC-03 – Chi tiết & tình trạng còn trống.
router.get('/products/:slug', getProductDetail)
router.get('/products/:slug/availability', checkAvailability)

export default router
