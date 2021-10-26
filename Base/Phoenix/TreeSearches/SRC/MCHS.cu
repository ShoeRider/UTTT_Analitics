/*
====================================================================================================
Description MCHS(Conte-Carlo-Hash-Search):
- Contains MCHS(Conte-Carlo-Hash-Search), and MCHS_Node to search a search space
based on the given rules within Game.cu


====================================================================================================
Date:           16 October 2021
Script Version: 2.0
Description: MCHS is a  modified version of MCTS to utilize a hash table in
conjunction with the standard MCTS search tree. This uses the game hash to
quickly find the duplicate game’s within different branches and prevents
identical branches from searching the same space.
==========================================================

*/

#ifndef MCHS_CU
#define MCHS_CU


#include <iostream>
#include <string>
#include <list>
#include <cmath>
#include <bits/stdc++.h>

#include "HashTable.cu"
#include "TreeSearch.cu"
#include "../../Games/SRC/Game.cu"



#define Pause int ASDF; std::cin >> ASDF;


/*
MCHS_Node

Great step by step example found here: https://www.youtube.com/watch?v=UXW2yZndl7U

@Methods:

 * @param
    Game* Instance,

 *
 * @see MCHS::Find_MAX_UCB1_Child()
 * @see Game interface(Found within Game.cu)
 */
template <typename Game_Tp, typename Player_Tp>
class MCHS_Node
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
  std::list<Player_Tp*> Players;

  //////////////////////////////////////////////////////////////////////////////
  // pointers to maintain tree structure.
  //////////////////////////////////////////////////////////////////////////////
  //MCHS_Node*           Parent       = NULL;
  std::list<MCHS_Node<Game_Tp,Player_Tp>*> Parents;
  MCHS_Node<Game_Tp,Player_Tp>*           RollOutChild = NULL;
  std::list<MCHS_Node<Game_Tp,Player_Tp>*> Children;

  //////////////////////////////////////////////////////////////////////////////
  //HashTable
  HashTable_t<MCHS_Node<Game_Tp,Player_Tp>>*HashTable;

    //////////////////////////////////////////////////////////////////////////////
    // Initialization method.
    //<Game_Tp,Player_Tp>
    MCHS_Node(Game_Tp* Instance,std::list<Player_Tp*> _GivenPlayers,HashTable_t<MCHS_Node>*GivenHashTable){
      for (Player_Tp* _Player : _GivenPlayers){
            //printf("adding Player:%p\n",(_Player));
            Players.push_back(_Player);
      }

      Parents = {};
      HashTable  = GivenHashTable;
      GivenGame  = Instance;
      Children   = {};
      NodeVisits = 0;
      ValueSum   = 0;

      //printf("Creating MCHS Node w Player:%p\n",*(_Players.begin()));
      //std::cin.get();
    }


    ~MCHS_Node(){
      //for (MCHS_Node<Game_Tp,Player_Tp>* Node : Children){
        //delete Node;
      //}

      if (RollOutChild != NULL)
      {
          delete RollOutChild;
      }

      //delete Parents;

      delete GivenGame;
    }

    bool equal(MCHS_Node * Node0)
    {
      return (GivenGame->equal(Node0->GivenGame));
    }
    //////////////////////////////////////////////////////////////////////////////
    // Method Declarations.
    //////////////////////////////////////////////////////////////////////////////
    double     Find_UCB1();
    void       RotatePlayers();

    MCHS_Node* Find_MAX_UCB1_Child();
    MCHS_Node* ReturnBestMove();
    MCHS_Node* RollOut();
    int        AddChildren(std::list<Game_Tp*> PossibleMoves);
    void       BackPropagation(Player_Tp* GivenPlayer);
    double     GetAverageValue();
    void       DisplayTree();
    void       DisplayTree(int Depth);
    void       DisplayStats();
    std::size_t GetHash();
    void RefreshWeights();
};

/*
MCHS_Node* get(std::list<MCHS_Node*> _list, int _i){
    std::list<MCHS_Node*>::iterator it = _list.begin();
    for(int i=0; i<_i; i++){
        ++it;
    }
    return *it;
}*/

template <typename Game_Tp, typename Player_Tp>
void MCHS_Node<Game_Tp,Player_Tp>::RotatePlayers(){
  Players.splice(Players.end(),        // destination position
                 Players,              // source list
                 Players.begin());     // source position

};




