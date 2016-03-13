CC=i686-elf-gcc
CFLAGS=-I.

BIN=naxos.bin
SRC=$(wildcard *.c)
GAS=$(wildcard *.s)
NASM=$(wildcard *.asm)
C_OBJ=$(SRC:.c=.o)
GAS_OBJ=$(GAS:.s=.o)
NASM_OBJ=$(NASM:.asm=.o)

OBJ=$(GAS_OBJ) $(NASM_OBJ) $(C_OBJ)


$(BIN): $(OBJ)
	$(CC) -T linker.ld -o $(BIN) -ffreestanding -O2 -nostdlib $^ -lgcc
%.o: %.c
	$(CC) -o $@ -c $^ -std=gnu99 -ffreestanding -O2 -Wall -Wextra
$(GAS_OBJ): $(GAS)
	i686-elf-as $^ -o $@
$(NASM_OBJ): $(NASM)
	nasm -f elf32 $^ -o $@

.PHONY : clean
clean :
	-rm -f $(BIN) $(OBJ)
