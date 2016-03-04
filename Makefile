CC=gcc
CFLAGS=-I.

default: link
link: compile assemble 
	i686-elf-gcc -T linker.ld -o myos.bin -ffreestanding -O2 -nostdlib boot.o \
kernel.o -lgcc
compile:
	i686-elf-gcc -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall \
-Wextra
assemble:
	i686-elf-as boot.s -o boot.o
