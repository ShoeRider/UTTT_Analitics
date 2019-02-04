#ifndef UTickTackToe_Base_C
#define UTickTackToe_Base_C

//Header Files
#include "UTickTackToe_Base.h"
//Forward declaration



void* Free_TTT_BoardMatrix(void* Given_Struct)
{
  TTT_t* TTTGame_Matrix = (TTT_t*)Given_Struct;
  for(int x = 0; x < 9; x++)
  {
    Free_TTT_Board_Element((void*)(TTTGame_Matrix+x));
  }
  free(TTTGame_Matrix);
  return NULL;
}

void* Create_UTTT_Board(void* Nothing)
{
  UTTT_t* UTTT = (UTTT_t*) malloc(sizeof(UTTT_t));
  UTTT->MovesLeft = 81;
  UTTT->Game      = -1;
  UTTT->Player    = 0;
  UTTT->GamesLeft = 9;
  UTTT->Winner    = ' ';
  UTTT->TTTGame_Matrix = (TTT_t*)malloc(sizeof(TTT_t)*9);

  for(int x = 0; x < 9; x++)
  {
    Set_TTT_Board((void*)(UTTT->TTTGame_Matrix+x));
  }

  return (void*)UTTT;
}


void* Free_UTTT_Board(void* Given_UTTT)
{
  UTTT_t* UTTT = (UTTT_t*)Given_UTTT;
  Free_TTT_BoardMatrix((void*)(UTTT->TTTGame_Matrix));
  free(UTTT);
  return NULL;
}


//Returns "IMatrix_t* Board = CreateIntegerMatrix(3,3)" with a 'Dropout' filter for valid moves
//Returns 1 in position if move is valid
void* PosibleMoves_UTTT(void* Given_UTTT)
{
  UTTT_t* UTTT = (UTTT_t*)Given_UTTT;

  IMatrix_t* Board = (IMatrix_t*)PosibleMoves_TTT((UTTT->TTTGame_Matrix+UTTT->Game));

  _2D_MatrixLoop(Board,
    if(_2D_CMatrix_Element(Board,i,j))
    {
      if(!AnyPosibleMoves_TTT(UTTT->TTTGame_Matrix+i*3+j))
      {
        _2D_CMatrix_Element(Board,i,j) = 0;
      }
    }
  )

  return Board;
}


//Returns (void*)0(False) if move is invalid
//Returns (void*)1(True) if move is valid
void* Player0_UTTT(void* Board_Struct,void* Move_Struct)
{
  //UTTT_t* UTTT = (UTTT_t*)Board_Struct;
  int Move = *(int*)Move_Struct;
  //int X = Move / 3;
  //int Y = Move % 3;

  if(Move < 0 ||
     Move > 8)
  {
    printf("Invalid Move, select between 0-8\n");
    ReturnVoid(false);
  }
  /*
  if(_2D_XY_Matrix_Element(UTTT->Board0,X,Y) || _2D_XY_Matrix_Element(UTTT->Board1,X,Y))
     {
       printf("Invalid Move...\n");
       ReturnVoid(false);
     }
  else
  {
    _2D_XY_Matrix_Element(UTTT->Board0,X,Y) = 1;
    //_2D_CMatrix_Element(,1,1) = 'X';
    (*(UTTT->BoardRep->Array+X*UTTT->BoardRep->Y+Y)) = 'X';
    UTTT->MovesLeft -=1;
    ReturnVoid(true);
  }
  */
  return NULL;
}

//Returns (void*)0(False) if move is invalid
//Returns (void*)1(True) if move is valid
void* Player1_UTTT(void* Board_Struct,void* Move_Struct)
{
  //UTTT_t* UTTT = (UTTT_t*)Board_Struct;
  int Move = *(int*)Move_Struct;
  //int X = Move / 3;
  //int Y = Move % 3;

  if(Move < 0 ||
     Move > 8)
  {
    printf("Invalid Move, select between 0-8\n");
    ReturnVoid(false);
  }
  /*
  if(_2D_XY_Matrix_Element(UTTT->Board0,X,Y) || _2D_XY_Matrix_Element(UTTT->Board1,X,Y))
     {
       printf("Invalid Move...\n");
       ReturnVoid(false);
     }
  else
  {
    _2D_XY_Matrix_Element(UTTT->Board1,X,Y) = 1;
    //_2D_CMatrix_Element(,1,1) = 'X';
    (*(UTTT->BoardRep->Array+X*UTTT->BoardRep->Y+Y)) = 'O';
    UTTT->MovesLeft -=1;
    ReturnVoid(true);
  }
  */
  return NULL;
}



