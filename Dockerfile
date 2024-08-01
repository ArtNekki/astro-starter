# Stage 1: Application Build
FROM node:20-alpine AS builder

# Install necessary build dependencies
RUN apk add --no-cache g++ make py3-pip curl

WORKDIR /app

# Copy package.json and package-lock.json files
COPY package*.json ./

# Install all dependencies, including devDependencies
RUN npm ci && npm cache clean --force

# Set environment variables at build time
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

ARG STRAPI_URL
ENV STRAPI_URL=${STRAPI_URL}

ARG DOPPLER_CONFIG
ENV DOPPLER_CONFIG=${DOPPLER_CONFIG}

# Copy source code
COPY . .

# Build the application
RUN npm run build

# Stage 2: Nginx Configuration
FROM nginx:alpine AS nginx-config

RUN rm /etc/nginx/conf.d/default.conf
COPY nginx/nginx.conf /etc/nginx/nginx.conf
RUN mkdir /etc/nginx/logs && \
    touch /etc/nginx/logs/error.log /etc/nginx/logs/access.log

# Stage 3: Final Image
FROM nginx:alpine

# Copy built files from the build stage
COPY --from=builder /app/dist/ /usr/share/nginx/html

# Copy Nginx configuration
COPY --from=nginx-config /etc/nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=nginx-config /etc/nginx/logs /etc/nginx/logs

# Optional: install additional tools for debugging
RUN apk add --no-cache curl

# Configure healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:80 || exit 1

EXPOSE 80

# Set environment variables at runtime
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

ARG STRAPI_URL
ENV STRAPI_URL=${STRAPI_URL}

ARG DOPPLER_CONFIG
ENV DOPPLER_CONFIG=${DOPPLER_CONFIG}

CMD ["nginx", "-g", "daemon off;"]
