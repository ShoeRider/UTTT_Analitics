#ifndef DoublyLinkedList_H
#define DoublyLinkedList_H


// Program Header Information ////////////////////////////////////////
/**
* @file DoublyLinkedList.h
*
* @brief Header file for DoublyLinkedList.c
* instantiate's The Structues:
*     -DLL_Node_t (DLL short for DoublyLinkedList)
*     -DLL_Handle_t (DLL short for DoublyLinkedList)
*
* @details Specifies:
*     -PCB(Process Control Block), That keeps track of simulated Programs
* That Run on The Simulated Operating System.
*     -SystemManagement, Keeps track of all information durring RunTime
*
*
* @note None
*/


//DLL - Doubly Linked List
typedef struct DLL_Node_t
{
  void * GivenStruct;
  struct DLL_Node_t *Prev;
  struct DLL_Node_t *Next;
} DLL_Node_t;


//DDL - Doubly Linked List
//This structure acts as a Holding Mechanism to hold a Doubly Linked List
//by tracking the First, and Last Node of the List.
//structure also holds
typedef struct DLL_Handle_t
{
	int Length;
  DLL_Node_t *First;
  DLL_Node_t *Last;
  Mutex_t* Mutex;
} DLL_Handle_t;






#define DLL_Transverse(DLL_Handle,Code)                   \
if(DLL_Handle != NULL)                                    \
{                                                         \
  if(DLL_Handle->Length > 0)                          \
  {                                                       \
    DLL_Node_t* Node = (DLL_Node_t*)DLL_Handle->First;    \
    while(Node->Next != NULL)                             \
    {                                                     \
      Code                                                \
      Node = (DLL_Node_t*)Node->Next;                     \
    }                                                     \
    Code                                                  \
  }                                                       \
}                                                         \

#define DLL_TransverseFree(DLL_Handle,Code)            \
if(DLL_Handle != NULL)                                    \
{                                                         \
  if(DLL_Handle->Length > 0)                          \
  {                                                       \
    DLL_Node_t* Node = (DLL_Node_t*)DLL_Handle->First;    \
    while(Node->Next != NULL)                             \
    {                                                     \
      Code                                                \
      Node = (DLL_Node_t*)Node->Next;                     \
      free(Node->Prev);                                        \
    }                                                     \
    Code                                                  \
    free(Node);                                                \
  }                                                       \
  free(DLL_Handle->Mutex);                                      \
  free(DLL_Handle);                                             \
}                                                         \




#define DLL_TransverseBackward(DLL_Handle,Code)           \
if(DLL_Handle != NULL)                                    \
{                                                         \
  if(DLL_Handle->Length > 0)                          \
  {                                                       \
    DLL_Node_t* Node = (DLL_Node_t*)DLL_Handle->Last;     \
    while(Node->Prev != NULL)                             \
    {                                                     \
      Code                                                \
      Node = (DLL_Node_t*)Node->Prev;                     \
    }                                                     \
    Code                                                  \
  }                                                       \
}                                                         \

#define q2DLL_Transverse(DLL_Handle0,DLL_Handle1,Code)    \
if(DLL_Handle0 != NULL && DLL_Handle1 != NULL)            \
{                                                         \
  if(DLL_Handle0->Length > 0 &&                       \
     DLL_Handle1->Length > 0)                         \
  {                                                       \
    DLL_Node_t* Node0 = (DLL_Node_t*)DLL_Handle0->First;  \
    DLL_Node_t* Node1 = (DLL_Node_t*)DLL_Handle1->First;  \
    while(Node0->Next != NULL && Node1->Next != NULL)     \
    {                                                     \
      Code                                                \
      Node0 = (DLL_Node_t*)Node0->Next;                   \
      Node1 = (DLL_Node_t*)Node1->Next;                   \
    }                                                     \
    Code                                                  \
  }                                                       \
}                                                         \


#define DLL_MethodTransverse(DLL_Handle,Method,Structure) \
if(DLL_Handle != NULL)                                    \
{                                                         \
  if(DLL_Handle->Length > 0)                          \
  {                                                       \
    DLL_Node_t* Node = (DLL_Node_t*)DLL_Handle->First;    \
    while(Node->Next != NULL)                             \
    {                                                     \
       Method((Structure*)Node->GivenStruct);            \
      Node = (DLL_Node_t*)Node->Next;                     \
    }                                                     \
     Method((Structure*)Node->GivenStruct);              \
  }                                                       \
                                                          \
}                                                         \


