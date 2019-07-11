#ifndef HashTable_C
#define HashTable_C

#include "HashTable.h"



// Code Implementation File Information ///////////////////////////////////////
/**
* @file DoublyLinkedList.c
*
* @brief Implementation for structures:
*          -DLL_Node_t
*          -DLL_Handle_t
*
*
* @details Implements all functions Related to Basic DLL(Doubly Linked List)
*           functionality.
*
* @version 1.10
*
* @note Requires:
*/

/*
* @brief
*
* @details
*
* @example:
*
*/
void HashTable_V()
{
	printf("HashTable  \t\t\tV:1.00\n");
}

HashTable_t* Create_HashTable_t()
{
	return Create_HashTable_t(DefaultHashSize);
}

HashTable_t* Create_HashTable_t(int ArraySize)
{
	HashTable_t* HashTable = (HashTable_t*) malloc(sizeof(HashTable_t));

	HashTable->ArraySize       = ArraySize;
	HashTable->ElementsAdded   = 0;
	HashTable->Elements        = Create_DLL_Handle_t();
	HashTable->Table           = (Hash_t*) malloc(ArraySize*sizeof(Hash_t));


	for(int x=0;x<HashTable->ArraySize;x++)
	{
			//printf("Looping through array %d\n",x );
		HashTable->Table[x].Accessed    = false;
		HashTable->Table[x].GivenStruct = NULL;
		HashTable->Table[x].UniqueHash  = 0;
					//printf("end of loop through array %d\n",x );
	}
	return HashTable;
}

Hash_t* Create_Hash_t(void* GivenStruct,int UniqueHash)
{
	Hash_t* Hash = (Hash_t*) malloc(sizeof(Hash_t));
	Hash->UniqueHash  = UniqueHash;
	Hash->GivenStruct = GivenStruct;
	return Hash;
}

int _Extend(HashTable_t* HashTable)
{
	double Filled = (HashTable->ElementsAdded / HashTable->ArraySize);
	if (Filled >= (2/3))
	{
		//Extend Hash Table Array


		//int NewArraySize = HashTable->ArraySize*4;
		//Hash_t* NewTable = (Hash_t*) malloc(NewArraySize*sizeof(Hash_t));
		//DLL_Transverse(HashTable->DLL_Elements,
			//Hash_t* Hash_Element = (Node->GivenStruct);

		//)
	}


	return 0;
}


//_Scan(ForNextOpening)(HashTable_t* HashTable,int UniqueHash)
//Retruns:
// [0-MaxInteger] : Index in HashTable->Table[Index]
// -1             : Entry Exists
// -2             : Array Full/Unexpected Error
int _Scan(HashTable_t* HashTable,int UniqueHash)
{
	int Index = UniqueHash % HashTable->ArraySize;
	int OverlapedStartIndex = Index;
	while(true)
	{
		printf("%d,%d\n",Index,OverlapedStartIndex );
		if(!HashTable->Table[Index].Accessed)
		{
			return Index;
		}
		else if(HashTable->Table[Index].UniqueHash == UniqueHash)
		{
			return -1;
		}
		Index++;
		if(HashTable->ArraySize <= Index)
		{
			Index = 0;
		}
		if(Index == OverlapedStartIndex)
		{
			return -2;
		}
	}
}



//Exists(HashTable_t* HashTable,int UniqueHash)
//Retruns:
// [0-MaxInteger] : Index in HashTable->Table[Index]
// -1             : No Entry Exists
// -2             : Array Full/Unexpected Error
int Exists(HashTable_t* HashTable,int UniqueHash)
{
	int Index = UniqueHash % HashTable->ArraySize;
	int OverlapedStartIndex = Index;
	while(true)
	{
		if(!HashTable->Table[Index].Accessed)
		{
			return -1;
		}
		else if(HashTable->Table[Index].UniqueHash == UniqueHash)
		{
			return Index;
		}
		Index++;
		if(HashTable->ArraySize >= Index)
		{
			Index = 0;
		}
		if(Index == OverlapedStartIndex)
		{
			return -2;
		}
	}
}

