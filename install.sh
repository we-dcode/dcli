#!/bin/bash
set -e

VERSION="${1}"
INSTALL_DIR="${HOME}/.dcode"


if [ -z "$VERSION" ]; then
  VERSION=$(curl -s https://api.github.com/repos/we-dcode/dcli/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
fi

if [ -x "$INSTALL_DIR/dcli" ]; then
  INSTALLED_VERSION=$("$INSTALL_DIR/dcli" -v 2>/dev/null | sed -nE 's/.*([0-9]+\.[0-9]+\.[0-9]+).*/\1/p')
  if [ "$INSTALLED_VERSION" = "${VERSION}" ]; then
    echo "dcli $INSTALLED_VERSION is already up to date in $INSTALL_DIR."
    exit 0
  fi
fi

OS="$(uname | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

# Translate arch names
if [[ "$ARCH" == "x86_64" ]]; then ARCH="amd64"; fi
if [[ "$ARCH" == "arm64" || "$ARCH" == "aarch64" ]]; then ARCH="arm64"; fi

URL="https://github.com/we-dcode/dcli/releases/download/$VERSION/dcli_${VERSION}_${OS}_${ARCH}.tar.gz"

echo "📦 Downloading dcli $VERSION for $OS/$ARCH..."
mkdir -p ${INSTALL_DIR}
curl -sL "$URL" | tar -xz -C ${INSTALL_DIR}

chmod +x ${INSTALL_DIR}/dcli

echo "✅ Installed to ${INSTALL_DIR}/dcli"
echo "👉 Add to PATH: export PATH=\"\$HOME/.dcode:\$PATH\""
