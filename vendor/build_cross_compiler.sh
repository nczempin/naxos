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

mkdir -p "$SCRIPT_DIR/src"
cd "$SCRIPT_DIR/src"

wget https://ftp.gnu.org/gnu/binutils/binutils-$BINUTILS_VERSION.tar.gz
if [ -d binutils-$BINUTILS_VERSION ]; then
  rm -rf binutils-$BINUTILS_VERSION
fi
tar -xvzf binutils-$BINUTILS_VERSION.tar.gz
mkdir build-binutils
cd build-binutils
../binutils-$BINUTILS_VERSION/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make -j$(nproc)
make install

cd "$SCRIPT_DIR/src"
wget https://ftp.gnu.org/gnu/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.gz
if [ -d gcc-$GCC_VERSION ]; then
  rm -rf gcc-$GCC_VERSION
fi
tar -xvzf gcc-$GCC_VERSION.tar.gz
cd gcc-$GCC_VERSION
./contrib/download_prerequisites
mkdir ../build-gcc
cd ../build-gcc
../gcc-$GCC_VERSION/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c --without-headers
make -j$(nproc) all-gcc
make -j$(nproc) all-target-libgcc
make install-gcc
make install-target-libgcc

