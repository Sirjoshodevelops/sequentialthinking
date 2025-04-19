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
COPY package*.json ./

# Just install production dependencies (skip prepare/build)
RUN npm install --omit=dev --ignore-scripts

CMD ["node", "dist/index.js"]
