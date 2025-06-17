#!/bin/sh
# Use pc-i440fx-3.1 machine type to avoid PVH ELF Note requirement
echo "Starting naxos kernel in QEMU..."
echo "- Type characters to see them echoed"
echo "- Press ESC to exit and see demo text"
echo "- Close QEMU window or press Ctrl+C to stop"
echo
qemu-system-i386 -machine pc-i440fx-3.1 -cpu pentium3 --serial file:serial.log -kernel naxos.bin
