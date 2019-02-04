#ifndef TickTackToe_C
#define TickTackToe_C

//Header Files
#include "TickTackToe.h"
//Forward declaration




void TickTackToe_V()
{
  printf("TickTackToe \t\t\tV:1.00\n");
}

void* Create_TTT_Board(void* Nothing)
{
  TTT_t* TTT = (TTT_t*) malloc(sizeof(TTT_t));
  TTT->MovesLeft = 9;
  TTT->Player = 0;
  TTT->Winner = ' ';
  TTT->BoardRep = Create_2D_CMatrix(3,3);
  TTT->Board0 = CreateIntegerMatrix(3,3);
  TTT->Board1 = CreateIntegerMatrix(3,3);
  TTT->InvalidBoard = CreateIntegerMatrix(3,3);
  return (void*)TTT;
}

void* Set_TTT_Board(void* Given_Position)
{
  TTT_t* TTT = (TTT_t*) Given_Position;
  TTT->MovesLeft = 9;
  TTT->Player = 0;
  TTT->Winner = ' ';
  TTT->BoardRep = Create_2D_CMatrix(3,3);
  TTT->Board0 = CreateIntegerMatrix(3,3);
  TTT->Board1 = CreateIntegerMatrix(3,3);
  TTT->InvalidBoard = CreateIntegerMatrix(3,3);
  return (void*)TTT;
}


void* Free_TTT_Board_Element(void* Given_TTT)
{
  if(Given_TTT != NULL)
  {
    TTT_t* TTT = (TTT_t*)Given_TTT;
    //if(TTT->BoardRep!=NULL)
    //{
      Free_2D_CMatrix(TTT->BoardRep);
    //}
    //if(TTT->Board0!=NULL)
    //{
      FreeMatrix(TTT->Board0);
    //}

    FreeMatrix(TTT->Board1);
    FreeMatrix(TTT->InvalidBoard);
  }
  return NULL;
}

void* Free_TTT_Board(void* Given_TTT)
{
  if(Given_TTT != NULL)
  {
    TTT_t* TTT = (TTT_t*)Given_TTT;
    //if(TTT->BoardRep!=NULL)
    //{
      Free_2D_CMatrix(TTT->BoardRep);
    //}
    //if(TTT->Board0!=NULL)
    //{
      FreeMatrix(TTT->Board0);
    //}

    FreeMatrix(TTT->Board1);
    FreeMatrix(TTT->InvalidBoard);
    free(TTT);
  }

  return NULL;
}


//Returns "IMatrix_t* Board = CreateIntegerMatrix(3,3)" with a 'Dropout' filter for valid moves
//Returns 1 in position if move is valid
void* PosibleMoves_TTT(void* Given_TTT)
{
  TTT_t* TTT = (TTT_t*)(Given_TTT);
  IMatrix_t* Board = CreateIntegerMatrix(3,3);
/*
  if(TTT == NULL)
  {
    printf("Board null...\n" );
  }
  if(TTT->Board0 == NULL)
  {
    printf("Board0 null...\n" );
  }
  if(TTT->Board1 == NULL)
  {
    printf("Board1 null...\n" );
  }
  if(TTT->InvalidBoard == NULL)
  {
    printf("InvalidBoard null...\n" );
  }
  */
  _2D_MatrixLoop(Board,
    //printf("i:%d\n",i );
    //printf("j:%d\n",j );
    //printf("Board 0 :%d\n",_2D_CMatrix_Element(TTT->Board0,i,j) );
    //printf("Board 1 :%d\n",_2D_CMatrix_Element(TTT->Board1,i,j) );
    //printf("Board IB:%d\n",_2D_CMatrix_Element(TTT->InvalidBoard,i,j) );
    if(_2D_CMatrix_Element(TTT->Board0,i,j) || _2D_CMatrix_Element(TTT->Board1,i,j) || _2D_CMatrix_Element(TTT->InvalidBoard,i,j))
    {
      _2D_FL_Matrix_Element(Board) = 0;
    }
    else
    {
      _2D_FL_Matrix_Element(Board) = 1;
    }
  )


  return (void*)Board;
}

//Returns 0 if no moves found
//Returns 1 if move found
void* Mark_BlockedTTTMove(void* Given_TTT, int Move)
{
  TTT_t* TTT = (TTT_t*)(Given_TTT);
  int X = Move / 3;
  int Y = Move % 3;


  _2D_MatrixLoop(TTT->Board0,

    if(_2D_CMatrix_Element(TTT->Board0,i,j) || _2D_CMatrix_Element(TTT->Board1,i,j) || _2D_CMatrix_Element(TTT->InvalidBoard,i,j))
    {
      //Do nothing
    }
    else
    {
      if(i == X && j == Y)
      {
        //Mark Position
        _2D_XY_Matrix_Element(TTT->InvalidBoard,X,Y) = 1;
        //_2D_CMatrix_Element(,1,1) = 'X';
        (*(TTT->BoardRep->Array+X*TTT->BoardRep->Y+Y)) = 'B';
        TTT->MovesLeft -=1;
      }

    }
  )


  return (void*)false;
}
//Returns 0 if no moves found
//Returns 1 if move found
void* AnyPosibleMoves_TTT(void* Given_TTT)
{
  TTT_t* TTT = (TTT_t*)(Given_TTT);

  _2D_MatrixLoop(TTT->Board0,
    if(_2D_CMatrix_Element(TTT->Board0,i,j) || _2D_CMatrix_Element(TTT->Board1,i,j))
    {
      //Do nothing
    }
    else
    {
      ReturnVoid(true);
    }
  )


  return (void*)false;
}


//Returns (void*)0(False) if move is invalid
//Returns (void*)1(True) if move is valid
void* Player0_TTT(void* Board_Struct,void* Move_Struct)
{
  TTT_t* TTT = (TTT_t*)Board_Struct;
  int Move = *(int*)Move_Struct;
  int X = Move / 3;
  int Y = Move % 3;

  if(Move < 0 ||
     Move > 8)
  {
    printf("Invalid Move, select between 0-8\n");
    ReturnVoid(false);
  }
  if(_2D_XY_Matrix_Element(TTT->Board0,X,Y)     ||
     _2D_XY_Matrix_Element(TTT->Board1,X,Y)     ||
     _2D_XY_Matrix_Element(TTT->InvalidBoard,X,Y))
     {
       printf("Invalid Move...\n");
       ReturnVoid(false);
     }
  else
  {
    _2D_XY_Matrix_Element(TTT->Board0,X,Y) = 1;
    //_2D_CMatrix_Element(,1,1) = 'X';
    (*(TTT->BoardRep->Array+X*TTT->BoardRep->Y+Y)) = 'X';
    TTT->MovesLeft -=1;
    ReturnVoid(true);
  }
}

//Returns (void*)0(False) if move is invalid
//Returns (void*)1(True) if move is valid
void* Player1_TTT(void* Board_Struct,void* Move_Struct)
{
  TTT_t* TTT = (TTT_t*)Board_Struct;
  int Move = *(int*)Move_Struct;
  int X = Move / 3;
  int Y = Move % 3;

  if(Move < 0 ||
     Move > 8)
  {
    printf("Invalid Move, select between 0-8\n");
    ReturnVoid(false);
  }
  if(_2D_XY_Matrix_Element(TTT->Board0,X,Y)     ||
     _2D_XY_Matrix_Element(TTT->Board1,X,Y)     ||
     _2D_XY_Matrix_Element(TTT->InvalidBoard,X,Y))
     {
       printf("Invalid Move...\n");
       ReturnVoid(false);
     }
  else
  {
    _2D_XY_Matrix_Element(TTT->Board1,X,Y) = 1;
    //_2D_CMatrix_Element(,1,1) = 'X';
    (*(TTT->BoardRep->Array+X*TTT->BoardRep->Y+Y)) = 'O';
    TTT->MovesLeft -=1;
    ReturnVoid(true);
  }
}

