/*
====================================================================================================
Description PMCTS_NN(Parallel Monte Carlo Tree Search):
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
Date:           2 November 2024
Script Version: 1.2
Name:           Anthony M Schroeder
Email:          as3379@nau.edu
Refactored code for Recursive Thread Dispatch.
Implemented the following 'thread dispatch' algorithms:
- UCB1 PMCTS_NN. (Fixed UCB1)
==========================================================
*/

#ifndef P_MCTS_NN_CU
#define P_MCTS_NN_CU


#define ExploreBy_UCB1_Factor 1.4

//#include "PMCTS_NN.h"

#include <pthread.h>
#include <mutex>
#include <bits/stdc++.h>

#include <cmath>


#include "TreeSearch.cu"



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
template <typename Game_Tp, typename Player_Tp, typename GameMove_Tp>
class PMCTS_NN_Node
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
  Game_Tp* GivenGame = nullptr;
  double UCB1Value;
  double SoftMAX;
  GameMove_Tp* Move;
  double NN_valuation;
  double NN_Weight=0.4;
  double UCB1_Weight=0.6;
  double UCB1_SoftMax,UCB1;

  //////////////////////////////////////////////////////////////////////////////
  // List of Players to maintain turn order.
  //////////////////////////////////////////////////////////////////////////////
  std::vector<Player_Tp*> Players;

  //////////////////////////////////////////////////////////////////////////////
  // pointers to maintain tree structure.
  //////////////////////////////////////////////////////////////////////////////
  PMCTS_NN_Node*           Parent       = nullptr;
  PMCTS_NN_Node*           RollOutChild = nullptr;
  std::vector<PMCTS_NN_Node<Game_Tp,Player_Tp,GameMove_Tp>*> Children;


    //////////////////////////////////////////////////////////////////////////////
    // Initialization method.
    PMCTS_NN_Node(Game_Tp* Instance,std::vector<Player_Tp*> GivenPlayers,GameMove_Tp* GivenMove){
      Players.reserve(2);
      for (Player_Tp* Player : GivenPlayers){
            //printf("adding Player:%p\n",(_Player));
            Players.push_back(Player);
      }
      Move       = GivenMove;
      GivenGame  = Instance;
      Children   = {};
      NodeVisits = 0;
      ValueSum   = 0;
      UCB1Value       = 0;
      SoftMAX    = 0;
      NN_valuation = -1;

      PastNodeVisits = 0;
      PastValueSum  = 0;
      //printf("Creating MCTS Node w Player:%p\n",*(Players.begin()));
      //std::cin.get();
      RollOutChild = nullptr;
    }


    ~PMCTS_NN_Node(){
      for (const PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* Node : Children){
        delete Node;
      }
      delete RollOutChild;
      delete GivenGame;
      delete Move;

    }


  //////////////////////////////////////////////////////////////////////////////
  // Method Declarations.
  //////////////////////////////////////////////////////////////////////////////
  double     Find_UCB1();
  void       UCB1_applySoftmax_ToChildren();
  void       UCB1_applyParabolicSoftmax_ToChildren();

  PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* Find_MAX_UCB1_Child();
    PMCTS_NN_Node* Find_MAX_Child();
  PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* ReturnBestMove();
  PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* RollOut();
  int        AddChildren(std::vector<GameMove_Tp*> PossibleMoves);
  int        AddChildren_WInference(std::vector<std::pair<GameMove_Tp*, double>> PossibleInstances);

  void       BackPropagation(Player_Tp* WinningPlayer,PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* HeadNode);
  void       RefreshWeights();
  double     GetAverageValue();
  void       DisplayTree();
  void       DisplayTree(int Depth);
  std::size_t GetHash();
  void       DisplayStats();
  double Get_UCB1_ChildrenSum();
  double AssignSoftMAX();
  double Get_ChildrenValueSum();

  void RotatePlayers();

};

template <typename Game_Tp, typename Player_Tp, typename GameMove_Tp>
void PMCTS_NN_Node<Game_Tp, Player_Tp, GameMove_Tp>::UCB1_applyParabolicSoftmax_ToChildren() {
  if (Children.empty()) {
    // No children to apply softmax
    return;
  }

  // Step 1: Extract the UCB1 values
  std::vector<double> values;
  for (PMCTS_NN_Node<Game_Tp, Player_Tp, GameMove_Tp>* Node : Children) {
    Node->UCB1 = Node->Find_UCB1();
    values.push_back(Node->UCB1);
  }

  if (values.empty()) {
    // No values to compute softmax
    return;
  }

  // Step 2: Compute the parabolic softmax
  std::vector<double> softmaxValues(values.size());
  double minValue = *std::min_element(values.begin(), values.end());

  // Shift values by the minimum to ensure non-negativity
  double sumSquared = 0.0;
  for (size_t i = 0; i < values.size(); ++i) {
    softmaxValues[i] = std::pow(values[i] - minValue, 2);
    sumSquared += softmaxValues[i];
  }

  if (sumSquared == 0.0) {
    // Avoid division by zero in normalization
    return;
  }

  // Normalize to get probabilities
  for (double& value : softmaxValues) {
    value /= sumSquared;
  }

  // Step 3: Assign the softmax values to the children
  size_t i = 0;
  for (PMCTS_NN_Node<Game_Tp, Player_Tp, GameMove_Tp>* Node : Children) {
    Node->UCB1_SoftMax = softmaxValues[i];
    i++;
  }
}


// Function to compute softmax values
template <typename Game_Tp, typename Player_Tp, typename GameMove_Tp>
void PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>::UCB1_applySoftmax_ToChildren() {
  if (Children.empty()) {
    //std::cerr << "Error: No children nodes to apply softmax." << std::endl;
    return;
  }
  // Step 1: Extract the double values (second elements)
  std::vector<double> values;

  for (PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* Node : Children){
    Node->UCB1 = Node->Find_UCB1();
    values.push_back(Node->UCB1);
  }
  if (values.empty()) {
    //std::cerr << "Error: No values to compute softmax." << std::endl;
    return;
  }
  // Step 2: Compute the softmax
  std::vector<double> softmaxValues(values.size());
  double maxValue = *std::max_element(values.begin(), values.end());

  // Exponentiate the values (shifted by maxValue for numerical stability)
  double sumExp = 0.0;
  for (size_t i = 0; i < values.size(); ++i) {
    softmaxValues[i] = std::exp(values[i] - maxValue);
    sumExp += softmaxValues[i];
  }

  // Normalize to get softmax probabilities
  for (double& value : softmaxValues) {
    value /= sumExp;
  }

  // Step 3: Create the output vector with softmax values
  size_t i = 0;
  for (PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* Node : Children){
    Node->UCB1_SoftMax = softmaxValues[i];
    i++;
  }

}

