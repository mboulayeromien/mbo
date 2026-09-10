# Multi-stage Dockerfile for static website (MBO Inc portfolio)

# Stage 1: Build stage (optional verification/processing)
FROM nginx:alpine AS builder
WORKDIR /app
COPY . .

# Stage 2: Production stage
FROM nginx:alpine
LABEL maintainer="MBO Inc"
LABEL description="MBO Inc portfolio website - static HTML/CSS site"

# Set nginx configuration
RUN apk add --no-cache curl

# Copy static files from local directory
COPY . /usr/share/nginx/html/

# Remove default nginx config and use a minimal one
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/ || exit 1

# Run nginx
CMD ["nginx", "-g", "daemon off;"]
