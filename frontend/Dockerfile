# ---- Frontend (React + Vite) build, phục vụ bằng nginx ----
FROM node:20-alpine AS build
WORKDIR /app

# URL API được nhúng vào bản build (client gọi trực tiếp). Mặc định cho demo local.
ARG VITE_API_URL=http://localhost:4000
ENV VITE_API_URL=$VITE_API_URL

COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# ---- Phục vụ tĩnh ----
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
