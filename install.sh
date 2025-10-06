#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

REPO="azeezabass2005/quickicon"
INSTALL_DIR="${INSTALL_DIR:-$HOME/.quickicon}"
BIN_DIR="${BIN_DIR:-$HOME/.local/bin}"

# Check for uninstall flag
if [ "$1" = "--uninstall" ] || [ "$1" = "-u" ]; then
    echo -e "${YELLOW}Uninstalling QuickIcon...${NC}"
    
    # Remove installation directory
    if [ -d "$INSTALL_DIR" ]; then
        rm -rf "$INSTALL_DIR"
        echo -e "${GREEN}✓ Removed $INSTALL_DIR${NC}"
    fi
    
    # Remove symlink
    if [ -L "$BIN_DIR/quickicon" ]; then
        rm -f "$BIN_DIR/quickicon"
        echo -e "${GREEN}✓ Removed symlink $BIN_DIR/quickicon${NC}"
    fi
    
    # Remove from system bin if exists
    if [ -L "/usr/local/bin/quickicon" ]; then
        rm -f "/usr/local/bin/quickicon"
        echo -e "${GREEN}✓ Removed system symlink /usr/local/bin/quickicon${NC}"
    fi
    
    echo -e "${GREEN}🎉 QuickIcon uninstalled successfully!${NC}"
    echo ""
    echo "Note: PATH configuration in your shell rc file was not removed."
    echo "You can manually remove the line containing '$BIN_DIR' if desired."
    exit 0
fi

# Check for update flag or if already installed
CURRENT_VERSION=""
if [ -f "$INSTALL_DIR/version.info" ]; then
    source "$INSTALL_DIR/version.info" 2>/dev/null || true
    CURRENT_VERSION="$VERSION"
fi

IS_UPDATE=false
if [ -n "$CURRENT_VERSION" ]; then
    if [ "$1" = "--update" ] || [ "$1" = "-U" ]; then
        IS_UPDATE=true
        echo -e "${BLUE}Updating QuickIcon...${NC}"
        echo -e "Current version: ${YELLOW}$CURRENT_VERSION${NC}"
    else
        echo -e "${YELLOW}QuickIcon $CURRENT_VERSION is already installed.${NC}"
        echo ""
        echo "To update to the latest version, run:"
        echo -e "  ${GREEN}curl -fsSL https://raw.githubusercontent.com/azeezabass2005/quickicon/main/install.sh | bash -s -- --update${NC}"
        echo ""
        echo "Or continue with reinstallation:"
        read -p "Do you want to reinstall? (y/N): " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Installation cancelled."
            exit 0
        fi
        IS_UPDATE=true
    fi
fi

if [ "$IS_UPDATE" = true ]; then
    echo -e "${BLUE}🔄 Updating QuickIcon...${NC}"
else
    echo -e "${GREEN}QuickIcon Installer${NC}"
fi
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

# Check if update is needed
if [ "$IS_UPDATE" = true ] && [ "$CURRENT_VERSION" = "$LATEST_RELEASE" ]; then
    echo -e "${GREEN}✅ You already have the latest version $LATEST_RELEASE${NC}"
    exit 0
fi

if [ "$IS_UPDATE" = true ]; then
    echo -e "Updating from ${YELLOW}$CURRENT_VERSION${NC} to ${GREEN}$LATEST_RELEASE${NC}"
else
    echo -e "Latest version: ${GREEN}${LATEST_RELEASE}${NC}"
fi

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

