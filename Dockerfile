# === Build stage ===
FROM node:22-alpine AS builder

WORKDIR /app

COPY package*.json ./
COPY tsconfig.json ./
COPY . .

RUN npm install
RUN npm run build


# === Release stage ===
FROM node:22-alpine AS release

WORKDIR /app

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package*.json ./

# 🛑 Remove prepare/build hooks to avoid needing devDeps
RUN npm pkg delete scripts.prepare && npm pkg delete scripts.build

# ✅ Install only production dependencies
RUN npm ci --omit=dev

CMD ["node", "dist/index.js"]
