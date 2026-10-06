#!/bin/sh
set -e

echo "[entrypoint] Chờ cơ sở dữ liệu sẵn sàng & đồng bộ schema..."
# Thử đồng bộ schema, lặp lại tới khi DB sẵn sàng (DB container có thể khởi động chậm hơn).
until npx prisma db push --skip-generate >/dev/null 2>&1; do
  echo "[entrypoint] DB chưa sẵn sàng, thử lại sau 3s..."
  sleep 3
done
echo "[entrypoint] Đã đồng bộ schema."

# Seed dữ liệu mẫu + tài khoản admin CHỈ ở lần chạy đầu tiên (tránh ghi đè dữ liệu khi khởi động lại).
mkdir -p /app/uploads
if [ ! -f /app/uploads/.seeded ]; then
  echo "[entrypoint] Lần chạy đầu — seed dữ liệu mẫu..."
  if npm run db:seed; then
    touch /app/uploads/.seeded
    echo "[entrypoint] Seed catalog xong."
    # Dữ liệu demo cho bảo vệ: tài khoản khách hàng, đơn đủ trạng thái, đánh giá,
    # hoàn tiền, yêu thích, token đánh giá (UC-15). Lỗi ở bước này không chặn server.
    if npm run db:seed:demo; then
      echo "[entrypoint] Seed dữ liệu demo xong."
    else
      echo "[entrypoint] Seed dữ liệu demo thất bại (bỏ qua, server vẫn chạy)."
    fi
  else
    echo "[entrypoint] Seed thất bại (bỏ qua, server vẫn chạy)."
  fi
fi

echo "[entrypoint] Khởi động API..."
exec node src/index.js
