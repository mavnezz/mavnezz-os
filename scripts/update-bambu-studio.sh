#!/usr/bin/env bash
# Update Bambu Studio to the latest version
# Usage: ./scripts/update-bambu-studio.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
NIX_FILE="$REPO_DIR/modules/mavnezz/printers3d.nix"
BLOCK_START='bambu-studio = mkSlicer {'
BLOCK_END='^  };'

echo "🔍 Checking for latest Bambu Studio version..."

LATEST_RELEASE=$(curl -s https://api.github.com/repos/bambulab/BambuStudio/releases/latest)
LATEST_VERSION=$(echo "$LATEST_RELEASE" | grep -oP '"name": "\K[0-9]+\.[0-9]+\.[0-9]+' | head -1)

if [ -z "$LATEST_VERSION" ]; then
    echo "❌ Failed to fetch latest version from GitHub"
    exit 1
fi

CURRENT_VERSION=$(awk "/$BLOCK_START/,/$BLOCK_END/" "$NIX_FILE" \
    | grep 'version = "' | head -1 | sed 's/.*version = "\([^"]*\)".*/\1/')

echo "📦 Current version: $CURRENT_VERSION"
echo "🆕 Latest version:  $LATEST_VERSION"

if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ]; then
    echo "✅ Already on the latest version!"
    exit 0
fi

echo ""
echo "📥 Finding AppImage URL..."

APPIMAGE_URL=$(echo "$LATEST_RELEASE" | grep -oP '"browser_download_url": "\K[^"]*ubuntu-24\.04[^"]*\.AppImage')
if [ -z "$APPIMAGE_URL" ]; then
    APPIMAGE_URL=$(echo "$LATEST_RELEASE" | grep -oP '"browser_download_url": "\K[^"]*ubuntu[^"]*\.AppImage' | head -1)
fi

if [ -z "$APPIMAGE_URL" ]; then
    echo "❌ Could not find AppImage download URL"
    exit 1
fi

echo "📥 Downloading from: $APPIMAGE_URL"

NEW_HASH=$(nix-prefetch-url "$APPIMAGE_URL" 2>/dev/null | tail -1)

if [ -z "$NEW_HASH" ]; then
    echo "❌ Failed to calculate hash"
    exit 1
fi

OLD_HASH=$(awk "/$BLOCK_START/,/$BLOCK_END/" "$NIX_FILE" \
    | grep 'sha256 = "' | head -1 | sed 's/.*sha256 = "\([^"]*\)".*/\1/')
OLD_URL=$(awk "/$BLOCK_START/,/$BLOCK_END/" "$NIX_FILE" \
    | grep 'url = "' | head -1 | sed 's/.*url = "\([^"]*\)".*/\1/')

echo "🔐 New hash: $NEW_HASH"
echo ""
echo "📝 Updating $NIX_FILE..."

sed -i "/$BLOCK_START/,/$BLOCK_END/ {
  s|version = \"$CURRENT_VERSION\"|version = \"$LATEST_VERSION\"|
  s|sha256 = \"$OLD_HASH\"|sha256 = \"$NEW_HASH\"|
  s|url = \"$OLD_URL\"|url = \"$APPIMAGE_URL\"|
}" "$NIX_FILE"

echo ""
echo "✅ Updated Bambu Studio from $CURRENT_VERSION to $LATEST_VERSION"
echo ""
echo "Next steps:"
echo "  1. dcli rebuild"
echo "  2. dcli commit \"Update Bambu Studio to $LATEST_VERSION\""
echo "  3. dcli push"
