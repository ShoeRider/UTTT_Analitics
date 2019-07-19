#ifndef ExtensibleArray_T_C
#define ExtensibleArray_T_C

#include "ExtensibleArray.c"



void MallocDealloc_ExtensibleArray_T()
{
	ExtensibleArray_T* Array = Create_ExtensibleArray_t(10,sizeof(int));
	Free(Array);
}

//TickTackToe Test Terminal
void ExtensibleArray_TT()
{
  printf("\n\n");
  printf("ExtensibleArray_T Test Terminal:\n");
  printf("===================\n");
  int SelectedTest = 0;
  printf("0 = MallocDealloc_ExtensibleArray_T()\n");
  printf("1 = \n");
  printf("2 = \n");
  printf("4 = \n");
  printf("5 = \n");
  GatherTerminalInt("Please Select a Test:",&SelectedTest);
  if (SelectedTest == 0)
  {
		MallocDealloc_ExtensibleArray_T();
  }
  else if (SelectedTest == 1)
  {

  }
  else if (SelectedTest == 2)
  {

  }
  else if (SelectedTest == 5)
  {

  }
  else if (SelectedTest == 6)
  {

  }
}


void ExtensibleArray_T(int CallSign)
{
  printf("\n\n");
  printf("Tick Tack Toe Tests:\n");
  printf("===================\n");

  if (CallSign == 1)
  {
    //TTT_Tree_AT();
  }
  else
  {
    ExtensibleArray_TT();
  }
}
#endif // ExtensibleArray_T_C
