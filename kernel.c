#if !defined(__cplusplus)
#include <stdbool.h> /* C doesn't have booleans by default. */
#endif
#include <stddef.h>
#include <stdint.h>

/* Check if the compiler thinks we are targeting the wrong operating system. */
#if defined(__linux__)
#error "Wrong compiler."
#endif

/* This tutorial will only work for the 32-bit ix86 targets. */
#if !defined(__i386__)
#error "This tutorial needs to be compiled with a ix86-elf compiler"
#endif

#include "terminal.h"
#include "vga.h"
#include "sys.h"
#include "keyboard.h"

#if defined(__cplusplus)
extern "C" /* Use C linkage for kernel_main. */
#endif

void kernel_main()
{
    terminal_initialize();
    unsigned char c = 0;
    unsigned char old_c;
    while (1) {
        old_c = c;
        c = keyboard_getchar();
        if (c == 1) { //ESC
            break;
        }
        if (c!=old_c && c != 0 && c!=0xfa) {
            terminal_putchar(c);
        }
    }
    terminal_writestring("Hello, kernel World!\n");
    for (size_t i = 0; i < VGA_HEIGHT; ++i) {
        terminal_writestring("Another line.\n");
    }
    terminal_writestring("One more line.\n");
}
