// @prisma/client is a CommonJS package; the default import is the most
// robust way to get PrismaClient in an ESM project (no reliance on
// named-export static detection).
import pkg from '@prisma/client'

const { PrismaClient } = pkg

// Reuse a single PrismaClient instance across the app (and across
// hot-reloads in dev) instead of opening a new connection pool each time.
export const prisma = new PrismaClient()
