#!/usr/bin/env bash
set -euo pipefail

BINUTILS_VERSION="${BINUTILS_VERSION:-2.44}"
GCC_VERSION="${GCC_VERSION:-14.1.0}"
TARGET="${TARGET:-i686-elf}"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PREFIX="${PREFIX:-$SCRIPT_DIR/cross}"
PATH="$PREFIX/bin:$PATH"

if [ -x "$PREFIX/bin/${TARGET}-gcc" ]; then
  echo "Cross compiler already built at $PREFIX"
  exit 0
fi

# Sources are expected to be in $SCRIPT_DIR/../toolchain_src/
# setup.sh should have cloned them there.

# Setup build directories
mkdir -p "$SCRIPT_DIR/src/build-binutils"
mkdir -p "$SCRIPT_DIR/src/build-gcc"

# Build Binutils
cd "$SCRIPT_DIR/src/build-binutils"
"$SCRIPT_DIR/../toolchain_src/binutils/configure" --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make -j$(nproc)
make install

# Build GCC
# First, run download_prerequisites from the GCC source directory
cd "$SCRIPT_DIR/../toolchain_src/gcc"
./contrib/download_prerequisites

# Then, configure and build GCC from its build directory
cd "$SCRIPT_DIR/src/build-gcc"
"$SCRIPT_DIR/../toolchain_src/gcc/configure" --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c --without-headers
make -j$(nproc) all-gcc
make -j$(nproc) all-target-libgcc
make install-gcc
make install-target-libgcc

