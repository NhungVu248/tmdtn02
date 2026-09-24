import { prisma } from '../lib/prisma.js'

// Cẩm nang du lịch công khai — danh sách (chỉ bài đã hiển thị).
export async function listPublicGuides(req, res, next) {
  try {
    const { search } = req.query
    const where = { status: 'VISIBLE' }
    if (search) where.title = { contains: String(search) }
    const items = await prisma.travelGuide.findMany({
      where,
      select: {
        id: true, title: true, slug: true, authorName: true, coverImage: true,
        excerpt: true, locationName: true, publishedAt: true,
      },
      orderBy: [{ publishedAt: 'desc' }, { createdAt: 'desc' }],
    })
    res.json({ items })
  } catch (err) {
    next(err)
  }
}

// Chi tiết một bài cẩm nang + tour liên quan (chỉ tour đang hiển thị).
export async function getPublicGuide(req, res, next) {
  try {
    const slug = String(req.params.slug || '')
    const guide = await prisma.travelGuide.findUnique({
      where: { slug },
      include: {
        relatedTours: {
          include: {
            tour: {
              select: { id: true, title: true, slug: true, thumbnail: true, basePrice: true, durationDays: true, durationNights: true, status: true, avgRating: true, reviewCount: true },
            },
          },
        },
      },
    })
    if (!guide || guide.status !== 'VISIBLE') {
      return res.status(404).json({ message: 'Không tìm thấy bài cẩm nang' })
    }
    const relatedTours = guide.relatedTours.map((r) => r.tour).filter((t) => t && t.status === 'VISIBLE')
    res.json({ guide: { ...guide, relatedTours } })
  } catch (err) {
    next(err)
  }
}
