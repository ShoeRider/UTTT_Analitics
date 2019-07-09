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
	HashTable_t* HashTable = (HashTable_t*) malloc(sizeof(DefaultHashSize));

	HashTable->ArraySize = DefaultHashSize;
	HashTable->ElementsAdded = 0;
	HashTable->DLL_Handle    = Create_DLL_Handle();
	HashTable->Table = (Hash_t*) malloc(DefaultHashSize*sizeof(Hash_t));
	Hash_t* SetHash = HashTable->Table;


	for(int x=0;x<HashTable->ArraySize;x++)
	{
			//printf("Looping through array %d\n",x );
		SetHash[x].Accessed  = false;
		SetHash[x].Structure = NULL;
		SetHash[x].UniqueTag = 0;
					//printf("end of loop through array %d\n",x );
	}
	return HashTable;
}

HashTable_t* Create_HashTable_t(int ArraySize)
{
	HashTable_t* HashTable = (HashTable_t*) malloc(sizeof(HashTable_t));

	HashTable->ArraySize = ArraySize;
	HashTable->ElementsAdded = 0;

	HashTable->Table = (Hash_t*) malloc(ArraySize*sizeof(Hash_t));
	Hash_t* SetHash = HashTable->Table;


	for(int x=0;x<ArraySize;x++)
	{
			//printf("Looping through array %d\n",x );
		SetHash[x].Accessed  = false;
		SetHash[x].Structure = NULL;
		SetHash[x].UniqueTag = 0;
					//printf("end of loop through array %d\n",x );
	}
	return HashTable;
}



int GetIndex(HashTable_t* HashTable,int UniqueTag)
{
	int Index = UniqueTag % HashTable->ArraySize;
	int OverLapIndex = Index;
	while(true)
	{
		if(!HashTable->Table[Index].Accessed)
		{
			return -1;
		}
		else if(HashTable->Table[Index].UniqueTag==UniqueTag)
		{
			return Index;
		}
		Index++;
		if(HashTable->ArraySize == Index)
		{Index=0;}
		if(Index==OverLapIndex)
		{
			return -1;
		}
	}
}


Hash_t* Find(HashTable_t* HashTable,int UniqueTag)
{
	int Index = GetIndex(HashTable,UniqueTag);
	if(Index==-1)
	{
		return NULL;
	}
	return &HashTable->Table[Index];
}

bool Print(HashTable_t* HashTable)
{
	for(int x=0;x<HashTable->ArraySize;x++)
	{
		printf("Index:%d, Accessed: %d, UniqueTag: %f\n",x, HashTable->Table[x].Accessed, HashTable->Table[x].UniqueTag);
	}
	return true;
}

Hash_t* Add(HashTable_t* HashTable,void* Structure,int UniqueTag)
{
	int Index = UniqueTag % HashTable->ArraySize;
	//printf("Push_HashTable- UniqueTag:%d HashTable->ArraySize:%d Index:%d\n",UniqueTag,HashTable->ArraySize, Index);
	if(HashTable->ArraySize == HashTable->ElementsAdded)
	{
		return NULL;
	}
	HashTable->ElementsAdded++;


	while(true)
	{
		//printf("\t Accessing Index:%d\n",Index);
		if(!HashTable->Table[Index].Accessed)
		{
			//printf("\t \tAccessing Index:%d\n",Index);
			HashTable->Table[Index].Structure = Structure;
			HashTable->Table[Index].Accessed  = true;
			HashTable->Table[Index].UniqueTag = UniqueTag;
			//printf("\t \tAccessing Index:%d\n",Index);
			return &HashTable->Table[Index];
		}
		Index++;
		if(HashTable->ArraySize == Index)
		{Index=0;}
	}
}


void Free_HashTable_t(HashTable_t* HashTable)
{
	Hash_t* FreeHash = HashTable->Table;
	for(int x=0;x<HashTable->ArraySize;x++)
	{
		if(FreeHash[x].Structure != NULL)
		{
			free(FreeHash[x].Structure);
		}
	}
	Free_DLL(HashTable,1);

	free(FreeHash);
	free(HashTable);
}






#endif // HashTable_C
