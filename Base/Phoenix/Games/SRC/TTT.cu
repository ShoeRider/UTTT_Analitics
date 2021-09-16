/*
====================================================================================================
Description TTT(Tic Tac Toe):
- Purpose:
Implement Tic Tac Toe through Game interface. Using standard rules.

====================================================================================================
Date:           NA
Script Version: 1.0
Name:           Anthony M Schroeder
Email:          as3379@nau.edu
==========================================================
Date:           15 September 2021
Script Version: 1.1
Description: Remove Game* from TTT to create usable version for MCTS Templates.
==========================================================
*/
#ifndef TTT_CU
#define TTT_CU


//////////////////////////////////////////////////////////////////////////////
// Game Library for inheritance structure.
//////////////////////////////////////////////////////////////////////////////
#include "TTT.h"

/*
TTT_Move


@Methods:

 */
struct TTT_Move : public GameMove
{

  public:
    int Row;
    int Col;
      TTT_Move(int GivenRow,int GivenCol){
        Row = GivenRow;
        Col = GivenCol;
      }
      virtual ~TTT_Move(){}
};
template <typename T>
T* get(std::list<T*> _list, int _i){
    typename std::list<T*>::iterator it = _list.begin();
    for(int i=0; i<_i; i++){
        ++it;
    }
    return *it;
}

struct TTT_Player : public Player
{
  public:
    int PlayerNumber;
    char GameRepresentation;
    bool HumanPlayer;
    TTT_Player(){}
   TTT_Player(int GivenPlayer,char GivenGameRepresentation){
    PlayerNumber = GivenPlayer;
    GameRepresentation = GivenGameRepresentation;
  }
  ~TTT_Player(){}
   TTT_Move* MakeMove(TTT* GivenGame);
};

TTT_Move* TTT_Player::MakeMove(TTT* GivenGame)
{
   //GameMove TTTPlayer = static_cast<GameMove>(TTT_Move(0,0));

   int X,Y;
   std::cout << "Please Enter X Axis: ";
   std::cin >> X;
   std::cout << "Please Enter Y Axis: ";
   std::cin >> Y;
   TTT_Move* TTTMove = new TTT_Move(X,Y);
   //GameMove* Move = static_cast<GameMove*>(TTTMove);

   return TTTMove;
}

void Free_TTTMoveList(std::list<TTT_Move*> GameMoves)
{
  //std::list<GameMove*> Moves = PossibleMoves();
  for (TTT_Move* GMove : GameMoves) { // c++11 range-based for loop
      //TTT_Move* Move = static_cast<TTT_Move*>(GMove);
      delete GMove;
    }
}


/*
TTT(Tic Tac Toe):
Implement Tic Tac Toe through Game interface. Using standard rules.

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
class TTT : public Game
{
protected:


public:
  /*
  Please note the following:
  Currentplayer = Players.front();
  */
  /*
  TTT_Player Player0 = TTT_Player(0,'X');
  TTT_Player Player1 = TTT_Player(1,'O');
  TTT(){
    Pause
      this->DeclarePlayers({&Player0,&Player1});
      this->DrawPlayer     = static_cast<Player*>(&Draw);
      this->WinningPlayer  = NULL;

      MovesRemaining       = 9;
      this->SetUpBoard();
    }
  */
  TTT_Player Draw    = TTT_Player(-1,'C');


  //std::list<Player*> _Players;
  std::list<TTT_Player*> Players;
  Player*  WinningPlayer = NULL;

  int MovesRemaining;
  char Board[3][3];
  TTT(){
    printf("Calling Default Constructor... \n");
    //throw "Calling Default Constructor... \n";
  }

    TTT(std::list<Player*> GivenPlayers){
        this->DeclarePlayers(GivenPlayers);

        this->WinningPlayer  = NULL;
        MovesRemaining       = 9;
        this->SetUpBoard();
      }
    virtual ~TTT(){
    }
    Player* GetWinner();
    void DisplayWinner();
    void DeclarePlayers(std::list<Player*> GivenPlayers);
    void SetUpBoard();
    TTT* CopyGame();
    void RotatePlayers();
    bool Move(GameMove* Move);

    bool ValidMove(GameMove* Move);
    Player* TestForWinner();

    std::list<TTT_Move*> PossibleMoves();
    std::list<TTT*>     PossibleGames();
    std::string Generate_StringRepresentation();

    Player* DeclareWinner(Player* Winner);
    char GetWinnersCharacter();
    //void DisplayInTerminal();
    TTT* RollOut();
    void PlayGame();
};



