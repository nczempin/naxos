#include "string.h"

size_t strnlen(const char* str, const unsigned int max)                          
{                                                                                
	size_t ret = 0;                                                                
	while ( ret < max && str[ret] != 0 ) {                                         
		ret++;                                                                       
	}                                                                              
	return ret;                                                                    
}  
