#ifndef DoublyLinkedList_T_C
#define DoublyLinkedList_T_C

#include "DoublyLinkedList.c"



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

void MallocFree_DoublyLinkedList_t()
{
	DLL_Handle_t* DLL_Handle  = Create_DLL_Handle_t();
	Free(DLL_Handle);
}

void AddStrings_DoublyLinkedList_t()
{

}


//DoublyLinkedList Test Table
void DoublyLinkedList_TT()
{
	int SelectedTest = 0;
  printf("0 = MallocFree_DoublyLinkedList_t\n");
  printf("1 =AddStrings_DoublyLinkedList_t\n");
  printf("2 = \n");
  printf("100 =\n");
  GatherTerminalInt("Please Select Test:",&SelectedTest);
  if (SelectedTest == 0)
  {
		MallocFree_DoublyLinkedList_t();
  }
  else if (SelectedTest == 1)
  {
		AddStrings_DoublyLinkedList_t();
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

//DoublyLinkedList Tests
void DoublyLinkedList_T(int CallSign)
{
	printf("\n\n");
	printf("Starting DoublyLinkedList_T Tests:\n");
	printf("----------------------------\n");

	if (CallSign == 1)
	{
		//
	}
	else
	{
		DoublyLinkedList_TT();
	}


}

#endif // DoublyLinkedList_T_C
