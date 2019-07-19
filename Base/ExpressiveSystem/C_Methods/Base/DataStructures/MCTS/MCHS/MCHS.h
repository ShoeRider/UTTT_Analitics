#ifndef MCHS_H
#define MCHS_H




//SESB_t (Selection, Expansion, Simulation, and BackPropigation function pointers)

typedef DLL_Handle_t* (*PossibleBreakOuts_f)(void *);
typedef int (*RollOut_f)(void *);
typedef int (*Hash_f)(void *);
typedef bool(*Equivalent_f)(void *,void *);
typedef int (*StopCondition_f)(void *);
typedef int (*PositionValue_f)(void *);

typedef void (*Free_f)(void *);

typedef struct MCHS__FL_t
{
  PossibleBreakOuts_f PossibleBreakOuts;
    //Returns DLL_Handle of Possible Moves

  RollOut_f           RollOut;
    //Takes (void*GivenStruct)
    //Returns integer representing a 'desire' value of the rollout.
       // for example: Win(1)/Tie(0)/Loss(-1)

  Equivalent_f        Equivalent;
  //Takes (void*GivenStruct,void*GivenStruct)
  //Returns boolean value if the two simulations are equalvalent.

  Hash_f              Hash;
    //Takes (void* GivenStruct)
    //Returns int: of the Given GivenStruct's Hash
    //

  StopCondition_f     StopCondition;
    //Takes (void*GivenStruct)
    //Returns integer representing if the GivenStruct has stoped.
       //for example: 0(Continue), else(Stop)

  PositionValue_f   PositionValue;
  //Takes (void*GivenStruct)
  //Returns integer representing a 'desire' value of the rollout.
     // for example: Win(1)/Tie(0)/Loss(-1)

  Free_              Free;
  //Takes (void*GivenStruct)
  //and free's the structure.
}MCHS__FL_t;



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

  int UniqueHash;
  void* GivenStruct;
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
  MCHS__FL_t* MCHS_FL;

} MCHS_t;

MCHS_Node_t* TreeTransversal(MCHS_t* MCHS);
MCHS_Node_t* NodeExpansion(MCHS_t* MCHS, MCHS_Node_t*MCHS_Node);
void RollOut(MCHS_t* MCHS, MCHS_Node_t* MCHS_Node);
void BackPropigation(MCHS_t* MCHS,MCHS_Node_t*MCHS_Node);


#endif //MCHS_H
