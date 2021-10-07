/*
====================================================================================================
Description PMCTS(Parallel Monte Carlo Tree Search):
This takes the Monte-Carlo Tree search and adds some multithreading to Create Faster Searches.

Still uses the Game interface, and template structure from MCTS.

Requires:
  "TreeSearch.cu"
  "MCTS.cu"

Possibly requires:


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
Implemented the following 'thread dispatch' algorithms:
- DispatchNaively
- DispatchEvenly
==========================================================
Date:           26 September 2021
Script Version: 1.2
Name:           Anthony M Schroeder
Email:          as3379@nau.edu
Refactored code for Recursive Thread Dispatch.
Implemented the following 'thread dispatch' algorithms:
- UCB1 PMCTS.
==========================================================
*/

#ifndef P_MCTS_CU
#define P_MCTS_CU



#include "PMCTS.h"









/*
MCTS_Node, is a structure within the MCTS which holds structural information,
as well as a game state representation.
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
  double PastNodeVisits;
  double PastValueSum;
  //////////////////////////////////////////////////////////////////////////////
  // Values to evaluate UCB1 preformance.
  //////////////////////////////////////////////////////////////////////////////
  double NodeVisits;
  double ValueSum;
  Game_Tp* GivenGame = NULL;
  double UCB1Value;
  double SoftMAX;

  //////////////////////////////////////////////////////////////////////////////
  // List of _Players to maintain turn order.
  //////////////////////////////////////////////////////////////////////////////
  std::list<Player_Tp*> _Players;

  //////////////////////////////////////////////////////////////////////////////
  // pointers to maintain tree structure.
  //////////////////////////////////////////////////////////////////////////////
  PMCTS_Node*           Parent       = NULL;
  PMCTS_Node*           RollOutChild = NULL;
  std::list<PMCTS_Node<Game_Tp,Player_Tp>*> Children;


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
      ValueSum   = 0.001;
      UCB1Value       = 0;
      SoftMAX    = 0;
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

    bool operator <(const PMCTS_Node<Game_Tp,Player_Tp> & Other_PMCTS_Node)
        {
          printf("This:%f\n", Find_UCB1());
          printf("That:%f\n", Other_PMCTS_Node->Find_UCB1());
          printf("-----------------------");
            return Find_UCB1() < Other_PMCTS_Node->Find_UCB1();
        }
/*    bool operator ==(const PMCTS_Node<Game_Tp,Player_Tp> & Other_PMCTS_Node)
        {
          printf("This:%f\n", Find_UCB1());
          printf("That:%f\n", Other_PMCTS_Node->Find_UCB1());
          printf("-----------------------");
            return Find_UCB1() == Other_PMCTS_Node->Find_UCB1();
        }
        */
  //////////////////////////////////////////////////////////////////////////////
  // Method Declarations.
  //////////////////////////////////////////////////////////////////////////////
  double     Find_UCB1();

  PMCTS_Node<Game_Tp,Player_Tp>* Find_MAX_UCB1_Child();
  PMCTS_Node<Game_Tp,Player_Tp>* ReturnBestMove();
  PMCTS_Node<Game_Tp,Player_Tp>* RollOut();
  int        AddChildren(std::list<Game_Tp*> PossibleMoves);
  void       BackPropagation(Player_Tp* GivenPlayer,PMCTS_Node<Game_Tp,Player_Tp>* HeadNode);
  void       BackPropagation(PMCTS_Node<Game_Tp,Player_Tp>* HeadNode);
  void       RefreshWeights();
  double     GetAverageValue();
  void       DisplayTree();
  void       DisplayTree(int Depth);
  std::size_t GetHash();
  void       DisplayStats();
  double Get_UCB1_ChildrenSum();
  double AssignSoftMAX();
  double Get_ChildrenValueSum();
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
  UCB1Value = (ValueSum/NodeVisits) + ExploreBy*sqrt(log(_NodeVisits/NodeVisits));

  return UCB1Value;
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
  //GivenGame->TestForWinner();
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