//Returns (void*)0(False) if move is invalid
//Returns (void*)1(True) if move is valid
void* PlayerMove_UTTT(void* Board_Struct,void* Move_Struct)
{
  UTTT_t* UTTT = (UTTT_t*)Board_Struct;
  int Move = *(int*)Move_Struct;

  int Game = Move / 9;

  int GameMove = (Move-(Game*9));
  int XMove = GameMove/3;
  int YMove = GameMove%3;

  //printf("UTTT->Game: (%d)\n",UTTT->Game);
  //printf("Board: (%d)\n",Game);
  //printf("Move : (%d,%d)\n",XMove,YMove);
  if(Move < 0 ||
     Move > 80)
  {
    printf("Invalid Move, select between 0-80\n");
    ReturnVoid(false);
  }
  if(Game != UTTT->Game)
  {
    if (UTTT->Game!=-1)
    {
      Display_UTTT_Game(UTTT);
      if(AnyPosibleMoves_TTT(UTTT->TTTGame_Matrix+(UTTT->Game)))
      {
        printf("Invalid Move, Select within Current Game!\n");
        ReturnVoid(false);
      }

    }
  }

  TTT_t* TTT = (UTTT->TTTGame_Matrix+Game);
  TTT_t* Next_TTT = (UTTT->TTTGame_Matrix+GameMove);

  if (!AnyPosibleMoves_TTT(Next_TTT))
  {
    //Invalid Move Made!
    //Sent Block Is FULL!
  }

  if(_2D_XY_Matrix_Element(TTT->Board0,XMove,YMove) || _2D_XY_Matrix_Element(TTT->Board1,XMove,YMove) || _2D_XY_Matrix_Element(TTT->InvalidBoard,XMove,YMove))
     {
       printf("Invalid Move...\n");
       ReturnVoid(false);
     }
  else
  {
    if(UTTT->Player == 0)
    {
      TTT->Player = ((UTTT_t*)UTTT)->Player;
      PlayerMove_TTT((void*)TTT,(void*)&GameMove);
      UTTT->Game = GameMove;
      Winner_TTT(TTT);
      if ( ((UTTT_t*)UTTT)->Player == 0 )
      {
        //printf("Player:%d\n", ((TTT_t*)UTTT)->Player);
        ((UTTT_t*)UTTT)->Player = 1;
        //printf("Player:%d\n", ((TTT_t*)UTTT)->Player);
      }
      else
      {
        //printf("Player:%d\n", ((TTT_t*)TTT)->Player);
        ((UTTT_t*)UTTT)->Player = 0;
        //printf("Player:%d\n", ((TTT_t*)TTT)->Player);
      }

      if (!AnyPosibleMoves_TTT(TTT))
      {
        //Game is Full Mark All corresponding Placements in other Games.
        //accept for the self game
        for(int x = 0; x < 9; x ++)
        {
          Mark_BlockedTTTMove((UTTT->TTTGame_Matrix+x),Game);
        }

      }
      ReturnVoid(true);
    }
    else
    {
      TTT->Player = ((UTTT_t*)UTTT)->Player;
      PlayerMove_TTT((void*)TTT,(void*)&GameMove);
      UTTT->Game = GameMove;
      Winner_TTT(TTT);

      if ( ((UTTT_t*)UTTT)->Player == 0 )
      {
        //printf("Player:%d\n", ((TTT_t*)TTT)->Player);
        ((UTTT_t*)UTTT)->Player = 1;
        //printf("Player:%d\n", ((TTT_t*)TTT)->Player);
      }
      else
      {
        //printf("Player:%d\n", ((TTT_t*)TTT)->Player);
        ((UTTT_t*)UTTT)->Player = 0;
        //printf("Player:%d\n", ((TTT_t*)TTT)->Player);
      }


      if (!AnyPosibleMoves_TTT(TTT))
      {
        //Game is Full Mark All corresponding Placements in other Games.
        //accept for the self game
        for(int x = 0; x < 9; x ++)
        {
          Mark_BlockedTTTMove((UTTT->TTTGame_Matrix+x),Game);
        }

      }
      ReturnVoid(true);
    }

  }
  return NULL;
}


