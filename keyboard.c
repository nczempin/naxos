#include "keyboard.h"
#include "sys.h"

//starting point for scan code table
unsigned char scan[] =
    "\0\1" "1234567890-=\b\tqwertzuiop[]\n\0asdfghjkl;'`\0\\yxcvbnm,./\0*\0 \0"
		"##############";

unsigned char keyboard_get_scancode()
{
    unsigned char c = 0;
    do {
        if (inpb(0x60) != c) {
            c=inpb(0x60);
            if(c>0) {
                return c;
            }
        }
    } while(1);
}
unsigned char keyboard_getchar()
{
    return scan[keyboard_get_scancode()];
}
