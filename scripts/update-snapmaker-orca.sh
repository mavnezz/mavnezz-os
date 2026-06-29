#!/usr/bin/env bash
# Update Snapmaker OrcaSlicer to the latest release that ships a Linux AppImage
# Usage: ./scripts/update-snapmaker-orca.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
NIX_FILE="$REPO_DIR/modules/mavnezz/printers3d.nix"
BLOCK_START='snapmaker-orca = mkSlicer {'
BLOCK_END='^  };'

echo "🔍 Searching for latest Snapmaker OrcaSlicer release with Linux AppImage..."

RELEASES=$(curl -s "https://api.github.com/repos/Snapmaker/OrcaSlicer/releases?per_page=20")

FOUND=$(echo "$RELEASES" | jq -r '
    [ .[]
      | select(.assets | any(.name | test("Linux.*AppImage$"; "i")))
      | { version: (.tag_name | ltrimstr("v")),
          url:     (.assets[] | select(.name | test("Linux.*AppImage$"; "i")) | .browser_download_url) }
    ] | first // empty
')

if [ -z "$FOUND" ]; then
    echo "❌ No release with a Linux AppImage found in the last 20 releases"
    exit 1
fi

LATEST_VERSION=$(echo "$FOUND" | jq -r '.version')
APPIMAGE_URL=$(echo "$FOUND" | jq -r '.url')

# Extract current version from the snapmaker-orca block only
CURRENT_VERSION=$(awk "/$BLOCK_START/,/$BLOCK_END/" "$NIX_FILE" \
    | grep 'version = "' | head -1 | sed 's/.*version = "\([^"]*\)".*/\1/')

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

OLD_HASH=$(awk "/$BLOCK_START/,/$BLOCK_END/" "$NIX_FILE" \
    | grep 'sha256 = "' | head -1 | sed 's/.*sha256 = "\([^"]*\)".*/\1/')
OLD_URL=$(awk "/$BLOCK_START/,/$BLOCK_END/" "$NIX_FILE" \
    | grep 'url = "' | head -1 | sed 's/.*url = "\([^"]*\)".*/\1/')

echo "🔐 New hash: $NEW_HASH"
echo ""
echo "📝 Updating $NIX_FILE..."

# Range-addressed sed: only touch lines inside the snapmaker-orca block
sed -i "/$BLOCK_START/,/$BLOCK_END/ {
  s|version = \"$CURRENT_VERSION\"|version = \"$LATEST_VERSION\"|
  s|sha256 = \"$OLD_HASH\"|sha256 = \"$NEW_HASH\"|
  s|url = \"$OLD_URL\"|url = \"$APPIMAGE_URL\"|
}" "$NIX_FILE"

echo ""
echo "✅ Updated Snapmaker OrcaSlicer from $CURRENT_VERSION to $LATEST_VERSION"
echo ""
echo "Next steps:"
echo "  1. dcli rebuild"
echo "  2. dcli commit \"Update Snapmaker OrcaSlicer to $LATEST_VERSION\""
echo "  3. dcli push"