//Return (void*)0(false) if no Winner
//Return (void*)1(true) if no Winner
void* Winner_UTTT(void* Board_Struct)
{

  UTTT_t* UTTT = (UTTT_t*)Board_Struct;
  //if Winner then go
  if(UTTT->Winner != ' ')
  {
    printf("UTTT winner :%c\n",UTTT->Winner );
    ReturnVoid(1);
  }

  UTTT->GamesLeft = 9;
  UTTT->MovesLeft = 0;
  for(int Games = 0 ;Games < 9;Games++)
  {
    UTTT->MovesLeft += ((UTTT->TTTGame_Matrix + Games)->MovesLeft);
    //printf("Game %d\n",Games);
    if((UTTT->TTTGame_Matrix + Games)->Winner != ' ')
    {
        UTTT->GamesLeft -= 1;
    }

  }
//printf("MovesLeft %d\n",)
  if(((UTTT->TTTGame_Matrix)->Winner == (UTTT->TTTGame_Matrix+1)->Winner) &&
     ((UTTT->TTTGame_Matrix)->Winner == (UTTT->TTTGame_Matrix+2)->Winner) &&
      (UTTT->TTTGame_Matrix->Winner != ' '))
  {

    UTTT->Winner = UTTT->TTTGame_Matrix->Winner;
    ReturnVoid(1);
  }
  else if(((UTTT->TTTGame_Matrix)->Winner == (UTTT->TTTGame_Matrix+4)->Winner) &&
          ((UTTT->TTTGame_Matrix)->Winner == (UTTT->TTTGame_Matrix+8)->Winner) &&
          (UTTT->TTTGame_Matrix->Winner != ' '))
    {
      UTTT->Winner = UTTT->TTTGame_Matrix->Winner;
      ReturnVoid(1);
    }
  else if(((UTTT->TTTGame_Matrix)->Winner == (UTTT->TTTGame_Matrix+3)->Winner) &&
          ((UTTT->TTTGame_Matrix)->Winner == (UTTT->TTTGame_Matrix+6)->Winner) &&
          (UTTT->TTTGame_Matrix->Winner != ' '))
    {
      UTTT->Winner = UTTT->TTTGame_Matrix->Winner;
      ReturnVoid(1);
    }
  else if(((UTTT->TTTGame_Matrix+1)->Winner == (UTTT->TTTGame_Matrix+4)->Winner) &&
          ((UTTT->TTTGame_Matrix+1)->Winner == (UTTT->TTTGame_Matrix+7)->Winner) &&
          ((UTTT->TTTGame_Matrix+1)->Winner != ' '))
    {
      UTTT->Winner = (UTTT->TTTGame_Matrix+1)->Winner;
      ReturnVoid(1);
    }
  else if(((UTTT->TTTGame_Matrix+2)->Winner == (UTTT->TTTGame_Matrix+4)->Winner) &&
          ((UTTT->TTTGame_Matrix+2)->Winner == (UTTT->TTTGame_Matrix+6)->Winner) &&
          ((UTTT->TTTGame_Matrix+2)->Winner != ' '))
    {
      UTTT->Winner = (UTTT->TTTGame_Matrix+2)->Winner;
      ReturnVoid(1);
    }
  else if(((UTTT->TTTGame_Matrix+2)->Winner == (UTTT->TTTGame_Matrix+5)->Winner )&&
          ((UTTT->TTTGame_Matrix+2)->Winner == (UTTT->TTTGame_Matrix+8)->Winner )&&
          ((UTTT->TTTGame_Matrix+2)->Winner != ' '))
    {
      UTTT->Winner = (UTTT->TTTGame_Matrix+2)->Winner;
      ReturnVoid(1);
    }
  else if(((UTTT->TTTGame_Matrix+3)->Winner == (UTTT->TTTGame_Matrix+4)->Winner) &&
          ((UTTT->TTTGame_Matrix+3)->Winner == (UTTT->TTTGame_Matrix+5)->Winner) &&
          ((UTTT->TTTGame_Matrix+3)->Winner != ' '))
    {
      UTTT->Winner = (UTTT->TTTGame_Matrix+3)->Winner;
      ReturnVoid(1);
    }
  else if(((UTTT->TTTGame_Matrix+6)->Winner == (UTTT->TTTGame_Matrix+7)->Winner) &&
          ((UTTT->TTTGame_Matrix+6)->Winner == (UTTT->TTTGame_Matrix+8)->Winner) &&
          ((UTTT->TTTGame_Matrix+6)->Winner != ' '))
    {
      UTTT->Winner = (UTTT->TTTGame_Matrix+6)->Winner;
      ReturnVoid(1);
    }

  if (UTTT->MovesLeft == 0 || UTTT->GamesLeft == 0)
  {
    UTTT->Winner = 'C';
    ReturnVoid(1);
  }
  //No winning combinations and Game not finished
  ReturnVoid(0);
}

