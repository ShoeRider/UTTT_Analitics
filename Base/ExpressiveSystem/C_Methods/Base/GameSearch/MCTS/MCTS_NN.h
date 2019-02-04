#ifndef MCTS_NN_H
#define MCTS_NN_H

#include "../../Base.h"
#include "../DoublyLinkedList.h"
#include "../../Threading.h"
#include "../../CharacterOperations.h"
#include "../MMath.h"
#include "MCTS.h"
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



typedef struct MCTS_NNN_t
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

} MCTS_NNN_t;

typedef struct MCTS_NNN_Handle_t
{
  int NodeVisits;
  int NodesToSearch;
  int NodesCreated;

  int Player;
  int PlayersMove;
  IMatrix_t* PosibleMoves;
  void* RollOutGame;
  GameRules_t* GameRules;
  MCTS_NNN_t* TransversedNode;

  MCTS_NNN_t* MCTS_Node0;

} MCTS_NNN_Handle_t;

MCTS_NNN_t* Create_MCTS_NNN_t(GameRules_t* GameRules,int Depth);
//Verison
void MCTS_NN_V();

void MCTS_NN_T();
#endif //MCTS_NN_H