template <typename Game_Tp, typename Player_Tp, typename GameMove_Tp>
void PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>::RotatePlayers(){
  std::rotate(Players.begin(), Players.begin() + 1, Players.end());
};





//Preform MonteCarlo's UCB1 evaluation algorithm on a given node.
template <typename Game_Tp, typename Player_Tp,typename GameMove_Tp>
double PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>::Find_UCB1(){
  double ExploreBy = ExploreBy_UCB1_Factor;
  if(NodeVisits == 0)
	{
		return DBL_MAX;
	}

  //Check if Parent node exists.
  // if it doesnt exist, assume its zero.
  double ParentVisits = 0;
  if(Parent!=nullptr) {
    ParentVisits = Parent->NodeVisits;
  }


  //Preform UCB1 Formula
  const double Value = (ValueSum/NodeVisits) + ExploreBy*sqrt(std::log(ParentVisits)/NodeVisits);

/*
  *
    printf("======================\n");
    printf("\tValueSum:%f\n", ValueSum);
    printf("\tNodeVisits:%f\n", NodeVisits);
    printf("(ValueSum/NodeVisits):%f\n",(ValueSum/NodeVisits));
    printf("log(_NodeVisits)/NodeVisits:%f\n",log(ParentVisits)/NodeVisits);
    printf("sqrt(log(_NodeVisits/NodeVisits):%f\n",sqrt(log(ParentVisits)/NodeVisits));
    printf("ExploreBy*sqrt(log(_NodeVisits/NodeVisits)):%f\n",ExploreBy*sqrt(log(ParentVisits)/NodeVisits));
    printf("Value:%f\n", Value);
    printf("Parent_NodeVisits:%f\n",ParentVisits);
    printf("======================\n");
 */

  return Value;
}


