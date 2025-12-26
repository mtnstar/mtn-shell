#!/usr/bin/env bash
set -euo pipefail

python3 -m venv /opt/python-venv
pip install --no-cache-dir --upgrade pip==24.0 \
  molecule==25.12.0 \
  ansible==13.1.0 \
  kubernetes==34.1.0 \
  pytest \
  testinfra \
  yamllint \
  "molecule-plugins[podman]==25.8.12"
