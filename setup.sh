#!/usr/bin/env bash
set -euo pipefail

# Install required packages
sudo apt-get update
sudo apt-get install -y build-essential bison flex libgmp-dev libmpc-dev libmpfr-dev texinfo wget libisl-dev g++ make cppcheck

echo "Removing existing toolchain source directory..."
rm -rf vendor/toolchain_src
echo "Creating toolchain source directory..."
mkdir -p vendor/toolchain_src

# Workaround for submodule issues: cloning directly
echo "Cloning GCC 14.1.0..."
git clone --depth 1 --branch releases/gcc-14.1.0 https://github.com/gcc-mirror/gcc vendor/toolchain_src/gcc
echo "Cloning Binutils 2.44..."
git clone --depth 1 --branch binutils-2_44 https://github.com/bminor/binutils-gdb vendor/toolchain_src/binutils
echo "Toolchain sources cloned successfully."

# Verify installations
for cmd in g++ make cppcheck; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "$cmd was not installed successfully" >&2
        exit 1
    fi
    "$cmd" --version | head -n 1
done

echo "All packages installed successfully."
