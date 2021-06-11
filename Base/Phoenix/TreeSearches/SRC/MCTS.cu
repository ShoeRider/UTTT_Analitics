#ifndef MCTS_CU
#define MCTS_CU


#include <iostream>
#include <string>
#include <list>
#include <cmath>
#include <bits/stdc++.h>

#include "TreeSearch.cu"

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
    MCTS_Node* Find_Highest_UCB1();
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

MCTS_Node* MCTS_Node::Find_Highest_UCB1(){
  double     HighestValue = -DBL_MAX;
  double     NodesValue;
  MCTS_Node* HighestNode  = NULL;

  for (MCTS_Node Node : Children){
      NodesValue = Node.Find_UCB1();
      if (HighestValue < NodesValue)
      {
        HighestNode = &Node;
      }
  }
  //Note: Doesnt account for NULL Node
  return HighestNode;
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






class MCTS : public SimulationTreeSearch
{
private:
    int Nodes;
    MCTS_Node* TransversedNode;
    MCTS_Node* HeadNode;

public:
    MCTS(){}
    ~MCTS(){}
    void Search(int Depth);

    void Give_MLMethodPointer();
    void CreateChildren();
    void TreeTraversal();
    void CreateNode();
    void RollOut();
};

// Provide implementation for the first method
void MCTS::Search(int Depth)
{
    std::cout << "Searching Depth:" << Depth << "\n";

}

// Provide implementation for the first method
void MCTS::Give_MLMethodPointer()
{
    std::cout << "Hello World!";
}



#endif //MCTS_CU
