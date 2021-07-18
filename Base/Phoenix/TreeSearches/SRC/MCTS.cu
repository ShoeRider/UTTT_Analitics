#ifndef MCTS_CU
#define MCTS_CU


#include <iostream>
#include <string>
#include <list>
#include <cmath>
#include <bits/stdc++.h>

#include "TreeSearch.cu"



#define Pause int ASDF; std::cin >> ASDF;

class MCTS_Node
{
private:

public:
    int    NodeVisits;
    double ValueSum;
    Game* GivenGame = NULL;

    MCTS_Node*           Parent       = NULL;
    MCTS_Node*           RollOutChild = NULL;
    std::list<MCTS_Node*> Children;
    MCTS_Node(){
      GivenGame  = NULL;
      Children   = {};
      NodeVisits = 0;
      ValueSum   = 0;
    }
    MCTS_Node(Game* Instance){
      GivenGame  = Instance;
      Children   = {};
      NodeVisits = 0;
      ValueSum   = 0;
    }

    ~MCTS_Node(){
      for (MCTS_Node* Node : Children){
        delete Node;
      }
      if (RollOutChild != NULL)
      {
          delete RollOutChild;
      }
      delete GivenGame;
    }
    double     Find_UCB1();
    MCTS_Node* Find_MAX_UCB1_Child();
    MCTS_Node* RollOut();
    int        AddChildren(std::list<Game*> PossibleMoves);
    void       BackPropagation(double GivenPlayer);
    double     GetAverageValue();
    void       DisplayTree();
    void       DisplayTree(int Depth);
    void       DisplayStats();
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
    _NodeVisits = Parent->NodeVisits;
  }
  else{
    _NodeVisits = 0;
  }
  //Preform UCB1 Formula
  double Value = (ValueSum/NodeVisits) + ExploreBy*sqrt(log(_NodeVisits/NodeVisits));
/*
printf("Value:%f\n", Value);
printf("\tNodeVisits:%i\n", NodeVisits);
printf("\tValueSum:%f\n", ValueSum);
*/
  return Value;
}



//For each element within a list of PossibleInstances(Different Game States)
//Add as different Childeren
int MCTS_Node::AddChildren(std::list<Game*> PossibleInstances){
  int ChildrenAdded = 0;
  MCTS_Node* NewNode;
  for (Game* Instance : PossibleInstances){
      if(Instance != NULL)
      {
        NewNode = new MCTS_Node(Instance);
        NewNode->Parent = this;
        Children.push_back(NewNode);
        ChildrenAdded++;
      }
  }
  return ChildrenAdded;
}


MCTS_Node* MCTS_Node::RollOut(){

  Game* RollOutGame = GivenGame->CopyGame();
  RollOutGame->RollOut();

  //printf("RO_WinningPlayer:%p\n",RollOutGame->WinningPlayer);
  //TODO Check if game is finished
  RollOutChild = new MCTS_Node(RollOutGame);
  RollOutChild->Parent = this;
  return RollOutChild;
}

void MCTS_Node::BackPropagation(double EvaluatedValue)
{
  NodeVisits++;
  ValueSum += EvaluatedValue;
  if (Parent != NULL)
  {
    Parent->BackPropagation(EvaluatedValue);
  }
}

double MCTS_Node::GetAverageValue()
{
  return ValueSum/NodeVisits;
}
void MCTS_Node::DisplayStats(){
  std::cout << "----------------------------------------\n";
  printf("ValueSum:%f\n", ValueSum);
  printf("\tNodeVisits:%i\n", NodeVisits);
  printf("\tValueSum:%f\n", ValueSum);
  std::cout << GivenGame->Generate_StringRepresentation();
}

void MCTS_Node::DisplayTree(int Depth){

  std::cout << "Displaying Depth:" << Depth << "\n";
  std::cout << "Children length:" << Children.size() << "\n";
  if (Children.size() > 0){
    for (MCTS_Node* Child : Children) { // c++11 range-based for loop
         Child->DisplayStats();
      }
    if((Depth-1)>0){
      for (MCTS_Node* Child : Children) { // c++11 range-based for loop
           Child->DisplayTree(Depth-1);
        }
      }
  }
}

