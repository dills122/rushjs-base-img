variable "REGISTRY" {
  default = "ghcr.io/dills122/rushjs-base-img"
}

variable "PLATFORMS" {
  default = "linux/amd64,linux/arm64"
}

target "_common" {
  context = "."
  dockerfile = "Dockerfile"
  platforms = split(",", PLATFORMS)
}

target "dev" {
  inherits = ["_common"]
  target = "dev"
  args = {
    DISTRO = "alpine"
    INSTALL_BASH = "true"
    INSTALL_GIT = "true"
    INSTALL_CURL = "true"
    INSTALL_JQ = "true"
    INSTALL_RUSH = "true"
    INSTALL_PM2 = "true"
    INSTALL_NEST = "true"
    INSTALL_PNPM = "true"
    INSTALL_YARN = "false"
  }
}

target "prod" {
  inherits = ["_common"]
  target = "prod"
  args = {
    DISTRO = "alpine"
    INSTALL_BASH = "false"
    INSTALL_GIT = "false"
    INSTALL_CURL = "false"
    INSTALL_JQ = "false"
    INSTALL_PM2 = "false"
    INSTALL_PNPM = "false"
    INSTALL_YARN = "false"
  }
}

target "dev-node16" {
  inherits = ["dev"]
  args = { NODE_VERSION = "16" }
  tags = ["${REGISTRY}:node16-dev"]
}

target "dev-node18" {
  inherits = ["dev"]
  args = { NODE_VERSION = "18" }
  tags = ["${REGISTRY}:node18-dev"]
}

target "dev-node20" {
  inherits = ["dev"]
  args = { NODE_VERSION = "20" }
  tags = ["${REGISTRY}:node20-dev"]
}

target "dev-node22" {
  inherits = ["dev"]
  args = { NODE_VERSION = "22" }
  tags = ["${REGISTRY}:node22-dev"]
}

target "prod-node16" {
  inherits = ["prod"]
  args = { NODE_VERSION = "16" }
  tags = ["${REGISTRY}:node16-prod"]
}

target "prod-node18" {
  inherits = ["prod"]
  args = { NODE_VERSION = "18" }
  tags = ["${REGISTRY}:node18-prod"]
}

target "prod-node20" {
  inherits = ["prod"]
  args = { NODE_VERSION = "20" }
  tags = ["${REGISTRY}:node20-prod"]
}

target "prod-node22" {
  inherits = ["prod"]
  args = { NODE_VERSION = "22" }
  tags = ["${REGISTRY}:node22-prod"]
}

group "dev-all" {
  targets = ["dev-node16", "dev-node18", "dev-node20", "dev-node22"]
}

group "prod-all" {
  targets = ["prod-node16", "prod-node18", "prod-node20", "prod-node22"]
}

group "all" {
  targets = [
    "dev-node16",
    "dev-node18",
    "dev-node20",
    "dev-node22",
    "prod-node16",
    "prod-node18",
    "prod-node20",
    "prod-node22"
  ]
}
