#!/bin/sh
qemu-system-i386 -cpu pentium3 --serial file:serial.log -kernel naxos.bin
