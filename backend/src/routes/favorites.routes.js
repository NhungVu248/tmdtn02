import { Router } from 'express'
import {
  addFavorite,
  listFavoriteIds,
  listFavorites,
  removeFavorite,
} from '../controllers/favorites.controller.js'
import { authenticate } from '../middleware/auth.middleware.js'

const router = Router()

// UC-08 – tất cả đều yêu cầu đăng nhập (BR-22 / «include» UC-06).
router.use(authenticate)
router.get('/', listFavorites)
router.get('/ids', listFavoriteIds)
router.post('/', addFavorite)
router.delete('/:productId', removeFavorite)

export default router
