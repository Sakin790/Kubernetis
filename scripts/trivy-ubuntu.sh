#!/bin/bash

set -e

echo "📦 Installing Trivy on Ubuntu..."

# Update system
sudo apt-get update -y

# Install dependencies
sudo apt-get install -y wget apt-transport-https gnupg lsb-release

# Add Trivy GPG key
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -

# Add repository
echo "deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | \
sudo tee /etc/apt/sources.list.d/trivy.list

# Update again
sudo apt-get update -y

# Install Trivy
sudo apt-get install -y trivy

# Verify
trivy --version

echo "✅ Trivy installed successfully on Ubuntu"
