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

//int Winner_TTT(void* Board_Struct)
//-1: represents no Winner/Game is still ongoing.
//0: represents a tie
//1: represent X as the winner
//2: represent O as the winner
int WinCondition(TTT_t* TTT)
{
  if(TTT->Winner != -1)
  {
    return TTT->Winner;
  }

  //Starting Checks from Center
  if(Get_2dMatrixValue(TTT->Board,1,1) != 0)
  {
    if(Get_2dMatrixValue(TTT->Board,1,0) == Get_2dMatrixValue(TTT->Board,1,1)
    && Get_2dMatrixValue(TTT->Board,1,0) == Get_2dMatrixValue(TTT->Board,1,2))
    {
      TTT->Winner = Get_2dMatrixValue(TTT->Board,1,1);
      return TTT->Winner;
    }
    if(Get_2dMatrixValue(TTT->Board,0,1) == Get_2dMatrixValue(TTT->Board,1,1)
    && Get_2dMatrixValue(TTT->Board,0,1) == Get_2dMatrixValue(TTT->Board,2,1))
    {
      TTT->Winner = Get_2dMatrixValue(TTT->Board,1,1);
      return TTT->Winner;
    }
    //Diagnal
    if(Get_2dMatrixValue(TTT->Board,0,0) == Get_2dMatrixValue(TTT->Board,1,1)
    && Get_2dMatrixValue(TTT->Board,0,0) == Get_2dMatrixValue(TTT->Board,2,2))
    {
      TTT->Winner = Get_2dMatrixValue(TTT->Board,1,1);
      return TTT->Winner;
    }
    //Diagnal
    if(Get_2dMatrixValue(TTT->Board,0,2) == Get_2dMatrixValue(TTT->Board,1,1)
    && Get_2dMatrixValue(TTT->Board,0,2) == Get_2dMatrixValue(TTT->Board,2,0))
    {
      TTT->Winner = Get_2dMatrixValue(TTT->Board,1,1);
      return TTT->Winner;
    }
  }

  //Starting from upper left square
  if(Get_2dMatrixValue(TTT->Board,0,0) != 0)
  {
    if(Get_2dMatrixValue(TTT->Board,0,0) == Get_2dMatrixValue(TTT->Board,0,1)
    && Get_2dMatrixValue(TTT->Board,0,0) == Get_2dMatrixValue(TTT->Board,0,2))
    {
      TTT->Winner = Get_2dMatrixValue(TTT->Board,0,0);
      return TTT->Winner;
    }
    if(Get_2dMatrixValue(TTT->Board,0,0) == Get_2dMatrixValue(TTT->Board,1,0)
    && Get_2dMatrixValue(TTT->Board,0,0) == Get_2dMatrixValue(TTT->Board,2,0))
    {
      TTT->Winner = Get_2dMatrixValue(TTT->Board,0,0);
      return TTT->Winner;
    }
  }

  //Starting from bottom right square
  if(Get_2dMatrixValue(TTT->Board,2,2) != 0)
  {
    if(Get_2dMatrixValue(TTT->Board,2,2) == Get_2dMatrixValue(TTT->Board,0,2)
    && Get_2dMatrixValue(TTT->Board,2,2) == Get_2dMatrixValue(TTT->Board,1,2))
    {
      TTT->Winner = Get_2dMatrixValue(TTT->Board,2,2);
      return TTT->Winner;
    }
    if(Get_2dMatrixValue(TTT->Board,2,2) == Get_2dMatrixValue(TTT->Board,2,1)
    && Get_2dMatrixValue(TTT->Board,2,2) == Get_2dMatrixValue(TTT->Board,2,0))
    {
      TTT->Winner = Get_2dMatrixValue(TTT->Board,2,2);
      return TTT->Winner;
    }
  }
  if (TTT->MovesMade == 9)
  {
    TTT->Winner = 0;
    return TTT->Winner;
  }
  return TTT->Winner;
}

int TTT_StopCondition(void* GivenStruct)
{
  TTT_t* TTT = (TTT_t*)GivenStruct;
  return WinCondition(TTT);
}




//int MakeMove(TTT_t*TTT,int Move)
//Returns: integer
//-2: Invalid Move
//-1: Game Still ongoing
//0: represents a tie
//1: represent X as the winner
//2: represent O as the winner
int MakeMove(TTT_t*TTT,int Move)
{
  if(0 <= Move && Move < 9 && (*(TTT->Board->Array+Move)) == 0)
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

    return WinCondition(TTT);
  }
  return -2;
}

void Print(TTT_t*TTT)
{
  Print(TTT->Board);
}

//Returns DLL_Handle (DoublyLinkedList Handle) containing each Possible Move
//returns a DoublyLinkedList of all posible Game Outcomes
HashTable_t* PossibleBreakOuts(TTT_t* TTT)
{
  HashTable_t* PossibleMoves = Create_HashTable_t();

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

//DLL_Handle_t* TTT_PossibleBreakOuts(void* GivenStruct)
//Short: TypeCast Calls PossibleBreakOuts,
//returns a DoublyLinkedList of all posible Game Outcomes
HashTable_t* TTT_PossibleBreakOuts(void* GivenStruct)
{
  return PossibleBreakOuts((TTT_t*)(GivenStruct));
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

int TTT_RollOut(TTT_t*TTT)
{
  DLLHandle_t* PossibleMoves;
  while(TTT->Winner == -1)
  {
    PossibleMoves = PossibleBreakOuts(TTT);
    PossibleMoves->Length;
  }
  return
}

bool Equivalent(TTT_t*TTT0,TTT_t*TTT1)
{
  return TTT_Equivalent((void*)TTT0,(void*)TTT1);
}


MCHS__FL_t* Create_MCHS_TTT_FL()
{
  MCHS__FL_t* MCHS_FL = (MCHS__FL_t*) malloc(sizeof(MCHS__FL_t));
  MCHS_FL->Free               = Free_TTT_t;
  MCHS_FL->PossibleBreakOuts  = TTT_PossibleBreakOuts;
  MCHS_FL->StopCondition      = TTT_StopCondition;
  return MCHS_FL;
}



#endif // TickTackToe_C
