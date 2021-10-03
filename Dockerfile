FROM mhart/alpine-node:14
LABEL version="1.0.1"
LABEL com.example.version="1.0.1"
LABEL com.example.release-date="2021-10-02"
LABEL author="Dylan Steele"
LABEL org.opencontainers.image.authors="dylansteele57@gmail.com"
LABEL description="image with rushjs, pm2, and bash"

RUN apk add --update bash && rm -rf /var/cache/apk/*
RUN npm install -g @microsoft/rush
RUN npm install pm2 -g
