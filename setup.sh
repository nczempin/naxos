#!/usr/bin/env bash
set -euo pipefail

# Install required packages
sudo apt-get update
sudo apt-get install -y \
    g++ \
    make \
    cppcheck \
    build-essential \
    gcc-i686-linux-gnu \
    binutils-i686-linux-gnu \
    qemu-system-x86

# Verify installations
for cmd in g++ make cppcheck i686-linux-gnu-gcc qemu-system-i386; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "$cmd was not installed successfully" >&2
        exit 1
    fi
    "$cmd" --version | head -n 1
done

echo "All packages installed successfully."
