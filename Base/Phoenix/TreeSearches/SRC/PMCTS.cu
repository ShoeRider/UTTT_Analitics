/*
====================================================================================================
Description PMCTS(Parallel Monte Carlo Tree Search):
This takes the Monte-Carlo Tree search and adds some multithreading to Create Faster Searches.

Still uses the Game interface, and template structure from MCTS.

Requires:
  "TreeSearch.cu"
  "MCTS.cu"

Possibly requires:
  "ThreadingTools.cu"

TODO:
  Implement Break Out Search from notes.
====================================================================================================
Date:           NA
Script Version: 1.0
Name:           Anthony M Schroeder
Email:          as3379@nau.edu
Implemented a 'dispatch evenly' algorithm.
==========================================================
Date:           26 September 2021
Script Version: 1.1
Name:           Anthony M Schroeder
Email:          as3379@nau.edu
Implementing different dispatch thread algorithms.
- _PMCTS: for a more directed search algorithm.
==========================================================
*/

#ifndef P_MCTS_CU
#define P_MCTS_CU


#include <iostream>
#include <string>
#include <list>
#include <cmath>
#include <bits/stdc++.h>

#include <thread>
#include <mutex>
#include "PMCTS.h"
#include "TreeSearch.cu"
#include "../SRC/MCTS.cu"
#include "../../ThreadingTools/SRC/ThreadingTools.cu"


template <typename Game_Tp, typename Player_Tp>
class PMCTS_Node;


template <typename Game_Tp, typename Player_Tp>
struct PMCTS_ThreadData_t {
    pthread_t Thread;
    //Player_Tp*
    PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode;
    double Threads;
    double Depth;
    bool Finished;
};










/*
MCTS_Node

Great step by step example found here: https://www.youtube.com/watch?v=UXW2yZndl7U

@Methods:

 * @param
    Game* Instance,

 *
 * @see MCTS::Find_MAX_UCB1_Child()
 * @see Game interface(Found within Game.cu)
 */
template <typename Game_Tp, typename Player_Tp>
class PMCTS_Node
{
private:

public:
  //////////////////////////////////////////////////////////////////////////////
  // Values to evaluate UCB1 preformance.
  //////////////////////////////////////////////////////////////////////////////
  double NodeVisits;
  double ValueSum;
  Game_Tp* GivenGame = NULL;

  //////////////////////////////////////////////////////////////////////////////
  // List of _Players to maintain turn order.
  //////////////////////////////////////////////////////////////////////////////
  std::list<Player_Tp*> _Players;

  //////////////////////////////////////////////////////////////////////////////
  // pointers to maintain tree structure.
  //////////////////////////////////////////////////////////////////////////////
  PMCTS_Node*           Parent       = NULL;
  PMCTS_Node*           RollOutChild = NULL;
  std::list<PMCTS_Node*> Children;


    //////////////////////////////////////////////////////////////////////////////
    // Initialization method.
    PMCTS_Node(Game_Tp* Instance,std::list<Player_Tp*> _GivenPlayers){
      for (Player_Tp* _Player : _GivenPlayers){
            //printf("adding Player:%p\n",(_Player));
            _Players.push_back(_Player);
      }
      GivenGame  = Instance;
      Children   = {};
      NodeVisits = 0;
      ValueSum   = 0;
      //printf("Creating MCTS Node w Player:%p\n",*(_Players.begin()));
      //std::cin.get();
    }


    ~PMCTS_Node(){
      for (PMCTS_Node<Game_Tp,Player_Tp>* Node : Children){
        delete Node;
      }
      if (RollOutChild != NULL)
      {
          delete RollOutChild;
      }
      delete GivenGame;
    }

    //////////////////////////////////////////////////////////////////////////////
    // Method Declarations.
    //////////////////////////////////////////////////////////////////////////////

double     Find_UCB1();

PMCTS_Node<Game_Tp,Player_Tp>* Find_MAX_UCB1_Child();
PMCTS_Node<Game_Tp,Player_Tp>* ReturnBestMove();
PMCTS_Node<Game_Tp,Player_Tp>* RollOut();
int        AddChildren(std::list<Game_Tp*> PossibleMoves);
void       BackPropagation(Player_Tp* GivenPlayer,PMCTS_Node<Game_Tp,Player_Tp>* HeadNode);
double     GetAverageValue();
void       DisplayTree();
void       DisplayTree(int Depth);
void       DisplayStats();

};


