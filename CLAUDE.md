# CLAUDE.md - Project Guidelines

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Git Workflow

- Never merge from parent; always rebase onto parent
- This maintains a clean, linear commit history

## Project Overview

naxos is a custom operating system kernel being developed following the OSDev Bare Bones tutorial. The project is written in C and x86 assembly, targeting the i686 architecture.

## Build System

- Uses a custom cross-compiler (i686-elf-gcc) built via `setup.sh`
- Falls back to system cross-compiler (i686-linux-gnu-gcc) if custom compiler unavailable
- Makefile automatically detects which compiler to use

## Development Guidelines

- Follow existing code style and conventions
- Test changes with `make run` before committing
- Ensure CI passes before merging PRs

## Current TODOs

### Hardware Abstraction Layer Development
- Design HAL interfaces supporting both DIO and memory-mapped I/O (in_progress)
- Create platform-specific I/O implementations for each architecture (pending)
- Define common device abstractions (timer, console, interrupt controller) (pending)
- Implement x86 platform layer using port I/O (pending)
- Implement NICNAC16 platform layer using DIO + memory-mapped (pending)

### Status
Working on issue #38 - Hardware Abstraction Layer design. Key insight: NICNAC16 can support both DIO instructions and memory-mapped I/O, allowing for a unified HAL interface where all platforms expose memory-mapped device registers, with platform-specific implementations handling the underlying I/O mechanisms.