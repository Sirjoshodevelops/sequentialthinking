# --------- Build Stage ---------
    FROM node:22-alpine AS builder
    WORKDIR /app
    
    # Copy all build-related files
    COPY package*.json ./
    COPY tsconfig.json ./
    COPY . .
    
    # Install all dependencies (incl. devDependencies)
    RUN npm install
    
    # Build the project
    RUN npm run build
    
    
    # --------- Release Stage ---------
    FROM node:22-alpine AS release
    WORKDIR /app
    
    # Copy dist files and production deps only
    COPY --from=builder /app/dist ./dist
    COPY --from=builder /app/package*.json ./
    
    # Install only production deps
    RUN npm install --omit=dev
    
    # Run the HTTP MCP server
    CMD ["node", "dist/index.js"]
    