#include "terminal.h"

#include "vga.h"
#include "sys.h"
#include "string.h"

static size_t terminal_row;
static size_t terminal_column;
static uint8_t terminal_color;
static uint16_t* terminal_buffer;

/* Updates the hardware cursor: the little blinking line
 *  on the screen under the last character pressed! */
static void move_cursor(void)
{
	unsigned temp;

	/* The equation for finding the index in a linear
	 *  chunk of memory can be represented by:
	 *  Index = [(y * width) + x] */
	temp = terminal_row * VGA_WIDTH + terminal_column;

	/* This sends a command to indicies 14 and 15 in the
	 *  CRT Control Register of the VGA controller. These
	 *  are the high and low bytes of the index that show
	 *  where the hardware cursor is to be 'blinking'.
	 *  To
	 *  learn more, you should look up some VGA
	 *  specific
	 *  programming documents. A great start to
	 *  graphics:
	 *  http://www.brackeen.com/home/vga */
	outb(0x3D4, 14);
	outb(0x3D5, temp >> 8);
	outb(0x3D4, 15);
	outb(0x3D5, temp);
}
void terminal_initialize()
{
	terminal_row = 0;
	terminal_column = 0;
	move_cursor();
	terminal_color = vga_make_color(COLOR_GREEN, COLOR_BLACK);
	terminal_buffer = (uint16_t*) 0xB8000;
	for (size_t y = 0; y < VGA_HEIGHT; y++) {
		for (size_t x = 0; x < VGA_WIDTH; x++) {
			const size_t index = y * VGA_WIDTH + x;
			terminal_buffer[index] = vga_make_color_entry(' ',
					terminal_color);
		}
	}
}

void terminal_setcolor(uint8_t color)
{
	terminal_color = color;
}

void terminal_putentryat(char c, uint8_t color, size_t x, size_t y)
{
	const size_t index = y * VGA_WIDTH + x;
	terminal_buffer[index] = vga_make_color_entry(c, color);
}

void terminal_putchar(char c)
{
	switch(c){
		case '\n':
			terminal_column = 0;
			if (++terminal_row >= VGA_HEIGHT) {
				terminal_row = 0;
			}
			break;
		case '\b':
			if (terminal_column > 0){
				--terminal_column;
				terminal_putchar(' ');
				--terminal_column;
			}
			break;
		default:
			terminal_putentryat(c, terminal_color, terminal_column, terminal_row);
			if (++terminal_column >= VGA_WIDTH) {
				terminal_column = 0;
				if (++terminal_row >= VGA_HEIGHT) {
					terminal_row = 0;
				}
			}
	}
	move_cursor();
}

void terminal_writestring(const char* data)
{
	size_t datalen = strnlen(data, VGA_WIDTH * VGA_HEIGHT);
	for (size_t i = 0; i < datalen; i++) {
		char character = data[i];
		terminal_putchar(character);
	}
}
