# Installer Script for Windows

$ErrorActionPreference = "Stop"

$Repo = "azeezabass2005/quickicon"
$InstallDir = if ($env:QUICKICON_INSTALL_DIR) { $env:QUICKICON_INSTALL_DIR } else { "$env:LOCALAPPDATA\quickicon" }
$BinDir = "$InstallDir\bin"

Write-Host "QuickIcon Installer" -ForegroundColor Green
Write-Host "================================"

$Arch = if ([Environment]::Is64BitOperatingSystem) { "x86_64" } else { "x86" }
Write-Host "Detected architecture: $Arch" -ForegroundColor Yellow

Write-Host "Fetching latest release..."
try {
    $LatestRelease = (Invoke-RestMethod -Uri "https://api.github.com/repos/$Repo/releases/latest").tag_name
    Write-Host "Latest version: $LatestRelease" -ForegroundColor Green
} catch {
    Write-Host "Failed to fetch latest release" -ForegroundColor Red
    exit 1
}

$BinaryName = "quickicon-windows-$Arch.exe"
$DownloadUrl = "https://github.com/$Repo/releases/download/$LatestRelease/$BinaryName.zip"

Write-Host "Downloading from: $DownloadUrl"

$TmpDir = New-Item -ItemType Directory -Path "$env:TEMP\quickicon-install-$(Get-Random)" -Force

try {
    $ZipPath = "$TmpDir\quickicon.zip"
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $ZipPath
    
    if (-not (Test-Path $ZipPath)) {
        throw "Download failed"
    }
    
    Write-Host "Extracting..."
    Expand-Archive -Path $ZipPath -DestinationPath $TmpDir -Force
    
    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
    New-Item -ItemType Directory -Path $BinDir -Force | Out-Null
    
    Write-Host "Installing to $BinDir..."
    Copy-Item -Path "$TmpDir\quickicon.exe" -Destination "$BinDir\quickicon.exe" -Force
    
    Write-Host "Installation complete!" -ForegroundColor Green
    Write-Host ""
    Write-Host "QuickIcon has been installed to: $BinDir"
    Write-Host ""
    
    $CurrentPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($CurrentPath -notlike "*$BinDir*") {
        Write-Host "Adding to PATH..." -ForegroundColor Yellow
        
        $NewPath = "$CurrentPath;$BinDir"
        [Environment]::SetEnvironmentVariable("Path", $NewPath, "User")
        
        Write-Host "✓ Added to PATH" -ForegroundColor Green
        Write-Host ""
        Write-Host "Please restart your terminal for PATH changes to take effect." -ForegroundColor Yellow
    } else {
        Write-Host "✓ Already in PATH" -ForegroundColor Green
        Write-Host "You can now use 'quickicon' command!" -ForegroundColor Green
    }
    
    Write-Host ""
    Write-Host "Get started:"
    Write-Host "  quickicon --icon-name MyIcon --path ./icon.svg"
    Write-Host ""
    Write-Host "For help:"
    Write-Host "  quickicon --help"
    
} catch {
    Write-Host "Installation failed: $_" -ForegroundColor Red
    exit 1
} finally {
    Remove-Item -Path $TmpDir -Recurse -Force -ErrorAction SilentlyContinue
}