#ifndef HashTable_C_T
#define HashTable_C_T

#include "HashTable.c"



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

//Create
//Add
//Remove
//Free

void MallocFree_HashTable_t()
{
	HashTable_t* HashTable  = Create_HashTable_t();
	Free(HashTable);
}


//Needs work
#define HashVoid(GivenStruct) _HashVoid((unsigned long)GivenStruct,sizeof(*GivenStruct))
float _HashVoid(unsigned long pointerValue,int Size)
{

	pointerValue++;
	printf("Size :%d\n",Size);
	printf("Pointer:%lu\n",pointerValue);
	printf("Pointer:%p\n",(void*)&pointerValue);
	return 0.0;
}

void MallocFree_HashTable0_t()
{
	HashTable_t* HashTable  = Create_HashTable_t();
	printf("Pointer:%p\n",HashTable);

	Add(HashTable,4,(void*)10);
	Free(HashTable);
}


void AddStrings_HashTable_T()
{
	HashTable_t* HashTable  = Create_HashTable_t(4);
	Add(HashTable,4,(void*)10);
	Add(HashTable,5,(void*)10);
	Print(HashTable);
	Add(HashTable,14,(void*)11);
		Print(HashTable);
	Add(HashTable,1,(void*)11);


	printf("%p\n",Pop(HashTable,4));
	Add(HashTable,7,(void*)10);
	printf("%p\n",Pop(HashTable,9));
	Print(HashTable);

	Print(HashTable);
	Free_DirectStructure(HashTable);

}



void HashTable_TT()
{
	int SelectedTest = 0;
  printf("0 = MallocFree_HashTable_t()\n");
  printf("1 = AddStrings_HashTable_T()\n");
  printf("2 = \n");
  printf("100 =\n");
  GatherTerminalInt("Please Select Test:",&SelectedTest);
  if (SelectedTest == 0)
  {
		MallocFree_HashTable_t();
  }
  else if (SelectedTest == 1)
  {
		AddStrings_HashTable_T();
  }
  else if (SelectedTest == 2)
  {
		MallocFree_HashTable0_t();
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

#endif // HashTable_C_T
