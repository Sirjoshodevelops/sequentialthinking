# Build stage
FROM node:22-alpine AS builder
WORKDIR /app

# Copy package files and install all dependencies
COPY package*.json ./
COPY tsconfig.json ./
RUN npm install

# Copy the rest and build
COPY . .
RUN npm run build

# Release stage
FROM node:22-alpine AS release
WORKDIR /app

# Copy dist + package files
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package*.json ./

# Install only production deps
RUN npm install --omit=dev

# Run the app
CMD ["node", "dist/index.js"]
