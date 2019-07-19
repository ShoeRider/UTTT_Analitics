#ifndef TickTackToe_C_T
#define TickTackToe_C_T

//Header Files
#include "TickTackToe.h"
//Forward declaration




void TickTackToe_V()
{
  printf("TickTackToe \t\t\tV:1.00\n");
}



void TwoPlayer_TTT_T()
{
  //TODO:with MCTS Handle'


  TTT_t* TTT = (TTT_t*)Create_TTT_Board(NULL);
  printf("Welcome to TTT\n");
  printf("===============\n");
  int Player = 0;
  int Move = -1;
  bool ActiveGame = true;
  while(ActiveGame)
  {
    if(Player == 0)
    {
      printf("Player's 0 Turn ! Please Go ! \n");
      GatherTerminalInt("Select Move:",&Move);
      if ((int*)Player0_TTT((void*) TTT,(void*) &Move))
      {
        printf("Move Made! Player 1's Turn \n");
        Player = 1;
        Display_TTT_Game(TTT);
      }
      else
      {
        printf("Invalid Move Please Go again\n");
      }
      if(Winner_TTT(TTT))
      {
        Player = -1;
        ActiveGame = false;
      }
    }

    if(Player == 1)
    {
      printf("Player's 1 Turn ! Please Go ! \n");
      GatherTerminalInt("Select Move:",&Move);
      if ((int*)Player1_TTT((void*) TTT,(void*) &Move))
      {
        printf("Move Made! Player 0's Turn \n");
        Player = 0;
        Display_TTT_Game(TTT);
      }
      else
      {
        printf("Invalid Move Please Go again\n");
      }
      if(Winner_TTT(TTT))
      {
        Player = -1;
        ActiveGame = false;
      }

    }
  }
  printf("Winner declared !Player: %c Won!\n",TTT->Winner);
  Free_TTT_Board(TTT);
}




void PvC_TTT_MCTS_TreeSearch(int Depth)
{
  //TODO:integrate with MCTS Handle'


  TTT_t* TTT = (TTT_t*)Create_TTT_Board(NULL);
  printf("Welcome to TTT\n");
  printf("===============\n");
  int Player = 0;
  int Move = -1;
  bool ActiveGame = true;
  while(ActiveGame)
  {
    if(Player == 0)
    {
      printf("Player's 0 Turn ! Please Go ! \n");
      //Project Move
      MCTS_Handle_t* MCTS_Handle = Create_MCTS_Handle(Depth,Get_TTT_GRules);
      TTT_t* Move = Simulate_TTT_MCTS_TreeSearch(MCTS_Handle,(void*)TTT);
      //Free_TTT_Board(TTT);
      Print_TTT_MCTS_UCB1(MCTS_Handle->MCTS_Node0,1);

      TTT = (TTT_t*) MakeCopy_TTT_Game(Move);
      Free_TTT_MCTS_Handle(MCTS_Handle);

      printf("Move Made! Player 1's Turn \n");
      Player = 1;
      Display_TTT_Game(TTT);

      if(Winner_TTT(TTT))
      {
        Player = -1;
        ActiveGame = false;
      }
    }

    if(Player == 1)
    {
      printf("Player's 1 Turn ! Please Go ! \n");
      GatherTerminalInt("Select Move:",&Move);
      if ((int*)PlayerMove_TTT((void*) TTT,(void*) &Move))
      {
        printf("Move Made! Player 0's Turn \n");
        Player = 0;
        Display_TTT_Game(TTT);
      }
      else
      {
        printf("Invalid Move Please Go again\n");
      }
      if(Winner_TTT(TTT))
      {
        Player = -1;
        ActiveGame = false;
      }

    }
  }
  printf("Winner declared !Player: %c Won!\n",TTT->Winner);
  Free_TTT_Board(TTT);
}


