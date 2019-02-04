#ifndef UTickTackToe_Base_H
#define UTickTackToe_Base_H

#include "../../Base.h"
#include "../TickTackToe/TickTackToe.h"
#include "../Games.h"
#include "../../DataStructures/StringFields.h"
#include "../../DataStructures/MMath.cu"
#include "../../DataStructures/DoublyLinkedList.c"
#include "../../GameSearch/MCTS/MCTS.c"

typedef struct UTTT_t
{
  TTT_t* TTTGame_Matrix;

  int Player;
  int Game;
  char Winner;
  int MovesLeft;
  int GamesLeft;
} UTTT_t;


typedef int(*UTTT_Move)(UTTT_t* UTTT,int Move);



void TickTackToe_V();

void* Create_UTTT_Game(void* Nothing);
void* Get_UTTT_GRules(void* Nothing);
void* Copy_UTTT_Game(void* Nothing);
void* Winner_UTTT(void* Board_Struct);
void* PlayerMove_UTTT(void* Board_Struct,void* Move_Struct);
void* PosibleMoves_UTTT(void* Given_UTTT);
void* Free_UTTT_Board(void* Given_UTTT);
void* Create_UTTT_Board(void* Nothing);
void* Free_TTT_BoardMatrix(void* Given_Struct);
void* Player0_UTTT(void* Board_Struct,void* Move_Struct);
void* Player1_UTTT(void* Board_Struct,void* Move_Struct);
void Display_UTTT_Game(UTTT_t* UTTT);
void Display_UTTT_Wins(UTTT_t* UTTT);
void TwoPlayer_UTTT_T();

#endif //UTickTackToe_Base_H
