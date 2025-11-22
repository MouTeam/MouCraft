#!/usr/bin/env bash
set -euo pipefail

# Script to update the version field in Packwiz pack.toml files
# Usage: ./update-packwiz-version.sh 1.2.3

VERSION="${1:-}"

if [ -z "$VERSION" ]; then
  echo "❌ Error: You must provide a version argument. Example:"
  echo "   ./update-packwiz-version.sh 1.2.3"
  exit 1
fi

echo "✨ Updating Packwiz version to $VERSION..."

update_pack() {
  local file="$1"
  if [ -f "$file" ]; then
    sed -i "s/^version = \".*\"/version = \"$VERSION\"/" "$file"
    echo "✅ Updated $file"
  else
    echo "⚠️ Warning: $file not found"
  fi
}

update_pack "packwiz/modrinth/pack.toml"
update_pack "packwiz/curseforge/pack.toml"

echo "🎉 All packwiz version fields updated."
