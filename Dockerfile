FROM node:20-alpine as development
  WORKDIR /app

  RUN apk update && apk add --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    git

  ENV CHROME_BIN=/usr/bin/chromium-browser
  ENV LIGHTHOUSE_CHROMIUM_PATH=/usr/bin/chromium-browser

  ENV PATH="/home/appuser/.npm-global/bin:${PATH}"
  RUN npm install -g @angular/cli

  COPY package*.json ./
  RUN npm install

  COPY . .
  EXPOSE 4200

  CMD ["ng","serve","--host","0.0.0.0","--poll","200"]

  FROM node:16 AS build

  WORKDIR /app

  RUN npm install -g @angular/cli

  COPY package*.json ./
  
  RUN npm install

  COPY . .

  RUN ng build --prod