//Returns (void*)0(False) if move is invalid
//Returns (void*)1(True) if move is valid
void* PlayerMove_TTT(void* Board_Struct,void* Move_Struct)
{
  TTT_t* TTT = (TTT_t*)Board_Struct;
  int Move = *(int*)Move_Struct;
  int X = Move / 3;
  int Y = Move % 3;

  if(Move < 0 ||
     Move > 8)
  {
    printf("Invalid Move, select between 0-8\n");
    ReturnVoid(false);
  }
  if(_2D_XY_Matrix_Element(TTT->Board0,X,Y)     ||
     _2D_XY_Matrix_Element(TTT->Board1,X,Y)     ||
     _2D_XY_Matrix_Element(TTT->InvalidBoard,X,Y))
     {
       printf("Invalid Move...\n");
       ReturnVoid(false);
     }
  else
  {
    if(TTT->Player == 0)
    {
      _2D_XY_Matrix_Element(TTT->Board0,X,Y) = 1;
      //_2D_CMatrix_Element(,1,1) = 'X';
      (*(TTT->BoardRep->Array+X*TTT->BoardRep->Y+Y)) = 'X';
      TTT->MovesLeft -=1;

      if ( ((TTT_t*)TTT)->Player == 0 )
      {
        //printf("Player:%d\n", ((TTT_t*)TTT)->Player);
        ((TTT_t*)TTT)->Player = 1;
        //printf("Player:%d\n", ((TTT_t*)TTT)->Player);
      }
      else
      {
        //printf("Player:%d\n", ((TTT_t*)TTT)->Player);
        ((TTT_t*)TTT)->Player = 0;
        //printf("Player:%d\n", ((TTT_t*)TTT)->Player);
      }

      ReturnVoid(true);
    }
    else
    {
      _2D_XY_Matrix_Element(TTT->Board1,X,Y) = 1;
      //_2D_CMatrix_Element(,1,1) = 'X';
      (*(TTT->BoardRep->Array+X*TTT->BoardRep->Y+Y)) = 'O';
      TTT->MovesLeft -=1;

      if ( ((TTT_t*)TTT)->Player == 0 )
      {
        //printf("Player:%d\n", ((TTT_t*)TTT)->Player);
        ((TTT_t*)TTT)->Player = 1;
        //printf("Player:%d\n", ((TTT_t*)TTT)->Player);
      }
      else
      {
        //printf("Player:%d\n", ((TTT_t*)TTT)->Player);
        ((TTT_t*)TTT)->Player = 0;
        //printf("Player:%d\n", ((TTT_t*)TTT)->Player);
      }

      ReturnVoid(true);
    }

  }
}
//Return (void*)0(false) if no Winner
//Return (void*)1(true) if no Winner
void* Playable_TTT(void* Board_Struct)
{
  TTT_t* TTT = (TTT_t*)Board_Struct;
  if (TTT->MovesLeft != 0)
  {
    ReturnVoid(1);
  }
  ReturnVoid(0);
}

//Return (void*)0(false) if no Winner
//Return (void*)1(true) if no Winner
void* Winner_TTT(void* Board_Struct)
{
  TTT_t* TTT = (TTT_t*)Board_Struct;
  if(TTT->Winner != ' ')
  {
    ReturnVoid(1);
  }

  if(_2D_CMatrix_Element(TTT->BoardRep,0,0) == _2D_CMatrix_Element(TTT->BoardRep,0,1) &&
     _2D_CMatrix_Element(TTT->BoardRep,0,0) == _2D_CMatrix_Element(TTT->BoardRep,0,2) &&
     _2D_CMatrix_Element(TTT->BoardRep,0,0) != ' ')
  {
    TTT->Winner = _2D_CMatrix_Element(TTT->BoardRep,0,0);
    ReturnVoid(1);
  }
  else if(_2D_CMatrix_Element(TTT->BoardRep,1,0) == _2D_CMatrix_Element(TTT->BoardRep,1,1) &&
     _2D_CMatrix_Element(TTT->BoardRep,1,0) == _2D_CMatrix_Element(TTT->BoardRep,1,2) &&
     _2D_CMatrix_Element(TTT->BoardRep,1,0) != ' ')
  {
    TTT->Winner = _2D_CMatrix_Element(TTT->BoardRep,1,0);
    ReturnVoid(1);
  }
  else if(_2D_CMatrix_Element(TTT->BoardRep,2,0) == _2D_CMatrix_Element(TTT->BoardRep,2,1) &&
       _2D_CMatrix_Element(TTT->BoardRep,2,0) == _2D_CMatrix_Element(TTT->BoardRep,2,2) &&
       _2D_CMatrix_Element(TTT->BoardRep,2,0) != ' ')
    {
      TTT->Winner = _2D_CMatrix_Element(TTT->BoardRep,2,0);
      ReturnVoid(1);
    }
  //Down
  else if(_2D_CMatrix_Element(TTT->BoardRep,0,0) == _2D_CMatrix_Element(TTT->BoardRep,1,0) &&
       _2D_CMatrix_Element(TTT->BoardRep,0,0) == _2D_CMatrix_Element(TTT->BoardRep,2,0) &&
       _2D_CMatrix_Element(TTT->BoardRep,0,0) != ' ')
    {
      TTT->Winner = _2D_CMatrix_Element(TTT->BoardRep,0,0);
      ReturnVoid(1);
    }
  else if(_2D_CMatrix_Element(TTT->BoardRep,0,1) == _2D_CMatrix_Element(TTT->BoardRep,1,1) &&
     _2D_CMatrix_Element(TTT->BoardRep,0,1) == _2D_CMatrix_Element(TTT->BoardRep,2,1) &&
     _2D_CMatrix_Element(TTT->BoardRep,0,1) != ' ')
  {
    TTT->Winner = _2D_CMatrix_Element(TTT->BoardRep,0,1);
    ReturnVoid(1);
  }
  else if(_2D_CMatrix_Element(TTT->BoardRep,0,2) == _2D_CMatrix_Element(TTT->BoardRep,1,2) &&
       _2D_CMatrix_Element(TTT->BoardRep,0,2) == _2D_CMatrix_Element(TTT->BoardRep,2,2) &&
       _2D_CMatrix_Element(TTT->BoardRep,0,2) != ' ')
    {
      TTT->Winner = _2D_CMatrix_Element(TTT->BoardRep,0,2);
      ReturnVoid(1);
    }
  //Diagnal
  else if(_2D_CMatrix_Element(TTT->BoardRep,0,0) == _2D_CMatrix_Element(TTT->BoardRep,1,1) &&
     _2D_CMatrix_Element(TTT->BoardRep,0,0) == _2D_CMatrix_Element(TTT->BoardRep,2,2) &&
     _2D_CMatrix_Element(TTT->BoardRep,0,0) != ' ')
  {
    TTT->Winner = _2D_CMatrix_Element(TTT->BoardRep,0,0);
    ReturnVoid(1);
  }
  else if(_2D_CMatrix_Element(TTT->BoardRep,0,2) == _2D_CMatrix_Element(TTT->BoardRep,1,1) &&
       _2D_CMatrix_Element(TTT->BoardRep,0,2) == _2D_CMatrix_Element(TTT->BoardRep,2,0) &&
       _2D_CMatrix_Element(TTT->BoardRep,0,2) != ' ')
    {
      TTT->Winner = _2D_CMatrix_Element(TTT->BoardRep,0,2);
      ReturnVoid(1);
    }
    else if(_2D_CMatrix_Element(TTT->BoardRep,0,2) == _2D_CMatrix_Element(TTT->BoardRep,1,2) &&
         _2D_CMatrix_Element(TTT->BoardRep,0,2) == _2D_CMatrix_Element(TTT->BoardRep,2,2) &&
         _2D_CMatrix_Element(TTT->BoardRep,0,2) != ' ')
      {
        TTT->Winner = _2D_CMatrix_Element(TTT->BoardRep,0,2);
        ReturnVoid(1);
      }
  if (TTT->MovesLeft == 0)
  {
    TTT->Winner = 'C';
    ReturnVoid(1);
  }
  //No winning combinations and Game not finished
  ReturnVoid(0);
}

