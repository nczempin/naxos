#!/usr/bin/env bash
set -euo pipefail

# Install required packages
sudo apt-get update
sudo apt-get install -y g++ make cppcheck

# Verify installations
for cmd in g++ make cppcheck; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "$cmd was not installed successfully" >&2
        exit 1
    fi
    "$cmd" --version | head -n 1
done

echo "All packages installed successfully."