template <typename Game_Tp, typename Player_Tp>
void PMCTS_Node<Game_Tp,Player_Tp>::RefreshWeights()
{
  NodeVisits = 0;
  ValueSum   = 0.001;
  for (PMCTS_Node<Game_Tp,Player_Tp>* Node : Children){
    NodeVisits+=Node->NodeVisits;
    ValueSum+=Node->ValueSum;

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
std::size_t PMCTS_Node<Game_Tp,Player_Tp>::GetHash()
{
  std::hash<Game_Tp>* Hash = new std::hash<Game_Tp>;// = std::hash<TTT>(* _Game);
  std::size_t HashValue = Hash->Hash(GivenGame);
  delete Hash;
  return HashValue;
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
    printf("\tHash: %zu\n",GetHash());
    //std::cout << GivenGame->Generate_StringRepresentation();
  }

}


// insertion sort template function
// to sort array in ascending order
// n is the size of array
template <typename Game_Tp, typename Player_Tp>
std::list<PMCTS_Node<Game_Tp,Player_Tp>*> InsertionSort(std::list<PMCTS_Node<Game_Tp,Player_Tp>*> OldList)
{

  std::list<PMCTS_Node<Game_Tp,Player_Tp>*> NewList;
//  std::list<PMCTS_Node<Game_Tp,Player_Tp>*> HighestNode;
  typename std::list<PMCTS_Node<Game_Tp,Player_Tp>*>::iterator HighestNode;

  while(OldList.size() > 0){
    typename std::list<PMCTS_Node<Game_Tp,Player_Tp>*>::iterator List_iterator = OldList.begin();
    double newValue,highestValue =-DBL_MAX;

    //Remove Next element from the list.
    while ( List_iterator != OldList.end())
    {
        newValue = (*List_iterator)->Find_UCB1();
        if(newValue > highestValue){
          highestValue = newValue;
          HighestNode = List_iterator;
        }
        else
        {
        }
        ++List_iterator;
    }
    NewList.push_back(*HighestNode);
    OldList.erase(HighestNode);
  }

  return NewList;
}



template <typename Game_Tp, typename Player_Tp>
double PMCTS_Node<Game_Tp,Player_Tp>::Get_UCB1_ChildrenSum(){
  double UCB1_Sum = 0;
  for (PMCTS_Node<Game_Tp,Player_Tp>* Node : Children){
    UCB1_Sum += Node->Find_UCB1();
    //printf("Node->SoftMAX:%f\n",Node->SoftMAX);
  }
  //printf("UCB1_Sum:%f\n",UCB1_Sum);
  return UCB1_Sum;
}


template <typename Game_Tp, typename Player_Tp>
double PMCTS_Node<Game_Tp,Player_Tp>::AssignSoftMAX(){
  double UCB1_Sum = Get_UCB1_ChildrenSum();
  for (PMCTS_Node<Game_Tp,Player_Tp>* Node : Children){
    Node->SoftMAX = Node->UCB1/UCB1_Sum;
  }
  return UCB1_Sum;
}

template <typename Game_Tp, typename Player_Tp>
double PMCTS_Node<Game_Tp,Player_Tp>::Get_ChildrenValueSum(){
  double Sum = 0;
  for (PMCTS_Node<Game_Tp,Player_Tp>* Node : Children){
    Sum += Node->ValueSum;
  }
  return Sum;
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
  printf("Calling Sort \n");
  Children = InsertionSort(Children);


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
JoinThreads.
 * @param
 *    Takes a std::list<PMCTS_ThreadData_t<Game_Tp,Player_Tp>*>, and takes the
 *   Finished threads and joins them.
 * Also has a internal wait 100 miliseconds to prevent overutilization of resources.

 */
template <typename Game_Tp, typename Player_Tp>
std::list<PMCTS_ThreadData_t<Game_Tp,Player_Tp>*> _JoinFinishedThreads(std::list<PMCTS_ThreadData_t<Game_Tp,Player_Tp>*>ThreadList)
{

/*
printf("/////////////////////////////////////////////////////////////////\n");
printf("Starting _JoinFinishedThreads\n");
printf("ThreadList.size():%lu\n",ThreadList.size());
printf("/////////////////////////////////////////////////////////////////\n");*/
  int ThreadsJoined = 0;

  while(ThreadsJoined <= 0){
      //printf("ThreadList.size():%d\n",ThreadList.size());
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
      std::this_thread::sleep_for(std::chrono::milliseconds(5));
    }

  return ThreadList;
}




template <typename Game_Tp, typename Player_Tp>
std::list<PMCTS_ThreadData_t<Game_Tp,Player_Tp>*> _JoinAllThreads(std::list<PMCTS_ThreadData_t<Game_Tp,Player_Tp>*>ThreadList)
{
  while(ThreadList.size() != 0){
    ThreadList = _JoinFinishedThreads<Game_Tp,Player_Tp>(ThreadList);
  }
  return ThreadList;
}














//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
// MCTS algorithms
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////



template <typename Game_Tp, typename Player_Tp>
PMCTS_Node<Game_Tp,Player_Tp>* MCTS_Algorithm(PMCTS_Node<Game_Tp,Player_Tp>*TransversedNode)
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
//////////////////////////////////////////////////////////////////////////////
// MCTS_Search
//////////////////////////////////////////////////////////////////////////////
template <typename Game_Tp, typename Player_Tp>
void MCTS_Search(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode, double ThreadDepth)
{
  PMCTS_ThreadData_t<Game_Tp,Player_Tp>* PMCTS_ThreadData = (PMCTS_ThreadData_t<Game_Tp,Player_Tp>*) malloc(sizeof(PMCTS_ThreadData_t<Game_Tp,Player_Tp>));
  //printf("PMCTS_ThreadData_t:%p\n",PMCTS_ThreadData);
  PMCTS_ThreadData->TransversedNode = TransversedNode;
  PMCTS_ThreadData->Depth           = ThreadDepth;
  PMCTS_ThreadData->Finished        = false;
  MCTS_Search_thread<Game_Tp,Player_Tp>(PMCTS_ThreadData);
  free(PMCTS_ThreadData);
}
*/
template <typename Game_Tp, typename Player_Tp>
void MCTS_Search(PMCTS_Node<Game_Tp,Player_Tp>* StartingNode,double Depth)
{

  //////////////////////////////////////////////////////////////////////////////
  // For each Itteration, preform the following steps.
  //////////////////////////////////////////////////////////////////////////////
  for (int i = 0; i < Depth; i++) {

    PMCTS_Node<Game_Tp,Player_Tp>*TransversedNode = StartingNode;
    //printf("Depth:%d\n", i);
    //printf("TransversedNode:%p\n", TransversedNode);
    //////////////////////////////////////////////////////////////////////////////
    // Preform Tree transversal, to build tree.
    //    This returns either a rollout node, or a node from the tree with a completed game(based on MCTS).
    TransversedNode = MCTS_Algorithm<Game_Tp,Player_Tp>(TransversedNode);

    //////////////////////////////////////////////////////////////////////////////
    // Preform BackPropagation, to assign weights.
    TransversedNode->BackPropagation(TransversedNode->GivenGame->TestForWinner(),StartingNode);
  }
}




//////////////////////////////////////////////////////////////////////////////
// MCTS_Search_thread has been implemented to call MCTS_Search as Thread.
//////////////////////////////////////////////////////////////////////////////
template <typename Game_Tp, typename Player_Tp>
void * MCTS_Search_thread(void* GivenPMCTS_ThreadData)
{
  PMCTS_ThreadData_t<Game_Tp,Player_Tp>* PMCTS_ThreadData = static_cast<PMCTS_ThreadData_t<Game_Tp,Player_Tp>*>(GivenPMCTS_ThreadData);

  MCTS_Search(PMCTS_ThreadData->TransversedNode,PMCTS_ThreadData->Depth);

  //////////////////////////////////////////////////////////////////////////////
  // Thread is finished, Set Flag for Thread Clean up.
  PMCTS_ThreadData->Finished = true;

  return 0;
}
















//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
// PMCTS/MCTS Dispatch algorithms
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////




template <typename Game_Tp, typename Player_Tp>
PMCTS_ThreadData_t<Game_Tp,Player_Tp>* DispatchMCTS_SearchThread(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,double Threads, int ThreadDepth)
{
  PMCTS_ThreadData_t<Game_Tp,Player_Tp>* PMCTS_ThreadData = (PMCTS_ThreadData_t<Game_Tp,Player_Tp>*) malloc(sizeof(PMCTS_ThreadData_t<Game_Tp,Player_Tp>));
  //printf("PMCTS_ThreadData_t:%p\n",PMCTS_ThreadData);
  PMCTS_ThreadData->TransversedNode = TransversedNode;
  PMCTS_ThreadData->Depth           = ThreadDepth;
  PMCTS_ThreadData->Threads           = Threads;
  PMCTS_ThreadData->Finished        = false;

  pthread_create(&(PMCTS_ThreadData->Thread), NULL, MCTS_Search_thread<Game_Tp,Player_Tp>, PMCTS_ThreadData);
  return PMCTS_ThreadData;
}








template <typename Game_Tp, typename Player_Tp>
void MCTS_DispatchNaively(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,int Threads, int Depth)
{
  double ThreadDepth = (Depth/TransversedNode->Children.size())+1;

  PMCTS_ThreadData_t<Game_Tp,Player_Tp>*            PMCTS_ThreadData;
  std::list<PMCTS_ThreadData_t<Game_Tp,Player_Tp>*> ThreadList;

  for (PMCTS_Node<Game_Tp,Player_Tp>* Node : TransversedNode->Children){
    ThreadList.push_back(
      DispatchMCTS_SearchThread<Game_Tp,Player_Tp>(Node, Threads, ThreadDepth)
    );
  }

  ThreadList = _JoinAllThreads<Game_Tp,Player_Tp>(ThreadList);
}


template <typename Game_Tp, typename Player_Tp>
void MCTS_DispatchEvenly(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,int Threads, int Depth)
{
  MCTS_Search(TransversedNode,2);

  double ThreadDepth = (Depth/TransversedNode->Children.size())+1;
  std::list<PMCTS_ThreadData_t<Game_Tp,Player_Tp>*> ThreadList;
  //////////////////////////////////////////////////////////////////////////////
  //For Each Branch within Game, Dispatch a new thread.
  for (PMCTS_Node<Game_Tp,Player_Tp>* Node : TransversedNode->Children){

    //////////////////////////////////////////////////////////////////////////////
    //For Each Thread to dispatch, wait until there is an available thread to release.
    bool DispatchedForNode = true;
    while(DispatchedForNode)
    {

      //////////////////////////////////////////////////////////////////////////////
      //Dispatch Threads
      if (ThreadList.size() < Threads){
        //PMCTS_ThreadData = _DispatchThread<Game_Tp,Player_Tp>(Node, ThreadDepth);
        ThreadList.push_back(
          DispatchMCTS_SearchThread<Game_Tp,Player_Tp>(Node, Threads, ThreadDepth)
        );
        DispatchedForNode = false;
      }


      //////////////////////////////////////////////////////////////////////////////
      //Join Threads
      if (ThreadList.size() == Threads){
        ThreadList = _JoinFinishedThreads<Game_Tp,Player_Tp>(ThreadList);
      }

    }
  }
  ThreadList = _JoinAllThreads<Game_Tp,Player_Tp>(ThreadList);

}







//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
// PMCTS searches
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////


/*
  Helper Function for MCTS::Search & EvaluateStep.
  Performs an itteration of the MCTS Algorithm on 'TransversedNode'
*/
/*
template <typename Game_Tp, typename Player_Tp>
PMCTS_Node<Game_Tp,Player_Tp>* PMCTS_Algorithm(PMCTS_Node<Game_Tp,Player_Tp>*TransversedNode)
{
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
*/



/*

  //////////////////////////////////////////////////////////////////////////////
  // For each Itteration, preform the following steps.
  //////////////////////////////////////////////////////////////////////////////
  for (int i = 0; i < PMCTS_ThreadData->Depth; i++) {
    PMCTS_Node<Game_Tp,Player_Tp>*TransversedNode = PMCTS_ThreadData->TransversedNode;

    //////////////////////////////////////////////////////////////////////////////
    // Preform Tree transversal, to build tree.
    TransversedNode = PMCTS_Algorithm<Game_Tp,Player_Tp>(TransversedNode);

    //////////////////////////////////////////////////////////////////////////////
    // Preform BackPropagation, to assign weights.
    TransversedNode->BackPropagation(TransversedNode->GivenGame->TestForWinner(),PMCTS_ThreadData->TransversedNode);

  }
  */



//////////////////////////////////////////////////////////////////////////////
// PMCTS_Search has been implemented for parallelism.
//////////////////////////////////////////////////////////////////////////////

template <typename Game_Tp, typename Player_Tp>
double MCTS_FindPriorityByUCB1(PMCTS_Node<Game_Tp,Player_Tp>*Node){
  double UCB1Value = Node->Find_UCB1();
  //printf("UCB1:%lf\n", UCB1Value);
  return sqrt(UCB1Value);
}


template <typename Game_Tp, typename Player_Tp>
double MCTS_FindSUMPriorityByUCB1(PMCTS_Node<Game_Tp,Player_Tp>*TransversedNode){
  double Sum = 0;
  for (PMCTS_Node<Game_Tp,Player_Tp>* Node : TransversedNode->Children){
    Sum += MCTS_FindPriorityByUCB1(Node);
    //Node->DisplayStats();
    //printf("MCTS_FindPriorityByUCB1:%lf\n", MCTS_FindPriorityByUCB1(Node));
    //printf("sum:%lf\n", Sum);
  }
  //printf("sum:%lf\n", Sum);
  return Sum;
}



template <typename Game_Tp, typename Player_Tp>
double MCTS_FindPriorityBySumValue(PMCTS_Node<Game_Tp,Player_Tp>*Node){
  double UCB1Value = Node->ValueSum;

  //printf("UCB1:%lf\n", UCB1Value);
  return std::max(UCB1Value,(double).001);
}


template <typename Game_Tp, typename Player_Tp>
double MCTS_FindSUMPriorityBySumValue(PMCTS_Node<Game_Tp,Player_Tp>*TransversedNode){
  double Sum = 0;
  for (PMCTS_Node<Game_Tp,Player_Tp>* Node : TransversedNode->Children){
    Sum += MCTS_FindPriorityBySumValue(Node);
    //Node->DisplayStats();
    //printf("MCTS_FindPriorityBySumValue:%f\n", MCTS_FindPriorityBySumValue(Node));
    //printf("sum:%f\n", Sum);
  }
  //printf("sum:%lf\n", Sum);
  return Sum;
}





//MCTS_UCB1Threads *UCB1Threads = new MCTS_UCB1Threads();
template <typename Game_Tp, typename Player_Tp>
class MCTS_UCB1Threads
{
public:
  //////////////////////////////////////////////////////////////////////////////
  // Thread Serach Data
  //////////////////////////////////////////////////////////////////////////////
  double MaxThreads;
  double ThreadsDispatched;
  std::list<PMCTS_ThreadData_t<Game_Tp,Player_Tp>*> ThreadList;


  //double MaxThreads;
  double SearchDepth;

  double DepthThreadRatio;

  double MinimumDistribution;
  double UBC1Distribution;
  double ValueSumDistribution;

  double MinimumDepth;
  double UBC1_Depth;
  double ValueSum_Depth;

  int Branches;
  double ValueSum_PrioritySum;
  double UBC1_PrioritySum;
  //////////////////////////////////////////////////////////////////////////////
  // Initialization method.
  MCTS_UCB1Threads(PMCTS_Node<Game_Tp,Player_Tp>*TransversedNode,double GivenThreads, double GivenDepth){

    UBC1Distribution      = .375;
    ValueSumDistribution  = .375;
    MinimumDistribution   = .25;


    ThreadsDispatched = 0;
    MaxThreads        = GivenThreads;
    SearchDepth       = GivenDepth;

    Branches              = TransversedNode->Children.size();
    DepthThreadRatio      = SearchDepth/MaxThreads;
    MinimumDepth          = (MinimumDistribution*SearchDepth)/Branches;

    ValueSum_PrioritySum   = std::max(MCTS_FindSUMPriorityBySumValue(TransversedNode),(double)0);
    if(ValueSum_PrioritySum == 0){
      UBC1Distribution += ValueSumDistribution;
    }
    ValueSum_Depth         = (ValueSumDistribution*SearchDepth);


    UBC1_PrioritySum      = std::max(MCTS_FindSUMPriorityByUCB1(TransversedNode),(double)1);
    UBC1_Depth             = (UBC1Distribution*SearchDepth);




    //Pause;
  }
  ~MCTS_UCB1Threads(){
    _JoinAllThreads<Game_Tp,Player_Tp>(ThreadList);

  }

  void JoinFinishedThreads(std::list<PMCTS_ThreadData_t<Game_Tp,Player_Tp>*>ThreadList)
  {

    //printf("/////////////////////////////////////////////////////////////////\n");
    //printf("Starting _JoinFinishedThreads\n");
    //printf("ThreadList.size():%d\n",ThreadList.size());
    //printf("/////////////////////////////////////////////////////////////////\n");
    int ThreadsJoined = 0;

    while(ThreadsJoined <= 0){

        //printf("ThreadList.size():%d\n",ThreadList.size());
        typename std::list<PMCTS_ThreadData_t<Game_Tp,Player_Tp>*>::iterator ThreadList_iterator = ThreadList.begin();
        while ( ThreadList_iterator != ThreadList.end())
        {
            if((*ThreadList_iterator)->Finished){
              pthread_join(((*ThreadList_iterator)->Thread), NULL);
              ThreadsJoined++;
              ThreadsDispatched -= ((*ThreadList_iterator)->Threads);
              free((*ThreadList_iterator));
              ThreadList.erase(ThreadList_iterator++);
            }
            else
            {
                // move to next item
                ++ThreadList_iterator;
            }
        }
        std::this_thread::sleep_for(std::chrono::milliseconds(5));
      }
  }

  void Dispatch(PMCTS_Node<Game_Tp,Player_Tp>*Node){

    double UCB1Value            = MCTS_FindPriorityByUCB1(Node);
    double ValueSum             = MCTS_FindPriorityBySumValue(Node);

    double Depth_By_UCB1       = std::max((UCB1Value / UBC1_PrioritySum)     * UBC1_Depth,(double)0);
    double Depth_By_ValueSum   = std::max((ValueSum  / ValueSum_PrioritySum) * ValueSum_Depth,(double)0);
    double BranchDepth         = (Depth_By_ValueSum + Depth_By_UCB1 + ceil(MinimumDepth));

    double BranchThreads       = std::min(ceil(BranchDepth/DepthThreadRatio),MaxThreads);
    //BranchDepth = MinimumDepth;


printf("/////////////////////////////////////////////////////////////////\n");
printf("Branches:%d\n",Branches);
printf("MinimumDepth:%lf\n",MinimumDepth);
printf("UBC1_PrioritySum:%f\n",UBC1_PrioritySum);
printf("ValueSum_PrioritySum:%f\n",ValueSum_PrioritySum);
printf("-----------------------------------------------------------------\n");
printf("ValueSum:                            %f\n",ValueSum);
printf("ValueSum_PrioritySum:                %f\n",ValueSum_PrioritySum);
printf("(ValueSum  / ValueSum_PrioritySum):  %f\n",(ValueSum  / ValueSum_PrioritySum));
printf("ValueSum_Depth:                      %f\n",ValueSum_Depth);
printf("Depth_By_ValueSum:                   %f\n",Depth_By_ValueSum);
printf("-----------------------------------------------------------------\n");
printf("UCB1Value:                           %f\n",UCB1Value);
printf("UBC1_PrioritySum:                    %f\n",UBC1_PrioritySum);
printf("(UCB1Value / UBC1_PrioritySum):      %f\n",(UCB1Value / UBC1_PrioritySum));
printf("UBC1_Depth:                          %f\n",UBC1_Depth);
printf("Depth_By_UCB1:                       %f\n",Depth_By_UCB1);
printf("-----------------------------------------------------------------\n");
printf("MinimumDepth:%f\n",MinimumDepth);
printf("BranchDepth:%f\n",BranchDepth);
printf("-----------------------------------------------------------------\n");
printf("SearchDepth:%f\n",SearchDepth);
printf("MaxThreads:%f\n",MaxThreads);
printf("DepthThreadRatio:%f\n",DepthThreadRatio);
printf("BranchThreads:%lf\n",BranchThreads);
printf("/////////////////////////////////////////////////////////////////\n");
//Pause;



//printf("BranchThreads:%f\n",BranchThreads);
//printf("BranchDepth:%f\n",BranchDepth);

    //double asdf= BranchDepth/DepthToThreadRatio;
    //printf("BranchDepth:%f\n",BranchDepth);
    //printf("DepthToThreadRatio:%f\n",DepthToThreadRatio);
    //printf("asdf:%f\n",asdf);
    //BranchThreads = std::min(asdf,(double)1);
    //BranchThreads = 1;
    //printf("BranchThreads:%f\n",BranchThreads);


    //////////////////////////////////////////////////////////////////////////////
    //For Each Thread to dispatch, wait until there is an available thread to release.
    bool DispatchingForNode = true;
    while(DispatchingForNode)
    {

      //////////////////////////////////////////////////////////////////////////////
      //Dispatch Threads
      if (ThreadsDispatched < (MaxThreads+BranchThreads)){
        //PMCTS_ThreadData = _DispatchThread<Game_Tp,Player_Tp>(Node, ThreadDepth);
        ThreadList.push_back(
          Dispatch_MCTS_UCB1PrioritySearch_Thread<Game_Tp,Player_Tp>(Node, BranchThreads, BranchDepth)
        );
        DispatchingForNode = false;
      }
      else{
        //////////////////////////////////////////////////////////////////////////////
        //Join Threads
        ThreadList = _JoinFinishedThreads<Game_Tp,Player_Tp>(ThreadList);
      }

    }
  }
};





template <typename Game_Tp, typename Player_Tp>
void MCTS_UCB1PriorityAssignment(PMCTS_Node<Game_Tp,Player_Tp>*TransversedNode,double Threads, double Depth){

  MCTS_UCB1Threads<Game_Tp, Player_Tp> *UCB1Threads = new MCTS_UCB1Threads<Game_Tp, Player_Tp>(TransversedNode,Threads,Depth);

  for (PMCTS_Node<Game_Tp,Player_Tp>* Node : TransversedNode->Children){
    //UCB1Threads->Dispatch(Node);
    UCB1Threads->Dispatch(Node);
/*
printf("UCB1_Sum:%f\n",Sum);
printf("Threads:%f\n",Threads);
printf("ThreadList.size() :%d\n",ThreadList.size() );
printf("UCB1_SumToThreadRatio:%f\n",SumToThreadRatio);
printf("ThreadsAssigned:%f\n",ThreadsAssigned);
printf("ThreadDepth:%f\n",ThreadDepth);
printf("/////////////////////////////////////////////////////////////////\n");
    //Pause;
    */


  }

  delete UCB1Threads;

}




template <typename Game_Tp, typename Player_Tp>
void MCTS_UCB1PrioritySearch(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,double Threads, double Depth)
{
  //TODO: add Segment Dispatch Logic to both:
  // -DispatchByPigeonHole
  // -DispatchByRotation

  double ThreshHold = 50000;
  //printf("TransversedNode->NodeVisits:%f\n",TransversedNode->NodeVisits);
  //Pause;
  /////////////////////////////////////////////////////////////////
  // Determine how to dispatch Threads.
  /////////////////////////////////////////////////////////////////
  if (TransversedNode->NodeVisits > ThreshHold){
  //if (true){
    /////////////////////////////////////////////////////////////////
    // Dispatch by recursive MCTS_UCB1PrioritySearch.
    /////////////////////////////////////////////////////////////////
    MCTS_UCB1PriorityAssignment<Game_Tp,Player_Tp>(TransversedNode,Threads,Depth);

    //PMCTS_DispatchByPigeonHole(TransversedNode,Threads,Depth);

  }
  else{
    /////////////////////////////////////////////////////////////////
    // Dispatch by MCTS_DispatchEvenly,
    /////////////////////////////////////////////////////////////////
    //printf("calling DispatchEvenly\n");
    MCTS_DispatchEvenly(TransversedNode,Threads,Depth);

  }
  TransversedNode->RefreshWeights();
/*
for (PMCTS_Node<Game_Tp,Player_Tp>* Node : TransversedNode->Children){
  TransversedNode->DisplayStats();
  Node->DisplayStats();
}
*/
}


template <typename Game_Tp, typename Player_Tp>
void* MCTS_UCB1PrioritySearch_Thread(void* GivenPMCTS_ThreadData)
{
  PMCTS_ThreadData_t<Game_Tp,Player_Tp>* PMCTS_ThreadData = static_cast<PMCTS_ThreadData_t<Game_Tp,Player_Tp>*>(GivenPMCTS_ThreadData);

  MCTS_UCB1PrioritySearch<Game_Tp,Player_Tp>(PMCTS_ThreadData->TransversedNode,PMCTS_ThreadData->Threads,PMCTS_ThreadData->Depth);
  //////////////////////////////////////////////////////////////////////////////
  // Thread is finished, Set Flag for Thread Clean up.
  PMCTS_ThreadData->Finished = true;
  return 0;
}


template <typename Game_Tp, typename Player_Tp>
PMCTS_ThreadData_t<Game_Tp,Player_Tp>* Dispatch_MCTS_UCB1PrioritySearch_Thread(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,double Threads, int ThreadDepth)
{
  PMCTS_ThreadData_t<Game_Tp,Player_Tp>* PMCTS_ThreadData = (PMCTS_ThreadData_t<Game_Tp,Player_Tp>*) malloc(sizeof(PMCTS_ThreadData_t<Game_Tp,Player_Tp>));
  //printf("PMCTS_ThreadData_t:%p\n",PMCTS_ThreadData);
  PMCTS_ThreadData->TransversedNode = TransversedNode;
  PMCTS_ThreadData->Depth           = ThreadDepth;
  PMCTS_ThreadData->Threads         = Threads;
  PMCTS_ThreadData->Finished        = false;

  pthread_create(&(PMCTS_ThreadData->Thread), NULL, MCTS_UCB1PrioritySearch_Thread<Game_Tp,Player_Tp>, PMCTS_ThreadData);
  return PMCTS_ThreadData;
}




template <typename Game_Tp, typename Player_Tp>
void MCTS_UCB1Search(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,double Threads, double Depth)
{
  //printf("(Depth/10):%f\n",(Depth/10));
  //Pause;
  //double Itterations = ceil(Depth/100000);
  //printf("Itterations:%f\n",Itterations);
  for(int i=0;i<10;i++){
      MCTS_UCB1PrioritySearch(TransversedNode,Threads,(Depth/10));
      //printf("Itterations:%d\n",(i*100000));
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
  }

  //////////////////////////////////////////////////////////////////////////////
  //
  //////////////////////////////////////////////////////////////////////////////
  virtual ~PMCTS(){
    delete HeadNode;
    //delete ParallelCB;
  }

  //////////////////////////////////////////////////////////////////////////////
  // Parallel Functions
  //////////////////////////////////////////////////////////////////////////////
  PMCTS_ThreadData_t<Game_Tp,Player_Tp>* DispatchThread(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,int Threads, int ThreadDepth);
  //void DispatchThreads(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,int Threads, int ThreadDepth);
  //void DispatchByPigeonHole(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,int Threads, int ThreadDepth);
  //void DispatchNaively(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,int Threads, int ThreadDepth);
  //void DispatchEvenly(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,int Threads, int ThreadDepth);

  //////////////////////////////////////////////////////////////////////////////
  // 'Single' Threaded Algorithms
  //////////////////////////////////////////////////////////////////////////////
  //PMCTS_Node<Game_Tp,Player_Tp>* PMCTS_Algorithm(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode);
  //TODO Include PMCTS Back Propagation
  //PMCTS_Node<Game_Tp,Player_Tp>* MCTS_Algorithm(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode);
  //TODO Include MCTS Back Propagation


  //////////////////////////////////////////////////////////////////////////////
  // Management Functions
  //////////////////////////////////////////////////////////////////////////////
  void PerformStep(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,Player_Tp* GivenPlayer);
  //double BackPropagation(MCTS_Node* TransversedNode,double GivenPlayer);
  //void PMCTS_Search(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,double Depth); //,Player* GivenPlayer
  //void MCTS_Search(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,double Depth); //,Player* GivenPlayer
  PMCTS* PruneSearch(PMCTS_Node<Game_Tp,Player_Tp>*SelectedNode);
  void ParallelSearch(int Depth);

  void Search(double Threads, double Depth);
  void Search(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,double Threads, double Depth);


  void Node_BackPropagation(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,Player_Tp* GivenPlayer);
  //MCTS* CreateBookMoves();
  //MCTS* SaveBookMoves(char* Path);
  //MCTS* OpenBookMoves(char* Path);
  //MCTS_Node* Find_Highest_UCB1(std::list<MCTS_Node*>MCTS_List);

};


















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
  MCTS_Search(TransversedNode,37);
  //PMCTS_DispatchThreads(TransversedNode, Threads, Depth);
  //PMCTS_Search(TransversedNode,Threads, Depth);


  //MCTS_DispatchEvenly(TransversedNode,5,10);

  //MCTS_UCB1PrioritySearch(TransversedNode,Threads,Depth);

  MCTS_UCB1Search(TransversedNode,Threads,Depth);
}



template <typename Game_Tp, typename Player_Tp>
void PMCTS<Game_Tp,Player_Tp>::Search(double Threads, double Depth)
{
  Search(HeadNode, Threads, Depth);
  HeadNode->DisplayTree(2);
  HeadNode->DisplayStats();
}




#endif //P_MCTS_CU
