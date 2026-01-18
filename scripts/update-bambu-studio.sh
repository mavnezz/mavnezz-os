#!/usr/bin/env bash
# Update Bambu Studio to the latest version
# Usage: ./scripts/update-bambu-studio.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
NIX_FILE="$REPO_DIR/modules/core/bambu-studio.nix"

echo "🔍 Checking for latest Bambu Studio version..."

# Get latest release info from GitHub API
LATEST_RELEASE=$(curl -s https://api.github.com/repos/bambulab/BambuStudio/releases/latest)
LATEST_TAG=$(echo "$LATEST_RELEASE" | grep -oP '"tag_name": "\K[^"]+')
LATEST_VERSION=$(echo "$LATEST_RELEASE" | grep -oP '"name": "\K[0-9]+\.[0-9]+\.[0-9]+' | head -1)

if [ -z "$LATEST_VERSION" ] || [ -z "$LATEST_TAG" ]; then
    echo "❌ Failed to fetch latest version from GitHub"
    exit 1
fi

# Get current version from nix file
CURRENT_VERSION=$(grep 'version = "' "$NIX_FILE" | head -1 | sed 's/.*version = "\([^"]*\)".*/\1/')
CURRENT_TAG=$(grep 'tag = "' "$NIX_FILE" | head -1 | sed 's/.*tag = "\([^"]*\)".*/\1/')

echo "📦 Current version: $CURRENT_VERSION (tag: $CURRENT_TAG)"
echo "🆕 Latest version:  $LATEST_VERSION (tag: $LATEST_TAG)"

if [ "$CURRENT_TAG" = "$LATEST_TAG" ]; then
    echo "✅ Already on the latest version!"
    exit 0
fi

echo ""
echo "📥 Finding AppImage URL..."

# Find Ubuntu 24.04 AppImage URL from release assets
APPIMAGE_URL=$(echo "$LATEST_RELEASE" | grep -oP '"browser_download_url": "\K[^"]*ubuntu-24\.04[^"]*\.AppImage')

if [ -z "$APPIMAGE_URL" ]; then
    # Try Ubuntu 22.04 as fallback
    APPIMAGE_URL=$(echo "$LATEST_RELEASE" | grep -oP '"browser_download_url": "\K[^"]*ubuntu[^"]*\.AppImage' | head -1)
fi

if [ -z "$APPIMAGE_URL" ]; then
    echo "❌ Could not find AppImage download URL"
    echo "   Please check: https://github.com/bambulab/BambuStudio/releases"
    exit 1
fi

echo "📥 Downloading from: $APPIMAGE_URL"

# Calculate new hash
NEW_HASH=$(nix-prefetch-url "$APPIMAGE_URL" 2>/dev/null | tail -1)

if [ -z "$NEW_HASH" ]; then
    echo "❌ Failed to calculate hash"
    exit 1
fi

# Extract filename from URL for the nix file
APPIMAGE_FILENAME=$(basename "$APPIMAGE_URL")

echo "🔐 New hash: $NEW_HASH"
echo ""
echo "📝 Updating $NIX_FILE..."

# Update version
sed -i "s/version = \"$CURRENT_VERSION\"/version = \"$LATEST_VERSION\"/" "$NIX_FILE"

# Update tag
sed -i "s/tag = \"$CURRENT_TAG\"/tag = \"$LATEST_TAG\"/" "$NIX_FILE"

# Update hash
OLD_HASH=$(grep 'sha256 = "' "$NIX_FILE" | head -1 | sed 's/.*sha256 = "\([^"]*\)".*/\1/')
sed -i "s|sha256 = \"$OLD_HASH\"|sha256 = \"$NEW_HASH\"|" "$NIX_FILE"

# Update URL with new filename
OLD_FILENAME=$(grep 'url = "' "$NIX_FILE" | grep -oP '/\K[^/]+\.AppImage')
sed -i "s|$OLD_FILENAME|$APPIMAGE_FILENAME|" "$NIX_FILE"

echo ""
echo "✅ Updated Bambu Studio from $CURRENT_VERSION to $LATEST_VERSION"
echo ""
echo "Next steps:"
echo "  1. dcli rebuild     # Apply changes"
echo "  2. dcli commit \"Update Bambu Studio to $LATEST_VERSION\""
echo "  3. dcli push"