//TODO Check
#define qGetNUM_MethodSUM_DLL(DLL_Handle,Method,Sum,Structure)   \
if(DLL_Handle != NULL)                                    \
{                                                         \
  if(DLL_Handle->Length > 0)                          \
  {                                                       \
    DLL_Node_t* Node = (DLL_Node_t*)DLL_Handle->First;    \
    while(Node->Next != NULL)                             \
    {                                                     \
      Sum += Method((Structure*)Node->GivenStruct);      \
      Node = (DLL_Node_t*)Node->Next;                     \
    }                                                     \
    Sum += Method((Structure*)Node->GivenStruct);        \
  }                                                       \
                                                          \
}                                                         \

/*
#define QDefineFree_DLL_GivenStruct(DLL_Handle,Method,Structure)  \
void DLL_##Method##_##Structure(DLL_Handle_t* DLL_Handle)       \
{                                                               \
  if(DLL_Handle->Length > 0)                                \
  {                                                             \
    DLL_Node_t* Node1 = (DLL_Node_t*)DLL_Handle->First;         \
    while(Node1->Next != NULL)                                  \
    {                                                           \
      FreeMethod((Structure*)Node1->GivenStruct);              \
      Node1 = (DLL_Node_t*)Node1->Next;                         \
      free(Node1->Prev);                                        \
    }                                                           \
    FreeMethod((Structure*)Node1->GivenStruct);                \
    free(Node1);                                                \
  }                                                             \
  free(DLL_Handle->Mutex);                                      \
  free(DLL_Handle);                                             \
}                                                               \
*/



//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//Free_DLL_Struct_t(DLL_Handle_t* DLL_Handle)
//qDefineFree_DLL_GivenStruct(FreeStructureFunction,Struct_t)
//Copy^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//TODO Change to QDefine... Q - Function Declaration, q-for simple

#define QDefineFree_DLL_GivenStruct(FreeMethod,Structure)       \
void Free_##Structure##_DLL(DLL_Handle_t* DLL_Handle)              \
{                                                               \
  if(DLL_Handle->Length > 0)                                \
  {                                                             \
    DLL_Node_t* Node1 = (DLL_Node_t*)DLL_Handle->First;         \
    while(Node1->Next != NULL)                                  \
    {                                                           \
      FreeMethod((Structure*)Node1->GivenStruct);              \
      Node1 = (DLL_Node_t*)Node1->Next;                         \
      free(Node1->Prev);                                        \
    }                                                           \
    FreeMethod((Structure*)Node1->GivenStruct);                \
    free(Node1);                                                \
  }                                                             \
  free(DLL_Handle->Mutex);                                      \
  free(DLL_Handle);                                             \
}                                                               \




typedef struct TwoHandles_t
{
  void * GivenStruct0;
  DLL_Handle_t *Head0;
  DLL_Handle_t *Head1;
} TwoHandles_t;

//Verison
void DoublyLinkedList_V();
// Function Prototypes
//Create struct Functions
DLL_Node_t* Create_DLL_Node_t();
DLL_Node_t* Create_DLL_Node_t(void* GivenStruct);
DLL_Handle_t* Create_DLL_Handle();




//Addnodes to Doubly Linked List
void Add(DLL_Handle_t* Head,DLL_Node_t* Node);
DLL_Node_t* Add(DLL_Handle_t* Head,void* GivenStruct);

void Add(DLL_Node_t* Node,void* GivenStruct);
void Set(DLL_Node_t* Node,void* GivenStruct);

void AddToStart(DLL_Handle_t* Head,DLL_Node_t* Node);





//free Functions
void* PopFirst(DLL_Handle_t* Head);
void* PopLast(DLL_Handle_t* Head);
void* Pop(DLL_Handle_t* Head,DLL_Node_t* Node);

//void RemoveFirst_Node_From_Handle_T(DLL_Handle_t* Head);
void Free_DirectStructure(DLL_Handle_t* DLL_Handle);
void Free(DLL_Handle_t* DLL_Handle);
void Free(DLL_Handle_t* DLL_Handle,Free_* Free);
#endif //DoublyLinkedList_H
