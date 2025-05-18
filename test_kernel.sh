#!/usr/bin/env bash
set -euxo pipefail

make clean
make

rm -f serial.log
# Boot kernel in QEMU and send ESC to exit the keyboard loop
# Use timeout to ensure the test finishes if the kernel hangs
if command -v qemu-system-i386 >/dev/null; then
  timeout 10s qemu-system-i386 -display none -serial file:serial.log \
    -no-reboot -no-shutdown -kernel naxos.bin -sendkey esc || true
  grep -q "Hello, kernel World!" serial.log
else
  echo "qemu-system-i386 not installed" >&2
  exit 1
fi