//Takes Nothing, and returns (GameRules_t*)
void* Get_TTT_GRules(void* Nothing)
{
  GameRules_t* TTT_Rules = (GameRules_t*)malloc(sizeof(GameRules_t));
  TTT_Rules->InitializeWorld = Create_TTT_Board;
  TTT_Rules->Player0_Moves = PosibleMoves_TTT; //Takes TTT_t
  TTT_Rules->Player1_Moves = PosibleMoves_TTT; //Takes TTT_t
  TTT_Rules->PlayerMove    = PlayerMove_TTT;
  TTT_Rules->Player0       = Player0_TTT;
  TTT_Rules->Player1       = Player1_TTT;

  TTT_Rules->Winner        = Winner_TTT; // TTT_t )-> Bool
  //TTT_Rules->RollOut = Create_TTT_Game;
  TTT_Rules->CopyGame  = MakeCopy_TTT_Game;
  TTT_Rules->FreeGame  = Free_TTT_Board;
  ReturnVoid(TTT_Rules);
}


void Set_MCTS_TTT(MCTS_Handle_t* MCTS_Handle)
{
  MCTS_Handle->GameRules = (GameRules_t*)Get_TTT_GRules(NULL);
}

void* CopyTo_TTT_Game(void* Struct,void* Location)
{
  TTT_t* TTT = (TTT_t*) Struct;
  TTT_t* TTT_copy = (TTT_t*)Location;
  TTT_copy->MovesLeft = (int)TTT->MovesLeft;
  TTT_copy->Winner    = TTT->Winner;
  TTT_copy->Player    = TTT->Player;
//printf("Copying game \n");

  TTT_copy->BoardRep = Copy_CMatrix(TTT->BoardRep);
  TTT_copy->Board0 = MakeCopyIntegerMatrix(TTT->Board0);
  TTT_copy->Board1 = MakeCopyIntegerMatrix(TTT->Board1);
  TTT_copy->InvalidBoard = MakeCopyIntegerMatrix(TTT->InvalidBoard);
//Display_TTT_Game(TTT);
//Display_TTT_Game(TTT_copy);
  return (void*)TTT_copy;
}

void* MakeCopy_TTT_Game(void* Struct)
{
  TTT_t* TTT = (TTT_t*) Struct;
  TTT_t* TTT_copy = (TTT_t*)malloc(sizeof(TTT_t));
  TTT_copy->MovesLeft = (int)TTT->MovesLeft;
  TTT_copy->Winner    = TTT->Winner;
  TTT_copy->Player    = TTT->Player;
//printf("Copying game \n");

  TTT_copy->BoardRep = Copy_CMatrix(TTT->BoardRep);
  TTT_copy->Board0 = MakeCopyIntegerMatrix(TTT->Board0);
  TTT_copy->Board1 = MakeCopyIntegerMatrix(TTT->Board1);
  TTT_copy->InvalidBoard = MakeCopyIntegerMatrix(TTT->InvalidBoard);
//Display_TTT_Game(TTT);
//Display_TTT_Game(TTT_copy);
  return (void*)TTT_copy;
}
//Row Value Should Be 0-2 !
void Print_TTT_Row(TTT_t* TTT,int Row)
{
  printf("%c|",(*(TTT->BoardRep->Array+Row*3)));
  printf("%c|",(*(TTT->BoardRep->Array+Row*3+1)));
  printf("%c", (*(TTT->BoardRep->Array+Row*3+2)));
}
void Display_TTT_Game(TTT_t* TTT)
{
  printf("Location : %p\n",TTT);
  Print_TTT_Row(TTT,0);
  printf("\n");
  Print_TTT_Row(TTT,1);
    printf("\n");
  Print_TTT_Row(TTT,2);
    printf("\n");
    /*
  IMatrix_t* Possiblemoves = (IMatrix_t*) PosibleMoves_TTT(TTT);

  printf("Possible Moves \n");
  PrintIntegerMatrix(Possiblemoves);
  Free_IMatrix(Possiblemoves);

  printf("X Moves \n");
  PrintIntegerMatrix(TTT->Board0);
  printf("Y Moves \n");
  PrintIntegerMatrix(TTT->Board1);
  */
}

float TTT_MCTS_Rollout(MCTS_Handle_t* MCTS_Handle)
{
	//float BP_Value = 0;
	//Game Over?
	if (MCTS_Handle->GameRules->Winner(MCTS_Handle->RollOutGame))
	{
		//Check Who Is Winner
		//Return 1 if won, 0 if loss
    if (((TTT_t*)MCTS_Handle->RollOutGame)->Winner == 'X')
    {
      return 1;
    }
    else if(((TTT_t*)MCTS_Handle->RollOutGame)->Winner == 'O')
    {
      return -1;
    }
    else
    {
      return 0;
    }

	}

  IMatrix_t* PosibleMoves = (IMatrix_t*)MCTS_Handle->GameRules->Player0_Moves((void*)MCTS_Handle->RollOutGame);
  int Move = RandomSelect_IMatrixIndex(PosibleMoves);

  //PrintInt(Move);
  ((GameRules_t*)MCTS_Handle->GameRules)->PlayerMove((TTT_t*)MCTS_Handle->RollOutGame,(void*)&Move);
  //Display_TTT_Game((TTT_t*)MCTS_Handle->RollOutGame);
  //Display_TTT_Game((TTT_t*)MCTS_Handle->RollOutGame);
  Free_IMatrix((IMatrix_t*)PosibleMoves);


//else make random move, and rollout
	return TTT_MCTS_Rollout(MCTS_Handle);
}

float TTT_MCHS_Rollout(MCHS_Handle_t* MCHS_Handle)
{
	//float BP_Value = 0;
	//Game Over?
	if (MCHS_Handle->GameRules->Winner(MCHS_Handle->RollOutGame))
	{
		//Check Who Is Winner
		//Return 1 if won, 0 if loss
    if (((TTT_t*)MCHS_Handle->RollOutGame)->Winner == 'X')
    {
      return 1;
    }
    else if(((TTT_t*)MCHS_Handle->RollOutGame)->Winner == 'O')
    {
      return -1;
    }
    else
    {
      return 0;
    }

	}

  IMatrix_t* PosibleMoves = (IMatrix_t*)MCHS_Handle->GameRules->Player0_Moves((void*)MCHS_Handle->RollOutGame);
  int Move = RandomSelect_IMatrixIndex(PosibleMoves);

  //PrintInt(Move);
  ((GameRules_t*)MCHS_Handle->GameRules)->PlayerMove((TTT_t*)MCHS_Handle->RollOutGame,(void*)&Move);
  //Display_TTT_Game((TTT_t*)MCHS_Handle->RollOutGame);
  //Display_TTT_Game((TTT_t*)MCHS_Handle->RollOutGame);
  Free_IMatrix((IMatrix_t*)PosibleMoves);


//else make random move, and rollout
	return TTT_MCHS_Rollout(MCHS_Handle);
}


void Select_MCTS_TTT_NodeFromDLL_ByValue(MCTS_Node_t** MCTS_Node)
{
	//printf("in  Select_MCTS_NodeFromDLL_UCB1\n");
	MCTS_Node_t* HighestNode = NULL;
	DLL_Handle_t* MCTS_DLL = (*MCTS_Node)->ChildNodes;
	if(MCTS_DLL->ListLength > 0)
	{
		//printf("Morethan one Element\n");

		float HighestValue = 0;
		float FoundValue = (INT_MIN);
		DLL_Node_t* Node = (DLL_Node_t*)MCTS_DLL->First;
		HighestNode = (MCTS_Node_t*)Node->Given_Struct;

		while(Node->Next != NULL)
		{
			FoundValue = ((MCTS_Node_t*)Node->Given_Struct)->Value;
			if(FoundValue > HighestValue)
			{
        //printf("~%d\n",FoundValue);
				HighestNode = (MCTS_Node_t*)Node->Given_Struct;
        HighestValue = FoundValue;
			}
			Node = (DLL_Node_t*)Node->Next;
		}
		FoundValue = ((MCTS_Node_t*)Node->Given_Struct)->Value;

    if(FoundValue > HighestValue)
		{
      //printf("~%d\n",FoundValue);
			HighestNode = (MCTS_Node_t*)Node->Given_Struct;
      HighestValue = FoundValue;
		}
	}
  //printf("ParentNode\n");
    //Display_TTT_Game((TTT_t*)*MCTS_Node);
  //  printf("Child\n");
  //    Display_TTT_Game((TTT_t*)HighestNode);
	if(HighestNode != NULL)
	{
		(*MCTS_Node)->LeafNode = false;
		*MCTS_Node = HighestNode;
	}
  //printf("NewParent\n");
  //  Display_TTT_Game((TTT_t*)*MCTS_Node);
}

