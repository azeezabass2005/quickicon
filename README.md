# QuickIcon CLI

> Transform SVG files into React components instantly from your clipboard, local files, or remote URLs.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## 🚀 What is QuickIcon?

QuickIcon is a command-line tool that converts SVG files into ready-to-use React components with proper TypeScript typings, customizable props, and automatic attribute conversion. Stop manually converting SVG attributes to camelCase or wrapping SVGs in component boilerplate!

### ✨ Features

- 📋 **Clipboard Support** - Copy an SVG, run one command
- 🌐 **Remote URLs** - Fetch SVGs directly from the web
- 📁 **Local Files** - Process `.svg` files from your filesystem
- ⚛️ **React Components** - Generates functional components with proper props
- 🎨 **Smart Defaults** - Automatic size and color props with sensible defaults
- 📝 **TypeScript & JavaScript** - Full support for both languages
- 💾 **Configuration Persistence** - Remember your preferences with `quickicon.json`
- 🔄 **Attribute Conversion** - Automatic HTML-to-JSX attribute transformation

## 📦 Installation

### Prerequisites

- Rust toolchain (1.70.0 or higher)

### From Source

```bash
# Clone the repository
git clone https://github.com/azeezabass2005/quickicon.git
cd quickicon

# Build and install
cargo install --path .
```

### From crates.io (Coming Soon)

```bash
cargo install quickicon
```

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

1. **Attribute Conversion**: Converts SVG attributes to React-compatible camelCase
   - `fill-rule` → `fillRule`
   - `stroke-width` → `strokeWidth`
   - `clip-path` → `clipPath`
   - `class` → `className`
   - And 40+ more attributes

2. **Style Conversion**: Transforms inline styles to React format
   - `style="background-color: red"` → `style={{ backgroundColor: 'red' }}`

3. **Dimension Props**: Replaces hardcoded dimensions
   - `width="24"` → `width={size}`
   - `height="24"` → `height={size}`

4. **Color Props**: Makes colors customizable
   - `fill="#000000"` → `fill={color}`
   - `stroke="#123456"` → `stroke={color}`

5. **Props Spreading**: Adds flexibility
   - Adds `{...props}` to root SVG element

## 🛡️ Supported Formats

### Input Sources
- ✅ Clipboard text (SVG content)
- ✅ Local `.svg` files
- ✅ Local `.txt` files containing SVG
- ✅ Remote URLs (http/https)

### Output Languages
- ✅ TypeScript (`.tsx`)
- ✅ JavaScript (`.jsx`)

### Supported Frameworks
- ✅ React (v16.8+)
- ⏳ Vue (planned)
- ⏳ Svelte (planned)
- ⏳ Angular (planned)

## 🐛 Troubleshooting

### "Your clipboard text content is not a valid svg"
- Ensure you've copied valid SVG markup
- Check that the SVG starts with `<svg` and ends with `</svg>`

### "An icon already exists at..."
- A component with that name already exists
- Choose a different name or delete the existing file

### "An error occurred while reading the provided svg file"
- Check file path is correct
- Ensure file has `.svg` or `.txt` extension
- Verify file permissions

### "There is no svg returned from the provided url"
- URL must return valid HTML/SVG content
- Check network connection
- Verify URL is accessible

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
git clone https://github.com/azeezabass2005/quickicon.git
cd quickicon

# Build
cargo build

# Run tests
cargo test

# Run locally
cargo run -- --icon-name TestIcon --path ./test.svg
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

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👏 Acknowledgments

- Built with [Rust](https://www.rust-lang.org/)
- Uses [clap](https://github.com/clap-rs/clap) for CLI parsing
- SVG parsing and manipulation with [regex](https://github.com/rust-lang/regex)

## 📧 Support

- 🐛 [Report a Bug](https://github.com/azeezabass2005/quickicon/issues)
- 💡 [Request a Feature](https://github.com/azeezabass2005/quickicon/issues)
- 💬 [Discussions](https://github.com/azeezabass2005/quickicon/discussions)

---

**Made with ❤️ by Fola**

If QuickIcon saves you time, consider giving it a ⭐️ on GitHub!