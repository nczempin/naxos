#!/usr/bin/env bash
set -euo pipefail

echo "Setting up naxos kernel development environment..."

# Detect OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
else
    echo "Unsupported OS: $OSTYPE" >&2
    exit 1
fi

# Install required packages
echo "Installing system dependencies..."
if [[ "$OS" == "linux" ]]; then
    sudo apt-get update
    sudo apt-get install -y \
        build-essential \
        bison \
        flex \
        libgmp3-dev \
        libmpc-dev \
        libmpfr-dev \
        texinfo \
        libisl-dev \
        wget \
        qemu-system-x86 \
        grub-common \
        grub-pc-bin \
        xorriso \
        gcc-i686-linux-gnu \
        binutils-i686-linux-gnu
elif [[ "$OS" == "macos" ]]; then
    if ! command -v brew >/dev/null 2>&1; then
        echo "Homebrew is required on macOS. Please install it first." >&2
        exit 1
    fi
    brew install gmp libmpc mpfr isl-gmp qemu grub xorriso wget
fi

echo "✅ System dependencies installed"

# Build cross-compiler
echo "Building cross-compiler toolchain..."
./scripts/build-cross-compiler.sh

# Verify installation
echo "Verifying installation..."
if [[ -f "vendor/cross/bin/i686-elf-gcc" ]]; then
    echo "✅ Cross-compiler available"
    vendor/cross/bin/i686-elf-gcc --version | head -n 1
else
    echo "❌ Cross-compiler not found" >&2
    exit 1
fi

for cmd in qemu-system-i386 grub-mkrescue; do
    if command -v "$cmd" >/dev/null 2>&1; then
        echo "✅ $cmd available"
    else
        echo "❌ $cmd not found" >&2
        exit 1
    fi
done

echo ""
echo "🎉 Setup complete! You can now build the kernel with:"
echo "   make clean && make"
echo "   make run"