void PvC_TTT_MCHS_Search(int Depth)
{
  TTT_t* TTT = (TTT_t*)Create_TTT_Board(NULL);
  //1.4 billion Positions
  printf("Creating MCHS_Handle_t for TTT\n");
  MCHS_Handle_t* MCHS_Handle = Create_MCHS_Handle_t(Depth,1000000,Get_TTT_GRules);
  printf("Welcome to TTT\n");
  printf("===============\n");
  int Player = 0;
  int Move = -1;
  bool ActiveGame = true;
  while(ActiveGame)
  {
    if(Player == 0)
    {
      printf("Player's 0 Turn ! Please Go ! \n");
      //Project Move

      TTT_t* Move = Simulate_TTT_MCHS_Search(MCHS_Handle,TTT);
      //Free_TTT_Board(TTT);
      Print_TTT_MCHS_UCB1(MCHS_Handle->MCHS_Node0,1);

      TTT = (TTT_t*) MakeCopy_TTT_Game((void*)Move);


      printf("Move Made! Player 1's Turn \n");
      Player = 1;
      Display_TTT_Game(TTT);

      if(Winner_TTT(TTT))
      {
        Player = -1;
        ActiveGame = false;
      }
    }

    if(Player == 1)
    {
      printf("Player's 1 Turn ! Please Go ! \n");
      GatherTerminalInt("Select Move:",&Move);
      if ((int*)PlayerMove_TTT((void*) TTT,(void*) &Move))
      {
        printf("Move Made! Player 0's Turn \n");
        Player = 0;
        Display_TTT_Game(TTT);
      }
      else
      {
        printf("Invalid Move Please Go again\n");
      }
      if(Winner_TTT(TTT))
      {
        Player = -1;
        ActiveGame = false;
      }

    }
  }
  printf("Winner declared !Player: %c Won!\n",TTT->Winner);
  Free_TTT_Board(TTT);
  Free_MCHS_Handle_t(MCHS_Handle);
}

//Tick TickTackToe Tree automated Tests
void TTT_Tree_AT()
{
  //printf("Automated TTT_AT selected\n");
  TTT_MCTS_TreeSearch_T(5000);
}
//Tick TickTackToe Tree automated Tests



void TTT_Tree_TT()
{
  printf("\n\n");
  printf("TTT_Tree Test Terminal:\n");
  printf("===================\n");

  int SelectedTest = 0;
  printf("0 = PvC_TTT_MCTS_TreeSearch\n");
  printf("1 = \n");
  printf("2 = \n");
  printf("3 = \n");
  printf("4 = \n");
  GatherTerminalInt("Please Select a Test:",&SelectedTest);
  if (SelectedTest == 0)
  {
    GatherTerminalInt("Please Select a Depth:",&SelectedTest);
    PvC_TTT_MCTS_TreeSearch(SelectedTest);
  }
  else if (SelectedTest == 4)
  {

  }
}

void TTT_HashTable_TT()
{
  printf("\n\n");
  printf("TTT_HashTable Test Terminal:\n");
  printf("===================\n");

  int SelectedTest = 0;
  printf("0 = PvC_TTT_MCTS_HashSearch\n");
  printf("1 = \n");
  printf("2 = \n");
  printf("3 = \n");
  printf("4 = \n");
  GatherTerminalInt("Please Select a Test:",&SelectedTest);
  if (SelectedTest == 0)
  {
    GatherTerminalInt("Please Select a Depth:",&SelectedTest);
    PvC_TTT_MCHS_Search(SelectedTest);
  }
  else if (SelectedTest == 1)
  {

  }
}

//TickTackToe Test Terminal
void TTT_TT()
{
  printf("\n\n");
  printf("TickTackToe Test Terminal:\n");
  printf("===================\n");
  int SelectedTest = 0;
  printf("0 = TTT:Tree      Test Terminal\n");
  printf("1 = TTT:HashTable Test Terminal\n");
  printf("2 = Play 2 Player TTT\n");
  printf("4 = \n");
  printf("5 = TTT Generic Test\n");
  GatherTerminalInt("Please Select a Test:",&SelectedTest);
  if (SelectedTest == 0)
  {
    TTT_Tree_TT();
  }
  else if (SelectedTest == 1)
  {
    TTT_HashTable_TT();
  }
  else if (SelectedTest == 2)
  {
    TwoPlayer_TTT_T();
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
