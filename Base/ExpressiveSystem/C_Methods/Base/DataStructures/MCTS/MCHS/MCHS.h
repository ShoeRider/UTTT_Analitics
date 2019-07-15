#ifndef MCHS_H
#define MCHS_H


//#include "../../Simulation/Games/TickTackToe/TickTackToe.h"
// Program Header Information ////////////////////////////////////////
/**

* @file
*
* @brief Header file for
* instantiate's The Structues:
*
* @details Specifies:
*
*
* @note None
*/

//SESB_t (Selection, Expansion, Simulation, and BackPropigation function pointers)

typedef DLL_Handle_t* (*PossibleBreakOuts_f)(void *);
typedef int (*RollOut_f)(void *);
typedef int (*Hash_f)(void *);
typedef bool(*Equivalent_f)(void *,void *);
typedef int (*StopCondition_f)(void *);
typedef int (*PositionValue_f)(void *);

typedef void (*Free_f)(void *);

typedef struct PRHS_fl
{
  PossibleBreakOuts_f* PossibleBreakOuts;
    //Returns DLL_Handle of Possible Moves

  RollOut_f*           RollOut;
    //Takes (void*Simulation)
    //Returns integer representing a 'desire' value of the rollout.
       // for example: Win(1)/Tie(0)/Loss(-1)

  Equivalent_f*        Equivalent;
  //Takes (void*Simulation,void*Simulation)
  //Returns boolean value if the two simulations are equalvalent.

  Hash_f*              Hash;
    //Takes (void* Simulation)
    //Returns int: of the Given Simulation's Hash
    //

  StopCondition_f*     StopCondition;
    //Takes (void*Simulation)
    //Returns integer representing if the Simulation has stoped.
       //for example: 1(Stop), 0(Continue)

  PositionValue_f*   PositionValue;
  //Takes (void*Simulation)
  //Returns integer representing a 'desire' value of the rollout.
     // for example: Win(1)/Tie(0)/Loss(-1)

  Free_f*              Free;
  //Takes (void*Simulation)
  //and free's the structure.
}PRHS_fl;



typedef struct MCHS_Node_t
{
  //float RolloutSum;
  float AverageValue;
  float Value;
  float EndValue;
  int Visits;
  int End;
  int Depth;
  int PosibleMoves;
  MCHS_Node_t* Parrent;

  void* Simulation;
  bool ContinueSimulation;
  bool LeafNode;
  DLL_Handle_t* ChildNodes; // To MCTS_Node
} MCHS_Node_t;


typedef struct MCHS_t
{
  HashTable_t* HashTable;

  int DepthSearched;
  int SearchDepth;

  MCHS_Node_t* Node0;

  void* RollOutSimulation;
  PRHS_fl* PRHS;

} MCHS_t;

MCHS_Node_t* TreeTransversal(MCHS_t* MCHS);
MCHS_Node_t* NodeExpansion(MCHS_t* MCHS, MCHS_Node_t*MCHS_Node);
void RollOut(MCHS_t* MCHS, MCHS_Node_t* MCHS_Node);
void BackPropigation(MCHS_t* MCHS,MCHS_Node_t*MCHS_Node);


#endif //MCHS_H
