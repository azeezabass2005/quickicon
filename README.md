# QuickIcon CLI

Transform SVG files into React components from your clipboard, local files, or remote URLs.

![QuickIcon Demo](https://imgur.com/gtwviic.gif)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## What is QuickIcon?

QuickIcon is a command-line tool that converts SVG files into React components with TypeScript support. It handles attribute conversion, adds customizable props, and saves you from manually converting SVG attributes to camelCase.

### Features

- Clipboard support - copy an SVG and run one command
- Remote URLs - fetch SVGs directly from the web
- Local files - process `.svg` files from your filesystem
- React components - generates functional components with proper props
- Smart defaults - automatic size and color props
- TypeScript & JavaScript - supports both
- Configuration persistence - save preferences in `quickicon.json`
- Attribute conversion - automatic HTML-to-JSX transformation (40+ attributes)
- Cross-platform - works on Linux, macOS, and Windows

## Installation

### Quick Install

**Linux / macOS:**
```bash
curl -fsSL https://raw.githubusercontent.com/azeezabass2005/quickicon/main/install.sh | bash
```

**Windows (PowerShell - Run as Administrator):**
```powershell
irm https://raw.githubusercontent.com/azeezabass2005/quickicon/main/install.ps1 | iex
```

For other installation methods, manual installation, or troubleshooting, see [INSTALLATION.md](INSTALLATION.md).

## Quick Start

**From clipboard** (copy any SVG first):
```bash
quickicon --icon-name MyIcon
```

**From local file:**
```bash
quickicon --icon-name MyIcon --path ./icons/heart.svg
```

**From remote URL:**
```bash
quickicon --icon-name MyIcon --path https://example.com/icon.svg
```

### Example Output

Given this SVG:
```xml
<svg width="24" height="24" viewBox="0 0 24 24" fill="none">
  <path d="M12 2L2 7l10 5 10-5-10-5z" fill="#000000" stroke="#000000"/>
</svg>
```

QuickIcon generates `MyIcon.tsx`:
```typescript
import React, {SVGProps} from "react";

interface MyIconProps extends SVGProps<SVGSVGElement> {
   size?: `${number}` | number;
   color?: string;
}

const MyIcon = ({ 
    size = 24, 
    color = '#111827', 
    ...props 
} : MyIconProps) => {
    return (
        <svg viewBox="0 0 24 24" fill="none" width={size} height={size} {...props}>
            <path d="M12 2L2 7l10 5 10-5-10-5z" fill={color} stroke={color}/>
        </svg>
    );
};

export default MyIcon;
```

## Command Reference

| Flag | Short | Description | Default |
|------|-------|-------------|---------|
| `--icon-name` | `-n` | Name of the React component (required) | - |
| `--path` | `-p` | Path to local file or remote URL | Clipboard |
| `--destination` | `-d` | Output directory for the component | `./public/assets/icon` |
| `--size` | `-s` | Default size prop (number) | `24` |
| `--language` | -l | Language: `ts` or `js` | `ts` |
| `--default` | `-D` | Save settings to `quickicon.json` | false |

### Examples

```bash
# TypeScript component from clipboard
quickicon --icon-name UserIcon

# JavaScript component
quickicon --icon-name UserIcon --language javascript

# Custom destination
quickicon --icon-name UserIcon --destination ./src/components/icons

# Save as default configuration
quickicon --icon-name UserIcon --destination ./src/icons --default

# From remote URL
quickicon -n GithubIcon -p https://api.iconify.design/mdi/github.svg
```

## Configuration

QuickIcon can save your preferences in a `quickicon.json` file in your project root.

Save current settings:
```bash
quickicon --icon-name MyIcon --destination ./src/icons --language javascript --default
```

This creates `quickicon.json`:
```json
{
  "is_javascript": true,
  "destination_folder": "./src/icons"
}
```

After saving, just run:
```bash
quickicon --icon-name AnotherIcon
```

QuickIcon will use your saved preferences automatically.

## How It Works

QuickIcon performs several transformations:

1. **Attribute Conversion**: Converts 40+ SVG attributes to React-compatible camelCase
   - `fill-rule` → `fillRule`
   - `stroke-width` → `strokeWidth`
   - `clip-path` → `clipPath`
   - `class` → `className`

2. **Style Conversion**: Transforms inline styles to React format
   - `style="background-color: red"` → `style={{ backgroundColor: 'red' }}`

3. **Dimension Props**: Replaces hardcoded dimensions with `size` prop
   - `width="24"` → `width={size}`
   - `height="24"` → `height={size}`

4. **Color Props**: Makes colors customizable via `color` prop
   - `fill="#000000"` → `fill={color}`
   - `stroke="#123456"` → `stroke={color}`

5. **Props Spreading**: Adds `{...props}` to root SVG element for flexibility

## Supported Formats

**Input Sources:**
- Clipboard text (SVG content)
- Local `.svg` files
- Local `.txt` files containing SVG
- Remote URLs (http/https)

**Output Languages:**
- TypeScript (`.tsx`)
- JavaScript (`.jsx`)

## Troubleshooting

**"Your clipboard text content is not a valid svg"**
- Make sure you've copied valid SVG markup
- Check that the SVG starts with `<svg` and ends with `</svg>`
- The content must be well-formed XML

**"An icon already exists at..."**
- A component with that name already exists at the destination
- Choose a different name or delete the existing file
- Or use a different destination folder with `--destination`

**"Command not found" after installation**
- **Linux/macOS**: Add `$HOME/.local/bin` to your PATH
- **Windows**: Restart your terminal after installation
- See [INSTALLATION.md](INSTALLATION.md) for detailed troubleshooting

**Clipboard issues on Linux**
Install clipboard utilities:
```bash
sudo apt-get install xclip xsel  # For X11
sudo apt-get install wl-clipboard # For Wayland
```

## Contributing

Contributions are welcome. Here's how you can help:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Setup

```bash
# Clone your fork
git clone https://github.com/azeezabass2005/quickicon.git
cd quickicon

# Build
cargo build

# Run tests
cargo test

# Run locally
cargo run -- --icon-name TestIcon --path ./test.svg
```

## Roadmap

- Interactive mode with prompts
- Batch processing multiple SVGs
- Custom component templates
- RGB/RGBA color support
- SVG optimization options
- GitHub Action integration
- VS Code extension
- Figma Plugin
- Homebrew formula

## Tech Stack

- **Language**: Rust
- **CLI**: [clap](https://github.com/clap-rs/clap)
- **Clipboard**: [arboard](https://github.com/1Password/arboard)
- **HTTP**: [reqwest](https://github.com/seanmonstar/reqwest)
- **Regex**: [regex](https://github.com/rust-lang/regex)
- **Node Bindings**: [napi-rs](https://napi.rs/)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support & Community

- [Report a Bug](https://github.com/azeezabass2005/quickicon/issues/new?labels=bug)
- [Request a Feature](https://github.com/azeezabass2005/quickicon/issues/new?labels=enhancement)
- [Discussions](https://github.com/azeezabass2005/quickicon/discussions)

![GitHub stars](https://img.shields.io/github/stars/azeezabass2005/quickicon?style=social)
![GitHub forks](https://img.shields.io/github/forks/azeezabass2005/quickicon?style=social)

---

**Made by Fola**

If QuickIcon saves you time, consider:
- Starring the repo
- Sharing on Twitter
- Sharing on LinkedIn
- [Buying me a coffee](https://buymeacoffee.com/rustyfola)