//Preform MonteCarlo's UCB1 evaluation algorithm on a given node.
template <typename Game_Tp, typename Player_Tp>
double MCHS_Node<Game_Tp,Player_Tp>::Find_UCB1(){

  double MaxValue = INT_MAX;
  double Value = 0;



  for (MCHS_Node<Game_Tp,Player_Tp>* Parent : Parents){
    double ExploreBy = 1.4142;
    if(NodeVisits == 0)
    {
      return DBL_MAX;
    }
    float _NodeVisits = 1;
    _NodeVisits = Parent->NodeVisits;

    //Preform UCB1 Formula
    Value = (ValueSum/NodeVisits) + ExploreBy*sqrt(log(_NodeVisits/NodeVisits));
    if(MaxValue<Value){
      MaxValue = Value;
    }
  }


/*
printf("Value:%f\n", Value);
printf("\tNodeVisits:%i\n", NodeVisits);
printf("\tValueSum:%f\n", ValueSum);
*/
  return Value;
}

template <typename Game_Tp, typename Player_Tp>
MCHS_Node<Game_Tp,Player_Tp>* MCHS_Node<Game_Tp,Player_Tp>::Find_MAX_UCB1_Child(){
  double     HighestValue = -DBL_MAX;
  double     NodesValue;
  MCHS_Node* HighestNode  = (*Children.begin());

  for (MCHS_Node<Game_Tp,Player_Tp>* Node : Children){
      NodesValue = Node->Find_UCB1();

      if (HighestValue <= NodesValue)
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
MCHS_Node<Game_Tp,Player_Tp>* MCHS_Node<Game_Tp,Player_Tp>::ReturnBestMove(){
  double     HighestValue = -DBL_MAX;
  double     NodesValue;
  MCHS_Node* HighestNode  = NULL;

  for (MCHS_Node<Game_Tp,Player_Tp>* Node : Children){
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
void MCHS_Node<Game_Tp,Player_Tp>::DisplayStats(){
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
  for (MCHS_Node<Game_Tp,Player_Tp>* Node : Children){
    printf("\t\tChilderen: %p \t%f \t%f\n",Node,Node->ValueSum,Node->NodeVisits);
  }
}

template <typename Game_Tp, typename Player_Tp>
int MCHS_Node<Game_Tp,Player_Tp>::AddChildren(std::list<Game_Tp*> PossibleInstances){
  int ChildrenAdded = 0;
  MCHS_Node* NewNode;

  //////////////////////////////////////////////////////////////////////////////
  // For each element within a list of PossibleInstances(Different Game States)
  // Add as different Childeren/Leaf Nodes
  for (Game_Tp* Instance : PossibleInstances){

      if(Instance != NULL)
      {


        //////////////////////////////////////////////////////////////////////////////
        // For Each Possible Game, Create New MCHS_Node<Game_Tp>, and add it to
        // children list.
        NewNode = new MCHS_Node<Game_Tp,Player_Tp>(Instance,(Instance->Players),HashTable);
        bool InsertedNode = false;
        NewNode->RotatePlayers();
        std::tie(NewNode, InsertedNode) = HashTable->AddGetReference(NewNode);

        Children.push_back(NewNode);
        NewNode->Parents.push_back(this);
        //std::cout << "\t"<<NewNode->Parents.size() << "\n";
/*
if(InsertedNode){
  this->RefreshWeights();
}
this->RefreshWeights();
*/
  if(!InsertedNode){

    //std::cout << "updating weights\n";
    //std::cout << "old*\t:"<<NewNode->NodeVisits<< "\n";
    //std::cout << "\t"<<this->NodeVisits<< "\n";
    RefreshWeights();
    //std::cout << "\t"<<this->NodeVisits<< "\n";
    //this->DisplayStats();
    //NewNode->DisplayStats();
  }


        ChildrenAdded++;
      }
  }
  return ChildrenAdded;
}

/*
Takes the Node itself, copies itself.        if(InsertedNode){
          this->RefreshWeights();
        }
        this->RefreshWeights();
(This also copies the corresponding game state And performs Rollout on the new copy.)
Please note: also sets the copy node's parent as the given Node. (This is
for the BackPropagation step for attributing the Final game state's value back up the tree)
Afterward, it returns the new copy.

@param Nothing
@return pointer to Copied Rollout Node.

*/
template <typename Game_Tp, typename Player_Tp>
MCHS_Node<Game_Tp,Player_Tp>* MCHS_Node<Game_Tp,Player_Tp>::RollOut(){

  Game_Tp* RollOutGame = GivenGame->CopyGame();
  RollOutGame->RollOut();

  //printf("RO_WinningPlayer:%p\n",RollOutGame->WinningPlayer);
  //TODO Check if game is finished
  //No need to free externally, MCHS_Node deconstructer will free.
  RollOutChild = new MCHS_Node<Game_Tp,Player_Tp>(RollOutGame,Players,HashTable);

  RollOutChild->Parents.push_back(this);
  //RollOutChild->Parent = this;
  return RollOutChild;
}

template <typename Game_Tp, typename Player_Tp>
void MCHS_Node<Game_Tp,Player_Tp>::RefreshWeights()
{
  if(Parents.size()){
    NodeVisits = 1;
    ValueSum   = 0;

    for (MCHS_Node<Game_Tp,Player_Tp>* Node : Children){
      NodeVisits += Node->NodeVisits;
      ValueSum   += -(Node->ValueSum);


    }
  }
  else{
    NodeVisits = 1;
    ValueSum   = 0;

    for (MCHS_Node<Game_Tp,Player_Tp>* Node : Children){
      NodeVisits += Node->NodeVisits;
      ValueSum   += (Node->ValueSum);


    }
  }

  //this->DisplayStats();
  if(Parents.size()){
    for (MCHS_Node<Game_Tp,Player_Tp>* Parent : Parents){
      //std::cout << "\tParent: " << Parent << "\n";

      Parent->RefreshWeights();

      //Parent->
    }
  }
}

/*
BackPropagation is the final step of the MCHS. It backtracks from a rollout leaf node,
 back up the tree. This attributes Values to each parent node based on the out
 come of the current branch, for each node it tests if the current Player is the winner of the transversal.
 A winning state for that player recieves +1, Losing -1, tie +0

@param (Player* GivenPlayer)The final winner from the rollout evaluation.
@return Nothing(void)

*/
template <typename Game_Tp, typename Player_Tp>
void MCHS_Node<Game_Tp,Player_Tp>::BackPropagation(Player_Tp* GivenPlayer)
{

  NodeVisits++;


  //If no matching condition is found an apposing player won the RollOut game.
  //double EvaluatedValue = -1;
  if(*(Players.begin()) == GivenPlayer)
  {
    ValueSum += 1;
  }
  else if(GivenPlayer == NULL)
  {
    ValueSum += 0;
  }
  else{

    ValueSum -= 1;
  }
  //std::cout << GivenGame->Generate_StringRepresentation();
  //printf("MCHS Node Player:%p\n",*(_Players.begin()));
  //printf("     GivenPlayer:%p\n",GivenPlayer);
  //printf("  EvaluatedValue:%f\n",EvaluatedValue);
  //printf("           Value:%f\n",ValueSum);
  //printf("          Visits:%f\n",NodeVisits);
  //ValueSum += EvaluatedValue;
  //printf(" Parent:%p\n",Parent);
  //If not the head Node, Keep transversing up the Search Tree.

    //std::cout << "Parents:"<<Parents.size()<<"\n";
  if(Parents.size()){
    for (MCHS_Node<Game_Tp,Player_Tp>* Parent : Parents){
      //std::cout << "\tParent: " << Parent << "\n";
      Parent->BackPropagation(GivenPlayer);
      //Parent->RefreshWeights();
    }
  }

  //RefreshWeights();


}


/*gets the average Value of a node.
 this is desired over the
O(1) vs O(1)

@param Nothing
@return pointer to Copied Rollout Node.

*/
template <typename Game_Tp, typename Player_Tp>
double MCHS_Node<Game_Tp,Player_Tp>::GetAverageValue()
{
  return ValueSum/NodeVisits;
}

template <typename Game_Tp, typename Player_Tp>
std::size_t MCHS_Node<Game_Tp,Player_Tp>::GetHash()
{
  //std::hash<Game_Tp>* Hash = new std::hash<Game_Tp>;// = std::hash<TTT>(* _Game);
  //std::size_t HashValue = Hash(GivenGame);
  //delete Hash;
  return GivenGame->Hash();
}
/*
DisplayStats

template <typename Game_Tp, typename Player_Tp>
void MCHS_Node<Game_Tp,Player_Tp>::DisplayStats(){
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
*/


/*
DisplayTree(int Depth)
  DisplayTree is a recursive function that displays the tree's structure, allowing for further
  analysis of the tree search.

@param (int Depth)
@return Void

*/
template <typename Game_Tp, typename Player_Tp>
void MCHS_Node<Game_Tp,Player_Tp>::DisplayTree(int Depth){

  //std::cout << "Displaying Depth:" << Depth << "\n";
  //std::cout << "Children length:" << Children.size() << "\n";
  if (Children.size() > 0){
    for (MCHS_Node* Child : Children) { // c++11 range-based for loop
         Child->DisplayStats();
      }
    if((Depth-1)>0){
      for (MCHS_Node* Child : Children) { // c++11 range-based for loop
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
void MCHS_Node<Game_Tp,Player_Tp>::DisplayTree(){
  // For each branch, display the game's statistics.
  //////////////////////////////////////////////////////////////////////////////
  for (MCHS_Node* Child : Children) {
      Child->DisplayStats();
    }

  std::cout << "----------------------------------------\n";
  std::cout << GivenGame->Generate_StringRepresentation();
  for (MCHS_Node* Child : Children) {
       Child->DisplayTree();
    }

}







#include "HashTable.cu"
/*
MCHS is a tree search that takes a complete view of a game and evaluates the
most optimal moves for both players through a UCB1 algorithm.
This algorithm performs a hybrid of breath and depth search to evenly search a given search space.

Great step by step example found here: https://www.youtube.com/watch?v=UXW2yZndl7U

@Methods:
Search()
Algorithm():: A recursive implementation of the MCHS algorithm. Recursively creates a serach tree based on the MCHS, searching for the most optimal move.

 * @param
    Game*_Game,
    std::list<Player*> _GivenPlayers)

 *
 * @see MCHS_Node::Find_MAX_UCB1_Child()
 * @see Game interface(Found within Game.cu)
 */
template <typename Game_Tp, typename Player_Tp>
class MCHS: public TreeSimulation
{
public:

  //////////////////////////////////////////////////////////////////////////////
  // The current head node.
  //////////////////////////////////////////////////////////////////////////////
  Game_Tp* GivenGame;
  MCHS_Node<Game_Tp,Player_Tp>* HeadNode;
  //Pointer to current game state.
  Game_Tp* SimulatedGame;

  //HashTable
  HashTable_t<MCHS_Node<Game_Tp,Player_Tp>>*HashTable;

  //////////////////////////////////////////////////////////////////////////////
  // The current head node.
  //////////////////////////////////////////////////////////////////////////////
  std::list<Player_Tp*> Players;
  Player_Tp* GivenPlayer;


  //////////////////////////////////////////////////////////////////////////////
  // Initialization method.
  MCHS(Game_Tp*_Game,std::list<Player_Tp*> _GivenPlayers){

    Players = _GivenPlayers;
    GivenPlayer = *(_GivenPlayers.begin());
    for (Player_Tp* _Player : _GivenPlayers){
          //printf("MCHS Playerlist:%p\n",(_Player));
    }
    //HeadNode  = NULL;
    //printf("new MCHS_Node's Player:%p\n",Player);
    //std::cin.get();
    HashTable = new HashTable_t<MCHS_Node<Game_Tp,Player_Tp>>(250000);
    HeadNode  = new MCHS_Node<Game_Tp,Player_Tp>(_Game,_GivenPlayers,HashTable);
    GivenGame = _Game;

    /*
    auto Compare = [](MCHS_Node<Game_Tp,Player_Tp> Node0,MCHS_Node<Game_Tp,Player_Tp> Node1)->bool {
      Node0;
    };
    */
    bool NewHash = false;

    std::tie(HeadNode, NewHash) = HashTable->AddGetReference(HeadNode);

  }

  //////////////////////////////////////////////////////////////////////////////
  //
  //////////////////////////////////////////////////////////////////////////////
  virtual ~MCHS(){


    delete HashTable;
    //delete HeadNode;
  }

  //////////////////////////////////////////////////////////////////////////////
  // Method Declarations.
  //////////////////////////////////////////////////////////////////////////////
    MCHS_Node<Game_Tp,Player_Tp>* Algorithm(MCHS_Node<Game_Tp,Player_Tp>* TransversedNode);
    void EvaluateStep(MCHS_Node<Game_Tp,Player_Tp>* TransversedNode,Player_Tp* GivenPlayer);
    //double BackPropagation(MCHS_Node* TransversedNode,double GivenPlayer);
    void Search(int Depth); //,Player* GivenPlayer
    MCHS* PruneSearch(MCHS_Node<Game_Tp,Player_Tp>*SelectedNode);
    void ParallelSearch(int Depth);


    //MCHS* CreateBookMoves();
    //MCHS* SaveBookMoves(char* Path);
    //MCHS* OpenBookMoves(char* Path);
    //MCHS_Node* Find_Highest_UCB1(std::list<MCHS_Node*>MCHS_List);

    void CreateChildren();
    void TreeTraversal();
    void CreateNode();
    void RollOut();
};








/**
   A recursive impementation of the MCHS algorithm. Recursively creates a serach
    tree based on the MCHS, searching for the most optimal move.

  This modifies the given MCHS search tree, adding MCHS_Node's.

 * @param
 *   <MCHS_Node*> TransversedNode(Is the next node to be evaluated on, either recursively or initialy).
 *
 * @return MCHS_Node,
 *
 * @see MCHS_Node::Find_MAX_UCB1_Child()
 * @see Game interface(Found within Game.cu)
 */
template <typename Game_Tp, typename Player_Tp>
MCHS_Node<Game_Tp,Player_Tp>* MCHS<Game_Tp,Player_Tp>::Algorithm(MCHS_Node<Game_Tp,Player_Tp>* TransversedNode)
{
  /*
    Helper Function for MCHS::Search & EvaluateStep.
    Performs an itteration of the MCHS Algorithm on 'TransversedNode'
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
    //////////////////////////////////////////////////////////////////////////////
    //If Node is LeafNode, create Children nodes, and select the first node for
    // rollout.
    //////////////////////////////////////////////////////////////////////////////
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
    MCHS_Node<Game_Tp,Player_Tp>* NextNode = *TransversedNode->Children.begin();

    /////////////////////////////////////////////////////////////////
    //Recursivly search down the tree looking for an 'optimal' branch to evaluate.
    /////////////////////////////////////////////////////////////////
    return Algorithm(NextNode);

  }
  //Otherwise, transverse the tree using the UCB1 formula, looking for an 'optimal' branch to evaluate.
  else{

    //Not Leaf Node, Transverse down the Tree: Find the branch with the MAX UCB1 value.
    MCHS_Node<Game_Tp,Player_Tp>* MAXNode = TransversedNode->Find_MAX_UCB1_Child();

    //Recursivly search down the tree looking for an 'optimal' branch to evaluate.
    return Algorithm(MAXNode);
  }
}




/**
   Helper Function for MCHS::Search. Performs an iteration of the MCHS on the parameter 'TransversedNode.' Then takes the result of Search/RollOut and performs BackPropagation to adjust the weights of each MCHS_Node within the search tree.
 *
 * @param
 *   <MCHS_Node*> TransversedNode().
 *   <Player*> GivenPlayer
          (A pointer of the current Player's turn. This is used during the
          backpropagation step to evaluate winning and losing game positions.).
 *
 * @return Void, modifies the given MCHS object, adding MCHS_Node elements to
 *   the Head node.
 *
 * @see MCHS
 * @see Game interface(Found within Game.cu)
 */
template <typename Game_Tp, typename Player_Tp>
void MCHS<Game_Tp,Player_Tp>::EvaluateStep(MCHS_Node<Game_Tp,Player_Tp>* TransversedNode,Player_Tp* GivenPlayer)
{

    TransversedNode = Algorithm(TransversedNode);
    //std::cout << TransversedNode->GivenGame->Generate_StringRepresentation();

    TransversedNode->BackPropagation(TransversedNode->GivenGame->TestForWinner());
}



/**
 * Preforms the Monte Carlo tree search on the game used to initialize the MCHS
 *  Object.
 *
 *
 * @param <int> Depth(Depth of search tree).
 *
 * @return Void, modifies the given MCHS object, adding MCHS_Node elements to
 *   the Head node.
 *
 * @see MCHS
 * @see Game interface(Found within Game.cu)
 */
template <typename Game_Tp, typename Player_Tp>
void MCHS<Game_Tp,Player_Tp>::Search(int Depth)
{

    std::cout << "Searching Depth:" << Depth << "\n";
    // Increment counter, and perform another step within the search.
    while(HeadNode->NodeVisits < Depth){
        // Use helper Method EvaluateStep to increment the search.
        EvaluateStep(HeadNode,GivenPlayer);
    }
/*
for (int i = 0; i < Depth; i++) {
  //printf("\tDepth: %d\n",i);

  // Use helper Method EvaluateStep to increment the search.
  EvaluateStep(HeadNode,GivenPlayer);
}
*/
//Pause
    HeadNode->RefreshWeights();
    HeadNode->DisplayTree(1);
    HeadNode->DisplayStats();


}

template <typename Game_Tp, typename Player_Tp>
MCHS<Game_Tp,Player_Tp>* MCHS<Game_Tp,Player_Tp>::PruneSearch(MCHS_Node<Game_Tp,Player_Tp>*SelectedNode)
{

    return NULL;
}


template <typename Game_Tp, typename Player_Tp>
void MCHS<Game_Tp,Player_Tp>::ParallelSearch(int Depth)
{
    std::cout << "Searching Depth:" << Depth << "\n";

}


#endif //MCHS_CU
