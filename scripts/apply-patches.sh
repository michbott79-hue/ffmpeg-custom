#!/bin/bash
# Apply all pending patches

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
FFMPEG_DIR="$PROJECT_DIR/ffmpeg"
PATCHES_DIR="$PROJECT_DIR/patches"

cd "$FFMPEG_DIR"

echo "=== Applying Pending Patches ==="
echo ""

PENDING_DIR="$PATCHES_DIR/pending"
APPLIED_DIR="$PATCHES_DIR/applied"
FAILED_DIR="$PATCHES_DIR/failed"

if [ ! -d "$PENDING_DIR" ] || [ -z "$(ls -A "$PENDING_DIR" 2>/dev/null)" ]; then
    echo "No pending patches found."
    exit 0
fi

for patch in "$PENDING_DIR"/*.patch; do
    [ -e "$patch" ] || continue

    PATCH_NAME=$(basename "$patch")
    echo "Applying: $PATCH_NAME"

    # Test first
    if git apply --check "$patch" 2>/dev/null; then
        git apply "$patch"
        mv "$patch" "$APPLIED_DIR/"
        echo "  ✓ Applied successfully"
    else
        mv "$patch" "$FAILED_DIR/"
        echo "  ✗ Failed - moved to failed/"
    fi
    echo ""
done

echo "=== Done ==="
