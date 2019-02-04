#ifndef UTickTackToe_Top_C
#define UTickTackToe_Top_C

//Header Files
#include "UTickTackToe_Top.h"
//Forward declaration




void UTickTackToe_V()
{
  printf("UTickTackToe \t\t\tV:1.00\n");
}



void UTTT_TT()
{
  int SelectedTest = 0;
  int SelectedGame = 0;
  int SelectedDepth = 1000;
  printf("0 = TTT Generic Test\n");
  printf("1 = Test Coordinate System\n");
  printf("2 = MCTS_Generic UTTT Depth Search.\n");
  printf("3 = Play 2 Player UTTT\n");
  printf("4 = Play Game With MCTS\n");
  printf("5 = Play Game With MCHS\n");
  printf("98 = Generic_UTTT_T\n");
  printf("99 = UTTT_Copy_Game_T\n");
  GatherTerminalInt("Please Select Test Move:",&SelectedTest);
  if (SelectedTest == 0)
  {

  }
  else if (SelectedTest == 1)
  {
    //CoordinateSystem_TTT_TT();
  }
  else if (SelectedTest == 2)
  {
    GatherTerminalInt("Please Select Search Starting Game:",&SelectedGame);
    GatherTerminalInt("Please Select a Depth:",&SelectedDepth);
    UTTT_MCTS_T(SelectedDepth,SelectedGame);
  }
  else if (SelectedTest == 3)
  {
    TwoPlayer_UTTT_T();
  }
  else if (SelectedTest == 4)
  {
    //Player vs Computer
    //Monte Carlo Tree Search Generic
    //Ultimate TickTackToe Test
    Play_UTTT_MCTS_T();
  }
  else if (SelectedTest == 5)
  {
     Play_UTTT_MCHS_T();
  }
  else if (SelectedTest == 6)
  {
    printf("Computer(MCTS_NN) for UTTT Not Implemented Yet\n");
  }
  else if (SelectedTest == 98)
  {
    printf("Generic_UTTT_T Not Done -Planed: Never\n");
  }
  else if (SelectedTest == 99)
  {
    //TODO Rename to Copy_UTTT
    printf("UTTT_Copy_Game_T needs to be declared in .h file\n");
    //UTTT_Copy_Game_T();
  }

}


void UTTT_T(int CallSign)
{
  printf("\n\n");
  printf("Ultimate Tick Tack Toe Tests:\n");
  printf("===================\n");

  if (CallSign == 1)
  {
    //UTTT_AT();
  }
  else
  {
    UTTT_TT();
  }


  //
  //TTT_Copy_Game_T();

  //TwoPlayer_TTT_T();
  //PvC_TTT_T(10000);
}

#endif // UTickTackToe_Top_C
