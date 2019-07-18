#ifndef TickTackToe_C
#define TickTackToe_C

//Header Files
#include "TickTackToe.h"
//Forward declaration


//TTT_t* Create_TTT_t()
//Creates New TickTackToe Game
TTT_t* Create_TTT_t()
{
  TTT_t* TTT = (TTT_t*) malloc(sizeof(TTT_t));
  TTT->Board = Create_IMatrix_t(3,3);
  TTT->Player = 1;
  TTT->Winner = -1;
  TTT->MovesMade = 0;
  return TTT;
}
TTT_t* Copy(TTT_t*TTT)
{
  TTT_t* TTT_Copy = (TTT_t*) malloc(sizeof(TTT_t));
  TTT_Copy->Board     = Copy(TTT->Board);
  TTT_Copy->Player    = TTT->Player;
  TTT_Copy->Winner    = TTT->Winner;
  TTT_Copy->MovesMade = TTT->MovesMade;
  return TTT_Copy;
}

void Free(TTT_t*TTT)
{
  Free(TTT->Board);
  free(TTT);
}
void Free_TTT_t(void*TTT)
{
  printf("Calling F*\n");
  Free((TTT_t*)TTT);
}

int WinCondition(TTT_t* TTT)
{
  
  return 0;
}

//int MakeMove(TTT_t*TTT,int Move)
//Returns: integer
//-1: Invalid Move
//0: Move Made
//1: GameOver
int MakeMove(TTT_t*TTT,int Move)
{
  int Row = Move%3;
  int Col = Move/3;
  printf("Row:%d\n",Row);
  printf("Col:%d\n",Col);
  if((*(TTT->Board->Array+Move)) != 0)
  {
    (*(TTT->Board->Array+Move)) = TTT->Player;
    Print(TTT->Board);

    if(TTT->Player == 1)
    {
      TTT->Player++;
    }
    else
    {
      TTT->Player=1;
    }

    return 0;
  }
  return -1;
}


//Returns "IMatrix_t* Board = CreateIntegerMatrix(3,3)" with a 'Dropout' filter for valid moves
//Returns 1 in position if move is valid
DLL_Handle_t* TTT_PossibleBreakOuts(void* GivenStruct)
{
  TTT_t* TTT = (TTT_t*)(GivenStruct);
  DLL_Handle_t* PossibleMoves = Create_DLL_Handle_t();


  int PositionValue,Move;
  DLL_Node_t* NewNode;
  TTT_t* NewGame;
  _2D_MatrixLoop(TTT->Board,
    //printf("i:%d\n",i );
    //printf("j:%d\n",j );
    //printf("Board 0 :%d\n",_2D_CMatrix_Element(TTT->Board0,i,j) );
    //printf("Board 1 :%d\n",_2D_CMatrix_Element(TTT->Board1,i,j) );
    //printf("Board IB:%d\n",_2D_CMatrix_Element(TTT->InvalidBoard,i,j) );
    Move          = i*TTT->Board->Y+j;
    PositionValue = (*(TTT->Board->Array+Move));

    if(PositionValue == 0)
    {
      NewGame = Copy(TTT);
      MakeMove(NewGame,Move);
      NewNode = Create_DLL_Node_t(NewGame);
      Add(PossibleMoves,NewNode);
    }
  )

  return PossibleMoves;
}


bool TTT_Equivalent(void*GivenStruct0,void*GivenStruct1)
{
  TTT_t* TTT0 = (TTT_t*)GivenStruct0;
  TTT_t* TTT1 = (TTT_t*)GivenStruct1;

  if((TTT0->Player)   != (TTT1->Player)    ||
     (TTT0->MovesMade)!= (TTT1->MovesMade) ||
     (TTT0->Winner)   != (TTT1->Winner)    ||
     Equivalent((TTT0->Board),(TTT1->Board))
   )
   {
     return false;
   }
  return true;
}

MCHS__FL_t* Create_MCHS_TTT_FL()
{
  MCHS__FL_t* MCHS_FL = (MCHS__FL_t*) malloc(sizeof(MCHS__FL_t));
  MCHS_FL->Free               = Free_TTT_t;
  MCHS_FL->PossibleBreakOuts = TTT_PossibleBreakOuts;
  //MCHS_FL->
  return MCHS_FL;
}



#endif // TickTackToe_C
