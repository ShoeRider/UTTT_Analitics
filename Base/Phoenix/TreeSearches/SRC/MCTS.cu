/*
====================================================================================================
Description MCTS(Conte-Carlo-Tree-Search):
- Contains MCTS(Conte-Carlo-Tree-Search), and MCTS_Node to search a search space
based on the given rules within Game.cu
====================================================================================================
Date:           13 September 2021
Script Version: 1.0
Name:           Anthony M Schroeder
Email:          as3379@nau.edu


==========================================================
Date:           15 September 2021
Script Version: 1.1
Description: Started modifying MCTS as a template<typename Game_Tp>.
==========================================================
Date:           16 September 2021
Script Version: 1.2
Description: Started modifying MCTS as a template<typename Game_Tp, typename Player_Tp>.
==========================================================
*/

#ifndef MCTS_CU
#define MCTS_CU


#include <iostream>
#include <string>
#include <list>
#include <cmath>
#include <bits/stdc++.h>

#include "TreeSearch.cu"
#include "../../Games/SRC/Game.cpp"



#define Pause int ASDF; std::cin >> ASDF;


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
class MCTS_Node
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
  // List of Players to maintain turn order.
  //////////////////////////////////////////////////////////////////////////////
  std::list<Player_Tp*> Players;

  //////////////////////////////////////////////////////////////////////////////
  // pointers to maintain tree structure.
  //////////////////////////////////////////////////////////////////////////////
  MCTS_Node*           Parent       = NULL;
  MCTS_Node*           RollOutChild = NULL;
  std::list<MCTS_Node*> Children;


    //////////////////////////////////////////////////////////////////////////////
    // Initialization method.
    MCTS_Node(Game_Tp* Instance,std::list<Player_Tp*> _GivenPlayers){
      for (Player_Tp* _Player : _GivenPlayers){
            //printf("adding Player:%p\n",(_Player));
            Players.push_back(_Player);
      }
      GivenGame  = Instance;
      Children   = {};
      NodeVisits = 0;
      ValueSum   = 0;
      //printf("Creating MCTS Node w Player:%p\n",*(Players.begin()));
      //std::cin.get();
    }


    ~MCTS_Node(){
      for (MCTS_Node<Game_Tp,Player_Tp>* Node : Children){
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
    void       RotatePlayers();

    MCTS_Node* Find_MAX_UCB1_Child();
    MCTS_Node* ReturnBestMove();
    MCTS_Node* RollOut();
    int        AddChildren(std::list<Game_Tp*> PossibleMoves);
    void       BackPropagation(Player_Tp* GivenPlayer);
    double     GetAverageValue();
    void       DisplayTree();
    void       DisplayTree(int Depth);
    void       DisplayStats();
    std::size_t GetHash();
};

/*
MCTS_Node* get(std::list<MCTS_Node*> _list, int _i){
    std::list<MCTS_Node*>::iterator it = _list.begin();
    for(int i=0; i<_i; i++){
        ++it;
    }
    return *it;
}*/

template <typename Game_Tp, typename Player_Tp>
void MCTS_Node<Game_Tp,Player_Tp>::RotatePlayers(){
  Players.splice(Players.end(),        // destination position
                 Players,              // source list
                 Players.begin());     // source position

};



//Preform MonteCarlo's UCB1 evaluation algorithm on a given node.
template <typename Game_Tp, typename Player_Tp>
double MCTS_Node<Game_Tp,Player_Tp>::Find_UCB1(){
  double ExploreBy = 1.4142;
  if(NodeVisits == 0)
	{
		return DBL_MAX;
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
printf("Parent_NodeVisits:%f\n",_NodeVisits);
printf("log(_NodeVisits/NodeVisits):%f\n",log(_NodeVisits/NodeVisits));
printf("sqrt(log(_NodeVisits/NodeVisits):%f\n",sqrt(log(_NodeVisits/NodeVisits)));
printf("ExploreBy*sqrt(log(_NodeVisits/NodeVisits)):%f\n",ExploreBy*sqrt(log(_NodeVisits/NodeVisits)));
printf("Value:%f\n", Value);
printf("\tNodeVisits:%f\n", NodeVisits);
printf("\tValueSum:%f\n", ValueSum);*/

  return Value;
}

template <typename Game_Tp, typename Player_Tp>
MCTS_Node<Game_Tp,Player_Tp>* MCTS_Node<Game_Tp,Player_Tp>::Find_MAX_UCB1_Child(){
  double     HighestValue = -DBL_MAX;
  double     NodesValue;
  MCTS_Node* HighestNode  = (*Children.begin());
/*
printf("Children.size(): %lu\n",Children.size());
printf("HighestValue: %f\n",HighestValue);
printf("HighestValue-1: %f\n",HighestValue-1);*/

  for (MCTS_Node<Game_Tp,Player_Tp>* Node : Children){
      NodesValue = Node->Find_UCB1();
/*
printf("potential Node: %p\n",Node);
printf("HighestValue: %f\n",HighestValue);
printf("NodesValue: %f\n",NodesValue);
*/


      if (HighestValue <= NodesValue)
      {
      //printf("Swaping Max Node\n");
        HighestNode  = Node;
        HighestValue = NodesValue;
      }
  }
  //printf("HighestNode: %p\n",HighestNode);
  //Note: Doesnt account for NULL Node
  return HighestNode;
}

//Preform MonteCarlo's UCB1 evaluation algorithm on a given node, and return
//the node with the highest UCB1 Value.
template <typename Game_Tp, typename Player_Tp>
MCTS_Node<Game_Tp,Player_Tp>* MCTS_Node<Game_Tp,Player_Tp>::ReturnBestMove(){
  double     HighestValue = -DBL_MAX;
  double     NodesValue;
  MCTS_Node* HighestNode  = NULL;

  for (MCTS_Node<Game_Tp,Player_Tp>* Node : Children){
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
int MCTS_Node<Game_Tp,Player_Tp>::AddChildren(std::list<Game_Tp*> PossibleInstances){
  int ChildrenAdded = 0;
  MCTS_Node* NewNode;

  //////////////////////////////////////////////////////////////////////////////
  // For each element within a list of PossibleInstances(Different Game States)
  // Add as different Childeren/Leaf Nodes
  for (Game_Tp* Instance : PossibleInstances){

      if(Instance != NULL)
      {

        //////////////////////////////////////////////////////////////////////////////
        // For Each Possible Game, Create New MCTS_Node<Game_Tp>, and add it to
        // children list.
        NewNode = new MCTS_Node<Game_Tp,Player_Tp>(Instance,(Instance->Players));
        NewNode->Parent = this;
        NewNode->RotatePlayers();

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
MCTS_Node<Game_Tp,Player_Tp>* MCTS_Node<Game_Tp,Player_Tp>::RollOut(){

  Game_Tp* RollOutGame = GivenGame->CopyGame();
  RollOutGame->RollOut();

  //printf("RO_WinningPlayer:%p\n",RollOutGame->WinningPlayer);
  //TODO Check if game is finished
  RollOutChild = new MCTS_Node(RollOutGame,Players);
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
void MCTS_Node<Game_Tp,Player_Tp>::BackPropagation(Player_Tp* GivenPlayer)
{

  NodeVisits++;


  //If no matching condition is found an apposing player won the RollOut game.
  double EvaluatedValue = -1;
  if(*(Players.begin()) == GivenPlayer)
  {
    EvaluatedValue = 1;
  }
  else if(GivenPlayer == NULL)
  {
    EvaluatedValue = 0;
  }
  else{

    EvaluatedValue = -1;
  }
  //std::cout << GivenGame->Generate_StringRepresentation();
  //printf("MCTS Node Player:%p\n",*(Players.begin()));
  //printf("     GivenPlayer:%p\n",GivenPlayer);
  //printf("  EvaluatedValue:%f\n",EvaluatedValue);
  //printf("           Value:%f\n",ValueSum);
  //printf("          Visits:%f\n",NodeVisits);
  ValueSum += EvaluatedValue;
  //printf(" Parent:%p\n",Parent);
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
template <typename Game_Tp, typename Player_Tp>
double MCTS_Node<Game_Tp,Player_Tp>::GetAverageValue()
{
  return ValueSum/NodeVisits;
}

template <typename Game_Tp, typename Player_Tp>
std::size_t MCTS_Node<Game_Tp,Player_Tp>::GetHash()
{
  //std::hash<Game_Tp>* Hash = new std::hash<Game_Tp>;// = std::hash<TTT>(* _Game);
  //std::size_t HashValue = Hash(GivenGame);
  //delete Hash;
  return GivenGame->Hash();
}
/*
DisplayStats


*/
template <typename Game_Tp, typename Player_Tp>
void MCTS_Node<Game_Tp,Player_Tp>::DisplayStats(){
  std::cout << "----------------------------------------\n";
  printf("\tLocation: %p\n",this);
  printf("\tPlayer: %c\n",(*Players.begin())->GameRepresentation);
  printf("\tNodeVisits:%f\n", NodeVisits);
  printf("\tValueSum:%f\n", ValueSum);
  printf("\tNode Ratio:%f\n", (ValueSum/NodeVisits));
  printf("\tUCB1:%f\n", Find_UCB1());
  printf("\tHash: %zu\n",GivenGame->Hash());
  printf("\tChilderen: %zu\n",Children.size());
  std::cout << GivenGame->Generate_StringRepresentation();
  for (MCTS_Node<Game_Tp,Player_Tp>* Node : Children){
    printf("\t\tChilderen: %p \t%f \t%f\n",Node,Node->ValueSum,Node->NodeVisits);
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
void MCTS_Node<Game_Tp,Player_Tp>::DisplayTree(int Depth){

  //std::cout << "Displaying Depth:" << Depth << "\n";
  //std::cout << "Children length:" << Children.size() << "\n";
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
template <typename Game_Tp, typename Player_Tp>
void MCTS_Node<Game_Tp,Player_Tp>::DisplayTree(){
  // For each branch, display the game's statistics.
  //////////////////////////////////////////////////////////////////////////////
  for (MCTS_Node* Child : Children) {
      Child->DisplayStats();
    }

  std::cout << "----------------------------------------\n";
  std::cout << GivenGame->Generate_StringRepresentation();
  for (MCTS_Node* Child : Children) {
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
class MCTS: public TreeSimulation
{
public:

  //////////////////////////////////////////////////////////////////////////////
  // The current head node.
  //////////////////////////////////////////////////////////////////////////////
  Game_Tp* GivenGame;
  //MCTS_Node* TransversedNode;
  MCTS_Node<Game_Tp,Player_Tp>* HeadNode;
  Game_Tp* SimulatedGame;


  //////////////////////////////////////////////////////////////////////////////
  // The current head node.
  //////////////////////////////////////////////////////////////////////////////
  std::list<Player_Tp*> Players;
  Player_Tp* GivenPlayer;


  //////////////////////////////////////////////////////////////////////////////
  // Initialization method.
  MCTS(Game_Tp*_Game,std::list<Player_Tp*> _GivenPlayers){

    Players = _GivenPlayers;
    GivenPlayer = *(_GivenPlayers.begin());
    for (Player_Tp* _Player : _GivenPlayers){
          //printf("MCTS Playerlist:%p\n",(_Player));
    }
    //HeadNode  = NULL;
    //printf("new MCTS_Node's Player:%p\n",Player);
    //std::cin.get();

    HeadNode  = new MCTS_Node<Game_Tp,Player_Tp>(_Game,_GivenPlayers);
    GivenGame = _Game;
  }

  //////////////////////////////////////////////////////////////////////////////
  //
  //////////////////////////////////////////////////////////////////////////////
  virtual ~MCTS(){
    delete HeadNode;
  }

  //////////////////////////////////////////////////////////////////////////////
  // Method Declarations.
  //////////////////////////////////////////////////////////////////////////////
    MCTS_Node<Game_Tp,Player_Tp>* Algorithm(MCTS_Node<Game_Tp,Player_Tp>* TransversedNode);

    void CreateChildren();
    void TreeTraversal();
    void CreateNode();
    void RollOut();

    void EvaluateStep(MCTS_Node<Game_Tp,Player_Tp>* TransversedNode,Player_Tp* GivenPlayer);
    //double BackPropagation(MCTS_Node* TransversedNode,double GivenPlayer);
    void Search(int Depth); //,Player* GivenPlayer
    MCTS* PruneSearch(MCTS_Node<Game_Tp,Player_Tp>*SelectedNode);
    void ParallelSearch(int Depth);


    //MCTS* CreateBookMoves();
    //MCTS* SaveBookMoves(char* Path);
    //MCTS* OpenBookMoves(char* Path);
    //MCTS_Node* Find_Highest_UCB1(std::list<MCTS_Node*>MCTS_List);



    void Save(std::string FilePath);
    //MCTS* Read_MCTS_UTTT_JSON(std::string FilePath);
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
MCTS_Node<Game_Tp,Player_Tp>* MCTS<Game_Tp,Player_Tp>::Algorithm(MCTS_Node<Game_Tp,Player_Tp>* TransversedNode)
{
  /*
    Helper Function for MCTS::Search & EvaluateStep.
    Performs an itteration of the MCTS Algorithm on 'TransversedNode'
  */


//TransversedNode->Children.size()
//int Leaf =TransversedNode->Children.size();

  //TransversedNode->DisplayStats();
  //std::cout << TransversedNode->GivenGame->Generate_StringRepresentation();
  /*
  std::cout << "TransversedNode:" <<TransversedNode << "\n";
  std::cout << "NodeVisits:" <<TransversedNode->NodeVisits << "\n";
  std::cout << "Children:"   <<TransversedNode->Children.size() << "\n";
  */

  //Pause;

  //std::cout << "TransversedNode->Children.size()  :"   << TransversedNode->Children.size() << "\n";

  if(TransversedNode->Children.size() == 0){
    //////////////////////////////////////////////////////////////////////////////
    //If Node is LeafNode, create Children nodes, and select the first node for
    // rollout.
    //////////////////////////////////////////////////////////////////////////////
    //std::cout << "TransversedNode->Children.size()  :"   << TransversedNode->Children.size() << "\n";

    if(TransversedNode->GivenGame->SimulationFinished){
      //std::cout << TransversedNode->GivenGame->Generate_StringRepresentation();
      //Pause;
      return TransversedNode;
    }

    //std::cout << "NodeVisits:" <<TransversedNode->NodeVisits << "\n";
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
    //printf("TransversedNode->GivenGame->Players.begin():%p\n",*(TransversedNode->GivenGame->Players.begin()));
    TransversedNode->AddChildren(Games);

    /////////////////////////////////////////////////////////////////
    //select the first posible node.
    /////////////////////////////////////////////////////////////////
    MCTS_Node<Game_Tp,Player_Tp>* NextNode = *TransversedNode->Children.begin();

    /////////////////////////////////////////////////////////////////
    //Recursivly search down the tree looking for an 'optimal' branch to evaluate.
    /////////////////////////////////////////////////////////////////
    return Algorithm(NextNode);

  }
  //Otherwise, transverse the tree using the UCB1 formula, looking for an 'optimal' branch to evaluate.
  else{

    //Not Leaf Node, Transverse down the Tree: Find the branch with the MAX UCB1 value.
    MCTS_Node<Game_Tp,Player_Tp>* MAXNode = TransversedNode->Find_MAX_UCB1_Child();

    //printf("MAXNode: %p\n",MAXNode);
    //Recursivly search down the tree looking for an 'optimal' branch to evaluate.
    return Algorithm(MAXNode);
  }
}




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
void MCTS<Game_Tp,Player_Tp>::EvaluateStep(MCTS_Node<Game_Tp,Player_Tp>* TransversedNode,Player_Tp* GivenPlayer)
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
void MCTS<Game_Tp,Player_Tp>::Search(int Depth)
{

    std::cout << "Searching Depth:" << Depth << "\n";
    // Increment counter, and perform another step within the search.
    for (int i = 0; i < Depth; i++) {
      //printf("\tDepth: %d\n",i);

      // Use helper Method EvaluateStep to increment the search.
      EvaluateStep(HeadNode,GivenPlayer);
    }
//Pause
    HeadNode->DisplayTree(1);
    HeadNode->DisplayStats();


}

template <typename Game_Tp, typename Player_Tp>
MCTS<Game_Tp,Player_Tp>* MCTS<Game_Tp,Player_Tp>::PruneSearch(MCTS_Node<Game_Tp,Player_Tp>*SelectedNode)
{

    return NULL;
}


template <typename Game_Tp, typename Player_Tp>
void MCTS<Game_Tp,Player_Tp>::ParallelSearch(int Depth)
{
    std::cout << "Searching Depth:" << Depth << "\n";

}


void MCTS<Game_Tp,Player_Tp>::Save(std::string FilePath){

}





#endif //MCTS_CU
