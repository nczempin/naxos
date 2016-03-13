#ifndef SYS_H
#define SYS_H

#include <stdint.h>

unsigned short inpw(unsigned short _port);
unsigned char inpb(unsigned short _port);
void outb(uint16_t port, uint8_t val);

#endif /* SYS_H */
