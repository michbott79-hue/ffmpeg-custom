#!/bin/bash
# FFmpeg Build Script - Debug Build

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
FFMPEG_DIR="$PROJECT_DIR/ffmpeg"

cd "$FFMPEG_DIR"

echo "=== FFmpeg Debug Build ==="
echo "Directory: $FFMPEG_DIR"
echo ""

# Configure with debug flags
echo "[1/3] Configuring (debug)..."
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
  --enable-protocol=hls \
  --enable-debug=3 \
  --disable-optimizations \
  --disable-stripping \
  --extra-cflags="-g -O0"

# Build
echo ""
echo "[2/3] Building..."
make -j$(sysctl -n hw.ncpu)

# Verify
echo ""
echo "[3/3] Verifying..."
./ffmpeg -version

echo ""
echo "=== Debug Build Complete ==="
