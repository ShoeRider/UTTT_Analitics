#ifndef BloomFilter_C
#define BloomFilter_C

#include "BloomFilter.h"



BloomFilter_t Create_BloomFilter_t()
{
  return Create_BloomFilter_t(DefaultBloomFilter);
}
BloomFilter_t Create_BloomFilter_t(int ArraySize)
{
  	BloomFilter_t * DLL_Node_Pointer =(BloomFilter_t *) malloc(sizeof(BloomFilter_t));
}

int* Malloc_BitArray(int Bits)
{
  int ArraySize = (Bits/(8*sizeof(int)))+1
  return (int*) malloc(sizeof(int)*ArraySize);
}

#endif // BloomFilter_C
