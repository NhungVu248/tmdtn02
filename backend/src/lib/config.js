import { prisma } from './prisma.js'

// UC-23 – Cấu hình hệ thống dạng singleton (luôn 1 dòng, id=1). Cache trong bộ nhớ để các UC
// khác (UC-09/10/11/14/18) không phải truy vấn DB thêm trên mỗi request; invalidate khi UC-23 lưu thay đổi.
let cache = null

export async function getSystemConfig() {
  if (cache) return cache
  let row = await prisma.systemConfig.findUnique({ where: { id: 1 } })
  if (!row) {
    row = await prisma.systemConfig.create({ data: { id: 1 } })
  }
  cache = row
  return row
}

export function invalidateSystemConfigCache() {
  cache = null
}
