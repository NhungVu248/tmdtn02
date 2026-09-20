import { Router } from 'express'
import { getInfo, listInfo } from '../controllers/info.controller.js'

const router = Router()

// UC-04 – công khai, không yêu cầu đăng nhập.
router.get('/', listInfo)
router.get('/:slug', getInfo)

export default router
