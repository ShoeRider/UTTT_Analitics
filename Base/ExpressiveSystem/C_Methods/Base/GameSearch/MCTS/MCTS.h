#ifndef MCTS_H
#define MCTS_H

#include "../../Base.h"
#include "../../DataStructures/DoublyLinkedList.c"
#include "../../DataStructures/StringFields.h"
#include "../../DataStructures/MMath.h"

//#include "../../Simulation/Games/TickTackToe/TickTackToe.h"
// Program Header Information ////////////////////////////////////////
/**

* @file DoublyLinkedList.h
*
* @brief Header file for DoublyLinkedList.c
* instantiate's The Structues:
*     -DLL_Node_t (DLL short for DoublyLinkedList)
*     -DLL_Handle_t (DLL short for DoublyLinkedList)
*
* @details Specifies:
*     -PCB(Process Control Block), That keeps track of simulated Programs
* That Run on The Simulated Operating System.
*     -SystemManagement, Keeps track of all information durring RunTime
*
*
* @note None
*/

typedef void *(*PayerMove)(void *Board,void* Move);


typedef struct GameRules_t
{
  RunTimeFunction InitializeWorld;
  RunTimeFunction Player0_Moves;
  PayerMove       Player0;
  RunTimeFunction Player1_Moves;
  PayerMove       Player1;
  PayerMove       PlayerMove;

  RunTimeFunction ManageGame;
  RunTimeFunction CopyGame;
  RunTimeFunction MakeMove;

  RunTimeFunction Winner;

  RunTimeFunction RollOut;
  RunTimeFunction FreeGame;

  //Create Node
} GameRules_t;

typedef struct MCTS_Node_t
{
  //float RolloutValue;
  float AverageValue;
  float Value;
  float EndValue;
  int NodeVisits;
  int End;
  int Depth;

  void* Board;
  int Player;
  bool LeafNode;

  GameRules_t* GameRules;
  DLL_Handle_t* ChildNodes; // To MCTS_Node

} MCTS_Node_t;

typedef struct MCTS_Handle_t
{
  int NodeVisits;
  int NodesToSearch;
  int NodesCreated;

  int Player;
  int PlayersMove;
  IMatrix_t* PosibleMoves;
  void* RollOutGame;
  GameRules_t* GameRules;
  MCTS_Node_t* TransversedNode;

  MCTS_Node_t* MCTS_Node0;

} MCTS_Handle_t;

MCTS_Node_t* Create_MCTS_Node(GameRules_t* GameRules,int Depth);

#define MCTS_GameRules ((GameRules_t*)MCTS_Handle->GameRules)
#define MCTS_P0Move_IMatrix(X) (IMatrix_t*)(MCTS_Handle->GameRules->Player0_Moves(X))
#define MCTS_P0Move_DLL(X) MCTS_P0Move_IMatrix(X)
//Verison
void MCTS_Heap_V();

float Find_MCTS_UCB1(MCTS_Node_t* MCTS_Node,int ParentVisitCount);
float MCTS_Rollout(MCTS_Handle_t* MCTS_Handle);
void Select_MCTS_NodeFromDLL_UCB1(MCTS_Node_t** MCTS_Node);
void CreateMCTSNode_DLL(MCTS_Handle_t* MCTS_Handle);
MCTS_Handle_t* Create_MCTS_Handle(int SearchDepth,RunTimeFunction GameRules);
void Free_MCTS_Handle(MCTS_Handle_t* MCTS_Handle);
void Free_MCTS_Node(MCTS_Node_t* MCTS_Node);
void Simulate_MCTS(MCTS_Handle_t* MCTS_Handle,void* Board);
float Transverse_MCTS(MCTS_Handle_t* MCTS_Handle);
void MCTS_Heap_T();
#endif //MCTS_H
