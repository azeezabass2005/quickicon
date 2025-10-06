# QuickIcon CLI

> Transform SVG files into React components instantly from your clipboard, local files, or remote URLs.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![npm version](https://badge.fury.io/js/quickicon.svg)](https://www.npmjs.com/package/quickicon)

## 🚀 What is QuickIcon?

QuickIcon is a blazingly fast command-line tool built with Rust that converts SVG files into ready-to-use React components with proper TypeScript typings, customizable props, and automatic attribute conversion. Stop manually converting SVG attributes to camelCase or wrapping SVGs in component boilerplate!

### ✨ Features

- 📋 **Clipboard Support** - Copy an SVG, run one command
- 🌐 **Remote URLs** - Fetch SVGs directly from the web
- 📁 **Local Files** - Process `.svg` files from your filesystem
- ⚛️ **React Components** - Generates functional components with proper props
- 🎨 **Smart Defaults** - Automatic size and color props with sensible defaults
- 📝 **TypeScript & JavaScript** - Full support for both languages
- 💾 **Configuration Persistence** - Remember your preferences with `quickicon.json`
- 🔄 **Attribute Conversion** - Automatic HTML-to-JSX attribute transformation (40+ attributes)
- ⚡ **Blazingly Fast** - Built with Rust for maximum performance
- 🌍 **Cross-Platform** - Works on Linux, macOS, and Windows

## 📦 Installation

### Quick Install (Recommended)

#### Linux / macOS
```bash
curl -fsSL https://raw.githubusercontent.com/yourusername/quickicon/main/install.sh | bash
```

#### Windows (PowerShell - Run as Administrator)
```powershell
irm https://raw.githubusercontent.com/yourusername/quickicon/main/install.ps1 | iex
```

### Via npm (All Platforms)

```bash
npm install -g quickicon
```

Or with yarn:
```bash
yarn global add quickicon
```

### Other Installation Methods

See [INSTALLATION.md](INSTALLATION.md) for:
- Manual installation
- Building from source
- Platform-specific instructions
- Troubleshooting

## 🎯 Quick Start

### Basic Usage

1. **From Clipboard** (Copy any SVG first)
```bash
quickicon --icon-name MyIcon
```

2. **From Local File**
```bash
quickicon --icon-name MyIcon --path ./icons/heart.svg
```

3. **From Remote URL**
```bash
quickicon --icon-name MyIcon --path https://example.com/icon.svg
```

### Example Output

Given an SVG input:
```xml
<svg width="24" height="24" viewBox="0 0 24 24" fill="none">
  <path d="M12 2L2 7l10 5 10-5-10-5z" fill="#000000" stroke="#000000"/>
</svg>
```

QuickIcon generates (`MyIcon.tsx`):
```typescript
import React, {SVGProps} from "react";

const MyIcon = ({ 
    size = 24, 
    color = '#111827', 
    ...props 
} : { size: number, color: string, props: SVGProps<SVGSVGElement> }) => {
    return (
        <svg viewBox="0 0 24 24" fill="none" width={size} height={size} {...props}>
            <path d="M12 2L2 7l10 5 10-5-10-5z" fill={color} stroke={color}/>
        </svg>
    );
};

export default MyIcon;

// Usage examples:
// <MyIcon />
// <MyIcon size={32} color="#3B82F6" />
// <MyIcon className="hover:opacity-80" />
```

## 📖 Command Reference

### Options

| Flag | Short | Description | Default |
|------|-------|-------------|---------|
| `--icon-name` | `-n` | Name of the React component (required) | - |
| `--path` | `-p` | Path to local file or remote URL | Clipboard |
| `--destination` | `-d` | Output directory for the component | `./src/assets/icon` |
| `--javascript` | - | Generate JavaScript instead of TypeScript | TypeScript |
| `--no-javascript` | - | Explicitly use TypeScript | TypeScript |
| `--default` | `-D` | Save settings to `quickicon.json` | false |

### Examples

**Generate TypeScript component from clipboard:**
```bash
quickicon --icon-name UserIcon
```

**Generate JavaScript component:**
```bash
quickicon --icon-name UserIcon --javascript
```

**Custom destination folder:**
```bash
quickicon --icon-name UserIcon --destination ./src/components/icons
```

**Save as default configuration:**
```bash
quickicon --icon-name UserIcon --destination ./src/icons --default
```

**From remote URL:**
```bash
quickicon -n GithubIcon -p https://api.iconify.design/mdi/github.svg
```

**Using npx (no global install needed):**
```bash
npx quickicon --icon-name MyIcon --path ./icon.svg
```

## ⚙️ Configuration

QuickIcon can save your preferences in a `quickicon.json` file in your project root.

### Creating Configuration

Use the `--default` flag to save current settings:
```bash
quickicon --icon-name MyIcon --destination ./src/icons --javascript --default
```

This creates `quickicon.json`:
```json
{
  "is_javascript": true,
  "destination_folder": "./src/icons"
}
```

### Using Saved Configuration

Once saved, simply run:
```bash
quickicon --icon-name AnotherIcon
```

QuickIcon will use your saved preferences automatically.

## 🔧 How It Works

QuickIcon performs several transformations:

1. **Attribute Conversion**: Converts 40+ SVG attributes to React-compatible camelCase
   - `fill-rule` → `fillRule`
   - `stroke-width` → `strokeWidth`
   - `clip-path` → `clipPath`
   - `class` → `className`
   - And many more...

2. **Style Conversion**: Transforms inline styles to React format
   - `style="background-color: red"` → `style={{ backgroundColor: 'red' }}`

3. **Dimension Props**: Replaces hardcoded dimensions
   - `width="24"` → `width={size}`
   - `height="24"` → `height={size}`

4. **Color Props**: Makes colors customizable
   - `fill="#000000"` → `fill={color}`
   - `stroke="#123456"` → `stroke={color}`

5. **Props Spreading**: Adds flexibility
   - Adds `{...props}` to root SVG element for maximum customization

## 🛡️ Supported Formats

### Input Sources
- ✅ Clipboard text (SVG content)
- ✅ Local `.svg` files
- ✅ Local `.txt` files containing SVG
- ✅ Remote URLs (http/https)

### Output Languages
- ✅ TypeScript (`.tsx`)
- ✅ JavaScript (`.jsx`)

### Framework Support
- ✅ React (v16.8+)
- ⏳ Vue (coming soon)
- ⏳ Svelte (coming soon)
- ⏳ Angular (coming soon)

**Note:** Version 0.1.0 focuses on React. Support for additional frameworks is planned for future releases. Star the repo to stay updated!

## 🎬 Demo

```bash
# Copy this SVG:
<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M12 2L2 7L12 12L22 7L12 2Z" fill="#000000" stroke="#000000" stroke-width="2"/>
</svg>

# Run:
quickicon --icon-name RocketIcon

# Output: src/assets/icon/RocketIcon.tsx created! ✨
```

## 🐛 Troubleshooting

### "Your clipboard text content is not a valid svg"
- Ensure you've copied valid SVG markup
- Check that the SVG starts with `<svg` and ends with `</svg>`
- The content must be well-formed XML

### "An icon already exists at..."
- A component with that name already exists at the destination
- Choose a different name or delete the existing file
- Or use a different destination folder with `--destination`

### "Command not found" after installation
- **Linux/macOS**: Add `$HOME/.local/bin` to your PATH
- **Windows**: Restart your terminal after installation
- See [INSTALLATION.md](INSTALLATION.md) for detailed troubleshooting

### Clipboard issues on Linux
Install clipboard utilities:
```bash
sudo apt-get install xclip xsel  # For X11
sudo apt-get install wl-clipboard # For Wayland
```

For more troubleshooting, see [INSTALLATION.md](INSTALLATION.md#troubleshooting).

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Setup

```bash
# Clone your fork
git clone https://github.com/yourusername/quickicon.git
cd quickicon

# Build
cargo build

# Run tests
cargo test

# Run locally
cargo run -- --icon-name TestIcon --path ./test.svg

# Build for npm
npm install
npm run build
```

## 📝 Roadmap

- [ ] Support for Vue components
- [ ] Support for Svelte components
- [ ] Support for Angular components
- [ ] Interactive mode with prompts
- [ ] Batch processing multiple SVGs
- [ ] Custom component templates
- [ ] RGB/RGBA color support
- [ ] SVG optimization options
- [ ] GitHub Action integration
- [ ] VS Code extension
- [ ] Homebrew formula

## 🏗️ Tech Stack

- **Language**: Rust 🦀
- **CLI**: [clap](https://github.com/clap-rs/clap)
- **Clipboard**: [arboard](https://github.com/1Password/arboard)
- **HTTP**: [reqwest](https://github.com/seanmonstar/reqwest)
- **Regex**: [regex](https://github.com/rust-lang/regex)
- **Node Bindings**: [napi-rs](https://napi.rs/)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👏 Acknowledgments

- Built with [Rust](https://www.rust-lang.org/) for blazing performance
- Inspired by the need to speed up React development workflows
- Thanks to all contributors and users!

## 📧 Support & Community

- 🐛 [Report a Bug](https://github.com/yourusername/quickicon/issues/new?labels=bug)
- 💡 [Request a Feature](https://github.com/yourusername/quickicon/issues/new?labels=enhancement)
- 💬 [Discussions](https://github.com/yourusername/quickicon/discussions)
- 📖 [Documentation](https://github.com/yourusername/quickicon/wiki)

## 📊 Stats

![GitHub stars](https://img.shields.io/github/stars/yourusername/quickicon?style=social)
![GitHub forks](https://img.shields.io/github/forks/yourusername/quickicon?style=social)
![npm downloads](https://img.shields.io/npm/dm/quickicon)

---

**Made with ❤️ and ☕ by [Your Name]**

If QuickIcon saves you time, consider:
- ⭐ Starring the repo
- 🐦 Sharing on Twitter
- 💼 Sharing on LinkedIn
- ☕ [Buying me a coffee](https://buymeacoffee.com/yourusername)

**QuickIcon** - Because life's too short for manual SVG conversion! ⚡