FROM node:hydrogen-alpine
LABEL author="Dylan Steele"
LABEL org.opencontainers.image.authors="dylansteele57@gmail.com"
LABEL org.opencontainers.image.description="image with rushjs, pm2, nestjs, and bash"

RUN apk add --update bash && rm -rf /var/cache/apk/*
RUN npm install -g @microsoft/rush pm2 @nestjs/cli
