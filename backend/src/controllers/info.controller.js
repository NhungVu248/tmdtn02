import { prisma } from '../lib/prisma.js'

// UC-04 – Danh sách bài viết đã công bố (BR-11), lọc theo category nếu có.
export async function listInfo(req, res, next) {
  try {
    const { category } = req.query
    const where = { published: true }
    if (['ABOUT', 'POLICY', 'GUIDE'].includes(category)) where.category = category

    const articles = await prisma.infoArticle.findMany({
      where,
      select: { id: true, slug: true, title: true, category: true, excerpt: true, updatedAt: true },
      orderBy: [{ category: 'asc' }, { order: 'asc' }],
    })
    res.json({ articles })
  } catch (err) {
    next(err)
  }
}

// UC-04 – Nội dung một bài viết. Ngoại lệ 2a: không tồn tại/chưa công bố.
export async function getInfo(req, res, next) {
  try {
    const article = await prisma.infoArticle.findUnique({ where: { slug: req.params.slug } })
    if (!article || !article.published) {
      return res.status(404).json({ message: 'Không tìm thấy nội dung' })
    }
    res.json({ article })
  } catch (err) {
    next(err)
  }
}
