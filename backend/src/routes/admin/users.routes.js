import { Router } from 'express'
import {
  createAdmin,
  getCustomer,
  listAdmins,
  listCustomers,
  setAdminActive,
  setCustomerLock,
  updateAdminRole,
} from '../../controllers/admin/users.controller.js'
import { requireAdmin, requireRole } from '../../middleware/adminAuth.middleware.js'

const router = Router()

// UC-19 «include» UC-24: mọi route bên dưới yêu cầu đã đăng nhập quản trị (BR-96).
router.use(requireAdmin)

// Khách hàng: MANAGER và SUPER_ADMIN đều được quản lý (không phải cấp quyền tài khoản quản trị).
router.get('/customers', listCustomers)
router.get('/customers/:id', getCustomer)
router.patch('/customers/:id/lock', setCustomerLock)

// Quản trị viên: chỉ SUPER_ADMIN được cấp/thu hồi vai trò quản trị (BR-92/schema AdminRole).
router.get('/admins', requireRole('SUPER_ADMIN'), listAdmins)
router.post('/admins', requireRole('SUPER_ADMIN'), createAdmin)
router.patch('/admins/:id/role', requireRole('SUPER_ADMIN'), updateAdminRole)
router.patch('/admins/:id/active', requireRole('SUPER_ADMIN'), setAdminActive)

export default router
