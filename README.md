# naxos

Just wanted to play with a shell of an x86 based operating system.

## Building

The `Makefile` assumes a cross compiler using the `i686-elf-` prefix. If your
toolchain uses a different prefix, set the `CROSS_PREFIX` variable when
invoking `make`:

```sh
make CROSS_PREFIX=arm-none-eabi-
```

If you don't already have an `i686-elf` toolchain installed you can build one
with the provided script:

```sh
./vendor/build_cross_compiler.sh
```

When the script completes, add the compiler to your `PATH` so `make` can find
it automatically:

```sh
export PATH="$PWD/vendor/cross/bin:$PATH"
```

## Running

After building the kernel you can boot it in QEMU with:

```sh
make run
```

The `run` target will execute `start-qemu.sh` if it exists, or fall back to
calling `qemu-system-i386` directly.
