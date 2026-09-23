import { logAdminAction } from '../../lib/auditLog.js'
import { publicUploadUrl } from '../../lib/uploads.js'

// UC-16 (BR-76) – Nhận 1 tệp ảnh đã qua kiểm soát loại/kích thước (multer), trả về URL công khai.
export async function uploadFile(req, res) {
  if (!req.file) {
    return res.status(400).json({ message: 'Vui lòng chọn một tệp ảnh (JPEG/PNG/WEBP, tối đa 5MB)' }) // 5a
  }
  logAdminAction(req.admin.sub, 'upload.image', { detail: { filename: req.file.filename, size: req.file.size } })
  res.status(201).json({ filename: req.file.filename, url: publicUploadUrl(req.file.filename) })
}
