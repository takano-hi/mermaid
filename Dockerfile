# 開発環境
FROM node:18.16.0-alpine3.17 AS development

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

EXPOSE 3000

CMD ["npm", "run", "dev"]

# ビルド環境
FROM node:18.16.0-alpine3.17 AS builder

WORKDIR /app

COPY --from=development /app .

RUN npm run build

# 本番環境
FROM node:18.16.0-alpine3.17 AS production

ENV NODE_ENV=production

WORKDIR /app

COPY --from=builder /app/package*.json ./
RUN npm ci --only=production

COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public

EXPOSE 3000

CMD ["npm", "start"]