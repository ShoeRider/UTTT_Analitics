#ifndef MCTS_CU
#define MCTS_CU


#include <iostream>
#include <string>
#include <list>
#include <cmath>
#include <bits/stdc++.h>

#include "TreeSearch.cu"

#include "../../Games/SRC/Game.cu"
#include "../../Games/SRC/TTT.cu"
#include "../../Games/SRC/UTTT.cu"
class MCTS_Node
{
private:

public:
    int    NodeVisits;
    int    Depth;
    double ValueSum;
    double SimulationRep;
    bool LeafNode;
    Game* GivenGame;

    MCTS_Node*           Parent;
    std::list<MCTS_Node*> Children;
    MCTS_Node(){}
    MCTS_Node(Game* Instance){
      GivenGame = Instance;
    }

    ~MCTS_Node(){}
    double     Find_UCB1();
    MCTS_Node* Find_MAX_UCB1_Child();
    void       RollOut();
    int        AddChildren(std::list<Game*> PossibleMoves);

};

MCTS_Node* get(std::list<MCTS_Node*> _list, int _i){
    std::list<MCTS_Node*>::iterator it = _list.begin();
    for(int i=0; i<_i; i++){
        ++it;
    }
    return *it;
}


MCTS_Node* MCTS_Node::Find_MAX_UCB1_Child(){
  double     HighestValue = -DBL_MAX;
  double     NodesValue;
  MCTS_Node* HighestNode  = NULL;

  for (MCTS_Node* Node : Children){
      NodesValue = Node->Find_UCB1();
      if (HighestValue < NodesValue)
      {
        HighestNode  = Node;
        HighestValue = NodesValue;
      }
  }
  //Note: Doesnt account for NULL Node
  return HighestNode;
}

//Preform MonteCarlo's UCB1 evaluation algorithm on a given node.
double MCTS_Node::Find_UCB1(){
  double ExploreBy = 1.4142;
  if(NodeVisits == 0)
	{
		return INT_MAX;
	}
  float _NodeVisits;
  if (Parent != NULL){
    _NodeVisits = (float)Parent->NodeVisits;
  }
  else{
    _NodeVisits = 0;
  }
  //Preform UCB1 Formula
  return (ValueSum/NodeVisits) + ExploreBy*sqrt(log(_NodeVisits/NodeVisits));
}



//For each element within a list of PossibleInstances(Different Game States)
//Add as different Childeren
int MCTS_Node::AddChildren(std::list<Game*> PossibleInstances){
  int ChildrenAdded = 0;
  MCTS_Node NewNode;
  for (Game* Instance : PossibleInstances){
      NewNode = MCTS_Node(Instance);
      NewNode.Parent = this;
      Children.push_back(&NewNode);
      ChildrenAdded++;
  }
  return ChildrenAdded;
}

void MCTS_Node::RollOut(){
  GivenGame->RollOut();
}




class MCTS : public TreeSimulation
{
public:
  double Value;
  double Visits;
  int Nodes;
  Game* GivenGame;

  //MCTS_Node* TransversedNode;
  MCTS_Node* HeadNode;
  std::list<MCTS_Node*>MCTS_List;
  Game* SimulatedGame;

    MCTS(Game*_Game){
      GivenGame = _Game;
    }
    ~MCTS(){}
    MCTS_Node* Algorithm(MCTS_Node* TransversedNode);
    double EvaluateTransversal(MCTS_Node* TransversedNode,Player* GivenPlayer);
    void Search(int Depth);
    void ParallelSearch(int Depth);
    //MCTS_Node* Find_Highest_UCB1(std::list<MCTS_Node*>MCTS_List);
    void GetPossibleMoves();

    void CreateChildren();
    void TreeTraversal();
    void CreateNode();
    void RollOut();
};






// Provide implementation for the first method
void MCTS::GetPossibleMoves()
{
    std::list<GameMove*> Moves = SimulatedGame->PossibleMoves();
    std::list<Game*> Games = SimulatedGame->PossibleGames();
}


// Provide implementation for the first method
MCTS_Node* MCTS::Algorithm(MCTS_Node* TransversedNode)
{

  if(TransversedNode->Children.size()==0){
    //If Node is LeafNode
    if(TransversedNode->NodeVisits == 0){
      TransversedNode->RollOut();
    }
    std::list<Game*> Games = GivenGame->PossibleGames();
    TransversedNode->AddChildren(Games);
    MCTS_Node* NextNode = *TransversedNode->Children.begin();
    return Algorithm(NextNode);

  }
  else{
    //Not Leaf Node, Transverse TreeSearch: Find Max Child UCB1 value.
    MCTS_Node* MAXNode = TransversedNode->Find_MAX_UCB1_Child();
    return Algorithm(MAXNode);
  }
}

// Provide implementation for the first method
double MCTS::EvaluateTransversal(MCTS_Node* TransversedNode,Player* GivenPlayer)
{
    Algorithm(TransversedNode);
    return Value;
}


// Provide implementation for the first method
void MCTS::Search(int Depth)
{

    std::cout << "Searching Depth:" << Depth << "\n";

}

// Provide implementation for the first method
void MCTS::ParallelSearch(int Depth)
{
    std::cout << "Searching Depth:" << Depth << "\n";

}


#endif //MCTS_CU
