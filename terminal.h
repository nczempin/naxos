#ifndef TERMINAL_H
#define TERMINAL_H
#include <stddef.h>
#include <stdint.h>

void terminal_initialize();
void terminal_setcolor(uint8_t color);
void terminal_putentryat(char c, uint8_t color, size_t x, size_t y);
void terminal_putchar(char c);
void terminal_writestring(const char* data);

#endif /* TERMINAL_H */
