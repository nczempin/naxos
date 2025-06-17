ifeq ($(wildcard vendor/cross/bin/i686-elf-gcc),)
CROSS_PREFIX ?= i686-linux-gnu-
else
CROSS_PREFIX ?= vendor/cross/bin/i686-elf-
endif
CC := $(CROSS_PREFIX)gcc
AS := $(CROSS_PREFIX)as
CFLAGS=-I. -fno-pie -no-pie
ASFLAGS=--noexecstack

BIN=naxos.bin
SRC=$(wildcard *.c)
GAS=$(wildcard *.s)
NASM=$(wildcard *.asm)
C_OBJ=$(SRC:.c=.o)
GAS_OBJ=$(GAS:.s=.o)
NASM_OBJ=$(NASM:.asm=.o)

OBJ=$(GAS_OBJ) $(NASM_OBJ) $(C_OBJ)


$(BIN): $(OBJ)
	$(CC) -T linker.ld -o $(BIN) -ffreestanding -O2 -nostdlib $(CFLAGS) $^ -lgcc
%.o: %.c
	$(CC) -o $@ -c $^ -std=gnu99 -ffreestanding -O2 -Wall -Wextra $(CFLAGS)
$(GAS_OBJ): $(GAS)
	$(AS) $(ASFLAGS) $^ -o $@
$(NASM_OBJ): $(NASM)
	nasm -f elf32 $^ -o $@

.PHONY : clean run
clean :
	-rm -f $(BIN) $(OBJ)
run: $(BIN)
	if [ -x ./start-qemu.sh ]; then \
		./start-qemu.sh; \
	else \
		qemu-system-i386 -machine pc-i440fx-3.1 -cpu pentium3 --serial file:serial.log -kernel $(BIN); \
	fi