template <typename Game_Tp, typename Player_Tp, typename GameMove_Tp>
PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>::Find_MAX_Child(){
  UCB1_applySoftmax_ToChildren();
  double     HighestValue = -DBL_MAX;
  double     NodesValue;
  PMCTS_NN_Node* HighestNode  = (*Children.begin());
  /*
  printf("Children.size(): %lu\n",Children.size());
  printf("HighestValue: %f\n",HighestValue);
  printf("HighestValue-1: %f\n",HighestValue-1);*/

  for (PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* Node : Children){
    NodesValue = ((Node->UCB1*Node->UCB1_Weight)+(Node->NN_valuation*Node->NN_Weight));
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
  //Note: Doesn't account for NULL Node
  return HighestNode;
}

template <typename Game_Tp, typename Player_Tp,typename GameMove_Tp>
PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>::Find_MAX_UCB1_Child(){
  UCB1_applySoftmax_ToChildren();
  double     HighestValue = -DBL_MAX;
  double     NodesValue;
  PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* HighestNode  = (*Children.begin());

  for (PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* Node : Children){
      NodesValue = (Node->UCB1);

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
template <typename Game_Tp, typename Player_Tp,typename GameMove_Tp>
PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>::ReturnBestMove(){
  UCB1_applySoftmax_ToChildren();
  double     HighestValue = -DBL_MAX;
  double     NodesValue,NNValue,NodeUCB1Value;
  PMCTS_NN_Node* HighestNode  = NULL;

  for (PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* Node : Children){
    //NodesValue = Node->GetAverageValue();
    NodesValue = ((Node->UCB1*Node->UCB1_Weight)+(Node->NN_valuation*Node->NN_Weight));
    std::cout << "NodesValue:"<< NodesValue  << std::endl;
    if (HighestValue < NodesValue)
    {
      HighestNode  = Node;
      HighestValue = NodesValue;
    }
  }
  //Note: Doesnt account for NULL Node
  return HighestNode;
}



template <typename Game_Tp, typename Player_Tp, typename GameMove_Tp>
int PMCTS_NN_Node<Game_Tp, Player_Tp, GameMove_Tp>::AddChildren(std::vector<GameMove_Tp*> PossibleMoves) {
  int ChildrenAdded = 0;
  std::list<PMCTS_NN_Node<Game_Tp, Player_Tp, GameMove_Tp>*> tempChildrenList;

  //////////////////////////////////////////////////////////////////////////////
  // For each element within PossibleMoves, create new child nodes and store them in a temporary list
  for (GameMove_Tp* Instance : PossibleMoves) {
    if (Instance != nullptr) {
      Game_Tp* GameInstance = this->GivenGame->Move_ReturnNewGame(Instance);

      // Create a new PMCTS_NN_Node and add it to the temp list
      PMCTS_NN_Node<Game_Tp, Player_Tp, GameMove_Tp>* NewNode = new PMCTS_NN_Node<Game_Tp, Player_Tp, GameMove_Tp>(
          GameInstance, GameInstance->Players, Instance);
      NewNode->Parent = this;
      NewNode->RotatePlayers();
      tempChildrenList.push_back(NewNode);
      ChildrenAdded++;
    }
  }

  // Reserve space in Children vector and transfer nodes from the list
  Children.reserve(Children.size() + tempChildrenList.size());
  for (PMCTS_NN_Node<Game_Tp, Player_Tp, GameMove_Tp>* childNode : tempChildrenList) {
    Children.push_back(childNode);
  }

  return ChildrenAdded;
}

template <typename Game_Tp, typename Player_Tp, typename GameMove_Tp>
int PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>::AddChildren_WInference(std::vector<std::pair<GameMove_Tp*, double>> PossibleInstances){

  //Get Vector of NN values for move.


  int ChildrenAdded = 0;
  //std::list<Game_Tp*> PossibleGames = this->GivenGame->PossibleGames(PossibleInstances);

  //////////////////////////////////////////////////////////////////////////////
  // For each element within a list of PossibleInstances(Different Game States)
  // Add as different Childeren/Leaf Nodes
  //std::cout << "   PossibleInstances:"<<PossibleInstances.size()<< std::endl;

  if(!PossibleInstances.empty())
  {
    for (std::pair<GameMove_Tp*, double> Instance : PossibleInstances){

      // Access elements of the tuple
      GameMove_Tp* Game_Move = std::get<0>(Instance);       // Access the first element
      double Inference_Value = std::get<1>(Instance); // Access the second element

      if(Game_Move != nullptr) {
        Game_Tp* GameInstance = this->GivenGame->Move_ReturnNewGame(Game_Move);
        //////////////////////////////////////////////////////////////////////////////
        // For Each Possible Game, Create New MCTS_NN_Node<Game_Tp>, and add it to
        // children list.
        PMCTS_NN_Node *NewNode = new PMCTS_NN_Node<Game_Tp, Player_Tp,GameMove_Tp>
             (GameInstance, (GameInstance->Players), Game_Move);
        NewNode->Parent = this;
        NewNode->RotatePlayers();
        NewNode->NN_valuation = Inference_Value;

        Children.push_back(NewNode);
        ChildrenAdded++;
      }
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
template <typename Game_Tp, typename Player_Tp,typename GameMove_Tp>
PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>::RollOut(){
  //GivenGame->TestForWinner();
  Game_Tp* RollOutGame = GivenGame->CopyGame();
  RollOutGame->RollOut();

  //printf("RO_WinningPlayer:%p\n",RollOutGame->WinningPlayer);
  //TODO Check if game is finished
  RollOutChild = new PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>(RollOutGame,Players,nullptr);
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
template <typename Game_Tp, typename Player_Tp,typename GameMove_Tp>
void PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>::BackPropagation(Player_Tp* WinningPlayer,PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* HeadNode)
{
  //printf("((((((((((((((((((((((((((((\n");
  //If no matching condition is found an apposing player won the RollOut game.
  double EvaluatedValue = -1;
  if((Players.front()) == WinningPlayer)
  {
    EvaluatedValue = 1;
  }
  else if((WinningPlayer == (GivenGame->Draw)) || (WinningPlayer == nullptr))
  {
    EvaluatedValue = 0;
  }
  else{

    EvaluatedValue = -1;
  }

/*
  *   std::cout << GivenGame->Generate_StringRepresentation();
    GivenGame->PrintPlayers();
    printf("PMCTS_NN Node Player:%p\n",(Players.front()));
    printf("PMCTS_NN Node Player:%c\n",(Players.front()->GameRepresentation));
    //printf("PMCTS_NN Node Player:%c\n",(static_cast<TTT_Player*>(Players.front())->GameRepresentation));
    //printf("PMCTS_NN Node Player:%c\n",(static_cast<UTTT_Player*>(Players.front())->GameRepresentation));
    printf("     GivenPlayer:%p\n",WinningPlayer);
    //printf("     Player REP:%c\n",WinningPlayer->GameRepresentation);
    printf("  EvaluatedValue:%f\n",EvaluatedValue);
    printf("           Value:%f\n",ValueSum);
    printf("          Visits:%f\n",NodeVisits);
    printf(")))))))))))))))))))))))))))\n");
 */

  NodeVisits++;
  ValueSum += EvaluatedValue;


  if (
    Parent != nullptr &&
    this   != HeadNode
  )
  {
    Parent->BackPropagation(WinningPlayer,HeadNode);
  }
}

template <typename Game_Tp, typename Player_Tp,typename GameMove_Tp>
void PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>::RefreshWeights()
{
  NodeVisits = 0;
  ValueSum   = 0.001;
  for (PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* Node : Children){
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
template <typename Game_Tp, typename Player_Tp,typename GameMove_Tp>
double PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>::GetAverageValue()
{
  return ValueSum/NodeVisits;
}

template <typename Game_Tp, typename Player_Tp,typename GameMove_Tp>
std::size_t PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>::GetHash()
{
  //std::hash<Game_Tp>* Hash = new std::hash<Game_Tp>;// = std::hash<TTT>(* _Game);

  //std::size_t HashValue = Hash(GivenGame);
  const std::size_t HashValue = GivenGame->Hash();

  //delete Hash;
  return HashValue;
}


template <typename Game_Tp, typename Player_Tp,typename GameMove_Tp>
void PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>::DisplayStats(){
  if(NodeVisits>0)
  {
    //Check if Parent node exists.
    // if it doesnt exist, assume its zero.
    double ParentVisits = 0;
    if(Parent!=nullptr) {
      ParentVisits = Parent->NodeVisits;
    }

/*
    std::cout << "----------------------------------------\n";
      printf("\tLocation: %p\n",this);
      printf("\tPlayer: %c\n",(*Players.begin())->GameRepresentation);
      printf("\tNodeVisits:%f\n", NodeVisits);
      printf("\tValueSum:%f\n", ValueSum);
      printf("\tNode Ratio:%f\n", (ValueSum/NodeVisits));
      if(Parent != nullptr){printf("\tUCB1:%f\n", Find_UCB1());}
      printf("\tNN_Inference:%f\n", NN_valuation);
      printf("\tHash: %zu\n",GivenGame->Hash());
      printf("\tChilderen: %zu\n",Children.size());
      if(Parent != nullptr){printf("\tParentVisits: %f\n",Parent->NodeVisits);}
      std::cout << GivenGame->Generate_StringRepresentation();

      for (MCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* Node : Children){
        printf("\t\tChilderen: %p \t%f \t%f\n",Node,Node->ValueSum,Node->NodeVisits);
        UCB1_applySoftmax_ToChildren();
        double NodesValue = ((Node->NN_valuation*.50) + (Node->UCB1_SoftMax*.50));
        std::cout << "\t\t\tNode->UCB1:"<< Node->UCB1  << std::endl;
        std::cout << "\t\t\tNode->UCB1_SoftMax:"<< Node->UCB1_SoftMax  << std::endl;
        std::cout << "\t\t\tNode->NN_valuation:"<< Node->NN_valuation  << std::endl;
        std::cout << "\t\t\tNodesValue:"<< ((Node->NN_valuation*.50) + (Node->UCB1_SoftMax*.50))  << std::endl;
      }

 */
  }

}


// insertion sort template function
// to sort array in ascending order
// n is the size of array
template <typename Game_Tp, typename Player_Tp,typename GameMove_Tp>
std::vector<PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>*> InsertionSort(std::vector<PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>*> OldList)
{

  std::vector<PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>*> NewList;
//  std::list<PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>*> HighestNode;
  typename std::vector<PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>*>::iterator HighestNode;

  while(OldList.size() > 0){
    typename std::vector<PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>*>::iterator List_iterator = OldList.begin();
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



template <typename Game_Tp, typename Player_Tp, typename GameMove_Tp>
double PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>::Get_UCB1_ChildrenSum(){
  double UCB1_Sum = 0;
  for (PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* Node : Children){
    UCB1_Sum += Node->Find_UCB1();
    //printf("Node->SoftMAX:%f\n",Node->SoftMAX);
  }
  //printf("UCB1_Sum:%f\n",UCB1_Sum);
  return UCB1_Sum;
}


template <typename Game_Tp, typename Player_Tp ,typename GameMove_Tp>
double PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>::AssignSoftMAX(){
  double UCB1_Sum = Get_UCB1_ChildrenSum();
  for (PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* Node : Children){
    Node->SoftMAX = Node->UCB1Value/UCB1_Sum;
  }
  return UCB1_Sum;
}

template <typename Game_Tp, typename Player_Tp ,typename GameMove_Tp>
double PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>::Get_ChildrenValueSum(){
  double Sum = 0;
  for (PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* Node : Children){
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
template <typename Game_Tp, typename Player_Tp ,typename GameMove_Tp>
void PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>::DisplayTree(const int Depth){
  printf("Calling Sort \n");
  Children = InsertionSort(Children);


  if (!Children.empty()){
    for (PMCTS_NN_Node* Child : Children) { // c++11 range-based for loop
         Child->DisplayStats();
      }
    if((Depth-1)>0){
      for (PMCTS_NN_Node* Child : Children) { // c++11 range-based for loop
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
template <typename Game_Tp, typename Player_Tp ,typename GameMove_Tp>
void PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>::DisplayTree(){
  // For each branch, display the game's statistics.
  //////////////////////////////////////////////////////////////////////////////
  for (PMCTS_NN_Node* Child : Children) {
      Child->DisplayStats();
    }

  std::cout << "----------------------------------------\n";
  std::cout << GivenGame->Generate_StringRepresentation();
  for (PMCTS_NN_Node* Child : Children) {
       Child->DisplayTree();
    }

}

















template <typename Game_Tp, typename Player_Tp,typename GameMove_Tp>
struct PMCTS_NN_ThreadData_t {

  //////////////////////////////////////////////////////////////////////////////
  // Thread Serach Data
  //////////////////////////////////////////////////////////////////////////////
  pthread_t Thread{};
  double Threads{};
  double Depth{};
  bool Finished{};

  //////////////////////////////////////////////////////////////////////////////
  // Game & Tree Data
  //////////////////////////////////////////////////////////////////////////////
  PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* TransversedNode;
  //std::vector<Player_Tp*> StartingPlayer;

};


template <typename Game_Tp, typename Player_Tp,typename GameMove_Tp>
PMCTS_NN_ThreadData_t<Game_Tp,Player_Tp, GameMove_Tp>* Dispatch_MCTS_UCB1PrioritySearch_Thread(PMCTS_NN_Node<Game_Tp,Player_Tp,GameMove_Tp>* TransversedNode,double Threads, int ThreadDepth);


/*
JoinThreads.
 * @param
 *    Takes a std::list<PMCTS_NN_ThreadData_t<Game_Tp,Player_Tp, GameMove_Tp>*>, and takes the
 *   Finished threads and joins them.
 * Also has a internal wait 100 miliseconds to prevent overutilization of resources.

 */
template <typename Game_Tp, typename Player_Tp ,typename GameMove_Tp>
std::vector<PMCTS_NN_ThreadData_t<Game_Tp,Player_Tp, GameMove_Tp>*> fJoinFinishedThreads(std::vector<PMCTS_NN_ThreadData_t<Game_Tp,Player_Tp, GameMove_Tp>*>ThreadList)
{

/*
printf("/////////////////////////////////////////////////////////////////\n");
printf("Starting _JoinFinishedThreads\n");
printf("ThreadList.size():%lu\n",ThreadList.size());
printf("/////////////////////////////////////////////////////////////////\n");*/
  int ThreadsJoined = 0;

  while(ThreadsJoined <= 0){
      //printf("ThreadList.size():%d\n",ThreadList.size());
      typename std::vector<PMCTS_NN_ThreadData_t<Game_Tp,Player_Tp, GameMove_Tp>*>::iterator ThreadList_iterator = ThreadList.begin();
      while ( ThreadList_iterator != ThreadList.end())
      {
          //printf("ThreadList.size():%ld\n", ThreadList.size());
          if((*ThreadList_iterator)->Finished){
            //printf("  Joining Thread\n");
            pthread_join(((*ThreadList_iterator)->Thread), nullptr);
            ThreadsJoined++;
            //printf("  ThreadsJoined:%d\n",ThreadsJoined);
            free(*ThreadList_iterator);
            //printf("  free\n");
            //ThreadList.erase(ThreadList_iterator++);
            ThreadList_iterator = ThreadList.erase(ThreadList_iterator);
            //printf("  ThreadList.erase\n");
          }
          else
          {
              // move to next item
              ++ThreadList_iterator;
          }
      }
      std::this_thread::sleep_for(std::chrono::milliseconds(5));
    }

  //printf("returning ThreadList\n");
  return ThreadList;
}




template <typename Game_Tp, typename Player_Tp ,typename GameMove_Tp>
std::vector<PMCTS_NN_ThreadData_t<Game_Tp,Player_Tp, GameMove_Tp>*> _JoinAllThreads(std::vector<PMCTS_NN_ThreadData_t<Game_Tp,Player_Tp, GameMove_Tp>*>ThreadList)
{
  while(ThreadList.size() != 0){
    ThreadList = fJoinFinishedThreads<Game_Tp,Player_Tp, GameMove_Tp>(ThreadList);
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



template <typename Game_Tp, typename Player_Tp ,typename GameMove_Tp>
PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* MCTS_Algorithm(PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>*TransversedNode)
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
    if(TransversedNode->GivenGame->isGameFinished){
      //std::cout << TransversedNode->GivenGame->Generate_StringRepresentation();
      //Pause;
      return TransversedNode;
    }

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
    //std::list<Game_Tp*> Games = TransversedNode->GivenGame->PossibleGames();
    //std::vector<GameMove_Tp*> GameMoves = TransversedNode->GivenGame->PossibleMoves();
    std::vector<std::pair<GameMove_Tp*, double>>GameMoves_WithInference = TransversedNode->GivenGame->PossibleMoves_WithInference();

    //std::cout << "Adding Children Size:" << Games.size() << "\n";


    /////////////////////////////////////////////////////////////////
    // verify future games have been found.
    /////////////////////////////////////////////////////////////////
    if (GameMoves_WithInference.empty())
    {
      return TransversedNode;
    }

    /////////////////////////////////////////////////////////////////
    //Takes the new Games and add them to the tree.
    /////////////////////////////////////////////////////////////////
    //printf("TransversedNode->GivenGame->Players.begin():%p\n",*(TransversedNode->GivenGame->_Players.begin()));
    //TransversedNode->AddChildren(GameMoves);
    TransversedNode->AddChildren_WInference(GameMoves_WithInference);

    /////////////////////////////////////////////////////////////////
    //select the first posible node.
    /////////////////////////////////////////////////////////////////
    PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* NextNode = *TransversedNode->Children.begin();

    /////////////////////////////////////////////////////////////////
    //Recursivly search down the tree looking for an 'optimal' branch to evaluate.
    /////////////////////////////////////////////////////////////////
    return MCTS_Algorithm(NextNode);

  }
  //Otherwise, transverse the tree using the UCB1 formula, looking for an 'optimal' branch to evaluate.
  else{

    //Not Leaf Node, Transverse down the Tree: Find the branch with the MAX UCB1 value.
    PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* MAXNode = TransversedNode->Find_MAX_UCB1_Child();

    //Recursivly search down the tree looking for an 'optimal' branch to evaluate.
    return MCTS_Algorithm(MAXNode);
  }
}


/*
//////////////////////////////////////////////////////////////////////////////
// MCTS_Search
//////////////////////////////////////////////////////////////////////////////
template <typename Game_Tp, typename Player_Tp ,typename GameMove_Tp>
void MCTS_Search(PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* TransversedNode, double ThreadDepth)
{
  PMCTS_NN_ThreadData_t<Game_Tp,Player_Tp, GameMove_Tp>* PMCTS_NN_ThreadData = (PMCTS_NN_ThreadData_t<Game_Tp,Player_Tp, GameMove_Tp>*) malloc(sizeof(PMCTS_NN_ThreadData_t<Game_Tp,Player_Tp, GameMove_Tp>));
  //printf("PMCTS_NN_ThreadData_t:%p\n",PMCTS_NN_ThreadData);
  PMCTS_NN_ThreadData->TransversedNode = TransversedNode;
  PMCTS_NN_ThreadData->Depth           = ThreadDepth;
  PMCTS_NN_ThreadData->Finished        = false;
  MCTS_Search_thread<Game_Tp,Player_Tp ,typename GameMove_Tp>(PMCTS_NN_ThreadData);
  free(PMCTS_NN_ThreadData);
}
*/
template <typename Game_Tp, typename Player_Tp ,typename GameMove_Tp>
void MCTS_Search(PMCTS_NN_Node<Game_Tp,Player_Tp,GameMove_Tp>* StartingNode,double Depth)
{

  //////////////////////////////////////////////////////////////////////////////
  // For each Itteration, preform the following steps.
  //////////////////////////////////////////////////////////////////////////////
  for (int i = 0; i < Depth; i++) {

    PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>*TransversedNode = StartingNode;
    //printf("Depth:%d\n", i);
    //printf("TransversedNode:%p\n", TransversedNode);
    //////////////////////////////////////////////////////////////////////////////
    // Preform Tree transversal, to build tree.
    //    This returns either a rollout node, or a node from the tree with a completed game(based on MCTS).
    TransversedNode = MCTS_Algorithm<Game_Tp,Player_Tp, GameMove_Tp>(TransversedNode);

    //////////////////////////////////////////////////////////////////////////////
    // Preform BackPropagation, to assign weights.
    //printf("Pack Propagation set:\n");
    TransversedNode->BackPropagation(TransversedNode->GivenGame->TestForWinner(),StartingNode);
  }
}




//////////////////////////////////////////////////////////////////////////////
// MCTS_Search_thread has been implemented to call MCTS_Search as Thread.
//////////////////////////////////////////////////////////////////////////////
template <typename Game_Tp, typename Player_Tp ,typename GameMove_Tp>
void * MCTS_Search_thread(void* GivenPMCTS_NN_ThreadData)
{
  PMCTS_NN_ThreadData_t<Game_Tp,Player_Tp, GameMove_Tp>* PMCTS_NN_ThreadData = static_cast<PMCTS_NN_ThreadData_t<Game_Tp,Player_Tp, GameMove_Tp>*>(GivenPMCTS_NN_ThreadData);

  MCTS_Search(PMCTS_NN_ThreadData->TransversedNode,PMCTS_NN_ThreadData->Depth);

  //////////////////////////////////////////////////////////////////////////////
  // Thread is finished, Set Flag for Thread Clean up.
  PMCTS_NN_ThreadData->Finished = true;

  return nullptr;
}
















//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
// PMCTS_NN/MCTS Dispatch algorithms
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////




template <typename Game_Tp, typename Player_Tp ,typename GameMove_Tp>
PMCTS_NN_ThreadData_t<Game_Tp,Player_Tp, GameMove_Tp>* DispatchMCTS_SearchThread(PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* TransversedNode,double Threads, int ThreadDepth)
{
  PMCTS_NN_ThreadData_t<Game_Tp,Player_Tp, GameMove_Tp>* PMCTS_NN_ThreadData = (PMCTS_NN_ThreadData_t<Game_Tp,Player_Tp, GameMove_Tp>*) malloc(sizeof(PMCTS_NN_ThreadData_t<Game_Tp,Player_Tp, GameMove_Tp>));
  //printf("PMCTS_NN_ThreadData_t:%p\n",PMCTS_NN_ThreadData);
  PMCTS_NN_ThreadData->TransversedNode = TransversedNode;
  PMCTS_NN_ThreadData->Depth           = ThreadDepth;
  PMCTS_NN_ThreadData->Threads           = Threads;
  PMCTS_NN_ThreadData->Finished        = false;

  pthread_create(&(PMCTS_NN_ThreadData->Thread), nullptr, MCTS_Search_thread<Game_Tp,Player_Tp, GameMove_Tp>, PMCTS_NN_ThreadData);
  return PMCTS_NN_ThreadData;
}








template <typename Game_Tp, typename Player_Tp ,typename GameMove_Tp>
void MCTS_DispatchNaively(PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* TransversedNode,int Threads, int Depth)
{
  double ThreadDepth = (Depth/TransversedNode->Children.size())+1;

  PMCTS_NN_ThreadData_t<Game_Tp,Player_Tp, GameMove_Tp>*            PMCTS_NN_ThreadData;
  std::vector<PMCTS_NN_ThreadData_t<Game_Tp,Player_Tp, GameMove_Tp>*> ThreadList;

  for (PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* Node : TransversedNode->Children){
    ThreadList.push_back(
      DispatchMCTS_SearchThread<Game_Tp,Player_Tp, GameMove_Tp>(Node, Threads, ThreadDepth)
    );
  }

  ThreadList = _JoinAllThreads<Game_Tp,Player_Tp, GameMove_Tp>(ThreadList);
}


template <typename Game_Tp, typename Player_Tp ,typename GameMove_Tp>
bool MCTS_DispatchEvenly(PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* TransversedNode,int Threads, int Depth)
{
  MCTS_Search(TransversedNode,2);
  if(TransversedNode->Children.size()==0) {
    return false;
  }
  double ThreadDepth = (Depth/TransversedNode->Children.size())+1;
  std::vector<PMCTS_NN_ThreadData_t<Game_Tp,Player_Tp, GameMove_Tp>*> ThreadList;
  ThreadList.reserve(Threads);
  //////////////////////////////////////////////////////////////////////////////
  //For Each Branch within Game, Dispatch a new thread.
  for (PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* Node : TransversedNode->Children){

    //////////////////////////////////////////////////////////////////////////////
    //For Each Thread to dispatch, wait until there is an available thread to release.
    bool DispatchedForNode = true;
    while(DispatchedForNode)
    {

      //////////////////////////////////////////////////////////////////////////////
      //Dispatch Threads
      //printf("----------\n");
      //printf("ThreadList.size():%ld\n",ThreadList.size());
      //printf("Threads:%d\n",Threads);
      if (ThreadList.size() < Threads){
        //PMCTS_NN_ThreadData = _DispatchThread<Game_Tp,Player_Tp, GameMove_Tp>(Node, ThreadDepth);
        ThreadList.push_back(
          DispatchMCTS_SearchThread<Game_Tp,Player_Tp, GameMove_Tp>(Node, Threads, ThreadDepth)
        );
        DispatchedForNode = false;
      }


      //////////////////////////////////////////////////////////////////////////////
      //Join Threads from previous node search
      if (ThreadList.size() == Threads){
        ThreadList = fJoinFinishedThreads<Game_Tp,Player_Tp, GameMove_Tp>(ThreadList);
      }


    }
  }
  //////////////////////////////////////////////////////////////////////////////
  //Join Threads from final search
  //printf("Join Threads from final search\n");
  ThreadList = _JoinAllThreads<Game_Tp,Player_Tp, GameMove_Tp>(ThreadList);
  //printf("  finished joining Threads from final search\n");

  return true;
}







//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
// PMCTS_NN searches
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////


/*
  Helper Function for MCTS::Search & EvaluateStep.
  Performs an itteration of the MCTS Algorithm on 'TransversedNode'
*/
/*
template <typename Game_Tp, typename Player_Tp, GameMove_Tp>
PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* PMCTS_NN_Algorithm(PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>*TransversedNode)
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
    PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* NextNode = *TransversedNode->Children.begin();

    /////////////////////////////////////////////////////////////////
    //Recursivly search down the tree looking for an 'optimal' branch to evaluate.
    /////////////////////////////////////////////////////////////////
    return MCTS_Algorithm(NextNode);

  }
  //Otherwise, transverse the tree using the UCB1 formula, looking for an 'optimal' branch to evaluate.
  else{

    //Not Leaf Node, Transverse down the Tree: Find the branch with the MAX UCB1 value.
    PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* MAXNode = TransversedNode->Find_MAX_UCB1_Child();

    //Recursivly search down the tree looking for an 'optimal' branch to evaluate.
    return MCTS_Algorithm(MAXNode);
  }
}
*/



/*

  //////////////////////////////////////////////////////////////////////////////
  // For each Itteration, preform the following steps.
  //////////////////////////////////////////////////////////////////////////////
  for (int i = 0; i < PMCTS_NN_ThreadData->Depth; i++) {
    PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>*TransversedNode = PMCTS_NN_ThreadData->TransversedNode;

    //////////////////////////////////////////////////////////////////////////////
    // Preform Tree transversal, to build tree.
    TransversedNode = PMCTS_NN_Algorithm<Game_Tp,Player_Tp, GameMove_Tp>(TransversedNode);

    //////////////////////////////////////////////////////////////////////////////
    // Preform BackPropagation, to assign weights.
    TransversedNode->BackPropagation(TransversedNode->GivenGame->TestForWinner(),PMCTS_NN_ThreadData->TransversedNode);

  }
  */



//////////////////////////////////////////////////////////////////////////////
// PMCTS_NN_Search has been implemented for parallelism.
//////////////////////////////////////////////////////////////////////////////

template <typename Game_Tp, typename Player_Tp ,typename GameMove_Tp>
double MCTS_FindPriorityByUCB1(PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>*Node){
  double UCB1Value = Node->Find_UCB1();
  //printf("UCB1:%lf\n", UCB1Value);
  return sqrt(UCB1Value);
}


template <typename Game_Tp, typename Player_Tp ,typename GameMove_Tp>
double MCTS_FindSUMPriorityByUCB1(PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>*TransversedNode){
  double Sum = 0;
  for (PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* Node : TransversedNode->Children){
    Sum += MCTS_FindPriorityByUCB1(Node);
    //Node->DisplayStats();
    //printf("MCTS_FindPriorityByUCB1:%lf\n", MCTS_FindPriorityByUCB1(Node));
    //printf("sum:%lf\n", Sum);
  }
  //printf("sum:%lf\n", Sum);
  return Sum;
}



template <typename Game_Tp, typename Player_Tp ,typename GameMove_Tp>
double MCTS_FindPriorityBySumValue(PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>*Node){
  double UCB1Value = Node->ValueSum;

  //printf("UCB1:%lf\n", UCB1Value);
  return std::max(UCB1Value,(double).001);
}


template <typename Game_Tp, typename Player_Tp ,typename GameMove_Tp>
double MCTS_FindSUMPriorityBySumValue(PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>*TransversedNode){
  double Sum = 0;
  for (PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* Node : TransversedNode->Children){
    Sum += MCTS_FindPriorityBySumValue(Node);
    //Node->DisplayStats();
    //printf("MCTS_FindPriorityBySumValue:%f\n", MCTS_FindPriorityBySumValue(Node));
    //printf("sum:%f\n", Sum);
  }
  //printf("sum:%lf\n", Sum);
  return Sum;
}





//MCTS_UCB1Threads *UCB1Threads = new MCTS_UCB1Threads();
template <typename Game_Tp, typename Player_Tp ,typename GameMove_Tp>
class MCTS_UCB1Threads
{
public:
  //////////////////////////////////////////////////////////////////////////////
  // Thread Serach Data
  //////////////////////////////////////////////////////////////////////////////
  double MaxThreads;
  double ThreadsDispatched;
  std::vector<PMCTS_NN_ThreadData_t<Game_Tp,Player_Tp, GameMove_Tp>*> ThreadList;


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
  MCTS_UCB1Threads(PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>*TransversedNode,double GivenThreads, double GivenDepth){

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
    _JoinAllThreads<Game_Tp,Player_Tp, GameMove_Tp>(ThreadList);
  }

  void JoinFinishedThreads(std::vector<PMCTS_NN_ThreadData_t<Game_Tp,Player_Tp, GameMove_Tp>*>ThreadList)
  {

    //printf("/////////////////////////////////////////////////////////////////\n");
    //printf("Starting JoinFinishedThreads\n");
    //printf("ThreadList.size():%d\n",ThreadList.size());
    //printf("/////////////////////////////////////////////////////////////////\n");
    int ThreadsJoined = 0;

    while(ThreadsJoined <= 0){

        //printf("ThreadList.size():%d\n",ThreadList.size());
        typename std::vector<PMCTS_NN_ThreadData_t<Game_Tp,Player_Tp, GameMove_Tp>*>::iterator ThreadList_iterator = ThreadList.begin();
        while ( ThreadList_iterator != ThreadList.end())
        {
            if((*ThreadList_iterator)->Finished){
              pthread_join(((*ThreadList_iterator)->Thread), nullptr);
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

  void Dispatch(PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>*Node);
};





template <typename Game_Tp, typename Player_Tp ,typename GameMove_Tp>
void MCTS_UCB1PriorityAssignment(PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>*TransversedNode,double Threads, double Depth){

  MCTS_UCB1Threads<Game_Tp, Player_Tp, GameMove_Tp> *UCB1Threads = new MCTS_UCB1Threads<Game_Tp, Player_Tp, GameMove_Tp>(TransversedNode,Threads,Depth);

  for (PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* Node : TransversedNode->Children){
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




template <typename Game_Tp, typename Player_Tp ,typename GameMove_Tp>
void MCTS_UCB1PrioritySearch(PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* TransversedNode,double Threads, double Depth)
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
    //MCTS_UCB1PriorityAssignment<Game_Tp,Player_Tp, GameMove_Tp>(TransversedNode,Threads,Depth);
    MCTS_DispatchEvenly(TransversedNode,Threads,Depth);
    //PMCTS_NN_DispatchByPigeonHole(TransversedNode,Threads,Depth);

  }
  else{
    /////////////////////////////////////////////////////////////////
    // Dispatch by MCTS_DispatchEvenly,
    /////////////////////////////////////////////////////////////////
    //printf("calling DispatchEvenly\n");
    MCTS_DispatchEvenly(TransversedNode,Threads,Depth);

  }
  //printf("Refreshing Wights");
  TransversedNode->RefreshWeights();
  //printf("   finished Refreshing Wights");
/*
for (PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* Node : TransversedNode->Children){
  TransversedNode->DisplayStats();
  Node->DisplayStats();
}
*/
}


template <typename Game_Tp, typename Player_Tp ,typename GameMove_Tp>
void* MCTS_UCB1PrioritySearch_Thread(void* GivenPMCTS_NN_ThreadData)
{
  PMCTS_NN_ThreadData_t<Game_Tp,Player_Tp, GameMove_Tp>* PMCTS_NN_ThreadData = static_cast<PMCTS_NN_ThreadData_t<Game_Tp,Player_Tp, GameMove_Tp>*>(GivenPMCTS_NN_ThreadData);

  MCTS_UCB1PrioritySearch<Game_Tp,Player_Tp, GameMove_Tp>(PMCTS_NN_ThreadData->TransversedNode,PMCTS_NN_ThreadData->Threads,PMCTS_NN_ThreadData->Depth);
  //////////////////////////////////////////////////////////////////////////////
  // Thread is finished, Set Flag for Thread Clean up.
  PMCTS_NN_ThreadData->Finished = true;
  return nullptr;
}


template <typename Game_Tp, typename Player_Tp ,typename GameMove_Tp>
PMCTS_NN_ThreadData_t<Game_Tp,Player_Tp, GameMove_Tp>* Dispatch_MCTS_UCB1PrioritySearch_Thread(PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* TransversedNode,double Threads, int ThreadDepth)
{
  PMCTS_NN_ThreadData_t<Game_Tp,Player_Tp, GameMove_Tp>* PMCTS_NN_ThreadData = (PMCTS_NN_ThreadData_t<Game_Tp,Player_Tp, GameMove_Tp>*) malloc(sizeof(PMCTS_NN_ThreadData_t<Game_Tp,Player_Tp, GameMove_Tp>));
  //printf("PMCTS_NN_ThreadData_t:%p\n",PMCTS_NN_ThreadData);
  PMCTS_NN_ThreadData->TransversedNode = TransversedNode;
  PMCTS_NN_ThreadData->Depth           = ThreadDepth;
  PMCTS_NN_ThreadData->Threads         = Threads;
  PMCTS_NN_ThreadData->Finished        = false;

  pthread_create(&(PMCTS_NN_ThreadData->Thread), nullptr, MCTS_UCB1PrioritySearch_Thread<Game_Tp,Player_Tp, GameMove_Tp>, PMCTS_NN_ThreadData);
  return PMCTS_NN_ThreadData;
}




template <typename Game_Tp, typename Player_Tp,typename GameMove_Tp>
void MCTS_UCB1Search(PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* TransversedNode,double Threads, double Depth)
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
    std::list<Player*> _GivenPlayers

 *
 * @see MCTS_Node::Find_MAX_UCB1_Child()
 * @see Game interface(Found within Game.cu)
 */
template <typename Game_Tp, typename Player_Tp ,typename GameMove_Tp>
class PMCTS_NN: public TreeSimulation
{
  public:

  //////////////////////////////////////////////////////////////////////////////
  //Thread Information
  double Depth;
  double Threads;
  //ParallelControlBlock* ParallelCB;


  //////////////////////////////////////////////////////////////////////////////
  // The current head node.
  //////////////////////////////////////////////////////////////////////////////
  Game_Tp* GivenGame;
  //MCTS_Node* TransversedNode;
  PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* HeadNode;
  Game_Tp* SimulatedGame;


  //////////////////////////////////////////////////////////////////////////////
  // The current head node.
  //////////////////////////////////////////////////////////////////////////////
  std::vector<Player_Tp*> Players;
  Player_Tp* GivenPlayer;


  //////////////////////////////////////////////////////////////////////////////
  // Initialization method.
  PMCTS_NN(Game_Tp*Game){

    GivenGame = Game->CopyGame();
    Players = GivenGame->Players;
    GivenPlayer = *(Players.begin());
    HeadNode  = new PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>(GivenGame,Players,nullptr);
  }

  //////////////////////////////////////////////////////////////////////////////
  //
  //////////////////////////////////////////////////////////////////////////////
  virtual ~PMCTS_NN(){
    delete HeadNode;
    //delete ParallelCB;
  }

  //////////////////////////////////////////////////////////////////////////////
  // Parallel Functions
  //////////////////////////////////////////////////////////////////////////////
  PMCTS_NN_ThreadData_t<Game_Tp,Player_Tp, GameMove_Tp>* DispatchThread(PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* TransversedNode,int Threads, int ThreadDepth);
  //void DispatchThreads(PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* TransversedNode,int Threads, int ThreadDepth);
  //void DispatchByPigeonHole(PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* TransversedNode,int Threads, int ThreadDepth);
  //void DispatchNaively(PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* TransversedNode,int Threads, int ThreadDepth);
  //void DispatchEvenly(PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* TransversedNode,int Threads, int ThreadDepth);

  //////////////////////////////////////////////////////////////////////////////
  // 'Single' Threaded Algorithms
  //////////////////////////////////////////////////////////////////////////////
  //PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* PMCTS_NN_Algorithm(PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* TransversedNode);
  //TODO Include PMCTS_NN Back Propagation
  //PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* MCTS_Algorithm(PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* TransversedNode);
  //TODO Include MCTS Back Propagation


  //////////////////////////////////////////////////////////////////////////////
  // Management Functions
  //////////////////////////////////////////////////////////////////////////////
  void PerformStep(PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* TransversedNode,Player_Tp* GivenPlayer);
  //double BackPropagation(MCTS_Node* TransversedNode,double GivenPlayer);
  //void PMCTS_NN_Search(PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* TransversedNode,double Depth); //,Player* GivenPlayer
  //void MCTS_Search(PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* TransversedNode,double Depth); //,Player* GivenPlayer
  PMCTS_NN* PruneSearch(PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>*SelectedNode);
  void ParallelSearch(int Depth);

  GameMove_Tp *ReturnBestMove();
  void Search(double Threads, double Depth);


  void DisplayTree(int Depth);

  void Search(PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* TransversedNode,double Threads, double Depth);


  void Save(std::string LogPath);
  void Save(std::string LogPath,int Depth);

  void SaveSearch(std::string Dir,double Threads, double Depth);


  void Node_BackPropagation(PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* TransversedNode,Player_Tp* GivenPlayer);
  //MCTS* CreateBookMoves();
  //MCTS* SaveBookMoves(char* Path);
  //MCTS* OpenBookMoves(char* Path);
  //MCTS_Node* Find_Highest_UCB1(std::list<MCTS_Node*>MCTS_List);

};














template<typename Game_Tp, typename Player_Tp, typename GameMove_Tp>
void PMCTS_NN<Game_Tp, Player_Tp, GameMove_Tp>::DisplayTree(int Depth) {
  HeadNode->DisplayTree(Depth);
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
template <typename Game_Tp, typename Player_Tp ,typename GameMove_Tp>
void PMCTS_NN<Game_Tp,Player_Tp, GameMove_Tp>::Search
  (
    PMCTS_NN_Node<Game_Tp,Player_Tp, GameMove_Tp>* TransversedNode,
    double Threads,
    double Depth
    )
{
  //Preform initial Search to build Search tree.
  MCTS_Search(TransversedNode,37);
  //PMCTS_NN_DispatchThreads(TransversedNode, Threads, Depth);
  //PMCTS_NN_Search(TransversedNode,Threads, Depth);


  //PMCTS_NN_DispatchEvenly(TransversedNode,5,10);

  //PMCTS_NN_UCB1PrioritySearch(TransversedNode,Threads,Depth);

  if(Threads==1){
    MCTS_Search(TransversedNode,Depth);
  }
  else{
    MCTS_UCB1Search(TransversedNode,Threads,Depth);
  }
}



template <typename Game_Tp, typename Player_Tp ,typename GameMove_Tp>
void PMCTS_NN<Game_Tp,Player_Tp, GameMove_Tp>::Search(double Threads, double Depth)
{
  Search(HeadNode, Threads, Depth);
  HeadNode->DisplayTree(1);
  HeadNode->DisplayStats();

}


template<typename Game_Tp, typename Player_Tp, typename GameMove_Tp>
void MCTS_UCB1Threads<Game_Tp, Player_Tp, GameMove_Tp>::Dispatch(PMCTS_NN_Node<Game_Tp, Player_Tp, GameMove_Tp> *Node) {

  double UCB1Value            = MCTS_FindPriorityByUCB1(Node);
  double ValueSum             = MCTS_FindPriorityBySumValue(Node);

  double Depth_By_UCB1       = std::max((UCB1Value / UBC1_PrioritySum)     * UBC1_Depth,(double)0);
  double Depth_By_ValueSum   = std::max((ValueSum  / ValueSum_PrioritySum) * ValueSum_Depth,(double)0);
  double BranchDepth         = (Depth_By_ValueSum + Depth_By_UCB1 + ceil(MinimumDepth));

  double BranchThreads       = std::min(ceil(BranchDepth/DepthThreadRatio),MaxThreads);
  //BranchDepth = MinimumDepth;


  /*
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
*/
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
      //PMCTS_NN_ThreadData = _DispatchThread<Game_Tp,Player_Tp, GameMove_Tp>(Node, ThreadDepth);
      ThreadList.push_back(
        Dispatch_MCTS_UCB1PrioritySearch_Thread<Game_Tp,Player_Tp, GameMove_Tp>(Node, BranchThreads, BranchDepth)
      );
      DispatchingForNode = false;
    }
    else{
      //////////////////////////////////////////////////////////////////////////////
      //Join Threads
      ThreadList = fJoinFinishedThreads<Game_Tp,Player_Tp, GameMove_Tp>(ThreadList);
    }
  }
  //ThreadList = fJoinFinishedThreads<Game_Tp,Player_Tp, GameMove_Tp>(ThreadList);
}

template <typename Game_Tp, typename Player_Tp, typename GameMove_Tp>
GameMove_Tp* PMCTS_NN<Game_Tp, Player_Tp, GameMove_Tp>::ReturnBestMove()
{
  return (HeadNode->ReturnBestMove())->Move;
}





/*





template <typename Game_Tp, typename Player_Tp ,typename GameMove_Tp>
void PMCTS_NN<Game_Tp,Player_Tp, GameMove_Tp>::SaveSearch(std::string Dir,double Threads, double Depth)
{
  Search(HeadNode, Threads, Depth);
  HeadNode->DisplayTree(1);
  HeadNode->DisplayStats();
  Save(Dir,10);
}
*/


#endif //P_MCTS_NN_CU
