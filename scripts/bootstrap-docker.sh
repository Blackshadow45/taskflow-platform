#!/usr/bin/env bash
# Installs Docker Engine from Docker's official APT repository on Ubuntu 24.04.
# Idempotent: safe to re-run.
set -euo pipefail
echo "==> Updating base packages"
sudo apt-get update -qq
sudo apt-get install -y -qq ca-certificates curl gnupg lsb-release git make jq
echo "==> Adding Docker GPG key"
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
| sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg --yes
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo "==> Adding Docker APT repository"
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
| sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
echo "==> Installing Docker Engine"
sudo apt-get update -qq
sudo apt-get install -y -qq \
docker-ce docker-ce-cli containerd.io \
docker-buildx-plugin docker-compose-plugin
echo "==> Granting docker group to ${USER}"
sudo usermod -aG docker "${USER}"
echo "==> Done. Log out and back in (or run: newgrp docker)"
docker --version
