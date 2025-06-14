# naxos

[![Build](https://github.com/nczempin/naxos/actions/workflows/build.yml/badge.svg?branch=develop)](https://github.com/nczempin/naxos/actions/workflows/build.yml)

## What Problem Does This Solve?
naxos is a tiny x86 toy kernel for exploring operating system concepts. It provides a minimal, hands-on environment for learning about kernel development, memory management, and low-level system programming without the complexity of a full operating system.

## Who Is This For?
- **Computer Science Students**: Learning operating system fundamentals
- **OS Development Enthusiasts**: Exploring kernel concepts in a simplified environment
- **Low-level Programming Learners**: Understanding x86 architecture and bare-metal programming
- **Educators**: Teaching operating system principles with a minimal codebase

## Current Implementation Status
- ✅ Basic kernel initialization and booting
- ✅ Simple terminal output functionality
- ✅ GDT (Global Descriptor Table) setup
- ✅ Interrupt handling infrastructure
- 🚧 Memory management (partial implementation)
- 🚧 Keyboard input handling
- 📋 Process scheduling
- 📋 File system support
- 📋 User mode applications

## Purpose & Scope

This project is a learning toy kernel. It is intentionally minimal and
incomplete, providing just enough functionality to explore operating system
concepts. It is not meant for production use or comprehensive feature
coverage.

### What This IS
- A minimal educational kernel for learning OS concepts
- A platform for experimenting with x86 bare-metal programming
- A simplified environment for understanding kernel fundamentals

### What This IS NOT
- Not a production-ready operating system
- Not intended for real-world applications
- Not aiming for POSIX compliance or compatibility
- Not focused on performance or security hardening

## Setup

The repository holds a prebuilt `i686-elf` cross compiler in Git LFS. After cloning run:

```sh
git lfs pull
export PATH="$PWD/vendor/cross/bin:$PATH"
```

To build the toolchain yourself, execute `./vendor/build_cross_compiler.sh`.

Install host dependencies with:

```sh
./setup.sh
```

## Build and Run

Compile with `make` and boot in QEMU using:

```sh
make run
```

The Makefile looks for a cross compiler using the `CROSS_PREFIX` variable.
It defaults to `i686-elf-`. Override it with `make CROSS_PREFIX=<prefix>` if
your tools use a different prefix or reside in a custom location.

## Expected Behavior

When running the kernel in QEMU, you should see:

1. GRUB bootloader loading the kernel
2. Kernel initialization messages
3. A simple terminal interface with basic output capabilities
4. Memory information display

The current implementation focuses on fundamental kernel structures rather than user-facing features. Interaction is limited to observing kernel messages and basic terminal output.

## Repository Structure
- `src/` - Kernel source code
- `include/` - Header files
- `boot/` - Boot-related code and configurations
- `vendor/` - Cross-compiler and development tools
- `scripts/` - Build and utility scripts

## Packaging

GitHub Actions builds the kernel and cross compiler. Tagged commits create
release archives of both artifacts.

## Development Status

This is an active learning project with minimal functionality. The core boot process and basic kernel infrastructure are implemented, while more advanced features like process scheduling and file systems are planned for future development. There are currently no automated tests beyond the CI build verification.
