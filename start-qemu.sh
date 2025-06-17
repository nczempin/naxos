#!/bin/sh
# Use older machine type for compatibility with multiboot kernels
qemu-system-i386 -machine pc-i440fx-2.12 -cpu pentium3 --serial file:serial.log -kernel naxos.bin
