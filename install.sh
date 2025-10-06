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

detect_and_update_shell() {
    local shell_rc=""
    local current_shell=""
    
    if [ -n "$ZSH_VERSION" ]; then
        current_shell="zsh"
        shell_rc="$HOME/.zshrc"
    elif [ -n "$BASH_VERSION" ]; then
        current_shell="bash"
        if [ "$OS" = "macos" ]; then
            shell_rc="$HOME/.bash_profile"
        else
            shell_rc="$HOME/.bashrc"
        fi
    else
        current_shell=$(basename "$SHELL")
        case $current_shell in
            zsh)
                shell_rc="$HOME/.zshrc"
                ;;
            bash)
                shell_rc="$HOME/.bash_profile"
                ;;
            *)
                shell_rc="$HOME/.profile"
                ;;
        esac
    fi
    
    echo "$shell_rc"
}

update_path_in_shell() {
    local shell_rc="$1"
    local path_line="export PATH=\"\$PATH:$BIN_DIR\""
    
    touch "$shell_rc"
    
    if grep -q "export PATH.*$BIN_DIR" "$shell_rc" 2>/dev/null; then
        echo -e "${GREEN}✓ PATH already configured in $shell_rc${NC}"
        return 0
    fi
    
    echo "" >> "$shell_rc"
    echo "# QuickIcon CLI - https://github.com/azeezabass2005/quickicon" >> "$shell_rc"
    echo "$path_line" >> "$shell_rc"
    
    echo -e "${GREEN}✓ Added $BIN_DIR to PATH in $shell_rc${NC}"
    return 1
}

try_system_install() {
    if [ "$OS" = "macos" ] && [ -w "/usr/local/bin" ]; then
        echo "Installing system-wide to /usr/local/bin..."
        ln -sf "$INSTALL_DIR/quickicon" "/usr/local/bin/quickicon"
        echo -e "${GREEN}✓ Installed system-wide to /usr/local/bin${NC}"
        return 0
    fi
    return 1
}

echo -e "${GREEN}✓ Installation complete!${NC}"
echo ""
echo "QuickIcon has been installed to: $INSTALL_DIR"
echo "Symlink created at: $BIN_DIR/quickicon"
echo ""

if try_system_install; then
    echo -e "${GREEN}🎉 You can now use 'quickicon' command!${NC}"
else
    SHELL_RC=$(detect_and_update_shell)
    echo "Detected shell configuration: $SHELL_RC"
    
    if update_path_in_shell "$SHELL_RC"; then
        echo -e "${GREEN}🎉 You can now use 'quickicon' command!${NC}"
    else
        echo ""
        echo -e "${YELLOW}⚠ Shell configuration updated!${NC}"
        echo ""
        echo "To use quickicon immediately, run:"
        echo -e "  ${GREEN}source $SHELL_RC${NC}"
        echo ""
        echo "Or simply restart your terminal."
        echo ""
        echo -e "${GREEN}After that, you can use 'quickicon' command!${NC}"
    fi
fi

echo ""
echo "Get started:"
echo "  quickicon --icon-name MyIcon --path ./icon.svg"
echo ""
echo "For help:"
echo "  quickicon --help"