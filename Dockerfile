FROM node:alpine AS deps

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install

# Rebuild the source code only when needed
FROM node:alpine AS builder
WORKDIR /app
COPY . .
COPY --from=deps /app/node_modules ./node_modules
RUN npm run build

# copy all the files and run next
FROM node:alpine AS runner
WORKDIR /app

COPY --from=builder /app/.next ./.next
COPY --from=builder /app/components ./components
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/pages ./pages
COPY --from=builder /app/static ./static
COPY --from=builder /app/next.config.js ./
COPY --from=builder /app/package.json ./package.json

EXPOSE 3000

CMD ["npm", "start"]