#ifndef HashTable_H
#define HashTable_H

//#include "../../../Base.h"
//#include "../../DoublyLinkedList/DoublyLinkedList.h"

#define DefaultHashSize 100

typedef struct Hash_t
{
  Mutex_t Mutex;
  bool Accessed;
  int UniqueHash;
  void* GivenStruct;

  DLL_Node_t* DLL_Node;
} Hash_t;
//typedef void *(*RunTimeFunction)(void *);

typedef struct HashTable_t
{
  Hash_t* Table;
  int ArraySize;
  int ElementsAdded;

  //RunTimeFunction* Hash_Structure;
  DLL_Handle_t* Elements; //DLL_Node Points to Hash_t
} HashTable_t;



void HashTable_V();

HashTable_t* Create_HashTable_t();
HashTable_t* Create_HashTable_t(int ArraySize);

Hash_t* Create_Hash_t(void* GivenStruct,int UniqueHash);

int Add(HashTable_t* HashTable,int UniqueHash,void* GivenStruct);

HashTable_t* Create_HashTable_t(int ArraySize);
/*float GetNewIndex(HashTable_t* HashTable,float UniqueTag);
int GetItemIndex(HashTable_t* HashTable,int UniqueTag);
Hash_t* PULL_HashTable(HashTable_t* HashTable,int UniqueTag);
bool Print(HashTable_t* HashTable);
Hash_t* Add(HashTable_t* HashTable,void* Structure,int UniqueTag);
Hash_t* Find(HashTable_t* HashTable,int UniqueTag);
*/
void Free_HashTable_t(HashTable_t*HashTable);

void HashTable_T(int CallSign);
#endif //HashTable_H