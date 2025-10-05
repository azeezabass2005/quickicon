#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

REPO="azeezabass2005/quickicon"
INSTALL_DIR="${INSTALL_DIR:-$HOME/.quickicon}"
BIN_DIR="${BIN_DIR:-$HOME/.local/bin}"

echo -e "${GREEN}QuickIcon Installer${NC}"
echo "================================"

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case "$OS" in
    linux*)
        OS="linux"
        ;;
    darwin*)
        OS="macos"
        ;;
    *)
        echo -e "${RED}Unsupported OS: $OS${NC}"
        exit 1
        ;;
esac

case "$ARCH" in
    x86_64|amd64)
        ARCH="x86_64"
        ;;
    aarch64|arm64)
        ARCH="aarch64"
        ;;
    *)
        echo -e "${RED}Unsupported architecture: $ARCH${NC}"
        exit 1
        ;;
esac

BINARY_NAME="quickicon-${OS}-${ARCH}"
echo -e "Detected: ${YELLOW}${OS} ${ARCH}${NC}"

echo "Fetching latest release..."
LATEST_RELEASE=$(curl -s "https://api.github.com/repos/${REPO}/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

if [ -z "$LATEST_RELEASE" ]; then
    echo -e "${RED}Failed to fetch latest release${NC}"
    exit 1
fi

echo -e "Latest version: ${GREEN}${LATEST_RELEASE}${NC}"

DOWNLOAD_URL="https://github.com/${REPO}/releases/download/${LATEST_RELEASE}/${BINARY_NAME}.tar.gz"

echo "Downloading from: $DOWNLOAD_URL"

TMP_DIR=$(mktemp -d)
trap "rm -rf $TMP_DIR" EXIT

curl -sL "$DOWNLOAD_URL" -o "$TMP_DIR/quickicon.tar.gz"

if [ $? -ne 0 ]; then
    echo -e "${RED}Download failed${NC}"
    exit 1
fi

echo "Extracting..."
tar -xzf "$TMP_DIR/quickicon.tar.gz" -C "$TMP_DIR"

mkdir -p "$INSTALL_DIR"
mkdir -p "$BIN_DIR"

echo "Installing to $INSTALL_DIR..."
mv "$TMP_DIR/quickicon" "$INSTALL_DIR/quickicon"
chmod +x "$INSTALL_DIR/quickicon"

ln -sf "$INSTALL_DIR/quickicon" "$BIN_DIR/quickicon"

echo -e "${GREEN}✓ Installation complete!${NC}"
echo ""
echo "QuickIcon has been installed to: $INSTALL_DIR"
echo "Symlink created at: $BIN_DIR/quickicon"
echo ""

if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    echo -e "${YELLOW}⚠ Warning: $BIN_DIR is not in your PATH${NC}"
    echo ""
    echo "Add the following line to your shell configuration file:"
    echo "  (~/.bashrc, ~/.zshrc, ~/.profile, etc.)"
    echo ""
    echo -e "${GREEN}export PATH=\"\$PATH:$BIN_DIR\"${NC}"
    echo ""
    echo "Then restart your shell or run: source ~/.bashrc (or ~/.zshrc)"
else
    echo -e "${GREEN}You can now use 'quickicon' command!${NC}"
fi

echo ""
echo "Get started:"
echo "  quickicon --icon-name MyIcon --path ./icon.svg"
echo ""
echo "For help:"
echo "  quickicon --help"