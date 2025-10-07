# Installation Guide

QuickIcon can be installed in multiple ways depending on your platform and preferences.

## Table of Contents
- [Quick Install (Recommended)](#quick-install-recommended)
- [npm/yarn Installation](#npmyarn-installation)
- [Manual Installation](#manual-installation)
- [From Source](#from-source)
- [Platform-Specific Notes](#platform-specific-notes)
- [Verification](#verification)
- [Troubleshooting](#troubleshooting)

---

## Quick Install (Recommended)

### Linux / macOS

```bash
curl -fsSL https://raw.githubusercontent.com/azeezabass2005/quickicon/main/install.sh | bash
```

Or with wget:
```bash
wget -qO- https://raw.githubusercontent.com/azeezabass2005/quickicon/main/install.sh | bash
```

### Windows (PowerShell)

Run PowerShell as Administrator:
```powershell
irm https://raw.githubusercontent.com/azeezabass2005/quickicon/main/install.ps1 | iex
```

Or download and run:
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/azeezabass2005/quickicon/main/install.ps1" -OutFile "install.ps1"
.\install.ps1
```

<!-- ---

## npm/yarn Installation

QuickIcon is available on npm and works across all platforms.

### Using npm

```bash
npm install -g quickicon
```

### Using yarn

```bash
yarn global add quickicon
```

### Using pnpm

```bash
pnpm add -g quickicon
```

### Using as a Project Dependency

If you want to use QuickIcon in a specific project:

```bash
npm install --save-dev quickicon
# or
yarn add -D quickicon
```

Then use it via npx or in package.json scripts:
```bash
npx quickicon --icon-name MyIcon
```

--- -->

## Manual Installation

### 1. Download Pre-built Binaries

Visit the [Releases page](https://github.com/azeezabass2005/quickicon/releases) and download the appropriate binary for your system:

#### Linux
- **x86_64**: `quickicon-linux-x86_64.tar.gz`
- **ARM64**: `quickicon-linux-aarch64.tar.gz`

#### macOS
- **Intel (x86_64)**: `quickicon-macos-x86_64.tar.gz`
- **Apple Silicon (ARM64)**: `quickicon-macos-aarch64.tar.gz`

#### Windows
- **64-bit**: `quickicon-windows-x86_64.exe.zip`

### 2. Extract and Install

#### Linux / macOS

```bash
# Extract the archive
tar -xzf quickicon-*.tar.gz

# Move to a directory in your PATH
sudo mv quickicon /usr/local/bin/

# Make it executable (if needed)
chmod +x /usr/local/bin/quickicon

# Verify installation
quickicon --help
```

#### Windows

1. Extract the ZIP file
2. Move `quickicon.exe` to a directory in your PATH (e.g., `C:\Program Files\quickicon\`)
3. Add that directory to your system PATH:
   - Right-click **This PC** → **Properties**
   - Click **Advanced system settings**
   - Click **Environment Variables**
   - Under **System Variables**, find and edit **Path**
   - Add the directory containing `quickicon.exe`
4. Restart your terminal and verify:
   ```powershell
   quickicon --help
   ```

---

## From Source

If you have Rust installed, you can build from source.

### Prerequisites

- Rust 1.70.0 or higher ([install Rust](https://rustup.rs/))
- Git

### Build and Install

```bash
# Clone the repository
git clone https://github.com/azeezabass2005/quickicon.git
cd quickicon

# Build and install
cargo install --path .

# Verify installation
quickicon --help
```

### Development Build

```bash
# Build without installing
cargo build --release

# The binary will be at target/release/quickicon
./target/release/quickicon --help
```

---

## Platform-Specific Notes

### Linux

#### Ubuntu/Debian
No additional dependencies required. If you encounter issues with clipboard access, install:
```bash
sudo apt-get install xclip xsel
```

#### Fedora/RHEL
```bash
sudo dnf install xclip xsel
```

#### Arch Linux
```bash
sudo pacman -S xclip xsel
```

#### Wayland Users
For Wayland clipboard support:
```bash
sudo apt-get install wl-clipboard  # Ubuntu/Debian
sudo dnf install wl-clipboard      # Fedora
```

### macOS

#### Permissions
On first run, you may need to grant clipboard access:
1. Go to **System Preferences** → **Security & Privacy** → **Privacy**
2. Grant access to **Accessibility** or **Automation** if prompted

#### Homebrew (Coming Soon)
```bash
brew install quickicon
```

### Windows

#### Windows Defender
Windows Defender may flag the binary on first run. This is a false positive. You can:
1. Click **More info** → **Run anyway**
2. Or add an exclusion in Windows Security

#### PowerShell Execution Policy
If the installer script fails, you may need to adjust the execution policy:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

## Verification

After installation, verify QuickIcon is working:

```bash
# Check version
quickicon --version

# View help
quickicon --help

# Test with a simple icon
echo '<svg width="24" height="24"><circle cx="12" cy="12" r="10" fill="#000"/></svg>' | quickicon --icon-name TestIcon
```

---

## Troubleshooting

### "Command not found" error

**Linux/macOS:**
```bash
# Check if the binary is in your PATH
which quickicon

# If not found, add to PATH (add to ~/.bashrc or ~/.zshrc)
export PATH="$PATH:$HOME/.local/bin"

# Reload shell configuration
source ~/.bashrc  # or ~/.zshrc
```

**Windows:**
```powershell
# Check if in PATH
where.exe quickicon

# If not found, add the installation directory to your PATH (see Manual Installation)
```

### npm installation fails

Try with sudo (Linux/macOS):
```bash
sudo npm install -g quickicon
```

Or use a node version manager like [nvm](https://github.com/nvm-sh/nvm):
```bash
nvm install 18
nvm use 18
npm install -g quickicon
```

### Permission denied on Linux/macOS

```bash
# Make the binary executable
chmod +x /path/to/quickicon

# Or reinstall with proper permissions
sudo mv quickicon /usr/local/bin/
```

### Clipboard issues on Linux

Install clipboard utilities:
```bash
# For X11
sudo apt-get install xclip xsel

# For Wayland
sudo apt-get install wl-clipboard
```

### Windows SmartScreen warning

This is normal for new executables. Click **More info** → **Run anyway**.

To permanently allow:
1. Right-click the executable → **Properties**
2. Check **Unblock** at the bottom
3. Click **Apply**

### Build from source fails

Ensure you have the latest Rust:
```bash
rustup update stable
cargo clean
cargo build --release
```

---

## Updating QuickIcon

### Via npm
```bash
npm update -g quickicon
```

### Via install script
Re-run the installation script - it will automatically fetch the latest version.

### Manual update
Download the latest binary from [Releases](https://github.com/azeezabass2005/quickicon/releases) and replace the existing one.

---

## Uninstallation

### npm installation
```bash
npm uninstall -g quickicon
```

### Manual installation (Linux/macOS)
```bash
sudo rm /usr/local/bin/quickicon
# Or wherever you installed it
rm ~/.local/bin/quickicon
rm -rf ~/.quickicon
```

### Manual installation (Windows)
1. Delete `quickicon.exe` from your installation directory
2. Remove the directory from your PATH
3. Delete the `%LOCALAPPDATA%\quickicon` folder

---

## Getting Help

If you encounter issues not covered here:

1. Check [existing issues](https://github.com/azeezabass2005/quickicon/issues)
2. Open a [new issue](https://github.com/azeezabass2005/quickicon/issues/new)
3. Join the [discussions](https://github.com/azeezabass2005/quickicon/discussions)

Include the following information when reporting issues:
- Operating system and version
- Installation method
- QuickIcon version (`quickicon --version`)
- Complete error message
- Steps to reproduce