# Backup old version if updating
BACKUP_DIR=""
if [ "$IS_UPDATE" = true ] && [ -d "$INSTALL_DIR" ]; then
    BACKUP_DIR="/tmp/quickicon-backup-$(date +%s)"
    mkdir -p "$BACKUP_DIR"
    cp -r "$INSTALL_DIR"/* "$BACKUP_DIR/" 2>/dev/null || true
    echo -e "${BLUE}📦 Backed up current version to $BACKUP_DIR${NC}"
fi

mkdir -p "$INSTALL_DIR"
mkdir -p "$BIN_DIR"

echo "Installing to $INSTALL_DIR..."
mv "$TMP_DIR/quickicon" "$INSTALL_DIR/quickicon"
chmod +x "$INSTALL_DIR/quickicon"

# Create/update version file
echo "VERSION=$LATEST_RELEASE" > "$INSTALL_DIR/version.info"
echo "INSTALL_DATE=$(date -Iseconds)" >> "$INSTALL_DIR/version.info"
echo "BIN_DIR=$BIN_DIR" >> "$INSTALL_DIR/version.info"
echo "PREVIOUS_VERSION=$CURRENT_VERSION" >> "$INSTALL_DIR/version.info"

# Update symlinks
ln -sf "$INSTALL_DIR/quickicon" "$BIN_DIR/quickicon"

# Auto-detect and update shell configuration (only on fresh install)
if [ "$IS_UPDATE" = false ]; then
    detect_and_update_shell() {
        local shell_rc=""
        local current_shell=""
        
        # Detect current shell
        if [ -n "$ZSH_VERSION" ]; then
            current_shell="zsh"
            shell_rc="$HOME/.zshrc"
        elif [ -n "$BASH_VERSION" ]; then
            current_shell="bash"
            # macOS bash uses .bash_profile by default
            if [ "$OS" = "macos" ]; then
                shell_rc="$HOME/.bash_profile"
            else
                shell_rc="$HOME/.bashrc"
            fi
        else
            # Fallback detection
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
        
        # Create shell rc file if it doesn't exist
        touch "$shell_rc"
        
        # Check if PATH modification already exists
        if grep -q "export PATH.*$BIN_DIR" "$shell_rc" 2>/dev/null; then
            echo -e "${GREEN}✓ PATH already configured in $shell_rc${NC}"
            return 0
        fi
        
        # Add PATH configuration
        echo "" >> "$shell_rc"
        echo "# QuickIcon CLI - https://github.com/azeezabass2005/quickicon" >> "$shell_rc"
        echo "$path_line" >> "$shell_rc"
        
        echo -e "${GREEN}✓ Added $BIN_DIR to PATH in $shell_rc${NC}"
        return 1
    }

    # Try system-wide installation first on macOS (no PATH modification needed)
    try_system_install() {
        if [ "$OS" = "macos" ] && [ -w "/usr/local/bin" ]; then
            echo "Installing system-wide to /usr/local/bin..."
            ln -sf "$INSTALL_DIR/quickicon" "/usr/local/bin/quickicon"
            echo "SYSTEM_LINK=/usr/local/bin/quickicon" >> "$INSTALL_DIR/version.info"
            echo -e "${GREEN}✓ Installed system-wide to /usr/local/bin${NC}"
            return 0
        fi
        return 1
    }

    # Try system install first (macOS only)
    if try_system_install; then
        echo -e "${GREEN}🎉 You can now use 'quickicon' command!${NC}"
    else
        # Auto-configure shell
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
else
    # For updates, just confirm success
    echo -e "${GREEN}🎉 QuickIcon updated successfully!${NC}"
    echo -e "From ${YELLOW}$CURRENT_VERSION${NC} to ${GREEN}$LATEST_RELEASE${NC}"
    
    # Clean up backup after successful update
    if [ -n "$BACKUP_DIR" ] && [ -d "$BACKUP_DIR" ]; then
        rm -rf "$BACKUP_DIR"
    fi
fi

echo ""
echo -e "${GREEN}✓ QuickIcon ${LATEST_RELEASE} is ready!${NC}"
echo ""
echo "Get started:"
echo "  quickicon --icon-name MyIcon --path ./icon.svg"
echo ""
echo "For help:"
echo "  quickicon --help"
echo ""
echo -e "${YELLOW}Management commands:${NC}"
echo "  Update:  curl -fsSL ... | bash -s -- --update"
echo "  Remove:   curl -fsSL ... | bash -s -- --uninstall"