# naxos

[![Build](https://github.com/nczempin/naxos/actions/workflows/build.yml/badge.svg?branch=develop)](https://github.com/nczempin/naxos/actions/workflows/build.yml)

naxos is a tiny x86 toy kernel for exploring operating system concepts.

## Setup

The repository holds a prebuilt `i686-elf` cross compiler in Git LFS. After cloning run:

```sh
git lfs pull
export PATH="$PWD/vendor/cross/bin:$PATH"
```

To build the toolchain yourself, execute `./vendor/build_cross_compiler.sh`.

## Build and Run

Compile with `make` and boot in QEMU using:

```sh
make run
```

Override the compiler prefix with `make CROSS_PREFIX=<prefix>` if needed.

## Packaging

GitHub Actions builds the kernel and cross compiler. Tagged commits create
release archives of both artifacts.

## Status

This is a learning project with minimal functionality and no automated tests.