//Takes Nothing, and returns (GameRules_t*)
void* Get_UTTT_GRules(void* Nothing)
{
  GameRules_t* UTTT_Rules = (GameRules_t*)malloc(sizeof(GameRules_t));
  UTTT_Rules->InitializeWorld = Create_UTTT_Board;
  UTTT_Rules->Player0_Moves = PosibleMoves_UTTT; //Takes TTT_t
  UTTT_Rules->Player1_Moves = PosibleMoves_UTTT; //Takes TTT_t
  UTTT_Rules->PlayerMove    = PlayerMove_UTTT;
  UTTT_Rules->Player0       = Player0_UTTT;
  UTTT_Rules->Player1       = Player1_UTTT;

  UTTT_Rules->Winner        = Winner_UTTT; // TTT_t )-> Bool
  //UTTT_Rules->RollOut = Create_TTT_Game;
  UTTT_Rules->CopyGame   = Copy_UTTT_Game;
  UTTT_Rules->FreeGame   = Free_UTTT_Board;
  ReturnVoid(UTTT_Rules);
}




void* Copy_UTTT_Game(void* Struct)
{
  UTTT_t* UTTT = (UTTT_t*) Struct;
  UTTT_t* UTTT_copy = (UTTT_t*)malloc(sizeof(UTTT_t));


  UTTT_copy->MovesLeft = (int)UTTT->MovesLeft;
  UTTT_copy->Winner    = UTTT->Winner;
  UTTT_copy->Player    = UTTT->Player;
  UTTT_copy->Game      = UTTT->Game;

  UTTT_copy->GamesLeft    = UTTT->GamesLeft;
  UTTT_copy->TTTGame_Matrix = (TTT_t*)malloc(sizeof(TTT_t)*9);
  //printf("Copying game \n");
  for(int x = 0; x < 9; x++)
  {
    //(*(Array+i))
    //
    CopyTo_TTT_Game((void*)(UTTT->TTTGame_Matrix+x),(void*)(UTTT_copy->TTTGame_Matrix+x));
  }

  return (void*)UTTT_copy;
}

