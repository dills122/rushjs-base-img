# Rush.js Base Image Modernization Plan

## Goals

- Support multiple Node versions: 16, 18, 20, 22.
- Provide configurable image flavors for development and production.
- Publish multi-platform images for modern developer environments.
- Define a simple, predictable tag policy that supports both stability and traceability.
- Improve security posture and reproducibility.

## Current State Summary

- Docker image is built from `node:hydrogen-alpine` (Node 18 line, now EOL).
- Tooling is installed globally with floating versions (`rush`, `pm2`, `nestjs/cli`).
- Workflows already use Buildx and publish to Docker Hub + GHCR.
- Workflows still use deprecated `::set-output`.
- Documentation is minimal and does not define supported matrix, flavors, or tag guarantees.

## Scope of Changes

### 1. Image architecture and configurability

- Replace the current single-stage Dockerfile with a multi-target Dockerfile:
  - `dev` target: tools for active development.
  - `prod` target: minimal runtime-oriented base.
- Add build arguments for Node version and optional tool installation.
- Add optional toggles for package-manager tooling and utility packages.
- Add non-root user configuration (`APP_USER`, `APP_UID`, `APP_GID`).
- Make package installation work on both Alpine and Debian-based Node images.

### 2. Multi-version and multi-platform publishing

- Publish Node 16/18/20/22 variants.
- Publish linux/amd64 and linux/arm64 manifests.
- Keep legacy versions explicit and clearly labeled.

### 3. Tag policy

Use both immutable and moving tags:

- Immutable:
  - `sha-<shortsha>`
  - (optional future) semver release tags per variant.
- Moving:
  - `node<version>-<target>`
  - `node<version>-<target>-<distro>`
  - `legacy-node<version>-<target>` for Node 16 and 18
  - `lts-<target>` for the designated LTS line
  - `latest` only for `node22-prod-alpine`

### 4. CI/workflow modernization

- Update workflow outputs to `$GITHUB_OUTPUT`.
- Expand workflow matrix by Node version, target, and distro.
- Keep push behavior on non-PR events and test builds on PR.
- Add scheduled rebuild cadence (weekly) and manual trigger.

### 5. Documentation

- Rewrite README with:
  - support matrix,
  - flavor overview,
  - build args and defaults,
  - tag contract,
  - practical usage examples.

## Planned Deliverables

- `Dockerfile` rewritten with configurable multi-target design.
- `docker-bake.hcl` for local matrix builds.
- Updated workflow(s) for matrix build/publish.
- Expanded `Readme.md`.
- This plan document.

## Execution Plan

1. Add docs and lock the implementation contract.
2. Implement new Dockerfile + bake configuration.
3. Update publish/scheduled workflows for matrix tags.
4. Update README and examples.
5. Run a local smoke build for at least one dev and one prod target.
6. Commit in logical intervals for easy review.

## Risk Management

- Legacy Node versions are built as best-effort compatibility targets.
- `latest` will never point to legacy versions.
- Keep defaults conservative for production target.
- Ensure tags remain deterministic and avoid accidental overwrites.
