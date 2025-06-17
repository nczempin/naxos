#!/bin/sh
# Use pc-i440fx-3.1 machine type to avoid PVH ELF Note requirement
qemu-system-i386 -machine pc-i440fx-3.1 -cpu pentium3 --serial file:serial.log -kernel naxos.bin
