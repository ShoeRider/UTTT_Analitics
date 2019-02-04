#ifndef UTickTackToe_H
#define UTickTackToe_H

#include "../../Base.h"
#include "../TickTackToe/TickTackToe.h"
#include "../Games.h"
#include "../../DataStructures/StringFields.h"
#include "../../DataStructures/MMath.cu"
#include "../../DataStructures/DoublyLinkedList.c"
#include "../../GameSearch/MCTS/MCTS.c"
#include "UTickTackToe_Base.cu"



typedef int(*UTTT_Move)(UTTT_t* UTTT,int Move);


typedef struct UTTT_MCTS_t
{
  float RolloutValue;
  int NodeVisits;
  UTTT_t* Board;
  GameRules_t* GameRules;

  DLL_Handle_t* TreeBranch;

} UTTT_MCTS_t;



void Set_MCTS_UTTT(MCTS_Handle_t* MCTS_Handle);
float UTTT_MCTS_Rollout(MCTS_Handle_t* MCTS_Handle);
void Select_MCTS_UTTT_NodeFromDLL_ByValue(MCTS_Node_t** MCTS_Node);
void Select_MCTS_UTTT_NodeFromDLL_ByAverage(MCTS_Node_t** MCTS_Node);
void Select_MCTS_UTTT_NodeFromDLL_UCB1(MCTS_Node_t** MCTS_Node);
void CreateMCTS_UTTT_Node_DLL(MCTS_Handle_t* MCTS_Handle);
float Transverse_UTTT_MCTS(MCTS_Handle_t* MCTS_Handle,int FromBranch);
void Print_UTTT_MCTS_Node(MCTS_Node_t* MCTS_Node,int ParentVisitCount);
void Print_UTTT_MCTS_UCB1(MCTS_Node_t* MCTS_Node,int ParentVisitCount);
void Print_UTTT_MCTS_Handle(MCTS_Node_t* MCTS_Node,int ParentVisitCount);
void Print_UTTT_MCTS_Tree(MCTS_Node_t* MCTS_Node,int ParentVisitCount);
void* Simulate_UTTT_MCTS(MCTS_Handle_t* MCTS_Handle,void* Board);
void Free_UTTT_MCTS_Handle(MCTS_Handle_t* MCTS_Handle);

void UTTT_MCTS_T(int Depth,int Game);

void Print_UTTT_MCTS_Node(MCTS_Node_t* MCTS_Node,int ParentVisitCount);
void Print_UTTT_MCTS_Handle(MCTS_Node_t* MCTS_Node,int ParentVisitCount);
void Print_UTTT_MCTS_UCB1(MCTS_Node_t* MCTS_Node,int ParentVisitCount);
void Print_UTTT_MCTS_Tree(MCTS_Node_t* MCTS_Node,int ParentVisitCount);

#endif //UTickTackToe_H
