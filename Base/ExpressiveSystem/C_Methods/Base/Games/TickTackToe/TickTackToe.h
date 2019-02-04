#ifndef TickTackToe_H
#define TickTackToe_H

#include "../../Base.h"
#include "../BaseGames.h"

#include "../../DataStructures/MMath.cu"
#include "../../DataStructures/DoublyLinkedList.c"
#include "../../GameSearch/MCTS/MCTS.c"
#include "../../GameSearch/MCTS/MCHS.c"
#include "../../DataStructures/HashTable.h"
typedef struct TTT_t
{
  _2D_CMatrix_t* BoardRep;
  IMatrix_t* Board0;
  IMatrix_t* Board1;
  IMatrix_t* InvalidBoard;
  int Player;
  char Winner;
  int MovesLeft;
} TTT_t;


typedef int(*TTT_Move)(TTT_t* TTT,int Move);


typedef struct TTT_MCTS_t
{
  float RolloutValue;
  int NodeVisits;
  TTT_t* Board;
  GameRules_t* GameRules;

  DLL_Handle_t* TreeBranch;

} TTT_MCTS_t;



void TickTackToe_V();

void* Create_TTT_Board(void* Nothing);
void* Set_TTT_Board(void* Given_Position);


void* Free_TTT_Board(void* Given_TTT);
void* Free_TTT_Board_Element(void* Given_TTT);

void* Create_TTT_Game(void* Nothing);
void* MakeCopy_TTT_Game(void* Struct);
void* CopyTo_TTT_Game(void* Struct,void* Location);

void* Player0_TTT(void* Board_Struct,void* Move_Struct);
void* Player1_TTT(void* Board_Struct,void* Move_Struct);
void* PlayerMove_TTT(void* Board_Struct,void* Move_Struct);
void* Mark_BlockedTTTMove(void* Given_TTT, int Move);
void* Winner_TTT(void* Board_Struct);

void* PosibleMoves_TTT(void* Given_TTT);

void* AnyPosibleMoves_TTT(void* Given_TTT);
void Print_TTT_Row(TTT_t* TTT,int Row);
void Display_TTT_Game(TTT_t* TTT);

void Print_TTT_MCTS_Node(MCTS_Node_t* MCTS_Node,int ParentVisitCount);
void Print_TTT_MCTS_Handle(MCTS_Node_t* MCTS_Node,int ParentVisitCount);
void Print_TTT_MCTS_UCB1(MCTS_Node_t* MCTS_Node,int ParentVisitCount);
void Print_TTT_MCTS_Tree(MCTS_Node_t* MCTS_Node,int ParentVisitCount);
void TTT_T(int CallSign);
#endif //TickTackToe_H
