#!/usr/bin/env bash
set -euo pipefail

echo "Building i686-elf cross-compiler toolchain..."

# Configuration
BINUTILS_VERSION="2.40"
GCC_VERSION="12.2.0"
TARGET="i686-elf"
PREFIX="$PWD/vendor/cross"
JOBS=$(nproc 2>/dev/null || echo 4)

# Add cross-compiler to PATH for this session
export PATH="$PREFIX/bin:$PATH"

# Create vendor directory
mkdir -p vendor
cd vendor

# Check if already built
if [[ -f "$PREFIX/bin/$TARGET-gcc" && -f "$PREFIX/bin/$TARGET-as" ]]; then
    echo "✅ Cross-compiler already exists at $PREFIX/bin/$TARGET-gcc"
    "$PREFIX/bin/$TARGET-gcc" --version | head -n 1
    cd ..
    exit 0
fi

echo "📦 Preparing source packages..."

# Option 1: Use git sources if available
if [[ -d "sources/binutils-gdb" && -d "sources/gcc" ]]; then
    echo "Using git sources..."
    BINUTILS_SRC="sources/binutils-gdb"
    GCC_SRC="sources/gcc"
# Option 2: Download tarballs as fallback
else
    # Download binutils
    if [[ ! -f "binutils-$BINUTILS_VERSION.tar.xz" ]]; then
        echo "Downloading binutils $BINUTILS_VERSION..."
        wget -q --show-progress "https://ftp.gnu.org/gnu/binutils/binutils-$BINUTILS_VERSION.tar.xz"
    fi

    # Download GCC
    if [[ ! -f "gcc-$GCC_VERSION.tar.xz" ]]; then
        echo "Downloading GCC $GCC_VERSION..."
        wget -q --show-progress "https://ftp.gnu.org/gnu/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.xz"
    fi

    echo "📦 Extracting source packages..."

    # Extract binutils
    if [[ ! -d "binutils-$BINUTILS_VERSION" ]]; then
        echo "Extracting binutils..."
        tar -xf "binutils-$BINUTILS_VERSION.tar.xz"
    fi

    # Extract GCC
    if [[ ! -d "gcc-$GCC_VERSION" ]]; then
        echo "Extracting GCC..."
        tar -xf "gcc-$GCC_VERSION.tar.xz"
    fi
    
    BINUTILS_SRC="binutils-$BINUTILS_VERSION"
    GCC_SRC="gcc-$GCC_VERSION"
fi

echo "🔨 Building binutils $BINUTILS_VERSION..."
if [[ ! -f "$PREFIX/bin/$TARGET-as" ]]; then
    rm -rf build-binutils
    mkdir build-binutils
    cd build-binutils
    
    ../$BINUTILS_SRC/configure \
        --target=$TARGET \
        --prefix="$PREFIX" \
        --with-sysroot \
        --disable-nls \
        --disable-werror
    
    make -j$JOBS
    make install
    cd ..
    echo "✅ binutils installed"
else
    echo "✅ binutils already installed"
fi

echo "🔨 Building GCC $GCC_VERSION..."
if [[ ! -f "$PREFIX/bin/$TARGET-gcc" ]]; then
    rm -rf build-gcc
    mkdir build-gcc
    cd build-gcc
    
    ../$GCC_SRC/configure \
        --target=$TARGET \
        --prefix="$PREFIX" \
        --disable-nls \
        --enable-languages=c,c++ \
        --without-headers
    
    make -j$JOBS all-gcc
    make -j$JOBS all-target-libgcc
    make install-gcc
    make install-target-libgcc
    cd ..
    echo "✅ GCC installed"
else
    echo "✅ GCC already installed"
fi

cd ..

echo "🎉 Cross-compiler toolchain built successfully!"
echo "   Location: $PREFIX/bin/$TARGET-gcc"
"$PREFIX/bin/$TARGET-gcc" --version | head -n 1