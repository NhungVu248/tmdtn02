# ---- Backend (Node/Express + Prisma) ----
# Dùng node:20 (Debian đầy đủ) vì đã có sẵn openssl mà Prisma cần — không cần cài thêm gói OS.
FROM node:20

WORKDIR /app

# Cài dependencies (gồm cả prisma CLI để generate/db push lúc chạy)
COPY package*.json ./
RUN npm ci

# Sinh Prisma Client theo schema
COPY prisma ./prisma
RUN npx prisma generate

# Chép mã nguồn
COPY . .

# Entrypoint: chờ DB -> đồng bộ schema -> seed lần đầu -> chạy server
COPY docker-entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 4000
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
