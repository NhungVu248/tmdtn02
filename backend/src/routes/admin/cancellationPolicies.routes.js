import { Router } from 'express'
import { listPolicies, createPolicy, updatePolicy, deletePolicy } from '../../controllers/admin/cancellationPolicies.controller.js'
import { requireAdmin } from '../../middleware/adminAuth.middleware.js'

const router = Router()
router.use(requireAdmin)

router.get('/', listPolicies)
router.post('/', createPolicy)
router.patch('/:id', updatePolicy)
router.delete('/:id', deletePolicy)

export default router
