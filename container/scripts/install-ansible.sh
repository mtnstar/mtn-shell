#!/usr/bin/env bash
set -euo pipefail

python3 -m venv /opt/python-venv
pip install --no-cache-dir --upgrade pip==24.0 \
  molecule==25.11.0 \
  ansible==12.2.0 \
  pytest \
  testinfra \
  yamllint \
  "molecule-plugins[docker]==25.8.12"
