import { Router } from 'express'
import { getPublicGuide, listPublicGuides } from '../controllers/publicGuides.controller.js'

const router = Router()

// Cẩm nang du lịch công khai.
router.get('/', listPublicGuides)
router.get('/:slug', getPublicGuide)

export default router
