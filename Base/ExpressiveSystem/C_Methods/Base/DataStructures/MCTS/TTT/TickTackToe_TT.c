#ifndef TickTackToe_C_T
#define TickTackToe_C_T

//Header Files
#include "TickTackToe.h"
//Forward declaration




void MallocFree_MCHT_t()
{
  printf("Create_MCHS_TTT_FL\n");
  MCHS__FL_t* MCHS_TTT_FL = Create_MCHS_TTT_FL();

  printf("Create_TTT_t\n");
  TTT_t* TTT    = Create_TTT_t();

  printf("Create_MCHS_t\n");
	MCHS_t* MCHS  = Create_MCHS_t(MCHS_TTT_FL,10,TTT);

  printf("Free \n");
	Free(MCHS);
}

void Copy_TTT_t()
{

  printf("Create_TTT_t\n");
  TTT_t* TTT    = Create_TTT_t();

  TTT_t* Copy0 = Copy(TTT);

  Free(TTT);
  Free(Copy0);
}


void TTT_PossibleBreakOuts()
{
  TTT_t* TTT = Create_TTT_t();
  DLL_Handle_t* Handle  = TTT_PossibleBreakOuts(TTT);

  Free(TTT);
  Free(Handle,(Free_)Free_TTT_t);
}



//TickTackToe Test Terminal
void TTT_TT()
{
  printf("\n\n");
  printf("TickTackToe Test Terminal:\n");
  printf("===================\n");
  int SelectedTest = 0;
  printf("0 = MallocFree_MCHT_t\n");
  printf("1 = Copy_TTT_t()\n");
  printf("2 =  TTT_PossibleBreakOuts()\n");
  printf("4 = \n");
  printf("5 = \n");
  GatherTerminalInt("Please Select a Test:",&SelectedTest);
  if (SelectedTest == 0)
  {
    MallocFree_MCHT_t();
  }
  else if (SelectedTest == 1)
  {
    Copy_TTT_t();
  }
  else if (SelectedTest == 2)
  {
    TTT_PossibleBreakOuts();
  }
  else if (SelectedTest == 5)
  {
    printf("Computer(MCTS_NN) for TTT Not Implemented Yet\n");
  }
}


void TTT_T(int CallSign)
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
    TTT_TT();
  }


}

#endif // TickTackToe_C_T
