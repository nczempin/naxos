# naxos

Just wanted to play with a shell of an x86 based operating system.

## Building

The `Makefile` assumes a cross compiler using the `i686-elf-` prefix. If your
toolchain uses a different prefix, set the `CROSS_PREFIX` variable when
invoking `make`:

```sh
make CROSS_PREFIX=arm-none-eabi-
```
