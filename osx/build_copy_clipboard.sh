#!/usr/bin/env bash
set -euo pipefail
# Absolute path to the folder this script lives in
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

BIN_DIR="$SCRIPT_DIR/../build/bin"
SRC="$SCRIPT_DIR/copyFileToClipboard.swift"

mkdir -p "$BIN_DIR"

echo "Building copyFileToClipboard..."
swiftc -O -o "$BIN_DIR/copyFileToClipboard" "$SRC"