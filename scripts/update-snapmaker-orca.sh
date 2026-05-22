#!/usr/bin/env bash
# Update Snapmaker OrcaSlicer to the latest release that ships a Linux AppImage
# Usage: ./scripts/update-snapmaker-orca.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
NIX_FILE="$REPO_DIR/modules/core/snapmaker-orca.nix"

echo "🔍 Searching for latest Snapmaker OrcaSlicer release with Linux AppImage..."

# Walk the most recent releases and pick the newest one that has a Linux AppImage
# (upstream stopped shipping AppImages in some releases — flatpak/zip only)
RELEASES=$(curl -s "https://api.github.com/repos/Snapmaker/OrcaSlicer/releases?per_page=20")

FOUND=$(echo "$RELEASES" | jq -r '
    [ .[]
      | select(.assets | any(.name | test("Linux.*AppImage$"; "i")))
      | { version: (.tag_name | ltrimstr("v")),
          url:     (.assets[] | select(.name | test("Linux.*AppImage$"; "i")) | .browser_download_url),
          filename:(.assets[] | select(.name | test("Linux.*AppImage$"; "i")) | .name) }
    ] | first // empty
')

if [ -z "$FOUND" ]; then
    echo "❌ No release with a Linux AppImage found in the last 20 releases"
    echo "   Please check: https://github.com/Snapmaker/OrcaSlicer/releases"
    exit 1
fi

LATEST_VERSION=$(echo "$FOUND" | jq -r '.version')
APPIMAGE_URL=$(echo "$FOUND" | jq -r '.url')
APPIMAGE_FILENAME=$(echo "$FOUND" | jq -r '.filename')

# Get current version from nix file
CURRENT_VERSION=$(grep 'version = "' "$NIX_FILE" | head -1 | sed 's/.*version = "\([^"]*\)".*/\1/')

echo "📦 Current version:        $CURRENT_VERSION"
echo "🆕 Latest with AppImage:   $LATEST_VERSION"
echo "   $APPIMAGE_URL"

if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ]; then
    echo "✅ Already on the latest AppImage release!"
    exit 0
fi

echo ""
echo "📥 Calculating hash..."

NEW_HASH=$(nix-prefetch-url "$APPIMAGE_URL" 2>/dev/null | tail -1)

if [ -z "$NEW_HASH" ]; then
    echo "❌ Failed to calculate hash"
    exit 1
fi

echo "🔐 New hash: $NEW_HASH"
echo ""
echo "📝 Updating $NIX_FILE..."

# Build templated filename so the nix file keeps using ${version}
# shellcheck disable=SC2016  # literal ${version} is intentional — written into the .nix file
VERSION_PLACEHOLDER='${version}'
TEMPLATED_FILENAME="${APPIMAGE_FILENAME//$LATEST_VERSION/$VERSION_PLACEHOLDER}"

# Update version
sed -i "s|version = \"$CURRENT_VERSION\"|version = \"$LATEST_VERSION\"|" "$NIX_FILE"

# Update hash
OLD_HASH=$(grep 'sha256 = "' "$NIX_FILE" | head -1 | sed 's/.*sha256 = "\([^"]*\)".*/\1/')
sed -i "s|sha256 = \"$OLD_HASH\"|sha256 = \"$NEW_HASH\"|" "$NIX_FILE"

# Replace the AppImage filename portion of the URL (last path segment)
sed -i "s|/Snapmaker_Orca[^\"]*\.AppImage|/$TEMPLATED_FILENAME|" "$NIX_FILE"

echo ""
echo "✅ Updated Snapmaker OrcaSlicer from $CURRENT_VERSION to $LATEST_VERSION"
echo ""
echo "Next steps:"
echo "  1. dcli rebuild     # Apply changes"
echo "  2. dcli commit \"Update Snapmaker OrcaSlicer to $LATEST_VERSION\""
echo "  3. dcli push"
