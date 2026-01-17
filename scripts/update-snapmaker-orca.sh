#!/usr/bin/env bash
# Update Snapmaker OrcaSlicer to the latest version
# Usage: ./scripts/update-snapmaker-orca.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
NIX_FILE="$REPO_DIR/modules/core/snapmaker-orca.nix"

echo "🔍 Checking for latest Snapmaker OrcaSlicer version..."

# Get latest release info from GitHub API
LATEST_RELEASE=$(curl -s https://api.github.com/repos/Snapmaker/OrcaSlicer/releases/latest)
LATEST_VERSION=$(echo "$LATEST_RELEASE" | grep -oP '"tag_name": "v\K[^"]+')

if [ -z "$LATEST_VERSION" ]; then
    echo "❌ Failed to fetch latest version from GitHub"
    exit 1
fi

# Get current version from nix file
CURRENT_VERSION=$(grep 'version = "' "$NIX_FILE" | head -1 | sed 's/.*version = "\([^"]*\)".*/\1/')

echo "📦 Current version: $CURRENT_VERSION"
echo "🆕 Latest version:  $LATEST_VERSION"

if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ]; then
    echo "✅ Already on the latest version!"
    exit 0
fi

echo ""
echo "📥 Downloading new version to calculate hash..."

# Construct AppImage URL
APPIMAGE_URL="https://github.com/Snapmaker/OrcaSlicer/releases/download/v${LATEST_VERSION}/Snapmaker_Orca_Linux_AppImage_Ubuntu2404_V${LATEST_VERSION}_Beta.AppImage"

# Check if URL exists
if ! curl -sfI "$APPIMAGE_URL" > /dev/null 2>&1; then
    echo "⚠️  Standard URL not found, trying alternative naming..."
    # Try without _Beta suffix
    APPIMAGE_URL="https://github.com/Snapmaker/OrcaSlicer/releases/download/v${LATEST_VERSION}/Snapmaker_Orca_Linux_AppImage_Ubuntu2404_V${LATEST_VERSION}.AppImage"
    if ! curl -sfI "$APPIMAGE_URL" > /dev/null 2>&1; then
        echo "❌ Could not find AppImage download URL"
        echo "   Please check: https://github.com/Snapmaker/OrcaSlicer/releases"
        exit 1
    fi
fi

# Calculate new hash
NEW_HASH=$(nix-prefetch-url "$APPIMAGE_URL" 2>/dev/null | tail -1)

if [ -z "$NEW_HASH" ]; then
    echo "❌ Failed to calculate hash"
    exit 1
fi

echo "🔐 New hash: $NEW_HASH"
echo ""
echo "📝 Updating $NIX_FILE..."

# Update version
sed -i "s/version = \"$CURRENT_VERSION\"/version = \"$LATEST_VERSION\"/" "$NIX_FILE"

# Update hash
OLD_HASH=$(grep 'sha256 = "' "$NIX_FILE" | head -1 | sed 's/.*sha256 = "\([^"]*\)".*/\1/')
sed -i "s|sha256 = \"$OLD_HASH\"|sha256 = \"$NEW_HASH\"|" "$NIX_FILE"

# Update URL pattern if needed (handle Beta vs non-Beta)
if [[ "$APPIMAGE_URL" == *"_Beta"* ]]; then
    sed -i 's|V${version}.AppImage|V${version}_Beta.AppImage|' "$NIX_FILE"
else
    sed -i 's|V${version}_Beta.AppImage|V${version}.AppImage|' "$NIX_FILE"
fi

echo ""
echo "✅ Updated Snapmaker OrcaSlicer from $CURRENT_VERSION to $LATEST_VERSION"
echo ""
echo "Next steps:"
echo "  1. dcli rebuild     # Apply changes"
echo "  2. dcli commit \"Update Snapmaker OrcaSlicer to $LATEST_VERSION\""
echo "  3. dcli push"
