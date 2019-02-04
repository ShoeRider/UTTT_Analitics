#ifndef MCHS_H
#define MCHS_H

#include "../../Base.h"
#include "../../DataStructures/DoublyLinkedList.h"
#include "../../DataStructures/StringFields.h"
#include "../../DataStructures/MMath.h"
#include "../../DataStructures/HashTable.h"
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
typedef struct MCTS_HashTable_t
{
  HashTable_t* MCTS_HashTable;
  GameRules_t* GameRules;
} MCTS_HashTable_t;

typedef struct MCHS_Node_t
{
  //float RolloutValue;
  float AverageValue;
  float Value;
  float EndValue;
  int NodeVisits;
  int End;
  int Depth;
  IMatrix_t* PosibleMoves;
  void* Board;
  int Player;
  bool LeafNode;


  GameRules_t* GameRules;
  DLL_Handle_t* ChildNodes; // To MCTS_Node

} MCHS_Node_t;

typedef struct MCHS_Handle_t
{
  int NodeVisits;
  int SearchDepth;
  int NodesSearched;
  int Player;
  int PlayersMove;
  IMatrix_t* PosibleMoves;

  void* RollOutGame;

  GameRules_t* GameRules;
  MCHS_Node_t* TransversedNode;
  MCHS_Node_t* MCHS_Node0;

  int HashSize;
  HashTable_t* HashTable;
} MCHS_Handle_t;




MCHS_Handle_t* Create_MCHS_Handle_t(int SearchDepth,int HashSize,RunTimeFunction GameRules);
MCHS_Node_t* Create_MCHS_Node_t(GameRules_t* GameRules);
void Free_MCHS_Handle_t(MCHS_Handle_t* MCHS_Handle);

#endif //MCHS_H
