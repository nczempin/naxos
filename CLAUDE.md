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