FROM mhart/alpine-node:16
LABEL version="1.1.0"
LABEL com.example.version="1.1.0"
LABEL com.example.release-date="2023-12-23"
LABEL author="Dylan Steele"
LABEL org.opencontainers.image.authors="dylansteele57@gmail.com"
LABEL description="image with rushjs, pm2, nestjs, and bash"

RUN apk add --update bash && rm -rf /var/cache/apk/*
RUN npm install -g @microsoft/rush pm2 @nestjs/cli
