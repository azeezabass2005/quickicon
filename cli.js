#!/usr/bin/env node

const { spawnSync } = require('child_process');
const path = require('path');
const fs = require('fs');

// Determine the platform-specific binary name
function getBinaryPath() {
  const platform = process.platform;
  const arch = process.arch;
  
  let binaryName = 'quickicon';
  if (platform === 'win32') {
    binaryName = 'quickicon.exe';
  }
  
  const optionalDeps = {
    'linux-x64': '@quickicon/linux-x64-gnu',
    'linux-arm64': '@quickicon/linux-arm64-gnu',
    'darwin-x64': '@quickicon/darwin-x64',
    'darwin-arm64': '@quickicon/darwin-arm64',
    'win32-x64': '@quickicon/win32-x64-msvc',
    'win32-arm64': '@quickicon/win32-arm64-msvc',
  };
  
  const key = `${platform}-${arch === 'x64' ? 'x64' : 'arm64'}`;
  const packageName = optionalDeps[key];
  
  if (packageName) {
    const binaryPath = path.join(
      __dirname,
      'node_modules',
      packageName,
      binaryName
    );
    
    if (fs.existsSync(binaryPath)) {
      return binaryPath;
    }
  }
  
  const fallbackPath = path.join(__dirname, binaryName);
  if (fs.existsSync(fallbackPath)) {
    return fallbackPath;
  }
  
  console.error('Error: Could not find quickicon binary for your platform.');
  console.error(`Platform: ${platform}, Architecture: ${arch}`);
  process.exit(1);
}

const binaryPath = getBinaryPath();
const result = spawnSync(binaryPath, process.argv.slice(2), {
  stdio: 'inherit',
});

process.exit(result.status || 0);