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
	Free_HashTable_t(HashTable);
}

void AddStrings_HashTable_T()
{
	HashTable_t* HashTable  = Create_HashTable_t(5);
	Add(HashTable,"Test1",(void*)10);
	Add(HashTable,"Test52",(void*)11);
	Add(HashTable,"Test53",(void*)11);
	Print(HashTable);
	Free_HashTable_t(HashTable);
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
