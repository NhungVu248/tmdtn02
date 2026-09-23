export function notFoundHandler(req, res) {
  res.status(404).json({ message: 'Không tìm thấy route' })
}

// eslint-disable-next-line no-unused-vars
export function errorHandler(err, req, res, next) {
  console.error(err)
  // UC-16 (BR-76): lỗi từ multer (kích thước/loại tệp) -> 400 thay vì 500 mặc định.
  if (err.name === 'MulterError' || /Chỉ chấp nhận ảnh/.test(err.message || '')) {
    const msg = err.code === 'LIMIT_FILE_SIZE' ? 'Ảnh vượt quá dung lượng tối đa (5MB)' : err.message
    return res.status(400).json({ message: msg })
  }
  const status = err.status || 500
  res.status(status).json({ message: err.message || 'Lỗi máy chủ' })
}