//Preform MonteCarlo's UCB1 evaluation algorithm on a given node.
template <typename Game_Tp, typename Player_Tp>
double PMCTS_Node<Game_Tp,Player_Tp>::Find_UCB1(){
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


template <typename Game_Tp, typename Player_Tp>
PMCTS_Node<Game_Tp,Player_Tp>* PMCTS_Node<Game_Tp,Player_Tp>::Find_MAX_UCB1_Child(){
  double     HighestValue = -DBL_MAX;
  double     NodesValue;
  PMCTS_Node<Game_Tp,Player_Tp>* HighestNode  = NULL;

  for (PMCTS_Node<Game_Tp,Player_Tp>* Node : Children){
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
template <typename Game_Tp, typename Player_Tp>
PMCTS_Node<Game_Tp,Player_Tp>* PMCTS_Node<Game_Tp,Player_Tp>::ReturnBestMove(){
  double     HighestValue = -DBL_MAX;
  double     NodesValue;
  PMCTS_Node<Game_Tp,Player_Tp>* HighestNode  = NULL;

  for (PMCTS_Node<Game_Tp,Player_Tp>* Node : Children){
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


template <typename Game_Tp, typename Player_Tp>
int PMCTS_Node<Game_Tp,Player_Tp>::AddChildren(std::list<Game_Tp*> PossibleInstances){
  int ChildrenAdded = 0;
  PMCTS_Node<Game_Tp,Player_Tp>* NewNode;

  //////////////////////////////////////////////////////////////////////////////
  // For each element within a list of PossibleInstances(Different Game States)
  // Add as different Childeren/Leaf Nodes
  for (Game_Tp* Instance : PossibleInstances){

      if(Instance != NULL)
      {

        //////////////////////////////////////////////////////////////////////////////
        // For Each Possible Game, Create New MCTS_Node<Game_Tp>, and add it to
        // children list.
        NewNode = new PMCTS_Node<Game_Tp,Player_Tp>(Instance,(Instance->Players));
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
template <typename Game_Tp, typename Player_Tp>
PMCTS_Node<Game_Tp,Player_Tp>* PMCTS_Node<Game_Tp,Player_Tp>::RollOut(){

  Game_Tp* RollOutGame = GivenGame->CopyGame();
  RollOutGame->RollOut();

  //printf("RO_WinningPlayer:%p\n",RollOutGame->WinningPlayer);
  //TODO Check if game is finished
  RollOutChild = new PMCTS_Node<Game_Tp,Player_Tp>(RollOutGame,_Players);
  RollOutChild->Parent = this;
  return RollOutChild;
}



/*
BackPropagation is the final step of the MCTS. It backtracks from a rollout leaf node,
 back up the tree. This attributes Values to each parent node based on the out
 come of the current branch, for each node it tests if the current Player is the winner of the transversal.
 A winning state for that player recieves +1, Losing -1, tie +0

@param (Player* GivenPlayer)The final winner from the rollout evaluation.
@return Nothing(void)

*/
template <typename Game_Tp, typename Player_Tp>
void PMCTS_Node<Game_Tp,Player_Tp>::BackPropagation(Player_Tp* WinningPlayer,PMCTS_Node<Game_Tp,Player_Tp>* HeadNode)
{
  NodeVisits++;


  //If no matching condition is found an apposing player won the RollOut game.
  double EvaluatedValue = -1;
  if(*(_Players.begin()) == WinningPlayer)
  {
    EvaluatedValue = 1;
  }
  else if(WinningPlayer == NULL)
  {
    EvaluatedValue = 0;
  }
  //std::cout << GivenGame->Generate_StringRepresentation();
  //printf("MCTS Node Player:%p\n",*(_Players.begin()));
  //printf("     GivenPlayer:%p\n",GivenPlayer);
  //printf("  EvaluatedValue:%f\n",EvaluatedValue);
  //printf("           Value:%f\n",ValueSum);
  //printf("          Visits:%f\n",NodeVisits);
  ValueSum += EvaluatedValue;
  //printf(" Parent:  %p\n",Parent);
  //printf(" HeadNode:%p\n",HeadNode);
  //If not the head Node, Keep transversing up the Search Tree.
  //<Game_Tp,Player_Tp>


  if (
    Parent != NULL  &&
    this   != HeadNode
  )
  {
    Parent->BackPropagation(WinningPlayer,HeadNode);
  }
}

/*gets the average Value of a node.
 this is desired over the
O(1) vs O(1)

@param Nothing
@return pointer to Copied Rollout Node.

*/
template <typename Game_Tp, typename Player_Tp>
double PMCTS_Node<Game_Tp,Player_Tp>::GetAverageValue()
{
  return ValueSum/NodeVisits;
}




template <typename Game_Tp, typename Player_Tp>
void PMCTS_Node<Game_Tp,Player_Tp>::DisplayStats(){
  if(NodeVisits>0)
  {
    std::cout << "----------------------------------------\n";
    printf("\tNodeVisits:%f\n", NodeVisits);
    printf("\tValueSum:%f\n", ValueSum);
    printf("\tNode Ratio:%f\n", (ValueSum/NodeVisits));
    printf("\tUCB1:%f\n", Find_UCB1());
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
template <typename Game_Tp, typename Player_Tp>
void PMCTS_Node<Game_Tp,Player_Tp>::DisplayTree(int Depth){


  if (Children.size() > 0){
    for (PMCTS_Node* Child : Children) { // c++11 range-based for loop
         Child->DisplayStats();
      }
    if((Depth-1)>0){
      for (PMCTS_Node* Child : Children) { // c++11 range-based for loop
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
template <typename Game_Tp, typename Player_Tp>
void PMCTS_Node<Game_Tp,Player_Tp>::DisplayTree(){
  // For each branch, display the game's statistics.
  //////////////////////////////////////////////////////////////////////////////
  for (PMCTS_Node* Child : Children) {
      Child->DisplayStats();
    }

  std::cout << "----------------------------------------\n";
  std::cout << GivenGame->Generate_StringRepresentation();
  for (PMCTS_Node* Child : Children) {
       Child->DisplayTree();
    }

}



/*
MCTS is a tree search that takes a complete view of a game and evaluates the
most optimal moves for both players through a UCB1 algorithm.
This algorithm performs a hybrid of breath and depth search to evenly search a given search space.

Great step by step example found here: https://www.youtube.com/watch?v=UXW2yZndl7U

@Methods:
Search()
Algorithm():: A recursive implementation of the MCTS algorithm. Recursively creates a serach tree based on the MCTS, searching for the most optimal move.

 * @param
    Game*_Game,
    std::list<Player*> _GivenPlayers)

 *
 * @see MCTS_Node::Find_MAX_UCB1_Child()
 * @see Game interface(Found within Game.cu)
 */
template <typename Game_Tp, typename Player_Tp>
class PMCTS: public TreeSimulation
{
public:

  //////////////////////////////////////////////////////////////////////////////
  //Thread Information
  double Depth;
  double Threads;
  ParallelControlBlock* ParallelCB;


  //////////////////////////////////////////////////////////////////////////////
  // The current head node.
  //////////////////////////////////////////////////////////////////////////////
  Game_Tp* GivenGame;
  //MCTS_Node* TransversedNode;
  PMCTS_Node<Game_Tp,Player_Tp>* HeadNode;
  Game_Tp* SimulatedGame;


  //////////////////////////////////////////////////////////////////////////////
  // The current head node.
  //////////////////////////////////////////////////////////////////////////////
  std::list<Player_Tp*> Players;
  Player_Tp* GivenPlayer;


  //////////////////////////////////////////////////////////////////////////////
  // Initialization method.
  PMCTS(Game_Tp*_Game,std::list<Player_Tp*> _GivenPlayers){
    Players        = _GivenPlayers;
    GivenPlayer    = *(_GivenPlayers.begin());

    HeadNode  = new PMCTS_Node<Game_Tp,Player_Tp>(_Game,_GivenPlayers);
    GivenGame = _Game;

    ParallelCB = new ParallelControlBlock();
  }

  //////////////////////////////////////////////////////////////////////////////
  //
  //////////////////////////////////////////////////////////////////////////////
  virtual ~PMCTS(){
    delete HeadNode;
    delete ParallelCB;
  }

  //////////////////////////////////////////////////////////////////////////////
  // Parallel Functions
  //////////////////////////////////////////////////////////////////////////////
  PMCTS_ThreadData_t<Game_Tp,Player_Tp>* DispatchThread(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,int Threads, int ThreadDepth);
  void DispatchThreads(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,int Threads, int ThreadDepth);
  void DispatchByPigeonHole(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,int Threads, int ThreadDepth);
  void DispatchByRotation(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,int Threads, int ThreadDepth);
  void DispatchEvenly(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,int Threads, int ThreadDepth);

  //////////////////////////////////////////////////////////////////////////////
  // 'Single' Threaded Algorithms
  //////////////////////////////////////////////////////////////////////////////
  PMCTS_Node<Game_Tp,Player_Tp>* PMCTS_Algorithm(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode);
  //TODO Include PMCTS Back Propagation
  PMCTS_Node<Game_Tp,Player_Tp>* MCTS_Algorithm(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode);
  //TODO Include MCTS Back Propagation


  //////////////////////////////////////////////////////////////////////////////
  // Management Functions
  //////////////////////////////////////////////////////////////////////////////
  void PerformStep(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,Player_Tp* GivenPlayer);
  //double BackPropagation(MCTS_Node* TransversedNode,double GivenPlayer);
  void PMCTS_Search(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,double Depth); //,Player* GivenPlayer
  void MCTS_Search(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,double Depth); //,Player* GivenPlayer
  PMCTS* PruneSearch(PMCTS_Node<Game_Tp,Player_Tp>*SelectedNode);
  void ParallelSearch(int Depth);

  void Search(double Threads, double Depth);
  void Search(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,double Threads, double Depth);


  void Node_BackPropagation(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,Player_Tp* GivenPlayer);
  //MCTS* CreateBookMoves();
  //MCTS* SaveBookMoves(char* Path);
  //MCTS* OpenBookMoves(char* Path);
  //MCTS_Node* Find_Highest_UCB1(std::list<MCTS_Node*>MCTS_List);


/*
void CreateChildren();
void TreeTraversal();
void CreateNode();
void RollOut();
*/

};

/**
   A recursive impementation of the MCTS algorithm. Recursively creates a serach
    tree based on the MCTS, searching for the most optimal move.

  This modifies the given MCTS search tree, adding MCTS_Node's.

 * @param
 *   <MCTS_Node*> TransversedNode(Is the next node to be evaluated on, either recursively or initialy).
 *
 * @return MCTS_Node,
 *
 * @see MCTS_Node::Find_MAX_UCB1_Child()
 * @see Game interface(Found within Game.cu)
 */
template <typename Game_Tp, typename Player_Tp>
PMCTS_Node<Game_Tp,Player_Tp>* PMCTS<Game_Tp,Player_Tp>::MCTS_Algorithm(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode)
{
  /*
    Helper Function for MCTS::Search & EvaluateStep.
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

  //////////////////////////////////////////////////////////////////////////////
  //If Node is LeafNode, create Children nodes, and select the first node for
  // rollout.
  //////////////////////////////////////////////////////////////////////////////
  if(TransversedNode->Children.size() == 0){

    //std::cout << "LeafNode Detected  :"   << TransversedNode << "\n";


    /////////////////////////////////////////////////////////////////
    // If Leaf Node has no visits, preform rollout.
    /////////////////////////////////////////////////////////////////
    if(TransversedNode->NodeVisits == 0){
      //std::cout << "About to rool out on:"   << TransversedNode << "\n";

      return TransversedNode->RollOut();
    }


    //std::cout << TransversedNode->GivenGame->Generate_StringRepresentation();
    //UTTT* UTTT_Game = static_cast<UTTT*>(TransversedNode->GivenGame);


    /////////////////////////////////////////////////////////////////
    // Find all possible games from branch.
    /////////////////////////////////////////////////////////////////
    std::list<Game_Tp*> Games = TransversedNode->GivenGame->PossibleGames();
    //std::cout << "Adding Children Size:" << Games.size() << "\n";


    /////////////////////////////////////////////////////////////////
    // verify future games have been found.
    /////////////////////////////////////////////////////////////////
    if (Games.size() == 0)
    {
      return TransversedNode;
    }

    /////////////////////////////////////////////////////////////////
    //Takes the new Games and add them to the tree.
    /////////////////////////////////////////////////////////////////
    //printf("TransversedNode->GivenGame->Players.begin():%p\n",*(TransversedNode->GivenGame->_Players.begin()));
    TransversedNode->AddChildren(Games);

    /////////////////////////////////////////////////////////////////
    //select the first posible node.
    /////////////////////////////////////////////////////////////////
    PMCTS_Node<Game_Tp,Player_Tp>* NextNode = *TransversedNode->Children.begin();

    /////////////////////////////////////////////////////////////////
    //Recursivly search down the tree looking for an 'optimal' branch to evaluate.
    /////////////////////////////////////////////////////////////////
    return MCTS_Algorithm(NextNode);

  }
  //Otherwise, transverse the tree using the UCB1 formula, looking for an 'optimal' branch to evaluate.
  else{

    //Not Leaf Node, Transverse down the Tree: Find the branch with the MAX UCB1 value.
    PMCTS_Node<Game_Tp,Player_Tp>* MAXNode = TransversedNode->Find_MAX_UCB1_Child();

    //Recursivly search down the tree looking for an 'optimal' branch to evaluate.
    return MCTS_Algorithm(MAXNode);
  }
}




/*
*/


/**
   Helper Function for MCTS::Search. Performs an iteration of the MCTS on the parameter 'TransversedNode.' Then takes the result of Search/RollOut and performs BackPropagation to adjust the weights of each MCTS_Node within the search tree.
 *
 * @param
 *   <MCTS_Node*> TransversedNode().
 *   <Player*> GivenPlayer
          (A pointer of the current Player's turn. This is used during the
          backpropagation step to evaluate winning and losing game positions.).
 *
 * @return Void, modifies the given MCTS object, adding MCTS_Node elements to
 *   the Head node.
 *
 * @see MCTS
 * @see Game interface(Found within Game.cu)
 */
template <typename Game_Tp, typename Player_Tp>
void PMCTS<Game_Tp,Player_Tp>::PerformStep(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,Player_Tp* GivenPlayer)
{


    TransversedNode = MCTS_Algorithm(TransversedNode);
    //std::cout << TransversedNode->GivenGame->Generate_StringRepresentation();


    TransversedNode->BackPropagation(TransversedNode->GivenGame->TestForWinner(),HeadNode);
    //Node_BackPropagation(TransversedNode,TransversedNode->GivenGame->TestForWinner());
}


/**
 * Preforms the Monte Carlo tree search on the game used to initialize the MCTS
 *  Object.
 *
 *
 * @param <int> Depth(Depth of search tree).
 *
 * @return Void, modifies the given MCTS object, adding MCTS_Node elements to
 *   the Head node.
 *
 * @see MCTS
 * @see Game interface(Found within Game.cu)
 */
template <typename Game_Tp, typename Player_Tp>
void PMCTS<Game_Tp,Player_Tp>::MCTS_Search(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,double Depth)
{
    // Increment counter, and perform another step within the search.

    for (int i = 0; i < Depth; i++) {

      // Use helper Method EvaluateStep to increment the search.
      PerformStep(TransversedNode,GivenPlayer);
    }
}





/**
 * Preforms the Monte Carlo tree search on the game used to initialize the MCTS
 *  Object.
 *
 *
 * @param <int> Depth(Depth of search tree).
 *
 * @return Void, modifies the given MCTS object, adding MCTS_Node elements to
 *   the Head node.
 *
 * @see MCTS
 * @see Game interface(Found within Game.cu)
 */
template <typename Game_Tp, typename Player_Tp>
void PMCTS<Game_Tp,Player_Tp>::PMCTS_Search(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,double Depth)
{
  /////////////////////////////////////////////////////////////////
  // Using multiple Threads.Prep the Tree until Child nodes have been created.
  /////////////////////////////////////////////////////////////////

  /////////////////////////////////////////////////////////////////
  //Check if Leaf Node
  if(TransversedNode->Children.size() == 0){
    //////////////////////////////////////////////////////////////////////////////
    //If Node is LeafNode, create Children nodes, for threads.
    //////////////////////////////////////////////////////////////////////////////

    /////////////////////////////////////////////////////////////////
    // Find all possible games from branch.
    /////////////////////////////////////////////////////////////////
    std::list<Game_Tp*> Games = TransversedNode->GivenGame->PossibleGames();

    /////////////////////////////////////////////////////////////////
    // verify future games have been found.
    // If size zero Win state found ...
    /////////////////////////////////////////////////////////////////
    if (Games.size() == 0)
    {
      //Instead of returning node, should i just apply the BackPropagation values to the tree directly ?
      //return TransversedNode;
    }
    /////////////////////////////////////////////////////////////////
    //Takes the new Games and add them to the tree.
    /////////////////////////////////////////////////////////////////
    //printf("TransversedNode->GivenGame->Players.begin():%p\n",*(TransversedNode->GivenGame->_Players.begin()));
    TransversedNode->AddChildren(Games);
  }

  /////////////////////////////////////////////////////////////////
  //Use the threads given.
  DispatchThreads(TransversedNode,Threads,Depth);


  /////////////////////////////////////////////////////////////////
  //Preform BackPropagation to balance tree.
}




template <typename Game_Tp, typename Player_Tp>
PMCTS_Node<Game_Tp,Player_Tp>* PMCTS<Game_Tp,Player_Tp>::PMCTS_Algorithm(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode)
{

}











template <typename Game_Tp, typename Player_Tp>
PMCTS_Node<Game_Tp,Player_Tp>* _PMCTS_Algorithm(PMCTS_Node<Game_Tp,Player_Tp>*TransversedNode)
{
  /*
    Helper Function for MCTS::Search & EvaluateStep.
    Performs an itteration of the MCTS Algorithm on 'TransversedNode'
  */

  //////////////////////////////////////////////////////////////////////////////
  //If Node is LeafNode, create Children nodes, and select the first node for
  // rollout.
  //////////////////////////////////////////////////////////////////////////////
  if(TransversedNode->Children.size() == 0){

    //std::cout << "LeafNode Detected  :"   << TransversedNode << "\n";


    /////////////////////////////////////////////////////////////////
    // If Leaf Node has no visits, preform rollout.
    /////////////////////////////////////////////////////////////////
    if(TransversedNode->NodeVisits == 0){
      //std::cout << "About to rool out on:"   << TransversedNode << "\n";

      return TransversedNode->RollOut();
    }


    //std::cout << TransversedNode->GivenGame->Generate_StringRepresentation();
    //UTTT* UTTT_Game = static_cast<UTTT*>(TransversedNode->GivenGame);


    /////////////////////////////////////////////////////////////////
    // Find all possible games from branch.
    /////////////////////////////////////////////////////////////////
    std::list<Game_Tp*> Games = TransversedNode->GivenGame->PossibleGames();
    //std::cout << "Adding Children Size:" << Games.size() << "\n";


    /////////////////////////////////////////////////////////////////
    // verify future games have been found.
    /////////////////////////////////////////////////////////////////
    if (Games.size() == 0)
    {
      return TransversedNode;
    }

    /////////////////////////////////////////////////////////////////
    //Takes the new Games and add them to the tree.
    /////////////////////////////////////////////////////////////////
    //printf("TransversedNode->GivenGame->Players.begin():%p\n",*(TransversedNode->GivenGame->_Players.begin()));
    TransversedNode->AddChildren(Games);

    /////////////////////////////////////////////////////////////////
    //select the first posible node.
    /////////////////////////////////////////////////////////////////
    PMCTS_Node<Game_Tp,Player_Tp>* NextNode = *TransversedNode->Children.begin();

    /////////////////////////////////////////////////////////////////
    //Recursivly search down the tree looking for an 'optimal' branch to evaluate.
    /////////////////////////////////////////////////////////////////
    return _PMCTS_Algorithm(NextNode);

  }
  //Otherwise, transverse the tree using the UCB1 formula, looking for an 'optimal' branch to evaluate.
  else{

    //Not Leaf Node, Transverse down the Tree: Find the branch with the MAX UCB1 value.
    PMCTS_Node<Game_Tp,Player_Tp>* MAXNode = TransversedNode->Find_MAX_UCB1_Child();

    //Recursivly search down the tree looking for an 'optimal' branch to evaluate.
    return _PMCTS_Algorithm(MAXNode);
  }
}


template <typename Game_Tp, typename Player_Tp>
void * _PMCTS_Search(void*GivenPMCTS_ThreadData)
{
  PMCTS_ThreadData_t<Game_Tp,Player_Tp>* PMCTS_ThreadData = static_cast<PMCTS_ThreadData_t<Game_Tp,Player_Tp>*>(GivenPMCTS_ThreadData);

  for (int i = 0; i < PMCTS_ThreadData->Depth; i++) {
  PMCTS_Node<Game_Tp,Player_Tp>*TransversedNode = PMCTS_ThreadData->TransversedNode;
    TransversedNode = _PMCTS_Algorithm<Game_Tp,Player_Tp>(TransversedNode);
    //std::cout << TransversedNode->GivenGame->Generate_StringRepresentation();


    TransversedNode->BackPropagation(TransversedNode->GivenGame->TestForWinner(),PMCTS_ThreadData->TransversedNode);
    //Node_BackPropagation(TransversedNode,TransversedNode->GivenGame->TestForWinner());


  }
  PMCTS_ThreadData->Finished = true;
  //TransversedNode->DisplayTree(1);
  return 0;
  //returning PMCTS_Node<Game_Tp,Player_Tp>*
}





template <typename Game_Tp, typename Player_Tp>
void PMCTS<Game_Tp,Player_Tp>::DispatchByPigeonHole(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,int Threads, int ThreadDepth)
{

}

/*
template <typename Game_Tp, typename Player_Tp>
void PMCTS<Game_Tp,Player_Tp>::DispatchEvenly(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,int Threads, int Depth)
{
  double ThreadDepth = (Depth/TransversedNode->Children.size())+1;
  PMCTS_ThreadData_t<Game_Tp,Player_Tp>* PMCTS_ThreadData;
  //printf("Depth                           :%d\n",Depth);
  //printf("TransversedNode->Children.size():%d\n",TransversedNode->Children.size());
  //printf("ThreadDepth                     :%f\n",ThreadDepth);
  std::list<PMCTS_ThreadData_t<Game_Tp,Player_Tp>*> ThreadList;

  for (PMCTS_Node<Game_Tp,Player_Tp>* Node : TransversedNode->Children){
    //MCTS_Search(Node,ThreadDepth);

    PMCTS_ThreadData = DispatchThread(TransversedNode, ThreadDepth);
    ThreadList.push_back(PMCTS_ThreadData);

  }

  for (PMCTS_ThreadData_t<Game_Tp,Player_Tp>* Node : ThreadList){

    pthread_join((Node->Thread), NULL);
    free(Node);
  }
}
*/


template <typename Game_Tp, typename Player_Tp>
PMCTS_ThreadData_t<Game_Tp,Player_Tp>* _DispatchThread(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode, int ThreadDepth)
{
  PMCTS_ThreadData_t<Game_Tp,Player_Tp>* PMCTS_ThreadData = (PMCTS_ThreadData_t<Game_Tp,Player_Tp>*) malloc(sizeof(PMCTS_ThreadData_t<Game_Tp,Player_Tp>));
  //printf("PMCTS_ThreadData_t:%p\n",PMCTS_ThreadData);
  PMCTS_ThreadData->TransversedNode = TransversedNode;
  PMCTS_ThreadData->Depth           = ThreadDepth;
  PMCTS_ThreadData->Finished        = false;
  //_PMCTS_Search<Game_Tp,Player_Tp>(PMCTS_ThreadData);
  pthread_create(&(PMCTS_ThreadData->Thread), NULL, _PMCTS_Search<Game_Tp,Player_Tp>, PMCTS_ThreadData);
  return PMCTS_ThreadData;
}

#include <chrono>
#include <thread>

/*
JoinThreads.
 * @param
 *    Takes a std::list<PMCTS_ThreadData_t<Game_Tp,Player_Tp>*>, and takes the
 *   Finished threads and joins them.
 * Also has a internal wait 100 miliseconds to prevent overutilization of resources.

 */
template <typename Game_Tp, typename Player_Tp>
std::list<PMCTS_ThreadData_t<Game_Tp,Player_Tp>*> _JoinThreads(std::list<PMCTS_ThreadData_t<Game_Tp,Player_Tp>*>ThreadList)
{
  int ThreadsJoined = 0;

  PMCTS_ThreadData_t<Game_Tp,Player_Tp>* RemovingThread;
  while(ThreadsJoined <= 0){
      typename std::list<PMCTS_ThreadData_t<Game_Tp,Player_Tp>*>::iterator ThreadList_iterator = ThreadList.begin();
      while ( ThreadList_iterator != ThreadList.end())
      {
          if((*ThreadList_iterator)->Finished){
            pthread_join(((*ThreadList_iterator)->Thread), NULL);
            ThreadsJoined++;
            free((*ThreadList_iterator));
            ThreadList.erase(ThreadList_iterator++);
          }
          else
          {
              // move to next item
              ++ThreadList_iterator;
          }
      }
      std::this_thread::sleep_for(std::chrono::milliseconds(100));
    }

  return ThreadList;
}



template <typename Game_Tp, typename Player_Tp>
void PMCTS<Game_Tp,Player_Tp>::DispatchEvenly(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,int Threads, int Depth)
{
  double ThreadDepth = (Depth/TransversedNode->Children.size())+1;
  PMCTS_ThreadData_t<Game_Tp,Player_Tp>* PMCTS_ThreadData;


  //printf("Depth                           :%d\n",Depth);
  //printf("TransversedNode->Children.size():%d\n",TransversedNode->Children.size());
  //printf("ThreadDepth                     :%f\n",ThreadDepth);
  std::list<PMCTS_ThreadData_t<Game_Tp,Player_Tp>*> ThreadList;

  int ThreadsJoined    = 0;
  int TotalDispatches  = 0;
  int ThreadsDispatched = 0;
  for (PMCTS_Node<Game_Tp,Player_Tp>* Node : TransversedNode->Children){
    //MCTS_Search(Node,ThreadDepth);

    //////////////////////////////////////////////////////////////////////////////
    //For Each Thread to dispatch, preform the following function untill complete.
    bool DispatchedForNode = true;
    while(DispatchedForNode)
    {
      //printf("DispatchedForNode:%d\n",DispatchedForNode);
      //printf("ThreadsDispatched:%d\n",ThreadsDispatched);
      //printf("Threads:%d\n",Threads);
      //printf("//////////////////////////////////////////////////////////////////////////////\n");
      //////////////////////////////////////////////////////////////////////////////
      //Dispatch Threads
      if (ThreadList.size() < Threads){
        //PMCTS_ThreadData = _DispatchThread<Game_Tp,Player_Tp>(Node, ThreadDepth);
        ThreadList.push_back(
          _DispatchThread<Game_Tp,Player_Tp>(Node, ThreadDepth)
        );
        DispatchedForNode = false;
      }


      //////////////////////////////////////////////////////////////////////////////
      //Join Threads
      if (ThreadList.size() == Threads){
        ThreadList = _JoinThreads<Game_Tp,Player_Tp>(ThreadList);
      }
    }
  }

}





template <typename Game_Tp, typename Player_Tp>
void PMCTS<Game_Tp,Player_Tp>::DispatchByRotation(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,int Threads, int Depth)
{
  double ThreadDepth = (Depth/TransversedNode->Children.size())+1;
  PMCTS_ThreadData_t<Game_Tp,Player_Tp>* PMCTS_ThreadData;
  //printf("Depth                           :%d\n",Depth);
  //printf("TransversedNode->Children.size():%d\n",TransversedNode->Children.size());
  //printf("ThreadDepth                     :%f\n",ThreadDepth);
  std::list<PMCTS_ThreadData_t<Game_Tp,Player_Tp>*> ThreadList;

  for (PMCTS_Node<Game_Tp,Player_Tp>* Node : TransversedNode->Children){
    //MCTS_Search(Node,ThreadDepth);
    PMCTS_ThreadData = (PMCTS_ThreadData_t<Game_Tp,Player_Tp>*) malloc(sizeof(PMCTS_ThreadData_t<Game_Tp,Player_Tp>));
    printf("PMCTS_ThreadData_t:%p\n",PMCTS_ThreadData);
    PMCTS_ThreadData->TransversedNode = Node;
    PMCTS_ThreadData->Depth = ThreadDepth;
    PMCTS_ThreadData->Finished = false;

    //_PMCTS_Search<Game_Tp,Player_Tp>(PMCTS_ThreadData);
    pthread_create(&(PMCTS_ThreadData->Thread), NULL, _PMCTS_Search<Game_Tp,Player_Tp>, PMCTS_ThreadData);
    ThreadList.push_back(PMCTS_ThreadData);
  }

/*
//////////////////////////////////////////////////////////////////////////////
// Original Free Threads Code.
for (PMCTS_ThreadData_t<Game_Tp,Player_Tp>* Node : ThreadList){
  pthread_join((Node->Thread), NULL);
  free(Node);
}

*/

  while(ThreadList.size() > 0){
    ThreadList = _JoinThreads<Game_Tp,Player_Tp>(ThreadList);
  }
  printf("Size Remaining: %lu\n",ThreadList.size());



  //delete ThreadList;
}


template <typename Game_Tp, typename Player_Tp>
void PMCTS<Game_Tp,Player_Tp>::DispatchThreads(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,int Threads, int Depth)
{
  //TODO: add Segment Dispatch Logic to both:
  // -DispatchByPigeonHole
  // -DispatchByRotation


  /////////////////////////////////////////////////////////////////
  // Determine how to dispatch Threads.
  /////////////////////////////////////////////////////////////////
  if (Threads > TransversedNode->Children.size()){
    /////////////////////////////////////////////////////////////////
    // Dispatch by PigeonHole. Giving the highest UCB1 nodes more Threads.
    /////////////////////////////////////////////////////////////////
    DispatchByPigeonHole(TransversedNode,Threads,Depth);

  }
  else{
    /////////////////////////////////////////////////////////////////
    // Dispatch by Rotation, Each Branch will eventually get a Thread gets an even Search Depth.
    /////////////////////////////////////////////////////////////////
    //DispatchByRotation(TransversedNode,Threads,Depth);
    printf("calling DispatchEvenly\n");
    DispatchEvenly(TransversedNode,Threads,Depth);
  }

}





/**
 * Preforms the Monte Carlo tree search on the game used to initialize the MCTS
 *  Object.
 *
 *
 * @param <int> Depth(Depth of search tree).
 *
 * @return Void, modifies the given MCTS object, adding MCTS_Node elements to
 *   the Head node.
 *
 * @see MCTS
 * @see Game interface(Found within Game.cu)
 */
template <typename Game_Tp, typename Player_Tp>
void PMCTS<Game_Tp,Player_Tp>::Search(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,double Threads, double Depth)
{
  MCTS_Search(TransversedNode,5);
  DispatchThreads(TransversedNode, Threads, Depth);

/*
/////////////////////////////////////////////////////////////////
// Determine if Multiple Threads are being used.
/////////////////////////////////////////////////////////////////
if (Threads > 1){
  DispatchThreads(TransversedNode, Threads, Depth);
}
else{
  /////////////////////////////////////////////////////////////////
  // Only using one thread, preform MCTS normaly for given Depth.
  /////////////////////////////////////////////////////////////////
  MCTS_Search(TransversedNode,Depth);
}
*/

}


template <typename Game_Tp, typename Player_Tp>
void PMCTS<Game_Tp,Player_Tp>::Search(double Threads, double Depth)
{
  Search(HeadNode, Threads, Depth);
  HeadNode->DisplayTree(1);
}




#endif //P_MCTS_CU
