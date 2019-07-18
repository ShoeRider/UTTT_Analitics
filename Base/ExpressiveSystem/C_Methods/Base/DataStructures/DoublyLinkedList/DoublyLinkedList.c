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
DLL_Node_t* Create_DLL_Node_t()
{
	return Create_DLL_Node_t(NULL);
}


//creates space for DLL_Node_t, and returns a pointer
DLL_Node_t* Create_DLL_Node_t(void* GivenStruct)
{
	DLL_Node_t * DLL_Node_Pointer =(DLL_Node_t *) malloc(sizeof(DLL_Node_t));
	DLL_Node_Pointer->Next = NULL;
	DLL_Node_Pointer->Prev = NULL;
	DLL_Node_Pointer->GivenStruct = GivenStruct;
	return DLL_Node_Pointer;
}



void Set(DLL_Node_t* Node,void* GivenStruct)
{
	if(Node->GivenStruct != NULL)
	{
		free(Node->GivenStruct);
	}
	Node->GivenStruct = GivenStruct;
}




//creates space for DLL_Handle_t, and returns a pointer
DLL_Handle_t* Create_DLL_Handle_t()
{
	DLL_Handle_t* DLL_Handle = (DLL_Handle_t*)malloc(sizeof(DLL_Handle_t));
	DLL_Handle->Length = 0;

	DLL_Handle->First = NULL;
	DLL_Handle->Last = NULL;

	DLL_Handle->Mutex = (Mutex_t*) malloc(sizeof(Mutex_t));
	DLL_Handle->Mutex->Key = 0;
	DLL_Handle->Mutex->Lock = 0;
	return DLL_Handle;
}

//takes un liked node(DoublyLinkedListNode_t) and adds connections to it
//allso adds it to defined 'head'(DoublyLinkedListHead_t)
void* PopFirst(DLL_Handle_t* Head)
{
	//Doesnt Delete First Node Just Removes It !!
	DLL_Node_t* Removing = Head->First;
	if(Head->Length == 0)								//If Head Has no Nodes, nothing to remove
	{
		//do nothing
		return NULL;
	}
	else if(Head->Length == 1)								//If Head Has no Nodes, nothing to remove
	{
		Head->First = NULL;
		Head->Last = NULL;
		Head->Length = 0;
	}
	else
	{
		DLL_Node_t* Temp = (Removing->Next);
		Head->First = ((DLL_Node_t*)Removing->Next);

		Removing->Next = NULL;
		Temp->Prev = NULL;
		Head->Length--;
	}


	if (Removing == NULL)
	{
		//Something went wrong
		return NULL;
	}
	void* GivenStruct = Removing->GivenStruct;
	free(Removing);
	return GivenStruct;
}


//takes un liked node(DoublyLinkedListNode_t) and adds connections to it
//allso adds it to defined 'head'(DoublyLinkedListHead_t)
void* PopLast(DLL_Handle_t* Head)
{//TODO Test
	//Doesnt Delete First Node Just Removes It !!
	DLL_Node_t* Removing = Head->Last;
	if(Head->Length == 0)							//If Head Has no Nodes, nothing to remove
	{
		//do nothing
		return NULL;
	}
	else if(Head->Length == 1)				//Head Has a single Nodes,
	{
		Head->First = NULL;
		Head->Last = NULL;
		Head->Length = 0;
	}
	else
	{
		DLL_Node_t* Temp = (Removing->Prev);
		Head->Last = ((DLL_Node_t*)Temp);

		Removing->Next = NULL;
		Temp->Prev = NULL;
		Head->Length--;
	}


	if (Removing == NULL)
	{
		//Something went wrong
		return NULL;
	}
	void* GivenStruct = Removing->GivenStruct;
	free(Removing);
	return GivenStruct;
}





//takes a new node(DoublyLinkedListNode_t) and adds it the end of a DLL
//moves required Pointers
void Add(DLL_Handle_t* Head,DLL_Node_t* Node)
{
	DLL_Node_t* Temp = NULL;

	if(Head->Length == 0)								//If Head Has no Nodes, Add Single Node
	{
		Head->First = (DLL_Node_t* )Node;
		Head->Last = (DLL_Node_t* )Node;
		Head->Length = 1;
	}
	else
	{
		Node->Prev = (DLL_Node_t* )Head->Last;
		Temp = (DLL_Node_t* ) Head->Last;
		Head->Last = (DLL_Node_t* )Node;
		Temp->Next = (DLL_Node_t* )Node;
		Head->Length++;
	}
}