void Select_MCTS_TTT_NodeFromDLL_ByAverage(MCTS_Node_t** MCTS_Node)
{
	//printf("in  Select_MCTS_NodeFromDLL_UCB1\n");
	MCTS_Node_t* HighestNode = NULL;
	DLL_Handle_t* MCTS_DLL = (*MCTS_Node)->ChildNodes;
	if(MCTS_DLL->ListLength > 0)
	{
		//printf("Morethan one Element\n");

		float HighestValue = 0;
		float FoundValue = (INT_MIN);
		DLL_Node_t* Node = (DLL_Node_t*)MCTS_DLL->First;
		HighestNode = (MCTS_Node_t*)Node->Given_Struct;

		while(Node->Next != NULL)
		{
			FoundValue = ((MCTS_Node_t*)Node->Given_Struct)->AverageValue;
			if(FoundValue > HighestValue)
			{
        //printf("~%d\n",FoundValue);
				HighestNode = (MCTS_Node_t*)Node->Given_Struct;
        HighestValue = FoundValue;
			}
			Node = (DLL_Node_t*)Node->Next;
		}
		FoundValue = ((MCTS_Node_t*)Node->Given_Struct)->AverageValue;

    if(FoundValue > HighestValue)
		{
      //printf("~%d\n",FoundValue);
			HighestNode = (MCTS_Node_t*)Node->Given_Struct;
      HighestValue = FoundValue;
		}
	}
  //printf("ParentNode\n");
    //Display_TTT_Game((TTT_t*)*MCTS_Node);
  //  printf("Child\n");
  //    Display_TTT_Game((TTT_t*)HighestNode);
	if(HighestNode != NULL)
	{
		(*MCTS_Node)->LeafNode = false;
		*MCTS_Node = HighestNode;
	}
  //printf("NewParent\n");
  //  Display_TTT_Game((TTT_t*)*MCTS_Node);
}
void Select_MCTS_TTT_NodeFromDLL_UCB1(MCTS_Node_t** MCTS_Node)
{
	//printf("in  Select_MCTS_NodeFromDLL_UCB1\n");
	MCTS_Node_t* HighestNode = NULL;
	DLL_Handle_t* MCTS_DLL = (*MCTS_Node)->ChildNodes;
	if(MCTS_DLL->ListLength > 0)
	{
		//printf("Morethan one Element\n");

		float HighestValue = 0;
		float FoundValue = (INT_MIN);
		DLL_Node_t* Node = (DLL_Node_t*)MCTS_DLL->First;
		HighestNode = (MCTS_Node_t*)Node->Given_Struct;

		while(Node->Next != NULL)
		{
			FoundValue = Find_MCTS_UCB1((MCTS_Node_t*)Node->Given_Struct, (*MCTS_Node)->NodeVisits);
			if(FoundValue > HighestValue)
			{
        //printf("~%d\n",FoundValue);
				HighestNode = (MCTS_Node_t*)Node->Given_Struct;
        HighestValue = FoundValue;
			}
			Node = (DLL_Node_t*)Node->Next;
		}
		FoundValue = Find_MCTS_UCB1((MCTS_Node_t*)Node->Given_Struct, (*MCTS_Node)->NodeVisits);

    if(FoundValue > HighestValue)
		{
      //printf("~%d\n",FoundValue);
			HighestNode = (MCTS_Node_t*)Node->Given_Struct;
      HighestValue = FoundValue;
		}
	}
  //printf("ParentNode\n");
    //Display_TTT_Game((TTT_t*)*MCTS_Node);
  //  printf("Child\n");
  //    Display_TTT_Game((TTT_t*)HighestNode);
	if(HighestNode != NULL)
	{
		(*MCTS_Node)->LeafNode = false;
		*MCTS_Node = HighestNode;
	}
  //printf("NewParent\n");
  //  Display_TTT_Game((TTT_t*)*MCTS_Node);
}


void CreateMCTS_TTT_Node_DLL(MCTS_Handle_t* MCTS_Handle)
{
	printf("Started CreateMCTSNode_DLL\n");
  MCTS_Handle->PosibleMoves = MCTS_P0Move_IMatrix(MCTS_Handle->TransversedNode->Board);
	//IMatrix_t* IMatrix = MCTS_Handle->PosibleMoves;
	printf("about to copy Moves Matrix\n");
	//PrintIntegerMatrix(MCTS_Handle->PosibleMoves);
	RunTimeFunction CopyGame = MCTS_Handle->GameRules->CopyGame;
	DLL_Handle_t* DLL_Handle = MCTS_Handle->TransversedNode->ChildNodes;
	//printf("about to Add DLL_Nodes\n");
	//Go Through Each Node, for each 1, Create/CopyGame and add to Handle (Could Also Create Matrix Version)

  _2D_MatrixLoop(MCTS_Handle->PosibleMoves,
    if (_2D_FL_Matrix_Element(MCTS_Handle->PosibleMoves) == 1)
    {
      //printf("Accpeptable Move Found\n");
      //printf("(%d,%d)",i,j);
      //PrintInt(_2D_FL_Matrix_Element(MCTS_Handle->PosibleMoves));
      //printf("ParentNode Depth:%d\n",MCTS_Handle->TransversedNode->Depth);
      DLL_Node_t* NewNode = Create_DLL_Node_WithStruct(Create_MCTS_Node(MCTS_GameRules,MCTS_Handle->TransversedNode->Depth+1));
      ((MCTS_Node_t*)NewNode->Given_Struct)->Board = (void*)CopyGame(MCTS_Handle->TransversedNode->Board);

      if ( ((MCTS_Node_t*)NewNode->Given_Struct)->Player == 0 )
      {
        ((MCTS_Node_t*)NewNode->Given_Struct)->Player = 1;
      }
      else
      {
        ((MCTS_Node_t*)NewNode->Given_Struct)->Player = 0;
      }

      int Move = (i*3 + j);
      //PrintInt(Move);
      //MCTS_GameRules->Player0((TTT_t*)((MCTS_Node_t*)NewNode->Given_Struct)->Board,(void*)&Move);
      PlayerMove_TTT((void*)((MCTS_Node_t*)NewNode->Given_Struct)->Board,(void*)&Move);
      //printf("displayed game , adding node to handle\n");
      Add_Node_To_Handle(NewNode,DLL_Handle);

    }
  )

  FreeMatrix(MCTS_Handle->PosibleMoves);
	//printf("%d - DLLLenght\n", DLL_Handle->ListLength);
  MCTS_Handle->TransversedNode->LeafNode = false;
	MCTS_Handle->TransversedNode->ChildNodes = DLL_Handle;
	//printf("%d - DLLLenght\n", MCTS_Handle->TransversedNode->ChildNodes->ListLength);
}



