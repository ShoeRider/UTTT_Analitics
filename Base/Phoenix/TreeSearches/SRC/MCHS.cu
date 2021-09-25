/*
====================================================================================================
Description MCHS(Conte-Carlo-Hash-Search):
- Contains MCTS(Conte-Carlo-Hash-Search), and MCHS_Node to search a search space
based on the given rules within Game.cu. MCHS adapts the MCTS Tree search but Uses a Hash algorithm and a Hash Table to centralize duplicate games and remove overlapping search tree branches. 

NOTE: Implementing Parallel threads will be a challenge. 
I need to figure out how to BackPropigation.
Problem: When duplicate games occur, there are multiple parents, creating the need for mutex locks and a list of all parents for each node.


====================================================================================================
Date:           24 September 2021
Script Version: 1.0
Name:           Anthony M Schroeder
Email:          as3379@nau.edu

//TODO: Hash Table itself
//TODO: Implement hash algorithm for Games. 
};

==========================================================
Date:           24 September 2021
Script Version: 1.0
Description: creating structure. 

==========================================================
*/

#ifndef MCHS_CU
#define MCHS_CU


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
class PMCTS_Node// Define the Hash Table Item here
struct Ht_item {
    char* key;
    char* value;
};
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
    PMCH_Node(Game_Tp* Instance,std::list<Player_Tp*> _GivenPlayers){

    }


    ~PMCTS_Node(){

    }

    //////////////////////////////////////////////////////////////////////////////
    // Method Declarations.
    //////////////////////////////////////////////////////////////////////////////
/*

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
*/

};














// Define the Hash Table Item here
template <typename Struct,typename Player_Tp>
struct Hash_item {
    Struct* key;
    Player_Tp value;
};


// Define the Hash Table here
template <typename Struct,typename Player_Tp>
struct HashTable {
    // Contains an array of pointers
    // to items
    Hash_item** items;
    int size;
    int count;
};

























/*
MCHS Monte Carlo Hash Search. 


@Methods:

 */
template <typename Game_Tp, typename Player_Tp>
class PMCHS: public TreeSimulation
{
public:


  //////////////////////////////////////////////////////////////////////////////
  //Hash Table information

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
  PMCH(Game_Tp*_Game,std::list<Player_Tp*> _GivenPlayers){
  
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


#endif //MCHS_CU
