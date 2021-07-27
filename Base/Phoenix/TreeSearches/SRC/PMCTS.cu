#ifndef P_MCTS_CU
#define P_MCTS_CU


#include <iostream>
#include <string>
#include <list>
#include <cmath>
#include <bits/stdc++.h>

#include <thread>
#include <mutex>
#include "TreeSearch.cu"
#include "../SRC/MCTS.cu"
#include "../../ThreadingTools/SRC/ThreadingTools.cu"





class PMCTS_ThreadData_t : public ThreadData_t
{
public:
  PMCTS_ThreadData_t(){
  }
  virtual ~PMCTS_ThreadData_t(){}
};




class PMCTS_Node : public MCTS_Node
{
public:
PMCTS_Node*           Parent       = NULL;
PMCTS_Node*           RollOutChild = NULL;

std::list<PMCTS_Node*> Children;

  PMCTS_Node(Game* Instance){
    GivenGame  = Instance;
    Children   = {};
    NodeVisits = 0;
    ValueSum   = 0;
  }
  PMCTS_Node* RollOut();
  void       BackPropagation(double GivenPlayer);
};


PMCTS_Node* PMCTS_Node::RollOut(){

  Game* RollOutGame = GivenGame->CopyGame();
  RollOutGame->RollOut();

  //printf("RO_WinningPlayer:%p\n",RollOutGame->WinningPlayer);
  //TODO Check if game is finished
  RollOutChild = new PMCTS_Node(RollOutGame);
  RollOutChild->Parent = this;
  return RollOutChild;
}

void PMCTS_Node::BackPropagation(double EvaluatedValue)
{
  NodeVisits++;
  ValueSum += EvaluatedValue;
  if (Parent != NULL)
  {
    Parent->BackPropagation(EvaluatedValue);
  }
}



//Parallel Monte Carlo Tree Search
class PMCTS : public MCTS
{
public:
  ParallelControlBlock PCB;



  PMCTS(Game*_Game,Player* Player):MCTS(_Game,Player){
    HeadNode  = new PMCTS_Node(_Game);
  }
  PMCTS_Node* DispatchAlgorithm(PMCTS_Node* TransversedNode,int Threads);
  void DispatchByPigeonHole(PMCTS_Node* TransversedNode);
};



void PMCTS::DispatchByPigeonHole(PMCTS_Node* TransversedNode){

}



PMCTS_Node* PMCTS::DispatchAlgorithm(PMCTS_Node* TransversedNode,int Threads)
{

    if(TransversedNode->Children.size() == 0){
      //If Node is LeafNode
      //std::cout << "LeafNode Detected  :"   << TransversedNode << "\n";

      if(TransversedNode->NodeVisits == 0){
        //std::cout << "About to rool out on:"   << TransversedNode << "\n";

        return TransversedNode->RollOut();
      }


      //std::cout << TransversedNode->GivenGame->Generate_StringRepresentation();
      std::list<Game*> Games = TransversedNode->GivenGame->PossibleGames();
      //std::cout << "Adding Children Size:" << Games.size() << "\n";
      if (Games.size() == 0)
      {
        return TransversedNode;
      }
      TransversedNode->AddChildren(Games);


      MCTS_Node* NextNode = *TransversedNode->Children.begin();
      //std::cout << "Selecting Next Node:" <<NextNode << "\n";
      return Algorithm(NextNode);
      //return NULL;

    }
    else{

      //Not Leaf Node, Transverse TreeSearch: Find Max Child UCB1 value.
      MCTS_Node* MAXNode = TransversedNode->Find_MAX_UCB1_Child();
      //TODO: Implement Node Visits within BackProp...
      //TransversedNode->NodeVisits++;
      return Algorithm(MAXNode);
      //return NULL;
    }

  return NULL;
}

#endif //P_MCTS_CU