void TTT::SetUpBoard()
{
  for (int Row = 0; Row < 3; Row++)
  {
    for (int Col = 0; Col < 3; Col++)
    {
        Board[Row][Col] = ' ';
    }
  }
  for (Player* Player : Players) { // c++11 range-based for loop
      ;
      printf("Player:%p:%c\n",Player,static_cast<TTT_Player*>(Player)->GameRepresentation);
    }
}



void TTT::DeclarePlayers(std::list<Player*> GivenPlayers)
{
  printf("Adding Players\n");
  for (Player* i : GivenPlayers) { // c++11 range-based for loop
      TTT_Player* TTTPlayer = static_cast<TTT_Player*>(i);
      Players.push_back(TTTPlayer);
      _Players.push_back(i);
    }
}


void TTT::RotatePlayers(){
  Players.splice(Players.end(),        // destination position
                 Players,              // source list
                 Players.begin());     // source position
 _Players.splice(_Players.end(),        // destination position
                _Players,              // source list
                _Players.begin());     // source position
};

bool TTT::ValidMove(GameMove* Move)
{
  //printf("TTT MovesRemaining:%d\n",MovesRemaining);
  if(MovesRemaining == 0 ){
    DeclareWinner(&Draw);
    return false;
  }

  TTT_Move* TTTMove = static_cast<TTT_Move*>(Move);

  //printf("TTTMove->Row:%d\n",TTTMove->Row);
  //printf("TTTMove->Col:%d\n",TTTMove->Col);
  //printf("Board[TTTMove->Row][TTTMove->Col]:%c\n",Board[TTTMove->Row][TTTMove->Col]);
  if (Board[TTTMove->Row][TTTMove->Col] == ' ')
  {
    //Valid Move
    //printf("TTT Valid Move\n");
    return true;
  }
  else
  {
    //Invalid Move
    //printf("TTT InValid Move\n");
    return false;
  }
}


bool TTT::Move(GameMove* Move)
{
  TTT_Move* TTTMove = static_cast<TTT_Move*>(Move);

  if (this->ValidMove(Move))
  {
    MovesRemaining--;

    // move first element to the end
    Board[TTTMove->Row][TTTMove->Col] = Players.front()->GameRepresentation;
    TestForWinner();
    RotatePlayers();
    return true;
  }
  return false;
}

void TTT::DisplayWinner(){
  printf("WinningPlayer:%p\n",WinningPlayer);
  if(this->WinningPlayer != NULL){
    TTT_Player* TTTPlayer = static_cast<TTT_Player*>(WinningPlayer);
    printf("Player %c Has won!",TTTPlayer->GameRepresentation);
  }

};


std::string TTT::Generate_StringRepresentation()
{

  std::string Game = "Winner: ";

  if (WinningPlayer != NULL){
    //Convert from Generic Player to TTT_Player Structure
    TTT_Player* TTTPlayer = static_cast<TTT_Player*>(WinningPlayer);

    Game += (TTTPlayer->GameRepresentation); //Use '+=' when appending a char
  }
  else{
    Game.append("C");
  }

  Game.append("\n");
  for (int Row = 0; Row < 3; Row++)
  {
    for (int Col = 0; Col < 3; Col++)
    {
        char position = Board[Row][Col];
        Game.append(&position);
        Game.append("|");
    }
    Game.append("\n--------\n");
  }
  return Game;
}

Player* TTT::DeclareWinner(Player* GivenWinner)
{
  if(WinningPlayer == NULL){
    //Player* Winner = static_cast<Player*>(GivenWinner);
    WinningPlayer=GivenWinner;
    //std::cout << this->Generate_StringRepresentation();
    //printf("WinningPlayer:%p\n",WinningPlayer);

  }
  return GetWinner();
}


char TTT::GetWinnersCharacter()
{
  Player* Winner = TestForWinner();
  if(Winner != NULL)
  {
  return static_cast<TTT_Player*>(TestForWinner())->GameRepresentation;
  }
  else{
    return ' ';
  }
}


Player* TTT::GetWinner(){
  return static_cast<Player*>(WinningPlayer);
};

