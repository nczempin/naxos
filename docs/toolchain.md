# Toolchain Build System

## Overview

The naxos kernel requires a cross-compiler targeting `i686-elf`. This project supports multiple approaches for obtaining the toolchain sources:

### Option 1: Automatic Download (Default)
The build system automatically downloads official release tarballs from GNU FTP servers when building the cross-compiler. This is the simplest approach and requires no manual steps.

### Option 2: Git Sources (Recommended for Development)
For reproducible builds and offline development, you can fetch specific git tags:

```bash
./scripts/fetch-toolchain-sources.sh
```

This fetches:
- binutils from tag `binutils-2_40`
- GCC from tag `releases/gcc-12.2.0`

The git sources are shallow clones (--depth 1) to minimize download size while maintaining exact version control.

## Build Process

1. **Run setup**: `./setup.sh`
   - Installs system dependencies
   - Builds cross-compiler (from either tarballs or git sources)
   - Verifies installation

2. **The build script**:
   - Checks for git sources in `vendor/sources/`
   - Falls back to downloading tarballs if git sources not found
   - Builds to `vendor/cross/`

## CI/CD

The CI system:
- Caches the built cross-compiler between runs
- Only rebuilds when toolchain versions change
- Uses the same build process as local development

## Version Management

Toolchain versions are defined in:
- `scripts/build-cross-compiler.sh` - for local builds
- `.github/workflows/*.yml` - for CI builds

When updating versions, ensure both locations are synchronized.