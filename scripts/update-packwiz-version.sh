#!/usr/bin/env bash
set -euo pipefail

# Script to update the version field in Packwiz pack.toml files
# and modpackVersion in bcc-common.toml configs.
# Also refreshes the Packwiz indexes.
# Usage: ./update-packwiz-version.sh v1.2.3

VERSION="${1:-}"

if [ -z "$VERSION" ]; then
  echo "❌ Error: You must provide a version argument. Example:"
  echo "   ./update-packwiz-version.sh v1.2.3"
  exit 1
fi

echo "✨ Updating Packwiz version to $VERSION..."

update_pack() {
  local file="$1"
  if [ -f "$file" ]; then
    sed -i "s/^version = \".*\"/version = \"$VERSION\"/" "$file"
    echo "✅ Updated version in $file"
  else
    echo "⚠️ Warning: $file not found"
  fi
}

update_bcc() {
  local file="$1"
  if [ -f "$file" ]; then
    sed -i "s/modpackVersion = \".*\"/modpackVersion = \"$VERSION\"/" "$file"
    echo "✅ Updated modpackVersion in $file"
  else
    echo "⚠️ Warning: $file not found"
  fi
}

# --- Packwiz pack.toml ---
update_pack "packwiz/modrinth/pack.toml"
update_pack "packwiz/curseforge/pack.toml"

# --- bcc-common.toml ---
update_bcc "packwiz/curseforge/config/bcc-common.toml"
update_bcc "packwiz/modrinth/config/bcc-common.toml"

echo "🎉 All version fields updated."

# --- Refresh Packwiz indexes ---
if ! command -v packwiz &> /dev/null; then
  echo "❌ Packwiz executable not found in PATH. Please install it first."
  exit 1
fi

echo "🔄 Refreshing Packwiz index for CurseForge..."
pushd packwiz/curseforge
packwiz refresh
popd

echo "🔄 Refreshing Packwiz index for Modrinth..."
pushd packwiz/modrinth
packwiz refresh
popd

echo "🎉 All version fields updated and Packwiz indexes refreshed."
