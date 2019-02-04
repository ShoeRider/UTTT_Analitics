#ifndef DoublyLinkedList_C
#define DoublyLinkedList_C

#include "DoublyLinkedList.h"


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
*          -"CharacterOperations.h"
*          -"DoublyLinkedList.h"
*/

/*
* @brief
*
* @details
*
* @example:
*
void *DLL_MutualExclution(void *Head)
{
	DLL_Handle_t* DLL_Handle = (DLL_Handle *)Head;

	double CurrentTime = clock()*.000001;

  //float OperationTimeAsDouble = *OperationTime;

  float OperationFinishTime = CurrentTime + (*OperationTime_pointer)* .000001;

  while(CurrentTime <= OperationFinishTime)
  {
    CurrentTime = clock()*.000001;
  }

	return NULL;
}
*/

void DoublyLinkedList_V()
{
	printf("DoublyLinkedList \tV:2.00\n");
}


//creates space for DLL_Node_t, and returns a pointer
DLL_Node_t* Create_DLL_Node()
{
	DLL_Node_t * DLL_Node_Pointer = (DLL_Node_t *)malloc(sizeof(DLL_Node_t));
	DLL_Node_Pointer->Next = NULL;
	DLL_Node_Pointer->Prev = NULL;
	DLL_Node_Pointer->Given_Struct = NULL;
	return DLL_Node_Pointer;
}
//creates space for DLL_Node_t, and returns a pointer
DLL_Node_t* Create_DLL_Node_WithString(char* Given_String)
{
	char* String =(char *) malloc(sizeof(char)*MAXCHAR);
	DLL_Node_t * DLL_Node_Pointer =(DLL_Node_t*) malloc(sizeof(DLL_Node_t));
	DLL_Node_Pointer->Next=NULL;
	DLL_Node_Pointer->Prev=NULL;
	DLL_Node_Pointer->Given_Struct = String;
	CopyString(Given_String,String);
	return DLL_Node_Pointer;
}





//creates space for DLL_Node_t, and returns a pointer
void AddStructTo_DLL_Node(DLL_Node_t* Node,void* Given_Struct)
{
	if(Node->Given_Struct != NULL)
	{
		free(Node->Given_Struct);
	}
	Node->Given_Struct = Given_Struct;
}


//creates space for DLL_Node_t, and returns a pointer
DLL_Node_t* Create_DLL_Node_WithStruct(void* Given_Struct)
{
	DLL_Node_t * DLL_Node_Pointer =(DLL_Node_t *) malloc(sizeof(DLL_Node_t));
	DLL_Node_Pointer->Next = NULL;
	DLL_Node_Pointer->Prev = NULL;
	DLL_Node_Pointer->Given_Struct = Given_Struct;
	return DLL_Node_Pointer;
}




//creates space for DLL_Handle_t, and returns a pointer
DLL_Handle_t* Create_DLL_Handle()
{
	DLL_Handle_t* DLL_Handle = (DLL_Handle_t*)malloc(sizeof(DLL_Handle_t));
	DLL_Handle->ListLength = 0;

	DLL_Handle->First = NULL;
	DLL_Handle->Last = NULL;

	DLL_Handle->Mutex = (Mutex_t*) malloc(sizeof(Mutex_t));
	DLL_Handle->Mutex->Key = 0;
	DLL_Handle->Mutex->Lock = 0;
	return DLL_Handle;
}

//takes un liked node(DoublyLinkedListNode_t) and adds connections to it
//allso adds it to defined 'head'(DoublyLinkedListHead_t)
DLL_Node_t* RemoveGetFirst_Node_From_Handle_T(DLL_Handle_t* Head)
{
	//Doesnt Delete First Node Just Removes It !!
	DLL_Node_t* Removing = Head->First;
	if(Head->ListLength == 0)								//If Head Has no Nodes, nothing to remove
	{
		//do nothing
		return NULL;
	}
	else if(Head->ListLength == 1)								//If Head Has no Nodes, nothing to remove
	{
		Head->First = NULL;
		Head->Last = NULL;
		Head->ListLength = 0;
		return Removing;
	}
	else
	{
		DLL_Node_t* Temp = (Removing->Next);
		Head->First = ((DLL_Node_t*)Removing->Next);

		Removing->Next = NULL;
		Temp->Prev = NULL;
		Head->ListLength--;
		return Removing;
	}
}


//takes un liked node(DoublyLinkedListNode_t) and adds connections to it
//allso adds it to defined 'head'(DoublyLinkedListHead_t)
DLL_Node_t* RemoveGetLast_Node_From_Handle_T(DLL_Handle_t* Head)
{//TODO Test
	//Doesnt Delete First Node Just Removes It !!
	DLL_Node_t* Removing = Head->Last;
	if(Head->ListLength == 0)								//If Head Has no Nodes, nothing to remove
	{
		//do nothing
		return NULL;
	}
	else if(Head->ListLength == 1)								//If Head Has no Nodes, nothing to remove
	{
		Head->First = NULL;
		Head->Last = NULL;
		Head->ListLength = 0;
		return Removing;
	}
	else
	{
		DLL_Node_t* Temp = (Removing->Prev);
		Head->Last = ((DLL_Node_t*)Temp);

		Removing->Next = NULL;
		Temp->Prev = NULL;
		Head->ListLength--;
		return Removing;
	}
}

