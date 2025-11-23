#!/usr/bin/env bash
set -euo pipefail

echo "✨ Building Packwiz artifacts (without version bump)..."

BUILD_DIR="build"
CURSEFORGE_DIR="packwiz/curseforge"
MODRINTH_DIR="packwiz/modrinth"

mkdir -p "${BUILD_DIR}/curseforge" "${BUILD_DIR}/modrinth"

# --- Check Packwiz executable ---
if ! command -v packwiz &> /dev/null; then
    echo "❌ Packwiz not found in PATH. Please install it first."
    exit 1
fi

echo "🚀 Exporting CurseForge server pack..."
pushd "${CURSEFORGE_DIR}" > /dev/null
packwiz curseforge export --side server --output "../../${BUILD_DIR}/curseforge/MouCraft-curseforge-server.zip"
popd > /dev/null

echo "🚀 Exporting CurseForge client pack..."
pushd "${CURSEFORGE_DIR}" > /dev/null
packwiz curseforge export --side client --output "../../${BUILD_DIR}/curseforge/MouCraft-curseforge-client.zip"
popd > /dev/null

echo "🚀 Exporting Modrinth pack..."
pushd "${MODRINTH_DIR}" > /dev/null
packwiz modrinth export --output "../../${BUILD_DIR}/modrinth/MouCraft-modrinth.mrpack"
popd > /dev/null

echo "✅ Packwiz build done"