float Transverse_TTT_MCTS(MCTS_Handle_t* MCTS_Handle,int FromBranch)
{
  //printf("TESting winner\n");

		float BP_Value = 0;
		MCTS_Node_t* Local_MCTS_Node = MCTS_Handle->TransversedNode;
    if (Local_MCTS_Node->End == 1)
    {
      //Local_MCTS_Node->Value += Local_MCTS_Node->EndValue;
      //Local_MCTS_Node->NodeVisits += 1;
      //Local_MCTS_Node->AverageValue = Local_MCTS_Node->Value /Local_MCTS_Node->NodeVisits;
      return Local_MCTS_Node->EndValue;
    }
		//int PlayersMove = MCTS_Handle->PlayersMove;
		//Loop for NodesToSearch
		//printf("Starting Transverse_MCTS:\n");
    //Print_TTT_MCTS_Node(Local_MCTS_Node,0);

    //Print_TTT_MCTS_UCB1(Local_MCTS_Node,0);
    //Print_TTT_MCTS_Handle(Local_MCTS_Node->ChildNodes,0);
		if(Local_MCTS_Node->LeafNode == false)
		{
			//printf("Not a Leaf Node\n");
			//Current Node Leaf node ?
			//if not find UCB1's Best Move

			Select_MCTS_TTT_NodeFromDLL_UCB1(&MCTS_Handle->TransversedNode);
			BP_Value = Transverse_TTT_MCTS(MCTS_Handle,1);
      //printf("\tTransversed TTT BP_Value:%f\n",BP_Value);


			//assign Value, add and return
		}
		else if(Local_MCTS_Node->NodeVisits == 0)
		{
      if(MCTS_Handle->GameRules->Winner(MCTS_Handle->TransversedNode->Board))
      {
        //printf("Found Winning Game \n");
        if (((TTT_t*)MCTS_Handle->TransversedNode->Board)->Winner == 'X')
        {
          //printf("X was found as the Winnter\n");
          Local_MCTS_Node->End = 1;//*MCTS_Handle->TransversedNode->Depth;
          //Local_MCTS_Node->NodeVisits++
          Local_MCTS_Node->EndValue = 1;
          Local_MCTS_Node->Value = INT_MAX;
          Local_MCTS_Node->NodeVisits = 1;
          Local_MCTS_Node->AverageValue = INT_MAX;
          return 1;//*MCTS_Handle->TransversedNode->Depth + 1;
        }
        else if(((TTT_t*)MCTS_Handle->TransversedNode->Board)->Winner == 'O')
        {
          //printf("O was found as the Winnter\n");
          Local_MCTS_Node->End = 1;//
          //Local_MCTS_Node->NodeVisits++;
          Local_MCTS_Node->EndValue = -1;
          Local_MCTS_Node->Value = INT_MAX;
          Local_MCTS_Node->NodeVisits = 1;
          Local_MCTS_Node->AverageValue = INT_MAX;
          return -1;//*MCTS_Handle->TransversedNode->Depth - 1;
        }
        else
        {
          //printf("C was found as the Winnter\n");
          Local_MCTS_Node->End = 1;
          //Local_MCTS_Node->NodeVisits++;
          Local_MCTS_Node->EndValue = 0;
          Local_MCTS_Node->Value = 0;
          Local_MCTS_Node->NodeVisits = 1;
          Local_MCTS_Node->AverageValue = 0;
          return 0;
        }
      }
			//printf("Visits not Zero ->Rolling out\n");

			//No-> so RollOut -> Back Propigate
     //PrintInt(Local_MCTS_Node->NodeVisits)
      MCTS_Handle->RollOutGame = MakeCopy_TTT_Game(MCTS_Handle->TransversedNode->Board);
      //printf("Rollout\n");
      //Display_TTT_Game((TTT_t*)MCTS_Handle->RollOutGame);
			BP_Value = TTT_MCTS_Rollout(MCTS_Handle);
      //BP_Value += Local_MCTS_Node->Depth*BP_Value;
      //BP_Value *= MCTS_Handle->TransversedNode->Depth;
      //printf("\t\tRollout Value:%f\n",BP_Value);
      Free_TTT_Board(MCTS_Handle->RollOutGame);
		}
		else
		{
      CreateMCTS_TTT_Node_DLL(MCTS_Handle);
      Select_MCTS_TTT_NodeFromDLL_UCB1(&MCTS_Handle->TransversedNode);

      BP_Value = Transverse_TTT_MCTS(MCTS_Handle,1);

		}


	//save best move

	//reset Nodes Created
  //printf("BP_Value %f\n", BP_Value);
  if(((TTT_t*)Local_MCTS_Node->Board)->Player == 1)
  {
    //BP_Value *= -1;
  }

	Local_MCTS_Node->Value += BP_Value;

  Local_MCTS_Node->NodeVisits++;
  Local_MCTS_Node->AverageValue = Local_MCTS_Node->Value/Local_MCTS_Node->NodeVisits;


  //Print_TTT_MCTS_Node(Local_MCTS_Node);
	return BP_Value ;
}

void Print_TTT_MCTS_Node(MCTS_Node_t* MCTS_Node,int ParentVisitCount)
{
  printf("---------------------------------------\n");
  printf("MCTS Node: %p\n",MCTS_Node);
  printf("--------------------\n");
  printf("Visits: %d\n",MCTS_Node->NodeVisits);
  printf("AverageValue: %f\n",MCTS_Node->AverageValue);
  printf("LeafNode: %d\n",MCTS_Node->LeafNode);
  //printf("ChildNodes: %d\n",MCTS_Node->ChildNodes->ListLength);
  printf("Find_MCTS_UCB1: %f\n",Find_MCTS_UCB1(MCTS_Node,ParentVisitCount));
  printf("Depth: %d\n",MCTS_Node->Depth);
  printf("--------------------\n");
  Display_TTT_Game((TTT_t*)MCTS_Node->Board);
  printf("^-------------------------------------^\n");
}
void Print_TTT_MCHS_Node(MCHS_Node_t* MCTS_Node,int ParentVisitCount)
{
  printf("---------------------------------------\n");
  printf("MCHS Node: %p\n",MCTS_Node);
  printf("--------------------\n");
  printf("Visits: %d\n",MCTS_Node->NodeVisits);
  printf("AverageValue: %f\n",MCTS_Node->AverageValue);
  printf("LeafNode: %d\n",MCTS_Node->LeafNode);
  //printf("ChildNodes: %d\n",MCTS_Node->ChildNodes->ListLength);
  printf("Find_MCTS_UCB1: %f\n",Find_MCHS_UCB1(MCTS_Node,ParentVisitCount));
  printf("Depth: %d\n",MCTS_Node->Depth);
  printf("--------------------\n");
  Display_TTT_Game((TTT_t*)MCTS_Node->Board);
  printf("^-------------------------------------^\n");
}
void Print_TTT_MCTS_UCB1(MCTS_Node_t* MCTS_Node,int ParentVisitCount)
{
  Print_TTT_MCTS_Node(MCTS_Node,ParentVisitCount);

  DLL_Handle_t* DLL_Handle = MCTS_Node->ChildNodes;
  printf("=====================================\n");
  printf("Child Nodes : %d\n",DLL_Handle->ListLength);
  ParentVisitCount = MCTS_Node->NodeVisits;
  DLL_Transverse(DLL_Handle,
  printf("~Node(UCB1): %f",Find_MCTS_UCB1((MCTS_Node_t*)Node->Given_Struct,ParentVisitCount));
  printf(", Average: %f",((MCTS_Node_t*)Node->Given_Struct)->AverageValue);
  printf(", Value: %f",((MCTS_Node_t*)Node->Given_Struct)->Value);
  printf(", Visits: %d\n",((MCTS_Node_t*)Node->Given_Struct)->NodeVisits);
  printf(", Located at: %p\n",((MCTS_Node_t*)Node->Given_Struct));
  )
  printf("^===================================^\n");
}
void Print_TTT_MCHS_UCB1(MCHS_Node_t* MCHS_Node,int ParentVisitCount)
{
  Print_TTT_MCHS_Node(MCHS_Node,ParentVisitCount);

  DLL_Handle_t* DLL_Handle = MCHS_Node->ChildNodes;
  printf("=====================================\n");
  printf("Child Nodes : %d\n",DLL_Handle->ListLength);
  ParentVisitCount = MCHS_Node->NodeVisits;
  DLL_Transverse(DLL_Handle,
  printf("~Node(UCB1): %f",Find_MCHS_UCB1((MCHS_Node_t*)Node->Given_Struct,ParentVisitCount));
  printf(", Average: %f",((MCHS_Node_t*)Node->Given_Struct)->AverageValue);
  printf(", Value: %f",((MCHS_Node_t*)Node->Given_Struct)->Value);
  printf(", Visits: %d",((MCHS_Node_t*)Node->Given_Struct)->NodeVisits);
  printf(", Located at: %p\n",((MCHS_Node_t*)Node->Given_Struct));
  )
  printf("^===================================^\n");
}
void Print_TTT_MCTS_Handle(MCTS_Node_t* MCTS_Node,int ParentVisitCount)
{
  Print_TTT_MCTS_Node(MCTS_Node,ParentVisitCount);

  DLL_Handle_t* DLL_Handle = MCTS_Node->ChildNodes;
  printf("=====================================\n");
  printf("Child Nodes : %d\n",DLL_Handle->ListLength);
  ParentVisitCount = MCTS_Node->NodeVisits;
  DLL_Transverse(DLL_Handle,
    Print_TTT_MCTS_Node((MCTS_Node_t*)Node->Given_Struct,ParentVisitCount);
    //Print_TTT_MCTS_Tree((MCTS_Node_t*)Node->Given_Struct,ParentVisitCount);
  )
  printf("^===================================^\n");
}
void Print_TTT_MCHS_Handle(MCHS_Node_t* MCTS_Node,int ParentVisitCount)
{
  Print_TTT_MCHS_Node(MCTS_Node,ParentVisitCount);

  DLL_Handle_t* DLL_Handle = MCTS_Node->ChildNodes;
  printf("=====================================\n");
  if(!DLL_Handle == NULL)
  {
    printf("Child Nodes : %d\n",DLL_Handle->ListLength);
    ParentVisitCount = MCTS_Node->NodeVisits;
    DLL_Transverse(DLL_Handle,
      Print_TTT_MCHS_Node((MCHS_Node_t*)Node->Given_Struct,ParentVisitCount);
      //Print_TTT_MCTS_Tree((MCTS_Node_t*)Node->Given_Struct,ParentVisitCount);
    )
  }
  else
  {
    printf("Child Nodes : 0\n");
  }

  printf("^===================================^\n");
}
void Print_TTT_MCTS_Tree(MCTS_Node_t* MCTS_Node,int ParentVisitCount)
{
  Print_TTT_MCTS_Node(MCTS_Node,ParentVisitCount);

  DLL_Handle_t* DLL_Handle = MCTS_Node->ChildNodes;
  printf("=====================================\n");
  printf("Child Nodes : %d\n",DLL_Handle->ListLength);
  ParentVisitCount = MCTS_Node->NodeVisits;
  DLL_Transverse(DLL_Handle,
    Print_TTT_MCTS_Node((MCTS_Node_t*)Node->Given_Struct,ParentVisitCount);
    //Print_TTT_MCTS_Tree((MCTS_Node_t*)Node->Given_Struct,ParentVisitCount);
  )
  printf("^===================================^\n");
}


