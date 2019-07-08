#ifndef HashTable_H
#define HashTable_H

#include "../../Base.h"
#include "../DoublyLinkedList.h"
#include "../StringFields.h"

typedef struct Hash_t
{
  Mutex_t Mutex;
  bool Accessed;
  float UniqueTag;

  void* Structure;
} Hash_t;

typedef struct HashTable_t
{
  Hash_t* Table;
  int ArraySize;
  int ElementsAdded;

} HashTable_t;



void HashTable_V();
unsigned long ElfHash ( const unsigned char *s );
unsigned int PJWHash(const char* str, unsigned int length);
int Get_PJWHash_2D_CMatrix_t(_2D_CMatrix_t*_2D_CMatrix);


HashTable_t* Create_HashTable_t(int ArraySize);
int GetItemIndex_HashTable(HashTable_t* HashTable,int UniqueTag);
Hash_t* PULL_HashTable(HashTable_t* HashTable,int UniqueTag);
bool Print_HashTable(HashTable_t* HashTable);
Hash_t* Push_HashTable(HashTable_t* HashTable,void* Structure,int UniqueTag);
void Free_HashTable_t(HashTable_t*HashTable);

void HashTable_T(int CallSign);
#endif //HashTable_H