//Get(HashTable_t* HashTable,int UniqueHash)
//Retruns:
// [0-MaxInteger] : Index in HashTable->Table[Index]
// -1             : No Entry Exists
// -2             : Array Full/Unexpected Error
void* Get(HashTable_t* HashTable,int UniqueHash)
{
	int Index = Exists(HashTable,UniqueHash);
	if (Index>=0)
	{
		return (void*)(&HashTable->Table[Index])->GivenStruct;
	}
	return NULL;
}

//Add(HashTable_t* HashTable,int UniqueHash,void* GivenStruct)
//Retruns:
// [0-MaxInteger] : Index in HashTable->Table[Index]
// -1             : UniqueTag Already Exists
// -2             : Array Full, Unexpected Error
int Add(HashTable_t* HashTable,int UniqueHash,void* GivenStruct)
{
	int Index = _Scan(HashTable,UniqueHash);
	printf("\n\nIndex:%d\n\n",Index);
	if (Index<0)
	{
		return Index;
	}

	//Add to Hash Array and DLL
	HashTable->Table[Index].Accessed    = true;
	HashTable->Table[Index].UniqueHash  = UniqueHash;
	HashTable->Table[Index].GivenStruct = GivenStruct;
	Add(HashTable->Elements,(void*)&HashTable->Table[Index]);
	HashTable->ElementsAdded++;
	_Extend(HashTable);
	return Index;
}

unsigned long ElfHash ( char *s )
{
    unsigned long   h = 0, high;
    while ( *s )
    {
        h = ( h << 4 ) + *s++;
        if ( high = h & 0xF0000000 )
            h ^= high >> 24;
        h &= ~high;
    }
    return h;
}

//Add(HashTable_t* HashTable,int UniqueHash,void* GivenStruct)
//Retruns:
// [0-MaxInteger] : Index in HashTable->Table[Index]
// -1             : UniqueTag Already Exists
// -2             : Array Full, Unexpected Error
int Add(HashTable_t* HashTable, char* String,void* GivenStruct)
{
	//String
	int hash = (int) ElfHash(String);
	printf("\n\n%d\n\n",hash);
	return Add(HashTable,hash,GivenStruct);
}


//Add(HashTable_t* HashTable,int UniqueHash,void* GivenStruct)
//Retruns:
// Void* : Success
// NULL  : Something went wrong
void* Pop(HashTable_t* HashTable,int Hash)
{
	int Index = Exists(HashTable,Hash);
	if (Index>=0)
	{
		void* GivenStruct = (&HashTable->Table[Index])->GivenStruct;

		return GivenStruct;
	}
	return NULL;
}

int Remove_Index(HashTable_t* HashTable,int Index)
{
	return 0;
}

int Remove_Hash(HashTable_t* HashTable, int UniqueHash)
{
	//int Index = UniqueHash % HashTable->ArraySize;
	return 0;
}



bool Print(HashTable_t* HashTable)
{
	for(int x=0;x<HashTable->ArraySize;x++)
	{
		printf("Index:%d, Accessed: %d, UniqueTag: %d, UniqueTag: %p\n",x, HashTable->Table[x].Accessed, HashTable->Table[x].UniqueHash,HashTable->Table[x].GivenStruct);
	}
	return true;
}




void Free_HashTable_t(HashTable_t* HashTable)
{
	Hash_t* FreeHash = HashTable->Table;
	for(int x=0;x<HashTable->ArraySize;x++)
	{
		if(FreeHash[x].GivenStruct != NULL)
		{
			//free(FreeHash[x].GivenStruct);
		}
	}
	Free_DLL_KeepGivenStructures(HashTable->Elements);

	free(FreeHash);
	free(HashTable);
}






#endif // HashTable_C