DLL_Node_t* Add(DLL_Handle_t* Handle,void* GivenStruct)
{
	DLL_Node_t* NewNode = Create_DLL_Node_t(GivenStruct);
	Add(Handle,NewNode);
	return NewNode;
}

void AddToStart(DLL_Handle_t* Head,DLL_Node_t* Node)
{
	DLL_Node_t* Temp = NULL;

	if(Head->Length == 0)								//If Head Has no Nodes, Add Single Node
	{
		Head->First = (DLL_Node_t* )Node;
		Head->Last = (DLL_Node_t* )Node;
		Head->Length = 1;
	}
	else
	{
		Node->Next = (DLL_Node_t* )Head->First;
		Temp = (DLL_Node_t* ) Head->First;
		Head->First = (DLL_Node_t* )Node;
		Temp->Prev = (DLL_Node_t* )Node;
		Head->Length++;
	}
}

//Pop(DLL_Handle_t* Head,DLL_Node_t* Node)
//Retruns:
// 0 : Success
// -1:
void* Pop(DLL_Handle_t* Head,DLL_Node_t* Node)
{
	if (Node == NULL)
	{
		//Something went wrong
		return NULL;
	}

	if(Head->First == Node)
	{
		return PopFirst(Head);
	}
	else if(Head->Last == Node)
	{
		return PopLast(Head);
	}
	else
	{
		Head->Length--;

		DLL_Node_t* Prev = (Node->Prev);
		DLL_Node_t* Next = (Node->Next);
		Prev->Next = Prev;
		Prev->Prev = Next;

		Node->Next = NULL;
		Node->Prev = NULL;

		void* GivenStruct = Node->GivenStruct;
		free(Node);
		return GivenStruct;
	}
}




//Print(HashTable_t* HashTable)
void Print(DLL_Handle_t* Handle)
{
	printf("DLL Handle Located At:%p\n",Handle);
	if (Handle->Length == 0)
	{
		printf("No Nodes added at this time.\n");
	}
	else
	{
	  if(Handle->Length > 0)
	  {
	    DLL_Node_t* Node = (DLL_Node_t*)Handle->First;
			int NodeItteration = 0;
	    while(Node->Next != NULL)
	    {
	      printf("\tNode:%d, Structure:%p\n",NodeItteration, Node->GivenStruct);
	      Node = (DLL_Node_t*)Node->Next;
				NodeItteration++;
	    }
	    printf("\tNode:%d, Structure:%p\n",NodeItteration, Node->GivenStruct);
	  }
	}

}






void Free_DirectStructure(DLL_Handle_t* DLL_Handle)
{
	if(DLL_Handle->Length > 0)
	{
		DLL_Node_t* Node = (DLL_Node_t*)DLL_Handle->First;
		while(Node->Next != NULL)
		{
			Node = (DLL_Node_t*)Node->Next;
			free(Node->Prev);
		}
		free(Node);
	}
	free(DLL_Handle->Mutex);
	free(DLL_Handle);
}

//Takes pointer to Handle and free's all elements within the Linked List
void Free(DLL_Handle_t* DLL_Handle)
{
	if(DLL_Handle->Length > 0)
	{
		DLL_Node_t* Node = (DLL_Node_t*)DLL_Handle->First;
		while(Node->Next != NULL)
		{
			free(Node->GivenStruct);
			Node = (DLL_Node_t*)Node->Next;
			free(Node->Prev);
		}
		free(Node->GivenStruct);
		free(Node);

	}
	free(DLL_Handle->Mutex);
	free(DLL_Handle);
}

void Free(DLL_Handle_t* DLL_Handle,Free_ Free)
{
	if(DLL_Handle->Length > 0)
	{
		DLL_Node_t* Node = (DLL_Node_t*)DLL_Handle->First;
		while(Node->Next != NULL)
		{
			Free(Node->GivenStruct);
			Node = (DLL_Node_t*)Node->Next;
			free(Node->Prev);
		}
		Free(Node->GivenStruct);
		free(Node);

	}
	free(DLL_Handle->Mutex);
	free(DLL_Handle);
}

#endif // DoublyLinkedList_C
