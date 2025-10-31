#!/usr/bin/env bash
set -euo pipefail

# Install OS packages, node, docker CLI and npm tools.
apt-get update

DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  gnupg \
  neovim \
  git git-lfs \
  dnsutils mtr iputils-ping \
  bash-completion \
  ssh \
  sudo \
  lsb-release \
  python3 python3-pip python3-venv build-essential \
  gnupg2 apt-transport-https

# NodeJS 20
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y --no-install-recommends nodejs

# Docker apt repo (uses debian bookworm packages which work on ubuntu bases in many images)
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian bookworm stable" > /etc/apt/sources.list.d/docker.list

apt-get update
apt-get install -y --no-install-recommends docker-ce-cli

# npm global tools
npm install -g prettier

# cleanup to reduce image size
apt-get clean
rm -rf /var/lib/apt/lists/*
