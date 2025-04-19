# === Build stage ===
FROM node:22-alpine AS builder
WORKDIR /app

# Copy all required build inputs BEFORE npm install
COPY package*.json ./
COPY tsconfig.json ./
COPY . .

RUN npm install

# === Release stage ===
FROM node:22-alpine AS release
WORKDIR /app

COPY --from=builder /app/dist ./dist
COPY package*.json ./

RUN npm ci --omit=dev

CMD ["node", "dist/index.js"]
