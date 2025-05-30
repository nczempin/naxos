#!/usr/bin/env bash
set -euo pipefail

# Install required packages
sudo apt-get update
sudo apt-get install -y \
    g++ make cppcheck \
    build-essential bison flex libgmp-dev \
    libmpc-dev libmpfr-dev texinfo wget libisl-dev

# Verify installations
for cmd in g++ make cppcheck bison flex wget; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "$cmd was not installed successfully" >&2
        exit 1
    fi
    "$cmd" --version | head -n 1
done

echo "All packages installed successfully."

# Prepare toolchain sources. These clones are placeholders for proper git
# submodule commands, necessary due to current tool limitations.
mkdir -p vendor/toolchain_src
rm -rf vendor/toolchain_src/gcc vendor/toolchain_src/binutils-gdb
git clone --depth 1 --branch releases/gcc-14.1.0 \
    https://github.com/gcc-mirror/gcc vendor/toolchain_src/gcc
git clone --depth 1 --branch binutils-2_44 \
    https://github.com/bminor/binutils-gdb vendor/toolchain_src/binutils-gdb
