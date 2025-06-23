cmake_minimum_required(VERSION 3.16)

# Project definition
project(naxos 
    LANGUAGES C ASM
    DESCRIPTION "naxos - A multi-architecture OS kernel"
)

# Architecture detection and validation
if(NOT DEFINED ARCH)
    set(ARCH "x86")
    message(STATUS "No ARCH specified, defaulting to x86")
endif()

# Validate architecture
set(SUPPORTED_ARCHS "x86;arm;riscv;nicnac16")
if(NOT ARCH IN_LIST SUPPORTED_ARCHS)
    message(FATAL_ERROR "Unsupported architecture: ${ARCH}. Supported architectures: ${SUPPORTED_ARCHS}")
endif()

message(STATUS "Building for architecture: ${ARCH}")

# Set architecture-specific compiler prefixes
if(ARCH STREQUAL "x86")
    # x86 compiler detection (replicating Makefile logic)
    if(EXISTS "${CMAKE_SOURCE_DIR}/vendor/cross/bin/i686-elf-gcc")
        set(CROSS_PREFIX "vendor/cross/bin/i686-elf-")
        message(STATUS "Using custom x86 cross-compiler: ${CROSS_PREFIX}")
    else()
        set(CROSS_PREFIX "i686-linux-gnu-")
        message(STATUS "Using system x86 cross-compiler: ${CROSS_PREFIX}")
    endif()
elseif(ARCH STREQUAL "arm")
    set(CROSS_PREFIX "arm-none-eabi-")
    message(STATUS "Using ARM cross-compiler: ${CROSS_PREFIX}")
elseif(ARCH STREQUAL "riscv")
    set(CROSS_PREFIX "riscv64-unknown-elf-")
    message(STATUS "Using RISC-V cross-compiler: ${CROSS_PREFIX}")
elseif(ARCH STREQUAL "nicnac16")
    # NICNAC16 will need custom toolchain - placeholder for now
    message(WARNING "NICNAC16 toolchain not yet implemented")
    set(CROSS_PREFIX "nicnac16-")
else()
    message(FATAL_ERROR "Architecture ${ARCH} not implemented")
endif()

# Set compilers
set(CMAKE_C_COMPILER "${CROSS_PREFIX}gcc")
set(CMAKE_ASM_COMPILER "${CROSS_PREFIX}as")

# Compiler flags (matching Makefile)
set(CMAKE_C_FLAGS "-I. -fno-pie -no-pie -std=gnu99 -ffreestanding -O2 -Wall -Wextra")
set(CMAKE_ASM_FLAGS "--noexecstack")

# Linker flags (matching Makefile)
set(CMAKE_EXE_LINKER_FLAGS "-T ${CMAKE_SOURCE_DIR}/linker.ld -ffreestanding -O2 -nostdlib -Wl,--build-id=none")

# Source files
set(SOURCES
    boot.s
    kernel.c
)

# Create the kernel binary
add_executable(naxos.bin ${SOURCES})

# Link with libgcc (matching Makefile)
target_link_libraries(naxos.bin gcc)

# Custom target for running in QEMU (matching Makefile 'run' target)
add_custom_target(run
    COMMAND ${CMAKE_COMMAND} -E echo "Starting naxos kernel in QEMU..."
    COMMAND bash -c "if [ -x ${CMAKE_SOURCE_DIR}/start-qemu.sh ]; then ${CMAKE_SOURCE_DIR}/start-qemu.sh; else qemu-system-i386 -machine pc-i440fx-3.1 -cpu pentium3 --serial file:serial.log -kernel ${CMAKE_BINARY_DIR}/naxos.bin; fi"
    DEPENDS naxos.bin
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    COMMENT "Running naxos in QEMU"
)

# Custom target for clean (CMake has built-in clean, but for compatibility)
add_custom_target(clean-all
    COMMAND ${CMAKE_COMMAND} -E remove -f naxos.bin boot.o kernel.o
    COMMENT "Cleaning build artifacts"
)