CC=gcc
CFLAGS=-I.

default: link
link: compile assemble 
	i686-elf-gcc -T linker.ld -o naxos.bin -ffreestanding -O2 -nostdlib boot.o \
kernel.o terminal.o vga.o -lgcc
compile:
	i686-elf-gcc -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall \
-Wextra
	i686-elf-gcc -c terminal.c -o terminal.o -std=gnu99 -ffreestanding -O2 \
-Wextra 
	i686-elf-gcc -c vga.c -o vga.o -std=gnu99 -ffreestanding -O2 -Wextra
assemble:
	i686-elf-as boot.s -o boot.o
