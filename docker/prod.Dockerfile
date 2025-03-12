# Stage 1: Build Next.js App
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package.json and install dependencies
COPY package.json package-lock.json ./
RUN npm install --frozen-lockfile

# Copy the rest of the source code
COPY . .

# Build Next.js app
RUN npm run build

# Stage 2: Run the app using Node.js
FROM node:18-alpine AS runner

WORKDIR /app

# Copy built application
COPY --from=builder /app/.next .next
COPY --from=builder /app/package.json package.json
COPY --from=builder /app/node_modules node_modules
COPY --from=builder /app/public public

# Set environment variables
ENV PORT=3000
EXPOSE 3000

# Start Next.js
CMD ["npm", "start"]
