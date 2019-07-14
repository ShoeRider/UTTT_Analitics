#ifndef Array_C
#define Array_C

#include "Array.h"

Array_t* Create_Array_t(int ArraySize)
{
	Array_t* HashTable = (Array_t*) malloc(sizeof(Array_t));

	return HashTable;
}


void Free(Array_t* Array)
{
	free(Array);
}
#endif // Array_C
