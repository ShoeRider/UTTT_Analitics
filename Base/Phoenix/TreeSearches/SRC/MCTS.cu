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



#define Pause int ASDF; std::cin >> ASDF;



class MCTS_Node
{
private:

public:
    double NodeVisits;
    double ValueSum;
    Game* GivenGame = NULL;
    //Player* _Player;
    std::list<Player*> _Players;

    MCTS_Node*           Parent       = NULL;
    MCTS_Node*           RollOutChild = NULL;
    std::list<MCTS_Node*> Children;

    MCTS_Node(Game* Instance,std::list<Player*> _GivenPlayers){
      for (Player* _Player : _GivenPlayers){
            printf("adding Player:%p\n",(_Player));
            _Players.push_back(_Player);
      }
      GivenGame  = Instance;
      Children   = {};
      NodeVisits = 0;
      ValueSum   = 0;
      printf("Creating MCTS Node w Player:%p\n",*(_Players.begin()));
      //std::cin.get();
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
    MCTS_Node* ReturnBestMove();
    MCTS_Node* RollOut();
    int        AddChildren(std::list<Game*> PossibleMoves);
    void       BackPropagation(Player* GivenPlayer);
    double     GetAverageValue();
    void       DisplayTree();
    void       DisplayTree(int Depth);
    void       DisplayStats();
};

/*
MCTS_Node* get(std::list<MCTS_Node*> _list, int _i){
    std::list<MCTS_Node*>::iterator it = _list.begin();
    for(int i=0; i<_i; i++){
        ++it;
    }
    return *it;
}*/

template <typename T>
T* get(std::list<T*> _list, int _i){
    typename std::list<T*>::iterator it = _list.begin();
    for(int i=0; i<_i; i++){
        ++it;
    }
    return *it;
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

//Preform MonteCarlo's UCB1 evaluation algorithm on a given node, and return
//the node with the highest UCB1 Value.

MCTS_Node* MCTS_Node::ReturnBestMove(){
  double     HighestValue = -DBL_MAX;
  double     NodesValue;
  MCTS_Node* HighestNode  = NULL;

  for (MCTS_Node* Node : Children){
      NodesValue = Node->GetAverageValue();

      if (HighestValue < NodesValue)
      {
        HighestNode  = Node;
        HighestValue = NodesValue;
      }
  }
  //Note: Doesnt account for NULL Node
  return HighestNode;
}


//For each element within a list of PossibleInstances(Different Game States)
//Add as different Childeren


int MCTS_Node::AddChildren(std::list<Game*> PossibleInstances){
  int ChildrenAdded = 0;
  MCTS_Node* NewNode;
  for (Game* Instance : PossibleInstances){
      if(Instance != NULL)
      {
        std::list<Player*> ProgressedOrder = *(new std::list<Player*>(Instance->_Players));
      /*
      ProgressedOrder.splice(ProgressedOrder.end(),        // destination position
                     ProgressedOrder,              // source list
                     ProgressedOrder.begin());     // source position
                     */
        //std::next(ProgressedOrder, 1);
        //GivenGame->_Players.begin()
        TTT* _Instance = static_cast<TTT*>(Instance);
        printf("%p\n",&(_Instance));
        printf("Create Instance->Players:%p\n",(_Instance->_Players));
        printf("Create Instance->Players:%p\n",&(_Instance->_Players));
        for (Player* _Pl : _Instance->_Players){
              printf("\t-:%p\n",(_Pl));
        }
        NewNode = new MCTS_Node(Instance,(_Instance->_Players));
        NewNode->Parent = this;
        Children.push_back(NewNode);
        ChildrenAdded++;
      }
  }
  return ChildrenAdded;
}

/*
Takes the Node itself, copies itself.
(This also copies the corresponding game state And performs Rollout on the new copy.)
Please note: also sets the copy node's parent as the given Node. (This is
for the BackPropagation step for attributing the Final game state's value back up the tree)
Afterward, it returns the new copy.

@param Nothing
@return pointer to Copied Rollout Node.

*/

MCTS_Node* MCTS_Node::RollOut(){

  Game* RollOutGame = GivenGame->CopyGame();
  RollOutGame->RollOut();

  //printf("RO_WinningPlayer:%p\n",RollOutGame->WinningPlayer);
  //TODO Check if game is finished
  RollOutChild = new MCTS_Node(RollOutGame,_Players);
  RollOutChild->Parent = this;
  return RollOutChild;
}


/*
BackPropagation is the final step of the MCTS. It backtracks from rollout leaf node,
 back up the tree, attributing the final game Value to each parent node, for each
 node it tests if the current Player is the winner of the transversal.
 A winning state for that player recieves +1, Losing -1, tie +0

@param (Player* GivenPlayer)The final winner from the rollout evaluation.
@return Nothing(void)

*/

void MCTS_Node::BackPropagation(Player* GivenPlayer)
{
  NodeVisits++;


  //If no matching condition is found an apposing player won the RollOut game.
  double EvaluatedValue = -1;
  if(*(_Players.begin()) == GivenPlayer)
  {
    EvaluatedValue = 1;
  }
  else if(GivenPlayer == NULL)
  {
    EvaluatedValue = 0;
  }
  std::cout << GivenGame->Generate_StringRepresentation();
  printf("MCTS Node Player:%p\n",*(_Players.begin()));
  printf("     GivenPlayer:%p\n",GivenPlayer);
  printf("  EvaluatedValue:%f\n",EvaluatedValue);
  printf("           Value:%f\n",ValueSum);
  printf("          Visits:%f\n",NodeVisits);
  ValueSum += EvaluatedValue;
  printf(" Parent:%p\n",Parent);
  //If not the head Node, Keep transversing up the Search Tree.
  if (Parent != NULL)
  {
    Parent->BackPropagation(GivenPlayer);
  }
}

/*gets the average Value of a node.
 this is desired over the
O(1) vs O(1)

@param Nothing
@return pointer to Copied Rollout Node.

*/

double MCTS_Node::GetAverageValue()
{
  return ValueSum/NodeVisits;
}


void MCTS_Node::DisplayStats(){
  if(NodeVisits>0)
  {
    std::cout << "----------------------------------------\n";
    printf("ValueSum:%f\n", ValueSum);
    printf("\tNodeVisits:%f\n", NodeVisits);
    printf("\tValueSum:%f\n", ValueSum);
    std::cout << GivenGame->Generate_StringRepresentation();
  }

}

/*
DisplayTree(int Depth)
  DisplayTree is a recursive function that displays the tree's structure, allowing for further
  analysis of the tree search.

@param (int Depth)
@return Void

*/

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

/*
DisplayTree(int Depth)
  DisplayTree is a recursive function that displays the tree's structure, allowing for further
  analysis of the tree search.
  *Shows entire TreeSearch.

@param ()
@return Void

*/

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



//template <class C, template <class C> class M>


class MCTS: public TreeSimulation
{
public:
  double Value;
  double Visits;
  Game* GivenGame;

  std::list<Player*> _Players;
  Player* GivenPlayer;

  //MCTS_Node* TransversedNode;
  MCTS_Node* HeadNode;
  std::list<MCTS_Node*>MCTS_List;
  Game* SimulatedGame;

    MCTS(Game*_Game,std::list<Player*> _GivenPlayers){
      Value  = 0;
      Visits = 0;
      _Players = _GivenPlayers;
      GivenPlayer = *(_GivenPlayers.begin());
      for (Player* _Player : _GivenPlayers){
            printf("MCTS Playerlist:%p\n",(_Player));
      }
      //HeadNode  = NULL;
      //printf("new MCTS_Node's Player:%p\n",Player);
      //std::cin.get();

      HeadNode  = new MCTS_Node(_Game,_GivenPlayers);
      GivenGame = _Game;
    }

    ~MCTS(){
      delete HeadNode;
    }

    MCTS_Node* Algorithm(MCTS_Node* TransversedNode);
    void EvaluateTransversal(MCTS_Node* TransversedNode,Player* GivenPlayer);
    //double BackPropagation(MCTS_Node* TransversedNode,double GivenPlayer);
    void Search(int Depth); //,Player* GivenPlayer
    MCTS* PruneSearch(MCTS_Node*SelectedNode);
    void ParallelSearch(int Depth);


    MCTS* CreateBookMoves();
    MCTS* SaveBookMoves(char* Path);
    MCTS* OpenBookMoves(char* Path);
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

    //UTTT* UTTT_Game = static_cast<UTTT*>(TransversedNode->GivenGame);
    std::list<Game*> Games = TransversedNode->GivenGame->PossibleGames();
    //std::cout << "Adding Children Size:" << Games.size() << "\n";
    if (Games.size() == 0)
    {
      return TransversedNode;
    }

    printf("TransversedNode->GivenGame->Players.begin():%p\n",*(TransversedNode->GivenGame->_Players.begin()));
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
  Performs an itteration of the MCTS Algorithm on the parameter 'TransversedNode'.
  Depending on the winner of the Transversal/RollOut aggregates the appropriate
  Value through MCTS's Back Propagation.
*/
    TransversedNode = Algorithm(TransversedNode);
    std::cout << TransversedNode->GivenGame->Generate_StringRepresentation();

    TransversedNode->BackPropagation(TransversedNode->GivenGame->TestForWinner());
}




void MCTS::Search(int Depth)
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
//Pause
    HeadNode->DisplayTree(2);


}


MCTS* MCTS::PruneSearch(MCTS_Node*SelectedNode)
{

    return NULL;
}


MCTS* MCTS::CreateBookMoves()
{

    return NULL;
}


MCTS* MCTS::SaveBookMoves(char* Path)
{

    return NULL;
}


MCTS* MCTS::OpenBookMoves(char* Path)
{

    return NULL;
}



void MCTS::ParallelSearch(int Depth)
{
    std::cout << "Searching Depth:" << Depth << "\n";

}


#endif //MCTS_CU
