#!/bin/bash
# FFmpeg Build Script - Standard Build

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
FFMPEG_DIR="$PROJECT_DIR/ffmpeg"

cd "$FFMPEG_DIR"

echo "=== FFmpeg Standard Build ==="
echo "Directory: $FFMPEG_DIR"
echo ""

# Configure
echo "[1/3] Configuring..."
./configure \
  --prefix=/usr/local \
  --enable-gpl \
  --enable-version3 \
  --enable-nonfree \
  --enable-libx264 \
  --enable-libx265 \
  --enable-libvpx \
  --enable-libopus \
  --enable-openssl \
  --enable-demuxer=dash \
  --enable-protocol=http \
  --enable-protocol=https \
  --enable-protocol=hls

# Build
echo ""
echo "[2/3] Building..."
make -j$(sysctl -n hw.ncpu)

# Verify
echo ""
echo "[3/3] Verifying..."
./ffmpeg -version

echo ""
echo "=== Build Complete ==="
