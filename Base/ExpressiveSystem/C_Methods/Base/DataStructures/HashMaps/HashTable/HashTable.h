#ifndef HashTable_H
#define HashTable_H

//#include "../../../Base.h"
//#include "../../DoublyLinkedList/DoublyLinkedList.h"

#define DefaultHashSize 100

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

  DLL_Handle_t* DLL_Handle;
} HashTable_t;



void HashTable_V();

HashTable_t* Create_HashTable_t(int ArraySize);
int GetIndex(HashTable_t* HashTable,int UniqueTag);
Hash_t* PULL_HashTable(HashTable_t* HashTable,int UniqueTag);
bool Print(HashTable_t* HashTable);
Hash_t* Add(HashTable_t* HashTable,void* Structure,int UniqueTag);
Hash_t* Find(HashTable_t* HashTable,int UniqueTag);

void Free_HashTable_t(HashTable_t*HashTable);

void HashTable_T(int CallSign);
#endif //HashTable_H