void Display_UTTT_Wins(UTTT_t* UTTT)
{
  //Display_TTT_Game(UTTT->TTTGame_Matrix);


  PrintLines(2)
  //printf("~%c\n",*(UTTT->TTTGame_Matrix->BoardRep->Array));
  printf("=======================\n");
  printf("%c|",(UTTT->TTTGame_Matrix)->Winner);
  printf("%c|",(UTTT->TTTGame_Matrix+1)->Winner);
  printf("%c\n", (UTTT->TTTGame_Matrix+2)->Winner);
  printf("-----\n");
  printf("%c|",(UTTT->TTTGame_Matrix+3)->Winner);
  printf("%c|",(UTTT->TTTGame_Matrix+4)->Winner);
  printf("%c\n", (UTTT->TTTGame_Matrix+5)->Winner);
  printf("-----\n");
  printf("%c|",(UTTT->TTTGame_Matrix+6)->Winner);
  printf("%c|",(UTTT->TTTGame_Matrix+7)->Winner);
  printf("%c\n", (UTTT->TTTGame_Matrix+8)->Winner);
  printf("=======================\n");
}

void Display_UTTT_Game(UTTT_t* UTTT)
{
  //Display_TTT_Game(UTTT->TTTGame_Matrix);
  printf("Location      : %p\n",UTTT);
  printf("GamesLeft     : %d\n",UTTT->GamesLeft);
  printf("Player(0-1)   : %d\n",UTTT->Player);
  printf("Game(0-8)     : %d\n",UTTT->Game);
  printf("Winner(X,Y,C,'') : %c\n",UTTT->Winner);

  PrintLines(2)
  Display_UTTT_Wins( UTTT);
  //printf("~%c\n",*(UTTT->TTTGame_Matrix->BoardRep->Array));
  printf("=======================\n");
  for(int x = 0; x < 3; x++)
  {
    for(int i = 0; i<3;i++)
    {
      for(int j = 0; j<3;j++)
      {
        Print_TTT_Row((TTT_t*)(UTTT->TTTGame_Matrix+x*3+j), i);
        printf(" | ");
      }
      printf("\n----- | ----- | -----\n");
    }
    printf("=======================");
    printf("\n");
  }

}









void Generic_UTTT_T()
{
  UTTT_t* UTTT = (UTTT_t*)Create_UTTT_Board(NULL);
  //Display_UTTT_Game(UTTT);
  //int move = 0;
  //Player0_UTTT((void*)UTTT,(void*)&move);

  //move = 1;
  //Player0_UTTT((void*)UTTT,(void*)&move);
  //Display_UTTT_Game(UTTT);

  if(Winner_UTTT((UTTT_t*)UTTT))
  {
    printf("Winner declared !Player: %c Won!\n",UTTT->Winner);
  }
  //Display_UTTT_Game(UTTT);

  //move = 8;
  //Player0_UTTT((void*)UTTT,(void*)&move);
  //Display_UTTT_Game(UTTT);

  if(Winner_UTTT((UTTT_t*)UTTT))
  {
    printf("About to get char\n");
    printf("Winner declared !Player: %c Won!\n",UTTT->Winner);
  }
  Free_UTTT_Board(UTTT);
}





void TwoPlayer_UTTT_T()
{
  //TODO:with MCTS Handle'


  UTTT_t* UTTT = (UTTT_t*)Create_UTTT_Board(NULL);
  printf("Welcome to UTTT\n");
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
      if ((int*)PlayerMove_UTTT((void*) UTTT,(void*) &Move))
      {
        printf("Move Made! Player 1's Turn \n");
        Player = 1;
        Display_UTTT_Game(UTTT);
      }
      else
      {
        printf("Invalid Move Please Go again\n");
      }
      if(Winner_UTTT(UTTT))
      {
        Player = -1;
        ActiveGame = false;
      }
    }

    if(Player == 1)
    {
      printf("Player's 1 Turn ! Please Go ! \n");
      GatherTerminalInt("Select Move:",&Move);
      if ((int*)PlayerMove_UTTT((void*) UTTT,(void*) &Move))
      {
        printf("Move Made! Player 0's Turn \n");
        Player = 0;
        Display_UTTT_Game(UTTT);
      }
      else
      {
        printf("Invalid Move Please Go again\n");
      }
      if(Winner_UTTT(UTTT))
      {
        Player = -1;
        ActiveGame = false;
      }

    }
  }
  printf("Winner declared !Player: %c Won!\n",UTTT->Winner);
  Free_UTTT_Board(UTTT);
}



#endif // UTickTackToe_Base_C
