# Build Stage
FROM node:18-slim AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build-css

# Serve Stage
FROM nginx:stable-alpine
WORKDIR /usr/share/nginx/html
# Copy all content from the build stage
COPY --from=build /app/styles ./styles
COPY --from=build /app/index.html ./
COPY --from=build /app/assets ./assets
COPY --from=build /app/index.js ./
COPY --from=build /app/images ./images
COPY --from=build /app/favicon.ico ./favicon.ico

# Fix the nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 3000

# Add debugging commands
RUN ls -la /usr/share/nginx/html
RUN cat /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]