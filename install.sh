#!/bin/bash
set -e

VERSION="${1}"

if [ -z "$VERSION" ]; then
  VERSION=$(curl -s https://api.github.com/repos/we-dcode/dcli/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
fi

OS="$(uname | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

# Translate arch names
if [[ "$ARCH" == "x86_64" ]]; then ARCH="amd64"; fi
if [[ "$ARCH" == "arm64" || "$ARCH" == "aarch64" ]]; then ARCH="arm64"; fi

URL="https://github.com/we-dcode/dcli/releases/download/$VERSION/dcli_${VERSION}_${OS}_${ARCH}.tar.gz"

echo "📦 Downloading dcli $VERSION for $OS/$ARCH..."
mkdir -p ~/.dcode
curl -sL "$URL" | tar -xz -C ~/.dcode

chmod +x ~/.dcode/dcli

echo "✅ Installed to ~/.dcode/dcli"
echo "👉 Add to PATH: export PATH=\"\$HOME/.dcode:\$PATH\""
