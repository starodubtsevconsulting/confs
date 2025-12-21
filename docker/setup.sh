#!/usr/bin/env bash
set -euo pipefail

# Install Docker engine and compose plugin
sudo apt update
sudo apt install -y docker.io docker-compose-plugin

# Enable and start Docker service
sudo systemctl enable --now docker

# Add current user to docker group for non-root usage
if getent group docker >/dev/null 2>&1; then
  sudo usermod -aG docker "$USER"
fi

echo "Docker installed. Log out/in or run: newgrp docker"
