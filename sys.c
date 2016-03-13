#include "sys.h"

unsigned short inpw(unsigned short _port)
{
    unsigned short _v;
    __asm__ __volatile__ ( "inw %w1,%0" : "=a" (_v) : "d" (_port) );
    return _v;
}
unsigned char inpb(unsigned short _port)
{
    unsigned char _v;
    __asm__ __volatile__ ( "inb %1, %0" : "=a" (_v) : "d" (_port) );
    return _v;
}
void outb (unsigned short _port, unsigned char _data)
{
    __asm__ __volatile__ ("outb %1, %0" : : "dN" (_port), "a" (_data));
}