Hash_t* GetSet_TTT_MCHS_Position(MCHS_Handle_t* MCHS_Handle,TTT_t* Board);
void Set_TTT_MCHS_Node_DLL(MCHS_Handle_t* MCHS_Handle,MCHS_Node_t* MCHS_Node);

void Select_MCHS_TTT_NodeFromDLL_UCB1(MCHS_Node_t** MCHS_Node)
{
	//printf("in  Select_MCTS_NodeFromDLL_UCB1\n");
	MCHS_Node_t* HighestNode = NULL;
	DLL_Handle_t* MCTS_DLL = (*MCHS_Node)->ChildNodes;
	if(MCTS_DLL->ListLength > 0)
	{
		//printf("Morethan one Element\n");

		float HighestValue = 0;
		float FoundValue = (INT_MIN);
		DLL_Node_t* Node = (DLL_Node_t*)MCTS_DLL->First;
		HighestNode = (MCHS_Node_t*)Node->Given_Struct;
    printf("Select_MCHS_TTT_NodeFromDLL_UCB1- \n");
		while(Node->Next != NULL)
		{
      printf("\t Loop Iteration\n");
			FoundValue = Find_MCHS_UCB1((MCHS_Node_t*)Node->Given_Struct, (*MCHS_Node)->NodeVisits);
			if(FoundValue > HighestValue)
			{
        //printf("~%d\n",FoundValue);
				HighestNode = (MCHS_Node_t*)Node->Given_Struct;
        HighestValue = FoundValue;
			}
			Node = (DLL_Node_t*)Node->Next;
		}
		FoundValue = Find_MCHS_UCB1((MCHS_Node_t*)Node->Given_Struct, (*MCHS_Node)->NodeVisits);

    if(FoundValue > HighestValue)
		{
      //printf("~%d\n",FoundValue);
			HighestNode = (MCHS_Node_t*)Node->Given_Struct;
      HighestValue = FoundValue;
		}
	}
  //printf("ParentNode\n");
    //Display_TTT_Game((TTT_t*)*MCTS_Node);
  //  printf("Child\n");
  //    Display_TTT_Game((TTT_t*)HighestNode);
	if(HighestNode != NULL)
	{
    printf("MCHS_Node(Before)    %p,%p\n",MCHS_Node,*MCHS_Node );
    printf("Highest Node is at   %p\n",HighestNode );
		(*MCHS_Node)->LeafNode = false;
		*MCHS_Node = HighestNode;

    printf("MCHS_Node Node is at %p,%p\n",MCHS_Node,*MCHS_Node );
	}


  //printf("NewParent\n");
  //  Display_TTT_Game((TTT_t*)*MCTS_Node);
}

//Transverse_TTT_MCTS
float Transverse_TTT_MCHS(MCHS_Handle_t* MCHS_Handle,int FromBranch)
{
  //printf("TESting winner\n");

		float BP_Value = 0;
		MCHS_Node_t* Local_MCHS_Node = MCHS_Handle->TransversedNode;
    if (Local_MCHS_Node->End == 1)
    {
      return Local_MCHS_Node->EndValue;
    }
		//int PlayersMove = MCHS_Handle->PlayersMove;
		//Loop for NodesToSearch
		//printf("Starting Transverse_MCTS:\n");
    //Print_TTT_MCTS_Node(Local_MCTS_Node,0);

    //Print_TTT_MCTS_UCB1(Local_MCTS_Node,0);
    //Print_TTT_MCTS_Handle(Local_MCTS_Node->ChildNodes,0);
		if(Local_MCHS_Node->LeafNode == false)
		{
			//printf("Not a Leaf Node\n");
			//Current Node Leaf node ?
			//if not find UCB1's Best Move

      printf("\t Loop Iteration 0\n");
      //printf("\t\t\t Before Call MCTS_DLL->ListLength:  at %p\n",MCHS_Handle->TransversedNode );
			Select_MCHS_TTT_NodeFromDLL_UCB1(&MCHS_Handle->TransversedNode);
      //printf("\t\t\t after Call MCTS_DLL->ListLength:  at %p\n",MCHS_Handle->TransversedNode );
      BP_Value = Transverse_TTT_MCHS(MCHS_Handle,1);

		}
		else if(Local_MCHS_Node->NodeVisits == 0)
		{
      if(MCHS_Handle->GameRules->Winner(MCHS_Handle->TransversedNode->Board))
      {
        //printf("Found Winning Game \n");
        if (((TTT_t*)MCHS_Handle->TransversedNode->Board)->Winner == 'X')
        {
          //printf("X was found as the Winnter\n");
          Local_MCHS_Node->End = 1;//*MCHS_Handle->TransversedNode->Depth;
          //Local_MCHS_Node->NodeVisits++
          Local_MCHS_Node->EndValue = 1;
          Local_MCHS_Node->Value = INT_MAX;
          Local_MCHS_Node->NodeVisits = 1;
          Local_MCHS_Node->AverageValue = INT_MAX;
          return 1;//*MCHS_Handle->TransversedNode->Depth + 1;
        }
        else if(((TTT_t*)MCHS_Handle->TransversedNode->Board)->Winner == 'O')
        {
          //printf("O was found as the Winnter\n");
          Local_MCHS_Node->End = 1;//
          //Local_MCHS_Node->NodeVisits++;
          Local_MCHS_Node->EndValue = -1;
          Local_MCHS_Node->Value = INT_MAX;
          Local_MCHS_Node->NodeVisits = 1;
          Local_MCHS_Node->AverageValue = INT_MAX;
          return -1;//*MCHS_Handle->TransversedNode->Depth - 1;
        }
        else
        {
          //printf("C was found as the Winnter\n");
          Local_MCHS_Node->End = 1;
          //Local_MCHS_Node->NodeVisits++;
          Local_MCHS_Node->EndValue = 0;
          Local_MCHS_Node->Value = 0;
          Local_MCHS_Node->NodeVisits = 1;
          Local_MCHS_Node->AverageValue = 0;
          return 0;
        }
      }
			//printf("Visits not Zero ->Rolling out\n");
            printf("\t Loop Iteration 1\n");
			//No-> so RollOut -> Back Propigate
     //PrintInt(Local_MCHS_Node->NodeVisits)
      MCHS_Handle->RollOutGame = MakeCopy_TTT_Game(MCHS_Handle->TransversedNode->Board);
      //printf("Rollout\n");
      //Display_TTT_Game((TTT_t*)MCHS_Handle->RollOutGame);
			BP_Value = TTT_MCHS_Rollout(MCHS_Handle);
      //BP_Value += Local_MCTS_Node->Depth*BP_Value;
      //BP_Value *= MCHS_Handle->TransversedNode->Depth;
      //printf("\t\tRollout Value:%f\n",BP_Value);
      Free_TTT_Board(MCHS_Handle->RollOutGame);
		}
		else
		{
      printf("\t Loop Iteration 2\n");
      printf("Local_MCHS_Node->NodeVisits %d\n",Local_MCHS_Node->NodeVisits);
      Set_TTT_MCHS_Node_DLL(MCHS_Handle,MCHS_Handle->TransversedNode);
      Select_MCHS_TTT_NodeFromDLL_UCB1(&MCHS_Handle->TransversedNode);

      BP_Value = Transverse_TTT_MCHS(MCHS_Handle,1);

		}


	//save best move

	//reset Nodes Created
  //printf("BP_Value %f\n", BP_Value);
  if(((TTT_t*)Local_MCHS_Node->Board)->Player == 1)
  {
    //BP_Value *= -1;
  }

	Local_MCHS_Node->Value += BP_Value;

  Local_MCHS_Node->NodeVisits++;
  Local_MCHS_Node->AverageValue = Local_MCHS_Node->Value/Local_MCHS_Node->NodeVisits;


  //Print_TTT_MCTS_Node(Local_MCHS_Node);
	return BP_Value ;
}

