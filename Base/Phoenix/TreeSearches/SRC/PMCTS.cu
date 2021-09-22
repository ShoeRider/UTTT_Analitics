/*
====================================================================================================
Description PMCTS(Parallel Monte Carlo Tree Search):
This takes the Monte-Carlo Tree search and adds some multithreading to Create Faster Searches.

Still uses the Game interface, and template structure from MCTS.

TODO:
  Create PMCTS<> template
  Implement Break Out Search from notes.
====================================================================================================
Date:           NA
Script Version: 1.0
Name:           Anthony M Schroeder
Email:          as3379@nau.edu
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
#include "TreeSearch.cu"
#include "../SRC/MCTS.cu"
#include "../../ThreadingTools/SRC/ThreadingTools.cu"





class PMCTS_ThreadData_t : public ThreadData_t
{

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
/*
double     Find_UCB1();

PMCTS_Node* Find_MAX_UCB1_Child();
PMCTS_Node* ReturnBestMove();
PMCTS_Node* RollOut();
int        AddChildren(std::list<Game_Tp*> PossibleMoves);
void       BackPropagation(Player_Tp* GivenPlayer);
double     GetAverageValue();
void       DisplayTree();
void       DisplayTree(int Depth);
void       DisplayStats();
*/
};






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
  double ThreadDepth;


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
  }

  //////////////////////////////////////////////////////////////////////////////
  //
  //////////////////////////////////////////////////////////////////////////////
  virtual ~PMCTS(){
    delete HeadNode;
  }

  //////////////////////////////////////////////////////////////////////////////
  // Parallel Functions
  //////////////////////////////////////////////////////////////////////////////
  PMCTS_Node<Game_Tp,Player_Tp>* DispatchThread(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,int Threads, int ThreadDepth);
  void DispatchThreads(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,int Threads, int ThreadDepth);
  void DispatchByPigeonHole(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,int Threads, int ThreadDepth);
  void DispatchByRotation(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,int Threads, int ThreadDepth);

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
  void EvaluateStep(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,Player_Tp* GivenPlayer);
  //double BackPropagation(MCTS_Node* TransversedNode,double GivenPlayer);
  void PMCTS_Search(int Depth); //,Player* GivenPlayer
  void MCTS_Search(int Depth); //,Player* GivenPlayer
  PMCTS* PruneSearch(PMCTS_Node<Game_Tp,Player_Tp>*SelectedNode);
  void ParallelSearch(int Depth);


  //MCTS* CreateBookMoves();
  //MCTS* SaveBookMoves(char* Path);
  //MCTS* OpenBookMoves(char* Path);
  //MCTS_Node* Find_Highest_UCB1(std::list<MCTS_Node*>MCTS_List);


  void CreateChildren();
  void TreeTraversal();
  void CreateNode();
  void RollOut();

};



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
void PMCTS<Game_Tp,Player_Tp>::EvaluateStep(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,Player_Tp* GivenPlayer)
{

    TransversedNode = Algorithm(TransversedNode);
    //std::cout << TransversedNode->GivenGame->Generate_StringRepresentation();

    TransversedNode->BackPropagation(TransversedNode->GivenGame->TestForWinner());
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
void PMCTS<Game_Tp,Player_Tp>::MCTS_Search(int Depth)
{
    // Increment counter, and perform another step within the search.
    for (int i = 0; i < Depth; i++) {
      //printf("\tDepth: %d\n",i);

      // Use helper Method EvaluateStep to increment the search.
      EvaluateStep(HeadNode,GivenPlayer);
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
void PMCTS<Game_Tp,Player_Tp>::PMCTS_Search(int Depth)
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
      //Instead of returning node, should i just apply the values to the tree directly ?
      return TransversedNode;
    }
    /////////////////////////////////////////////////////////////////
    //Takes the new Games and add them to the tree.
    /////////////////////////////////////////////////////////////////
    //printf("TransversedNode->GivenGame->Players.begin():%p\n",*(TransversedNode->GivenGame->_Players.begin()));
    TransversedNode->AddChildren(Games);
  }

  /////////////////////////////////////////////////////////////////
  //Use the threads given.
  DispatchThreads(TransversedNode,Threads,ThreadDepth);


  /////////////////////////////////////////////////////////////////
  //Preform BackPropagation to balance tree.
}


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
PMCTS_Node<Game_Tp,Player_Tp>* PMCTS<Game_Tp,Player_Tp>::PMCTS_Algorithm(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode)
{
  /////////////////////////////////////////////////////////////////
  // Determine if Multiple Threads are being used.
  /////////////////////////////////////////////////////////////////
  if (Threads > 1){


  }
  else{
    /////////////////////////////////////////////////////////////////
    // Only using one thread, preform MCTS normaly for given Depth.
    /////////////////////////////////////////////////////////////////
    MCTS_Search(Depth);
  }

  return 0;
}

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
    return Algorithm(NextNode);

  }
  //Otherwise, transverse the tree using the UCB1 formula, looking for an 'optimal' branch to evaluate.
  else{

    //Not Leaf Node, Transverse down the Tree: Find the branch with the MAX UCB1 value.
    PMCTS_Node<Game_Tp,Player_Tp>* MAXNode = TransversedNode->Find_MAX_UCB1_Child();

    //Recursivly search down the tree looking for an 'optimal' branch to evaluate.
    return Algorithm(MAXNode);
  }
}




template <typename Game_Tp, typename Player_Tp>
void PMCTS<Game_Tp,Player_Tp>::DispatchThreads(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,int Threads, int ThreadDepth)
{
  /////////////////////////////////////////////////////////////////
  // Determine how to dispatch Threads.
  /////////////////////////////////////////////////////////////////
  if (Threads > TransversedNode->Children.size()){
    /////////////////////////////////////////////////////////////////
    // Dispatch by PigeonHole. Giving the highest UCB1 nodes more Threads.
    /////////////////////////////////////////////////////////////////
    DispatchByPigeonHole(TransversedNode,Threads,ThreadDepth);

  }
  else{
    /////////////////////////////////////////////////////////////////
    // Dispatch by Rotation, Each Branch will eventually get a Thread gets an even Search Depth.
    /////////////////////////////////////////////////////////////////
    int Depth = TransversedNode->Children.size()/ThreadDepth;
    DispatchByRotation(TransversedNode,Threads,Depth);
  }
}


template <typename Game_Tp, typename Player_Tp>
void PMCTS<Game_Tp,Player_Tp>::DispatchByPigeonHole(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,int Threads, int ThreadDepth)
{

}

template <typename Game_Tp, typename Player_Tp>
void PMCTS<Game_Tp,Player_Tp>::DispatchByRotation(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,int Threads, int ThreadDepth)
{

  for (PMCTS* Node : TransversedNode->Children){

  }
}

template <typename Game_Tp, typename Player_Tp>
PMCTS_Node<Game_Tp,Player_Tp>* PMCTS<Game_Tp,Player_Tp>::DispatchThread(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,int Threads, int ThreadDepth)
{

}


#endif //P_MCTS_CU
