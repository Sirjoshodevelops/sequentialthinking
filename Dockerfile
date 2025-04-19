# === Build stage ===
FROM node:22-alpine AS builder
WORKDIR /app

# Copy everything first (you need .ts files BEFORE npm install)
COPY . ./

# Install full deps and run build
RUN npm install

# === Release stage ===
FROM node:22-alpine AS release
WORKDIR /app

COPY --from=builder /app/dist ./dist
COPY package*.json ./

RUN npm ci --omit=dev

CMD ["node", "dist/index.js"]
