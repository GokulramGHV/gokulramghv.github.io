# Build Stage
FROM node:18-slim AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build-css

# Serve Stage using thttpd
FROM alpine:latest
RUN apk add --no-cache thttpd
WORKDIR /www
COPY --from=build /app/styles ./styles
COPY --from=build /app/index.html ./index.html
COPY --from=build /app/assets ./assets
COPY --from=build /app/index.js ./index.js
EXPOSE 3000
CMD ["thttpd", "-D", "-h", "0.0.0.0", "-p", "3000", "-d", "/www", "-u", "nobody", "-l", "-", "-M", "300"]