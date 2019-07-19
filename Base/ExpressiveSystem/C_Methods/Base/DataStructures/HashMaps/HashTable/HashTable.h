#ifndef HashTable_H
#define HashTable_H

//#include "../../../Base.h"
//#include "../../DoublyLinkedList/DoublyLinkedList.h"

#define DefaultHashSize 100

typedef struct Hash_t
{
  Mutex_t Mutex;
  bool Accessed; // Stores a boolean value if this element has ever been set.
  bool InUse;

//TODO include multiple hashvalues for redundant uniqueness.
  int UniqueHashes;
  int UniqueHash;

  void* Identifier;
  void* GivenStruct;

  DLL_Node_t* DLL_Node;
} Hash_t;
//typedef void *(*RunTimeFunction)(void *);

typedef struct HashTable_t
{
  Hash_t* Table;
  int*    PageTable;
  int Entries;

  int UniqueHashes;

  int ArraySize;

  int UsedCells;

  //RunTimeFunction* Hash_Structure;
  DLL_Handle_t* Elements; //DLL_Node Points to Hash_t
} HashTable_t;

/*
#define Free_HashTable(HashTable,Code)   \
for(int x=0;x<HashTable->ArraySize;x++) \
{ \
	if(HashTable->Table[x].GivenStruct != NULL) \
	{ \	//HashTable->Table[x].GivenStruct;
		Code \
	} \
} \
Free_DirectStructure(HashTable->Elements); \
free(HashTable->Table); \
free(HashTable); \
*/

void HashTable_V();

HashTable_t* Create_HashTable_t();
HashTable_t* Create_HashTable_t(int ArraySize);

Hash_t* Create_Hash_t(void* GivenStruct,int UniqueHash);

int Add(HashTable_t* HashTable,int UniqueHash,void* GivenStruct);


void* Pop(HashTable_t* HashTable,int Hash);
void Print(HashTable_t* HashTable);
/*float GetNewIndex(HashTable_t* HashTable,float UniqueTag);
int GetItemIndex(HashTable_t* HashTable,int UniqueTag);
Hash_t* PULL_HashTable(HashTable_t* HashTable,int UniqueTag);

Hash_t* Add(HashTable_t* HashTable,void* Structure,int UniqueTag);
Hash_t* Find(HashTable_t* HashTable,int UniqueTag);
*/
void Free(HashTable_t*HashTable);

void HashTable_T(int CallSign);
#endif //HashTable_H
