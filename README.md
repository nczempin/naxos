# naxos

Just wanted to play with a shell of an x86 based operating system.

## Building

This repository stores the prebuilt cross compiler using [Git LFS](https://git-lfs.com/).
If you haven't enabled LFS, install it and run `git lfs pull` after cloning to
retrieve the compiler binaries.

The `Makefile` assumes a cross compiler using the `i686-elf-` prefix. If your
toolchain uses a different prefix, set the `CROSS_PREFIX` variable when
invoking `make`:

```sh
make CROSS_PREFIX=arm-none-eabi-
```

If you don't already have an `i686-elf` toolchain installed you can build one
with the provided script. The repository may also include a prebuilt toolchain
under `vendor/cross` if Git LFS objects were fetched during checkout:

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

## Toolchain and CI

The kernel and cross‑compiler are built automatically on GitHub Actions. The
workflow in `.github/workflows/build.yml` triggers the `cross-compiler` job
defined in `.github/workflows/cross-compiler.yml`.

When the workflow runs for a tagged commit, the generated cross compiler is
packaged and published as a GitHub release.

The cross‑compiler workflow installs the build dependencies
`build-essential`, `bison`, `flex`, `libgmp3-dev`, `libmpc-dev`, `libmpfr-dev`,
`texinfo`, `wget`, and `coreutils`. It then builds an `i686-elf` toolchain using
GCC **14.1.0** and binutils **2.44**. The same defaults are used by
`vendor/build_cross_compiler.sh` if you run the script locally.

After building, you can boot the kernel in QEMU by running `make run`. The
kernel will print:

```
Hello, kernel World!
Another line.
...
```

followed by additional lines before halting.

This repository currently includes no automated tests or linters.
