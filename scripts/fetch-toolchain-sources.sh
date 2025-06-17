#!/usr/bin/env bash
set -euo pipefail

# This script fetches specific commits of toolchain sources
# Using git's sparse checkout to avoid downloading full history

BINUTILS_REPO="https://github.com/bminor/binutils-gdb.git"
BINUTILS_TAG="binutils-2_40"

GCC_REPO="https://github.com/gcc-mirror/gcc.git"
GCC_TAG="releases/gcc-12.2.0"

echo "Fetching toolchain sources..."
mkdir -p vendor/sources
cd vendor/sources

# Fetch binutils at specific tag
if [[ ! -d "binutils-gdb" ]]; then
    echo "Fetching binutils ${BINUTILS_TAG}..."
    git clone --depth 1 --branch "${BINUTILS_TAG}" "${BINUTILS_REPO}" binutils-gdb
fi

# Fetch GCC at specific tag
if [[ ! -d "gcc" ]]; then
    echo "Fetching GCC ${GCC_TAG}..."
    git clone --depth 1 --branch "${GCC_TAG}" "${GCC_REPO}" gcc
fi

echo "✅ Toolchain sources ready"