void MCTS_Node::DisplayTree(){
  for (MCTS_Node* Child : Children) { // c++11 range-based for loop
      Child->DisplayStats();
    }
  std::cout << "----------------------------------------\n";
  std::cout << GivenGame->Generate_StringRepresentation();
  for (MCTS_Node* Child : Children) { // c++11 range-based for loop
       Child->DisplayTree();
    }

}






class MCTS : public TreeSimulation
{
public:
  double Value;
  double Visits;
  Game* GivenGame;
  Player* GivenPlayer;

  //MCTS_Node* TransversedNode;
  MCTS_Node* HeadNode;
  std::list<MCTS_Node*>MCTS_List;
  Game* SimulatedGame;

    MCTS(Game*_Game){
      Value  = 0;
      Visits = 0;

      //HeadNode  = NULL;
      HeadNode  = new MCTS_Node(_Game);
      GivenGame = _Game;
    }

    ~MCTS(){
      delete HeadNode;
    }
    MCTS_Node* Algorithm(MCTS_Node* TransversedNode);
    void EvaluateTransversal(MCTS_Node* TransversedNode,Player* GivenPlayer);
    //double BackPropagation(MCTS_Node* TransversedNode,double GivenPlayer);
    void Search(int Depth,Player* GivenPlayer);
    void ParallelSearch(int Depth);
    //MCTS_Node* Find_Highest_UCB1(std::list<MCTS_Node*>MCTS_List);
    void GetPossibleMoves();

    void CreateChildren();
    void TreeTraversal();
    void CreateNode();
    void RollOut();
};







void MCTS::GetPossibleMoves()
{
    std::list<GameMove*> Moves = SimulatedGame->PossibleMoves();
    std::list<Game*> Games = SimulatedGame->PossibleGames();
}



MCTS_Node* MCTS::Algorithm(MCTS_Node* TransversedNode)
{
  /*
    Helper Function for MCTS::Search & EvaluateTransversal.
    Performs an itteration of the MCTS Algorithm on 'TransversedNode'
  */


//TransversedNode->Children.size()
//int Leaf =TransversedNode->Children.size();

  //std::cout << TransversedNode->GivenGame->Generate_StringRepresentation();
  /*
  std::cout << "TransversedNode:" <<TransversedNode << "\n";
  std::cout << "NodeVisits:" <<TransversedNode->NodeVisits << "\n";
  std::cout << "Children:"   <<TransversedNode->Children.size() << "\n";
  */


  //Pause;


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
}


//


void MCTS::EvaluateTransversal(MCTS_Node* TransversedNode,Player* GivenPlayer)
{
/*
  Helper Function for MCTS::Search.
  Performs an itteration of the MCTS Algorithm on the parameter 'TransversedNode'
  and tests if the current Player is the winner of the transversal.
  Depending on the winner of the Transversal/RollOut aggregates the appropriate
  Value through MCTS's Back Propagation.
*/
    TransversedNode = Algorithm(TransversedNode);
    double EvaluatedValue = -1;


    //std::cout << TransversedNode->GivenGame->Generate_StringRepresentation();

    if(TransversedNode->GivenGame->TestForWinner() == GivenPlayer)
    {
      EvaluatedValue = 1;
    }
    else if( TransversedNode->GivenGame->WinningPlayer == NULL )
    {
      //printf("Draw Game\n");
      EvaluatedValue = 0;
    }
    TransversedNode->BackPropagation(EvaluatedValue);
}



void MCTS::Search(int Depth,Player* GivenPlayer)
{
  /*
    Interface to initate MCTS Tree Searches.
    Given Depth,
  */
    std::cout << "Searching Depth:" << Depth << "\n";
    for (int i = 0; i < Depth; i++) {
      //printf("\tDepth: %d\n",i);
      EvaluateTransversal(HeadNode,GivenPlayer);
    }

    HeadNode->DisplayTree(1);


}


void MCTS::ParallelSearch(int Depth)
{
    std::cout << "Searching Depth:" << Depth << "\n";

}


#endif //MCTS_CU
