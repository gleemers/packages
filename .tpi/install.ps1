# TPI Installer Script
$NAME = "TPI"
$AUTHOR = "Thoq"
$DATE = "5-24-25"
$INSTALL_DIR = "$env:USERPROFILE\.local\bin"
$DOWNLOAD_DIR = "$env:TEMP\tpi"
$REPO = "https://github.com/gleemers/tpi.git"

# Welcome Screen
Write-Host "+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+"
Write-Host "Welcome to the $NAME installer!"
Write-Host "Written by $AUTHOR on $DATE"
Write-Host "+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+"
Write-Host ""

Write-Host "Windows is experimental, not all packages will work!"

# Check for Git
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Git is not installed!" -ForegroundColor Red
}

# Check for Cargo
if (-not (Get-Command cargo -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Cargo (Rust toolchain) is not installed!" -ForegroundColor Red
}

# Download or update repository
if (Test-Path $DOWNLOAD_DIR) {
    Write-Host "[-] tpi already downloaded!"
    Write-Host "[*] Updating tpi..."
    Set-Location $DOWNLOAD_DIR
    git pull | Out-Null
} else {
    Write-Host "[+] Downloading tpi to $DOWNLOAD_DIR..."
    git clone $REPO $DOWNLOAD_DIR
}

# Build the project
Write-Host "[+] Entering directory: $DOWNLOAD_DIR"
Set-Location $DOWNLOAD_DIR

Write-Host "[+] Building tpi (this may take a while)..."
cargo build --release

# Install the binary
Write-Host "[+] Installing tpi to $INSTALL_DIR"
if (-not (Test-Path $INSTALL_DIR)) {
    New-Item -ItemType Directory -Path $INSTALL_DIR | Out-Null
}
Copy-Item -Path "$DOWNLOAD_DIR\target\release\tpi.exe" -Destination $INSTALL_DIR -Force

# Final message
Write-Host ""
Write-Host "To add to PATH, run:" -ForegroundColor Yellow
Write-Host "==============================================="
Write-Host '  $env:Path += ";$env:USERPROFILE\.local\bin"'
Write-Host "==============================================="
Write-Host "Or add that line to your PowerShell profile:"
Write-Host "  notepad $PROFILE"
Write-Host ""
Write-Host "Thank you!"
