#include "terminal.h"

#include "vga.h"

size_t terminal_row;                                                             
size_t terminal_column;                                                          
uint8_t terminal_color;                                                          
uint16_t* terminal_buffer;

/* We will use this to write to I/O ports to send bytes to devices. This
 *  will be used in the next tutorial for changing the textmode cursor
 *  position. Again, we use some inline assembly for the stuff that
 *  simply
 *  cannot be done in C */
void outportb (unsigned short _port, unsigned char _data)
{
	__asm__ __volatile__ ("outb %1, %0" : : "dN" (_port), "a" (_data));
}

/* Updates the hardware cursor: the little blinking line
 *  on the screen under the last character pressed! */
void move_cursor(void)
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
	outportb(0x3D4, 14);
	outportb(0x3D5, temp >> 8);
	outportb(0x3D4, 15);
	outportb(0x3D5, temp);
}

size_t strnlen(const char* str, const unsigned int max) {
	size_t ret = 0;
	while ( ret < max && str[ret] != 0 )
		ret++;
	return ret;
}


void terminal_initialize() {                                                     
	terminal_row = 0;                                                              
	terminal_column = 0;                                                           
	terminal_color = vga_make_color(COLOR_LIGHT_MAGENTA, COLOR_LIGHT_CYAN);
	terminal_buffer = (uint16_t*) 0xB8000;
	for (size_t y = 0; y < VGA_HEIGHT; y++) {                                      
		for (size_t x = 0; x < VGA_WIDTH; x++) {                                     
			const size_t index = y * VGA_WIDTH + x;                                    
			terminal_buffer[index] = vga_make_color_entry(' ',
					terminal_color);               
		}                                                                            
	}                                                                              
}                                                                                

void terminal_setcolor(uint8_t color) {                                          
	terminal_color = color;                                                        
}                                                                                

void terminal_putentryat(char c, uint8_t color, size_t x, size_t y) {            
	const size_t index = y * VGA_WIDTH + x;                                        
	terminal_buffer[index] = vga_make_color_entry(c, color);
}                                                                                

void terminal_putchar(char c) {                                                  
	terminal_putentryat(c, terminal_color, terminal_column, terminal_row);         
	if (++terminal_column >= VGA_WIDTH) {                                          
		terminal_column = 0;                                                         
		if (++terminal_row >= VGA_HEIGHT) {                                          
			terminal_row = 0;                                                          
		}                                                                            
	}                                                                              
	move_cursor();                                                                 
}                                                                                

void terminal_writestring(const char* data) {                                    
	size_t datalen = strnlen(data, VGA_WIDTH * VGA_HEIGHT);                        
	for (size_t i = 0; i < datalen; i++) {                                         
		char character = data[i];                                                    
		switch (character){                                                          
			case '\n':                                                                 
				if (++terminal_row >= VGA_HEIGHT){                                       
					terminal_row = 0;                                                      
				}
				terminal_column = 0;
				break;
			default:
				terminal_putchar(character);
				break;
		}
	}
}
