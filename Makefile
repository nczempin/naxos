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
# Use only the bare bones files for now
SRC=kernel.c
GAS=boot.s
C_OBJ=$(SRC:.c=.o)
GAS_OBJ=$(GAS:.s=.o)

OBJ=$(GAS_OBJ) $(C_OBJ)


$(BIN): boot.o kernel.o
	$(CC) -T linker.ld -o $(BIN) -ffreestanding -O2 -nostdlib $(CFLAGS) -Wl,--build-id=none $^ -lgcc
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