//takes un liked node(DoublyLinkedListNode_t) and adds connections to it
//allso adds it to defined 'head'(DoublyLinkedListHead_t)
void AddToEnd_DLLHandle_t(DLL_Node_t* Node, DLL_Handle_t* Head)
{
	DLL_Node_t* Temp = NULL;

	if(Head->ListLength == 0)								//If Head Has no Nodes, Add Single Node
	{
		Head->First = (DLL_Node_t* )Node;
		Head->Last = (DLL_Node_t* )Node;
		Head->ListLength = 1;
	}
	else
	{
		Node->Prev = (DLL_Node_t* )Head->Last;
		Temp = (DLL_Node_t* ) Head->Last;
		Head->Last = (DLL_Node_t* )Node;
		Temp->Next = (DLL_Node_t* )Node;
		Head->ListLength++;
	}
}

void AddToStart_DLLHandle_t(DLL_Node_t* Node, DLL_Handle_t* Head)
{
	DLL_Node_t* Temp = NULL;

	if(Head->ListLength == 0)								//If Head Has no Nodes, Add Single Node
	{
		Head->First = (DLL_Node_t* )Node;
		Head->Last = (DLL_Node_t* )Node;
		Head->ListLength = 1;
	}
	else
	{
		Node->Next = (DLL_Node_t* )Head->First;
		Temp = (DLL_Node_t* ) Head->First;
		Head->First = (DLL_Node_t* )Node;
		Temp->Prev = (DLL_Node_t* )Node;
		Head->ListLength++;
	}
}

//takes un liked node(DoublyLinkedListNode_t) and adds connections to it
//allso adds it to defined 'head'(DoublyLinkedListHead_t)
void Add_Node_To_Handle_T(DLLCall_t* DLLCall)
{
	DLL_Node_t* Temp = NULL;

	if(((DLL_Handle_t *)DLLCall->Head)->ListLength == 0)								//If Head Has no Nodes, Add Single Node
	{
		((DLL_Handle_t *)DLLCall->Head)->First = (DLL_Node_t* )DLLCall->Node;
		((DLL_Handle_t *)DLLCall->Head)->Last = (DLL_Node_t* )DLLCall->Node;
		((DLL_Handle_t *)DLLCall->Head)->ListLength=1;
	}
	else
	{
		((DLL_Node_t*)DLLCall->Node)->Prev = ((DLL_Handle_t*)DLLCall->Head)->Last;
		Temp = ((DLL_Handle_t *)DLLCall->Head)->Last;
		((DLL_Handle_t *)DLLCall->Head)->Last = (DLL_Node_t*)DLLCall->Node;
		Temp->Next = (DLL_Node_t* )DLLCall->Node;
		((DLL_Handle_t *)DLLCall->Head)->ListLength++;
	}
}

//takes a new node(DoublyLinkedListNode_t) and adds it the end of a DLL
//moves required Pointers
void Add_Node_To_Handle(DLL_Node_t* Node, DLL_Handle_t* Head)
{
	DLL_Node_t* Temp = NULL;

	if(Head->ListLength == 0)								//If Head Has no Nodes, Add Single Node
	{
		Head->First = (DLL_Node_t* )Node;
		Head->Last = (DLL_Node_t* )Node;
		Head->ListLength = 1;
	}
	else
	{
		Node->Prev = (DLL_Node_t* )Head->Last;
		Temp = (DLL_Node_t* ) Head->Last;
		Head->Last = (DLL_Node_t* )Node;
		Temp->Next = (DLL_Node_t* )Node;
		Head->ListLength++;
	}
}


//ViewString_Node
//Takes DLL_Node_t and Prints (Node->Given_Struct) as a Character String
void ViewString_Node(DLL_Node_t* Node)
{
  printf("%s\n",(char*)Node->Given_Struct);
}

//ViewString_DLL
//Takes DLL_Handle_t and Loops to each Node printing a string as
// (Node->Given_Struct) as a Character String
void ViewString_DLL(DLL_Handle_t* File_DLL)
{
  printf("Viewing String DLL\n");
	//create Node_Slide that 'Slides' accross the given DLL Nodes
	if((DLL_Node_t*)File_DLL->First!=NULL)
	{
		DLL_Node_t* NodeSlide = (DLL_Node_t*)File_DLL->First;

		//Loop through the DLL untill the end
	  while(NodeSlide->Next != NULL)
	  {
			//Node's String Value
	    ViewString_Node(NodeSlide);
			//then move to Next
	    NodeSlide = (DLL_Node_t*)NodeSlide->Next;
	  }
		//Print the final Node
	  ViewString_Node(NodeSlide);
	}

}



//Takes pointer to Handle and free's all elements within the Linked List
void Free_DLL(DLL_Handle_t* DLL_Handle)
{
	if(DLL_Handle->ListLength > 0)
	{
		DLL_Node_t* Node = (DLL_Node_t*)DLL_Handle->First;
		while(Node->Next != NULL)
		{
			free(Node->Given_Struct);
			Node = (DLL_Node_t*)Node->Next;
			free(Node->Prev);
		}
		free(Node->Given_Struct);
		free(Node);

	}
	free(DLL_Handle->Mutex);
	free(DLL_Handle);
}


#endif // DoublyLinkedList_C
