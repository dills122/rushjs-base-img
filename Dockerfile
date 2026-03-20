# syntax=docker/dockerfile:1.7

ARG NODE_VERSION=22
ARG DISTRO=alpine
FROM node:${NODE_VERSION}-${DISTRO} AS base

LABEL author="Dylan Steele"
LABEL org.opencontainers.image.authors="dylansteele57@gmail.com"
LABEL org.opencontainers.image.description="Configurable Rush.js base image for development and production"

ARG APP_USER=node
ARG APP_UID=1000
ARG APP_GID=1000
ARG TZ=UTC
ARG LANG=C.UTF-8
ARG LC_ALL=C.UTF-8

ARG INSTALL_CA_CERTS=true
ARG INSTALL_TZDATA=true
ARG INSTALL_BASH=false
ARG INSTALL_GIT=false
ARG INSTALL_CURL=false
ARG INSTALL_JQ=false

ENV TZ=${TZ}
ENV LANG=${LANG}
ENV LC_ALL=${LC_ALL}

RUN set -eux; \
    packages=""; \
    [ "${INSTALL_CA_CERTS}" = "true" ] && packages="${packages} ca-certificates" || true; \
    [ "${INSTALL_TZDATA}" = "true" ] && packages="${packages} tzdata" || true; \
    [ "${INSTALL_BASH}" = "true" ] && packages="${packages} bash" || true; \
    [ "${INSTALL_GIT}" = "true" ] && packages="${packages} git" || true; \
    [ "${INSTALL_CURL}" = "true" ] && packages="${packages} curl" || true; \
    [ "${INSTALL_JQ}" = "true" ] && packages="${packages} jq" || true; \
    if command -v apk >/dev/null 2>&1; then \
      [ -n "${packages}" ] && apk add --no-cache ${packages} || true; \
    else \
      apt-get update; \
      [ -n "${packages}" ] && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ${packages} || true; \
      rm -rf /var/lib/apt/lists/*; \
    fi

RUN set -eux; \
    if [ "${APP_USER}" = "node" ] && [ "${APP_UID}" = "1000" ] && [ "${APP_GID}" = "1000" ]; then \
      mkdir -p /workspace && chown -R node:node /workspace; \
    else \
      if command -v apk >/dev/null 2>&1; then \
        addgroup -S -g "${APP_GID}" "${APP_USER}"; \
        adduser -S -D -H -u "${APP_UID}" -G "${APP_USER}" "${APP_USER}"; \
      else \
        groupadd --gid "${APP_GID}" "${APP_USER}"; \
        useradd --uid "${APP_UID}" --gid "${APP_GID}" --create-home --shell /bin/sh "${APP_USER}"; \
      fi; \
      mkdir -p /workspace; \
      chown -R "${APP_UID}:${APP_GID}" /workspace; \
    fi

WORKDIR /workspace

FROM base AS dev

ARG RUSH_VERSION=5.151.0
ARG PM2_VERSION=6.0.8
ARG NEST_VERSION=11.0.5
ARG PNPM_VERSION=9.15.4
ARG YARN_VERSION=1.22.22

ARG COREPACK_ENABLE=true
ARG INSTALL_RUSH=true
ARG INSTALL_PM2=true
ARG INSTALL_NEST=true
ARG INSTALL_PNPM=true
ARG INSTALL_YARN=false

RUN set -eux; \
    npm_global_packages=""; \
    [ "${INSTALL_RUSH}" = "true" ] && npm_global_packages="${npm_global_packages} @microsoft/rush@${RUSH_VERSION}" || true; \
    [ "${INSTALL_PM2}" = "true" ] && npm_global_packages="${npm_global_packages} pm2@${PM2_VERSION}" || true; \
    [ "${INSTALL_NEST}" = "true" ] && npm_global_packages="${npm_global_packages} @nestjs/cli@${NEST_VERSION}" || true; \
    [ -n "${npm_global_packages}" ] && npm install --global ${npm_global_packages} || true; \
    if [ "${COREPACK_ENABLE}" = "true" ]; then corepack enable; fi; \
    if [ "${INSTALL_PNPM}" = "true" ]; then corepack prepare "pnpm@${PNPM_VERSION}" --activate || npm install --global "pnpm@${PNPM_VERSION}"; fi; \
    if [ "${INSTALL_YARN}" = "true" ]; then corepack prepare "yarn@${YARN_VERSION}" --activate || npm install --global "yarn@${YARN_VERSION}"; fi; \
    npm cache clean --force

ENV NODE_ENV=development
USER ${APP_USER}

FROM base AS prod

ARG PM2_VERSION=6.0.8
ARG PNPM_VERSION=9.15.4
ARG YARN_VERSION=1.22.22

ARG COREPACK_ENABLE=true
ARG INSTALL_PM2=false
ARG INSTALL_PNPM=false
ARG INSTALL_YARN=false

RUN set -eux; \
    npm_global_packages=""; \
    [ "${INSTALL_PM2}" = "true" ] && npm_global_packages="${npm_global_packages} pm2@${PM2_VERSION}" || true; \
    [ -n "${npm_global_packages}" ] && npm install --global ${npm_global_packages} || true; \
    if [ "${COREPACK_ENABLE}" = "true" ]; then corepack enable; fi; \
    if [ "${INSTALL_PNPM}" = "true" ]; then corepack prepare "pnpm@${PNPM_VERSION}" --activate || npm install --global "pnpm@${PNPM_VERSION}"; fi; \
    if [ "${INSTALL_YARN}" = "true" ]; then corepack prepare "yarn@${YARN_VERSION}" --activate || npm install --global "yarn@${YARN_VERSION}"; fi; \
    npm cache clean --force

ENV NODE_ENV=production
USER ${APP_USER}