// Returns True/False If Winner is found
Player* TTT::TestForWinner()
{
  if(
    WinningPlayer == &Draw ||
    WinningPlayer != NULL
  ){
    return WinningPlayer;
  }

  for (int Row_Col = 0; Row_Col < 3; Row_Col++)
  {
    if(
      Board[Row_Col][0] == Board[Row_Col][1] &&
      Board[Row_Col][0] == Board[Row_Col][2] &&
      Board[Row_Col][0] != ' '
    )
    {
      /*
      Winning Row Method Found. Example:
      X|X|X|
      --------
       | | |
      --------
       | | |
      */

      return this->DeclareWinner(Players.front());

    }
    else if(
      Board[0][Row_Col] == Board[1][Row_Col] &&
      Board[0][Row_Col] == Board[2][Row_Col] &&
      Board[0][Row_Col] != ' '
    )
    {
      /*
      Winning Column Method Found. Example:
      X| | |
      --------
      X| | |
      --------
      X| | |
      */
      return this->DeclareWinner(Players.front());

    }
  }


  if(
    Board[0][0] == Board[1][1] &&
    Board[0][0] == Board[2][2] &&
    Board[0][0] != ' '
  )
  {
/*
Winning Diagonal Method Found. Example:
  X| | |
  --------
   |X| |
  --------
   | |X|
  */
      return this->DeclareWinner(Players.front());

  }
  else if(
    Board[0][2] == Board[1][1] &&
    Board[0][2] == Board[2][0] &&
    Board[0][2] != ' '
  )
  {
/*
Winning Diagonal Method Found. Example:
   | |X|
  --------
   |X| |
  --------
  X| | |
  */
      return this->DeclareWinner(Players.front());
  }

  if(this->MovesRemaining == 0){
    WinningPlayer = &Draw;
    return WinningPlayer;
  }
  return WinningPlayer;
}


std::list<TTT_Move*> TTT::PossibleMoves()
{
  std::list<TTT_Move*>Moves;

  //GameMove TTTPlayer = static_cast<GameMove>(TTT_Move(0,0));
  for (int Row = 0; Row < 3; Row++)
  {
    for (int Col = 0; Col < 3; Col++)
    {
        if (Board[Row][Col] == ' ')
        {
          TTT_Move* TTTMove = new TTT_Move(Row,Col);
          //GameMove* Move = static_cast<GameMove*>(TTTMove);
          Moves.push_back(TTTMove);
        }
    }
  }
  return Moves;
}

std::list<TTT*> TTT::PossibleGames()
{
  std::list<TTT_Move*> Moves = PossibleMoves();
  std::list<TTT*>Games;
  TTT* Branch;
  for (TTT_Move* GMove : Moves) { // c++11 range-based for loop
       Branch = new TTT(*this);
       Branch->Move(GMove);
       Games.push_back(Branch);
       //Free each Move Structure
       printf("%p\n",&(Branch));
       printf("Create Instance->Players:%p\n",(Branch->_Players));
       printf("PossibleGames's Players:%p\n",&(Branch->_Players));
       for (Player* _Pl : Branch->_Players){
             printf("\t:%p\n",(_Pl));
       }
       delete GMove;
    }
  //printf("Freeing Moves list \n");
  //delete &Moves;
  return Games;
}


TTT* TTT::CopyGame(){
  return (new TTT(*this));
}






TTT* TTT::RollOut(){
  GameMove* Move;
  int Range;

  //TTT_Player* TTTPlayer = static_cast<TTT_Player*>(TestForWinner());
  while(WinningPlayer == NULL){

    //TTTPlayer = static_cast<TTT_Player*>(TestForWinner());
    std::list<TTT_Move*>GameMoves = PossibleMoves();
    Range = GameMoves.size();
    //printf("Range:%d\n",Range);
    Move          = get(GameMoves,(rand() % (Range)));
    this->Move(Move);
    //printf("Freeing memory\n");
    Free_TTTMoveList(GameMoves);
    //delete &GameMoves;
    //delete Move;

    //std::cout << this->Generate_StringRepresentation();
    //TTTPlayer = static_cast<TTT_Player*>(TestForWinner());
  }
  //printf("WinningPlayer:%p\n",WinningPlayer);
  return this;
}

void TTT::PlayGame()
{
  GameMove* Move;
  TTT_Player* Currentplayer;

  TTT_Player* TTTPlayer = static_cast<TTT_Player*>(TestForWinner());
  while(TTTPlayer == NULL){
    Currentplayer = Players.front();

    Move          = (*Currentplayer).MakeMove(this);
    this->Move(Move);
    delete Move;

    std::cout << this->Generate_StringRepresentation();
    TTTPlayer = static_cast<TTT_Player*>(TestForWinner());
  }
}

#endif //TTT_CU
