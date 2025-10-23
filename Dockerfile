# Stage 1: Build
FROM node:20-alpine AS builder

WORKDIR /app

ARG RESEND_API_KEY
ENV RESEND_API_KEY=$RESEND_API_KEY

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

COPY . .
RUN yarn build

# Stage 2: Serve with nginx
FROM nginx:alpine

COPY --from=builder /app/out /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]