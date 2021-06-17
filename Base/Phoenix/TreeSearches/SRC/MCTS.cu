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
    int    NodeVisits;
    int    Depth;
    double ValueSum;
    double SimulationRep;
    bool LeafNode;

    MCTS_Node*           Parent;
    std::list<MCTS_Node> Children;
public:
    MCTS_Node(){}
    MCTS_Node(void* Instance){}

    ~MCTS_Node(){}
    double     Find_UCB1();
    int        AddChildren(std::list<void*> PossibleMoves);

};

//Preform MonteCarlo's UCB1 evaluation algorithm on a given node.
double MCTS_Node::Find_UCB1(){
  double ExploreBy = 1.4142;
  if(NodeVisits == 0)
	{
		return INT_MAX;
	}
  //Preform UCB1 Formula
  return (ValueSum/NodeVisits + ExploreBy*sqrt(log((float)Parent->NodeVisits)/NodeVisits));
}



//For each element within a list of PossibleInstances(Different Game States)
//Add as different Childeren
int MCTS_Node::AddChildren(std::list<void*> PossibleInstances){
  int ChildrenAdded = 0;
  for (void* Instance : PossibleInstances){
      Children.push_back(MCTS_Node(Instance));
      ChildrenAdded++;
  }
  return ChildrenAdded;
}






class MCTS : public TreeSimulation
{
public:
  int Nodes;
  MCTS_Node* TransversedNode;
  MCTS_Node* HeadNode;
  std::list<MCTS_Node*>MCTS_List;

  Game* SimulatedGame;
    MCTS(){}
    ~MCTS(){}
    void Search(int Depth);
    MCTS_Node* Find_Highest_UCB1(std::list<MCTS_Node*>MCTS_List);
    void GetPossibleMoves();

    void CreateChildren();
    void TreeTraversal();
    void CreateNode();
    void RollOut();
};


MCTS_Node* MCTS::Find_Highest_UCB1(std::list<MCTS_Node*>MCTS_List){
  double     HighestValue = -DBL_MAX;
  double     NodesValue;
  MCTS_Node* HighestNode  = NULL;

  for (MCTS_Node Node : MCTS_List){
      NodesValue = Node.Find_UCB1();
      if (HighestValue < NodesValue)
      {
        HighestNode = &Node;
      }
  }
  //Note: Doesnt account for NULL Node
  return HighestNode;
}

// Provide implementation for the first method
void MCTS::GetPossibleMoves()
{
    std::list<GameMove*> Moves = SimulatedGame->PossibleMoves();
    std::list<Game*> Games = SimulatedGame->PossibleGames();
}

// Provide implementation for the first method
void MCTS::Search(int Depth)
{
    std::cout << "Searching Depth:" << Depth << "\n";

}



#endif //MCTS_CU
