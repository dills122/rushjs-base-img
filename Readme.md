# Rush.js Base Docker Image

Configurable base image for Rush.js-oriented projects with separate development and production targets, multi-arch publishing, and multi-version Node support.

## Support Matrix

### Node versions

- 16 (legacy, best-effort)
- 18 (legacy, best-effort)
- 20 (supported)
- 22 (supported, default/LTS line)

### Image targets

- `dev`: includes common development tooling
- `prod`: runtime-oriented minimal base

### Distros

- `alpine` (default)
- `bookworm-slim` (Node 20/22 variants)

### Platforms

- `linux/amd64`
- `linux/arm64`

## Tag Policy

### Moving tags

- `node<version>-<target>`
  - default distro variant (`alpine`)
- `node<version>-<target>-<distro>`
  - explicit distro variant
- `legacy-node16-<target>` and `legacy-node18-<target>`
- `lts-<target>`
  - tracks `node22-<target>-alpine`
- `latest`
  - tracks `node22-prod-alpine`

### Immutable tags

- `sha-<shortsha>-node<version>-<target>-<distro>`
- on version tags (`v*`), semver flavor tags are published per variant

## Build Arguments

Core:

- `NODE_VERSION` default: `22`
- `DISTRO` default: `alpine`
- `APP_USER` default: `node`
- `APP_UID` default: `1000`
- `APP_GID` default: `1000`

Base package toggles:

- `INSTALL_CA_CERTS` default: `true`
- `INSTALL_TZDATA` default: `true`
- `INSTALL_BASH` default: `false`
- `INSTALL_GIT` default: `false`
- `INSTALL_CURL` default: `false`
- `INSTALL_JQ` default: `false`

Dev target toggles:

- `INSTALL_RUSH` default: `true`
- `INSTALL_PM2` default: `true`
- `INSTALL_NEST` default: `true`
- `INSTALL_PNPM` default: `true`
- `INSTALL_YARN` default: `false`

Tool version pins:

- `RUSH_VERSION` default: `5.151.0`
- `PM2_VERSION` default: `6.0.8`
- `NEST_VERSION` default: `11.0.5`
- `PNPM_VERSION` default: `9.15.4`
- `YARN_VERSION` default: `1.22.22`

## Local Build Examples

Build a Node 22 dev image:

```bash
docker build \
  --target dev \
  --build-arg NODE_VERSION=22 \
  --build-arg DISTRO=alpine \
  -t rushjs-base:node22-dev \
  .
```

Build a Node 20 prod image with slim distro:

```bash
docker build \
  --target prod \
  --build-arg NODE_VERSION=20 \
  --build-arg DISTRO=bookworm-slim \
  -t rushjs-base:node20-prod-slim \
  .
```

Build via Bake (all versions/targets):

```bash
docker buildx bake all
```

Build only dev variants:

```bash
docker buildx bake dev-all
```

## CI Publishing

GitHub Actions builds and publishes matrix variants to:

- Docker Hub: `dills122/rushjs-base-img`
- GHCR: `ghcr.io/dills122/rushjs-base-img`

Triggers:

- push to `master`/`main`
- pull requests into `master`/`main` (build only, no push)
- weekly scheduled rebuild
- manual dispatch
