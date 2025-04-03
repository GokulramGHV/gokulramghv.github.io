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
COPY --from=build /app/styles ./styles
COPY --from=build /app/index.html ./index.html
COPY --from=build /app/assets ./assets
COPY --from=build /app/index.js ./index.js
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 3000
CMD ["nginx", "-g", "daemon off;"]