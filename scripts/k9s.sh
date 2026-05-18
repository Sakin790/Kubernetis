#!/bin/bash

# ============================================
#   K9s Auto Install Script
#   For Linux AMD64 / ARM64
# ============================================

set -e  # Exit immediately if any command fails

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}==============================${NC}"
echo -e "${BLUE}   K9s Installation Script   ${NC}"
echo -e "${BLUE}==============================${NC}"
echo ""

# ---- Step 1: Check if already installed ----
if command -v k9s &> /dev/null; then
    echo -e "${YELLOW}⚠️  K9s is already installed!${NC}"
    k9s version
    echo ""
    read -p "Do you want to reinstall? (y/n): " choice
    if [[ "$choice" != "y" ]]; then
        echo -e "${GREEN}✅ Exiting.${NC}"
        exit 0
    fi
fi

# ---- Step 2: Check OS ----
echo -e "${YELLOW}🔍 Checking system...${NC}"
OS=$(uname -s)
ARCH=$(uname -m)

if [[ "$OS" != "Linux" ]]; then
    echo -e "${RED}❌ This script only works on Linux!${NC}"
    exit 1
fi

if [[ "$ARCH" == "x86_64" ]]; then
    PLATFORM="Linux_amd64"
elif [[ "$ARCH" == "aarch64" ]]; then
    PLATFORM="Linux_arm64"
else
    echo -e "${RED}❌ Unsupported architecture: $ARCH${NC}"
    exit 1
fi

echo -e "${GREEN}✅ OS: $OS | Architecture: $ARCH${NC}"
echo ""

# ---- Step 3: Fetch latest version ----
echo -e "${YELLOW}🌐 Checking latest K9s version...${NC}"
LATEST=$(curl -s https://api.github.com/repos/derailed/k9s/releases/latest | grep '"tag_name"' | cut -d'"' -f4)

if [[ -z "$LATEST" ]]; then
    echo -e "${RED}❌ Could not fetch version. Please check your internet connection.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Latest version: $LATEST${NC}"
echo ""

# ---- Step 4: Download ----
DOWNLOAD_URL="https://github.com/derailed/k9s/releases/download/${LATEST}/k9s_${PLATFORM}.tar.gz"
TMP_DIR=$(mktemp -d)

echo -e "${YELLOW}📥 Downloading...${NC}"
curl -L "$DOWNLOAD_URL" -o "$TMP_DIR/k9s.tar.gz"
echo -e "${GREEN}✅ Download complete!${NC}"
echo ""

# ---- Step 5: Extract ----
echo -e "${YELLOW}📦 Extracting...${NC}"
tar -xzf "$TMP_DIR/k9s.tar.gz" -C "$TMP_DIR"
echo -e "${GREEN}✅ Extraction complete!${NC}"
echo ""

# ---- Step 6: Install ----
echo -e "${YELLOW}🚀 Installing...${NC}"
sudo mv "$TMP_DIR/k9s" /usr/local/bin/k9s
sudo chmod +x /usr/local/bin/k9s
echo -e "${GREEN}✅ Installation complete!${NC}"
echo ""

# ---- Step 7: Cleanup ----
rm -rf "$TMP_DIR"

# ---- Step 8: Verify ----
echo -e "${YELLOW}🔎 Verifying installation...${NC}"
if command -v k9s &> /dev/null; then
    echo -e "${GREEN}✅ K9s installed successfully!${NC}"
    echo ""
    k9s version
else
    echo -e "${RED}❌ Installation failed! Please try again.${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}==============================${NC}"
echo -e "${GREEN}🎉 All done! K9s is ready.${NC}"
echo -e "${BLUE}Run it with: ${NC}k9s"
echo -e "${BLUE}==============================${NC}"