//Location

//Takes TTT Game, finds its hash value, Creates a MCHS_Node and points to the existing
Hash_t* GetSet_TTT_MCHS_Position(MCHS_Handle_t* MCHS_Handle,TTT_t* Board)
{
  int Hash = Get_PJWHash_2D_CMatrix_t(Board->BoardRep);
  int Index = GetIndex_HashTable(MCHS_Handle->HashTable,Hash);
  if(Index==-1)
  {
    MCHS_Node_t* MCHS_Node = Create_MCHS_Node_t(MCHS_Handle->GameRules);
    printf("MCHS_Node    %p\n",MCHS_Node );
    MCHS_Node->Board = Board;

    //GetSet_TTT_MCHS_Node_DLL(MCHS_Handle,MCHS_Node);//Create List of child nodes
    //CreateMCTS_TTT_Node_DLL
    return Push_HashTable(MCHS_Handle->HashTable,(void*)MCHS_Node,Hash);
  }
  printf("GetSet_TTT_MCHS_Position done\n" );
  printf("MCHS_Handle->HashTable[Index] is  At %p\n",MCHS_Handle->HashTable->Table[Index]);
  //printf("MCHS_Handle->HashTable[Index]->Structure is  At %p\n",(&MCHS_Handle->HashTable[Index])->Structure);
  //printf("Board_Hash is  At %p\n",Board_Hash->Structure);
  return (Hash_t*)&MCHS_Handle->HashTable->Table[Index];
}


//CreateMCTS_TTT_Node_DLL
void Set_TTT_MCHS_Node_DLL(MCHS_Handle_t* MCHS_Handle,MCHS_Node_t* MCHS_Node)
{
  //If not ChildNodes DLL then we need to create/account for branches in the game

  if(MCHS_Node->ChildNodes == NULL)
  {
    MCHS_Node->ChildNodes = Create_DLL_Handle();

    printf("Started CreateMCHSNode_DLL\n");
    MCHS_Node->PosibleMoves = (IMatrix_t*)(MCHS_Handle->GameRules->Player0_Moves(MCHS_Node->Board));

    //PrintIntegerMatrix(MCHS_Handle->PosibleMoves);
    RunTimeFunction CopyGame = MCHS_Handle->GameRules->CopyGame;
    DLL_Handle_t* DLL_Handle = MCHS_Node->ChildNodes;
    //printf("about to Add DLL_Nodes\n");
    //Go Through Each Node, for each 1, Create/CopyGame and add to Handle (Could Also Create Matrix Version)

    _2D_MatrixLoop(MCHS_Node->PosibleMoves,
      if (_2D_FL_Matrix_Element(MCHS_Node->PosibleMoves) == 1)
      {
        TTT_t* NewTTT_Game = (TTT_t*) CopyGame(MCHS_Node->Board);
        int Move = (i*3 + j);
        PlayerMove_TTT((void*)NewTTT_Game,(void*)&Move);

        //Here we see if a current board matches this one, if so we add it,
        //if not we just point to it
        int Hash = Get_PJWHash_2D_CMatrix_t(NewTTT_Game->BoardRep);
        Hash_t* Hash_t = PULL_HashTable(MCHS_Handle->HashTable,Hash);
        if(Hash_t == NULL)
        {
          MCHS_Node_t* MCHS_Node = Create_MCHS_Node_t(MCHS_Handle->GameRules);
          MCHS_Node->Board = NewTTT_Game;
          Hash_t = GetSet_TTT_MCHS_Position(MCHS_Handle,NewTTT_Game);//Create List of child nodes
          //CreateMCTS_TTT_Node_DLL
          Push_HashTable(MCHS_Handle->HashTable,(void*)MCHS_Node,Hash);
        }



        DLL_Node_t* NewNode = Create_DLL_Node_WithStruct((void*) Hash_t->Structure);
            printf("NewNode    %p,Structure  %p\n",NewNode,NewNode->Given_Struct );
        Add_Node_To_Handle(NewNode,MCHS_Handle->TransversedNode->ChildNodes);
      }
    )
    FreeMatrix(MCHS_Node->PosibleMoves);
    MCHS_Node->PosibleMoves = NULL;
    MCHS_Node->LeafNode = false;
  }

}

