#ifndef UTickTackToe_MCHS_H
#define UTickTackToe_MCHS_H

#include "../../Base.h"
#include "../TickTackToe/TickTackToe.h"
#include "../Games.h"
#include "../../DataStructures/StringFields.h"
#include "../../DataStructures/MMath.cu"
#include "../../DataStructures/DoublyLinkedList.c"
#include "../../DataStructures/HashTable.h"
#include "../../GameSearch/MCTS/MCTS.c"
#include "../../GameSearch/MCTS/MCHS.c"
#include "UTickTackToe_Base.cu"



typedef int(*UTTT_Move)(UTTT_t* UTTT,int Move);


typedef struct UTTT_MCHS_t
{
  float RolloutValue;
  int NodeVisits;
  UTTT_t* Board;
  GameRules_t* GameRules;

  DLL_Handle_t* TreeBranch;

} UTTT_MCHS_t;



void Set_MCHS_UTTT(MCHS_Handle_t* MCHS_Handle);
float UTTT_MCHS_Rollout(MCHS_Handle_t* MCHS_Handle);
void Select_MCHS_UTTT_NodeFromDLL_ByValue(MCHS_Node_t** MCHS_Node);
void Select_MCHS_UTTT_NodeFromDLL_ByAverage(MCHS_Node_t** MCHS_Node);
void Select_MCHS_UTTT_NodeFromDLL_UCB1(MCHS_Node_t** MCHS_Node);
void CreateMCHS_UTTT_Node_DLL(MCHS_Handle_t* MCHS_Handle);
float Transverse_UTTT_MCHS(MCHS_Handle_t* MCHS_Handle,int FromBranch);
void Print_UTTT_MCHS_Node(MCHS_Node_t* MCHS_Node,int ParentVisitCount);
void Print_UTTT_MCHS_UCB1(MCHS_Node_t* MCHS_Node,int ParentVisitCount);
void Print_UTTT_MCHS_Handle(MCHS_Node_t* MCHS_Node,int ParentVisitCount);
void Print_UTTT_MCHS_Tree(MCHS_Node_t* MCHS_Node,int ParentVisitCount);
void* Simulate_UTTT_MCHS(MCHS_Handle_t* MCHS_Handle,void* Board);
void Free_UTTT_MCHS_Handle(MCHS_Handle_t* MCHS_Handle);

void UTTT_MCHS_T(int Depth,int Game);

void PvC_MCHS_G_UTTT_T0(int Depth);

void Print_UTTT_MCHS_Node(MCHS_Node_t* MCHS_Node,int ParentVisitCount);
void Print_UTTT_MCHS_Handle(MCHS_Node_t* MCHS_Node,int ParentVisitCount);
void Print_UTTT_MCHS_UCB1(MCHS_Node_t* MCHS_Node,int ParentVisitCount);
void Print_UTTT_MCHS_Tree(MCHS_Node_t* MCHS_Node,int ParentVisitCount);
void Play_UTTT_MCHS_T();



Hash_t* GetSet_UTTT_MCHS_Position(MCHS_Handle_t* MCHS_Handle,UTTT_t* Board);
#endif //UTickTackToe_MCHS_H
