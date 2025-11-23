#!/usr/bin/env bash
set -euo pipefail

# Install OS packages, node, podman CLI and npm tools.
apt-get update

DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  gnupg \
  neovim \
  git git-lfs \
  dnsutils mtr iputils-ping \
  podman slirp4netns fuse-overlayfs uidmap \
  bash-completion \
  ssh \
  sudo \
  lsb-release \
  python3 python3-pip python3-venv build-essential

# NodeJS 22
curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
apt-get install -y --no-install-recommends nodejs

# npm global tools
npm install -g prettier

# cleanup to reduce image size
apt-get clean
rm -rf /var/lib/apt/lists/*