//Print_TTT_MCTS_Node
TTT_t* Simulate_TTT_MCHS_Search(MCHS_Handle_t* MCHS_Handle,TTT_t* Board)
{
  //Find Board Hash value
  Hash_t* Board_Hash = GetSet_TTT_MCHS_Position(MCHS_Handle,Board);
  printf("GetSet_TTT_MCHS_Position complete\n" );
  printf("Board_Hash is  At %p\n",Board_Hash);
  printf("Board_Hash->Structure is  At %p\n",Board_Hash->Structure);
  printf("Comparison  done\n" );
  MCHS_Handle->TransversedNode = (MCHS_Node_t*)Board_Hash->Structure;
  printf("setting  Set_TTT_MCHS_Node_DLL\n");
  Set_TTT_MCHS_Node_DLL(MCHS_Handle,MCHS_Handle->TransversedNode);
  printf("Get Set MCHS DLL\n");

  //Prep for new Search
  //Select it as Node0
  MCHS_Handle->MCHS_Node0      = (MCHS_Node_t*)Board_Hash->Structure;
  MCHS_Handle->TransversedNode = (MCHS_Node_t*)Board_Hash->Structure;

  TTT_t* NewTTT_Game = (TTT_t*) MCHS_Handle->GameRules->CopyGame(Board);
  int Hash = Get_PJWHash_2D_CMatrix_t(NewTTT_Game->BoardRep);
  int Index = GetIndex_HashTable(MCHS_Handle->HashTable,Hash);
  if(Index==-1)
  {
    MCHS_Node_t* MCHS_Node = Create_MCHS_Node_t(MCHS_Handle->GameRules);
    MCHS_Node->Board = NewTTT_Game;
    GetSet_TTT_MCHS_Position(MCHS_Handle,NewTTT_Game);//Create List of child nodes
    //CreateMCTS_TTT_Node_DLL
    Push_HashTable(MCHS_Handle->HashTable,(void*)MCHS_Node,Hash);
  }
  //set Visits to 1
  //(MCHS_Handle->MCTS_Node0->NodeVisits) = 1;

  //MCHS_Handle->NodesSearched = 0;
  //CopyGame




	while(MCHS_Handle->NodesSearched < MCHS_Handle->SearchDepth)
	{

	 MCHS_Handle->TransversedNode = MCHS_Handle->MCHS_Node0;
	 Transverse_TTT_MCHS(MCHS_Handle,1);//Transverse_TTT_MCTS
   printf("NodesSearched :%d\n", MCHS_Handle->NodesSearched);

   //printf("Value  :%f\n", MCHS_Handle->MCHS_Node0->AverageValue);
   //printf("Visits :%d\n", MCHS_Handle->MCHS_Node0->NodeVisits);
   //printf("<--------------------------->\n");
	 MCHS_Handle->NodesSearched++;
 	}

  //printf("BestMove ~?~ \n");
  MCHS_Handle->TransversedNode = MCHS_Handle->MCHS_Node0;
  //TODO Print_TTT_MCHS_UCB1(MCHS_Handle->MCHS_Node0,1);


  Select_MCHS_TTT_NodeFromDLL_UCB1(&MCHS_Handle->TransversedNode);
  //Select_MCHS_TTT_NodeFromDLL_ByValue(&MCHS_Handle->TransversedNode);

  //Print_TTT_MCHS_Node(MCHS_Handle->MCHS_Node0,MCHS_Handle->MCHS_Node0->NodeVisits);
  //Print_TTT_MCHS_Handle(MCHS_Handle->MCHS_Node0,MCHS_Handle->MCHS_Node0->NodeVisits);
     printf("Display_TTT_Game \n");
   Display_TTT_Game((TTT_t*)MCHS_Handle->TransversedNode->Board);
   printf("Display_TTT_Game \n");
  return (TTT_t*) MCHS_Handle->TransversedNode->Board;
  //Free_MCTS_Node(MCHS_Handle->MCHS_Node0);
	//Select Best Move from Select_MCTS_NodeFromDLL_UCB1() all the way down the Search Tree
	//either Return or Display Move
}

TTT_t* Simulate_TTT_MCTS_TreeSearch(MCTS_Handle_t* MCTS_Handle,void* Board)
{
  //Free_TTT_Board(Board);

	if(MCTS_Handle->MCTS_Node0 == NULL)
	{
		(MCTS_Handle->MCTS_Node0) = (MCTS_Node_t*)Create_MCTS_Node(MCTS_GameRules,0);
	}


	//CopyGame
	(MCTS_Handle->MCTS_Node0->Board) = Board; //MCTS_Handle->GameRules->InitializeWorld(NULL);
  (MCTS_Handle->MCTS_Node0->NodeVisits) = 1;
  MCTS_Handle->TransversedNode = MCTS_Handle->MCTS_Node0;
  CreateMCTS_TTT_Node_DLL(MCTS_Handle);

  MCTS_Handle->NodesCreated = 0;



	while(MCTS_Handle->NodesCreated < MCTS_Handle->NodesToSearch)
	{

	 MCTS_Handle->TransversedNode = MCTS_Handle->MCTS_Node0;
	 Transverse_TTT_MCTS(MCTS_Handle,1);
   //printf("Value  :%f\n", MCTS_Handle->MCTS_Node0->AverageValue);
   //printf("Visits :%d\n", MCTS_Handle->MCTS_Node0->NodeVisits);
   //printf("NodesCreated :%d\n", MCTS_Handle->NodesCreated);
   //printf("<--------------------------->\n");
	 MCTS_Handle->NodesCreated++;
 	}

  //printf("BestMove ~?~ \n");
  MCTS_Handle->TransversedNode = MCTS_Handle->MCTS_Node0;
  Print_TTT_MCTS_UCB1(MCTS_Handle->MCTS_Node0,1);
  //Select_MCTS_TTT_NodeFromDLL_UCB1(&MCTS_Handle->TransversedNode);
  Select_MCTS_TTT_NodeFromDLL_ByValue(&MCTS_Handle->TransversedNode);
  Print_TTT_MCTS_Node(MCTS_Handle->TransversedNode,MCTS_Handle->MCTS_Node0->NodeVisits);



  return (TTT_t*) MCTS_Handle->TransversedNode->Board;
  //Free_MCTS_Node(MCTS_Handle->MCTS_Node0);
	//Select Best Move from Select_MCTS_NodeFromDLL_UCB1() all the way down the Search Tree
	//either Return or Display Move
}

void Free_TTT_MCTS_Handle(MCTS_Handle_t* MCTS_Handle)
{
	Free_MCTS_Node(MCTS_Handle->MCTS_Node0);
	free(MCTS_Handle->GameRules);
	free(MCTS_Handle);
}

void TTT_MCTS_TreeSearch_T(int Depth)
{
  printf("MCTS Tests \n");
  printf("Testing with TTT... \n");
  //Create MCTS and Set for TTT
  MCTS_Handle_t* MCTS_Handle = Create_MCTS_Handle(Depth,Get_TTT_GRules);
  //Simulate Game
  //Game
  Simulate_TTT_MCTS_TreeSearch(MCTS_Handle,(void*)Create_TTT_Board(NULL));
  printf("Freeing MCTS \n");
  Free_TTT_MCTS_Handle(MCTS_Handle);
}

void Generic_TTT_T()
{
  TTT_t* TTT = (TTT_t*)Create_TTT_Board(NULL);
  Display_TTT_Game(TTT);

  int move = 0;
  Player0_TTT((void*)TTT,(void*)&move);

  move = 1;
  Player0_TTT((void*)TTT,(void*)&move);
  Display_TTT_Game(TTT);

  if(Winner_TTT((TTT_t*)TTT))
  {
    printf("Winner declared !Player: %c Won!\n",TTT->Winner);
  }
  Display_TTT_Game(TTT);
  PrintInt(8)
  move = 8;
  Player0_TTT((void*)TTT,(void*)&move);
  Display_TTT_Game(TTT);

  if(Winner_TTT((TTT_t*)TTT))
  {
    printf("About to get char\n");
    printf("Winner declared !Player: %c Won!\n",TTT->Winner);
  }
  Free_TTT_Board(TTT);
}

void TTT_Copy_Game_T()
{
  TTT_t* TTT = (TTT_t*)Create_TTT_Board(NULL);
  //Display_TTT_Game(TTT);

  int move = 0;
  Player1_TTT((void*)TTT,(void*)&move);

  move = 1;
  Player1_TTT((void*)TTT,(void*)&move);
  //Copy Game
  Display_TTT_Game(TTT);
  TTT_t* TTT_copy = (TTT_t*)MakeCopy_TTT_Game((TTT_t*)TTT);
  Free_TTT_Board(TTT);
  Display_TTT_Game(TTT_copy);

  if(Winner_TTT((TTT_t*)TTT_copy))
  {
    printf("Winner declared !Player: %c Won!\n",TTT_copy->Winner);
  }
  move = 2;
  Player1_TTT((void*)TTT_copy,(void*)&move);
  //Display_TTT_Game(TTT_copy);

  if(Winner_TTT((TTT_t*)TTT_copy))
  {
    printf("About to get char\n");
    printf("Winner declared !Player: %c Won!\n",TTT_copy->Winner);
  }
  Free_TTT_Board(TTT_copy);
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

#endif // TickTackToe_C
