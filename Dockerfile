# Build stage
FROM oven/bun:1.1.30 AS builder
WORKDIR /app

COPY package.json bun.lockb* ./
RUN bun install --frozen-lockfile

COPY . .
RUN bun run build

# Production stage
FROM nginx:1.27-alpine
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
