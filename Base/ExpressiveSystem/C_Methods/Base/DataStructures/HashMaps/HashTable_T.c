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

#endif // HashTable_C_T
