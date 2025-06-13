#!/usr/bin/env bash
set -euo pipefail

# Install required packages
sudo apt-get update
sudo apt-get install -y g++ make cppcheck git-lfs qemu-system-i386

# Fetch cross compiler if not present
if [ ! -x vendor/cross/bin/i686-elf-gcc ]; then
    git lfs install --skip-repo
    git lfs pull || true
    export PATH="$PWD/vendor/cross/bin:$PATH"
    if [ ! -x vendor/cross/bin/i686-elf-gcc ]; then
        chmod +x vendor/build_cross_compiler.sh
        vendor/build_cross_compiler.sh
    fi
fi

# Ensure cross compiler is in PATH
export PATH="$PWD/vendor/cross/bin:$PATH"

# Verify installations
for cmd in g++ make cppcheck git-lfs qemu-system-i386 i686-elf-gcc; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "$cmd was not installed successfully" >&2
        exit 1
    fi
    "$cmd" --version | head -n 1
done

echo "All packages installed successfully."

# Print cross compiler path
command -v i686-elf-gcc
