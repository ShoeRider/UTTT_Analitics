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


int GetIndex_HashTable(HashTable_t* HashTable,int UniqueTag)
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


Hash_t* PULL_HashTable(HashTable_t* HashTable,int UniqueTag)
{
	int Index = GetIndex_HashTable(HashTable_t* HashTable,int UniqueTag);
	if(Index==-1)
	{
		return NULL;
	}
	return &HashTable->Table[Index];
}

bool Print_HashTable(HashTable_t* HashTable)
{
	for(int x=0;x<HashTable->ArraySize;x++)
	{
		printf("Index:%d, Accessed: %d, UniqueTag: %f\n",x, HashTable->Table[x].Accessed, HashTable->Table[x].UniqueTag);
	}
	return true;
}

Hash_t* Push_HashTable(HashTable_t* HashTable,void* Structure,int UniqueTag)
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
	free(FreeHash);
	free(HashTable);
}

unsigned long ElfHash ( const unsigned char *s )
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

unsigned int PJWHash(const char* str, unsigned int length)
{
   const unsigned int BitsInUnsignedInt = (unsigned int)(sizeof(unsigned int) * 8);
   const unsigned int ThreeQuarters     = (unsigned int)((BitsInUnsignedInt  * 3) / 4);
   const unsigned int OneEighth         = (unsigned int)(BitsInUnsignedInt / 8);
   const unsigned int HighBits          =
                      (unsigned int)(0xFFFFFFFF) << (BitsInUnsignedInt - OneEighth);
   unsigned int hash = 0;
   unsigned int test = 0;
   unsigned int i    = 0;

   for (i = 0; i < length; ++str, ++i)
   {
      hash = (hash << OneEighth) + (*str);

      if ((test = hash & HighBits) != 0)
      {
         hash = (( hash ^ (test >> ThreeQuarters)) & (~HighBits));
      }
   }

   return hash;
}

int Get_PJWHash_2D_CMatrix_t(_2D_CMatrix_t*_2D_CMatrix)
{
	return PJWHash(_2D_CMatrix->Array,_2D_CMatrix->IndexSize);
}

//Create
//Add
//Remove
//Free
void HashTable_T0()
{
	const char* charString[100];
	HashTable_t* HashTable = Create_HashTable_t(10);
	for(int x=0;x<8;x++)
	{
		GatherTerminalString("Enter a string", (char*)&charString);
		int UniqueTag =PJWHash((const char*)&charString, 99);
		Push_HashTable(HashTable,NULL,UniqueTag);
		Print_HashTable(HashTable);
	}
	Free_HashTable_t(HashTable);



}
void HashTable_T1()
{
	HashTable_t* HashTable  = Create_HashTable_t(1000000);
	Free_HashTable_t(HashTable);
}


void PJWHash_T()
{
	const char* charString[100];
	while(true)
	{
		GatherTerminalString("Enter a string", (char*)&charString);
		printf("%d\n",PJWHash((const char*)&charString, 99));
	}

}


void HashTable_TT()
{
	int SelectedTest = 0;
  printf("0 = PJWHash_T()\n");
  printf("1 = HashTable_T()\n");
  printf("2 = \n");
  printf("100 =\n");
  GatherTerminalInt("Please Select Test:",&SelectedTest);
  if (SelectedTest == 0)
  {
    PJWHash_T();
  }
  else if (SelectedTest == 1)
  {
		HashTable_T0();
  }
  else if (SelectedTest == 2)
  {
		HashTable_T1();
  }
  else if (SelectedTest == 3)
  {

  }
  else if (SelectedTest == 4)
  {

  }
  else if (SelectedTest == 100)
  {

  }
}

void HashTable_T(int CallSign)
{
	printf("\n\n");
	printf("Starting HashTable_T Tests:\n");
	printf("----------------------------\n");

	if (CallSign == 1)
	{
		//
	}
	else
	{
		HashTable_TT();
	}


}

#endif // HashTable_C
