#!/usr/bin/env bash
set -euo pipefail

DOWNLOAD_BASE_URL=https://github.com/one2onex/toolchain/releases/download/v1.0.0

if [ "$(uname -s)" != "Linux" ]; then
  echo "[ ❌ ] musl toolchain can be installed on Linux ONLY"
  exit 1
fi

if [ $# -ne 1 ]; then
  echo "Usage: $0 {x86_64|aarch64|armv7l}"
  exit 1
fi

case $1 in
x86_64|aarch64|armv7l)
  TOOLCHAIN="musl-$1"
  if [ ! -f "$TOOLCHAIN.tar.gz" ]; then
    echo "[ 📥 ] Downloading $TOOLCHAIN.tar.gz..."
    wget "${DOWNLOAD_BASE_URL}/${TOOLCHAIN}.tar.gz"
  fi

  echo "[ 📦 ] Extracting $TOOLCHAIN.tar.gz ..."
  tar -xf "$TOOLCHAIN".tar.gz

  echo "[ 📁 ] Installing to /opt/buildroot/..."
  mkdir -p /opt/buildroot/
  mv "$TOOLCHAIN" /opt/buildroot/

  echo "[ 🔧 ] Relocating SDK..."
  cd /opt/buildroot/"$TOOLCHAIN"
  ./relocate-sdk.sh
  ;;
*)
 echo "[ ❌ ] Supported architectures: x86_64, aarch64, armv7l"
 exit 1
 ;;
esac