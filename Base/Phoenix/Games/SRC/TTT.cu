 /*
Anthony M Schroeder


Purpose:
Implement Tic Tac Toe through Game interface. Using standard rules.


*/
#ifndef TTT_CU
#define TTT_CU


#include <iostream>
#include <string>
#include <list>
#include <cstdlib>

#include "Game.cu"

struct TTT_Move : public GameMove
{

  public:
    int Row;
    int Col;
      TTT_Move(int GivenRow,int GivenCol){
        Row = GivenRow;
        Col = GivenCol;
      }
      ~TTT_Move(){}
};

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
  virtual GameMove* MakeMove(Game* GivenGame);
};

GameMove* TTT_Player::MakeMove(Game* GivenGame)
{
   //GameMove TTTPlayer = static_cast<GameMove>(TTT_Move(0,0));

   int X,Y;
   std::cout << "Please Enter X Axis: ";
   std::cin >> X;
   std::cout << "Please Enter Y Axis: ";
   std::cin >> Y;
   TTT_Move* TTTMove = new TTT_Move(X,Y);
   GameMove* Move = static_cast<GameMove*>(TTTMove);

   return Move;
}

void Free_TTTMoveList(std::list<GameMove*> GameMoves)
{
  //std::list<GameMove*> Moves = PossibleMoves();
  for (GameMove* GMove : GameMoves) { // c++11 range-based for loop
      TTT_Move* Move = static_cast<TTT_Move*>(GMove);
      delete Move;
    }
}



class TTT : public Game
{
protected:


public:
  /*
  Please note the following:
  Currentplayer = Players.front();
  */
  TTT_Player Draw    = TTT_Player(-1,'C');
  TTT_Player Player0 = TTT_Player(0,'X');
  TTT_Player Player1 = TTT_Player(1,'Y');

  std::list<TTT_Player*> Players;
  Player*  WinningPlayer = NULL;

  int MovesRemaining;
  char Board[3][3];

  TTT(){
      this->DeclarePlayers({&Player0,&Player1});
      this->DrawPlayer     = static_cast<Player*>(&Draw);
      this->WinningPlayer  = NULL;

      MovesRemaining       = 9;
      this->SetUpBoard();
    }
    TTT(std::list<Player*> GivenPlayers){
        this->DeclarePlayers(GivenPlayers);

        this->WinningPlayer  = NULL;
        MovesRemaining       = 9;
        this->SetUpBoard();
      }
    ~TTT(){
    }
    Player* GetWinner();
    void DisplayWinner();
    void DeclarePlayers(std::list<Player*> GivenPlayers);
    void SetUpBoard();
    Game* CopyGame();
    bool Move(GameMove* Move);

    bool ValidMove(GameMove* Move);
    Player* TestForWinner();

    virtual std::list<GameMove*> PossibleMoves();
    virtual std::list<Game*>     PossibleGames();
    std::string Generate_StringRepresentation();
    Player* DeclareWinner(Player* Winner);
    //void DisplayInTerminal();
    Game* RollOut();
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
}



void TTT::DeclarePlayers(std::list<Player*> GivenPlayers)
{

  for (Player* i : GivenPlayers) { // c++11 range-based for loop
      TTT_Player* TTTPlayer = static_cast<TTT_Player*>(i);
      Players.push_back(TTTPlayer);
    }
}



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

    Players.splice(Players.end(),        // destination position
                   Players,              // source list
                   Players.begin());     // source position
    return true;
  }
  return false;
}




std::string TTT::Generate_StringRepresentation()
{
  std::string Game = "";
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
  }
  return GetWinner();
}

void TTT::DisplayWinner(){
  if(WinningPlayer!=NULL){
    printf("Player %d Has won!",WinningPlayer->PlayerNumber);
  }
};

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


std::list<GameMove*> TTT::PossibleMoves()
{
  std::list<GameMove*>Moves;

  //GameMove TTTPlayer = static_cast<GameMove>(TTT_Move(0,0));
  for (int Row = 0; Row < 3; Row++)
  {
    for (int Col = 0; Col < 3; Col++)
    {
        if (Board[Row][Col] == ' ')
        {
          TTT_Move* TTTMove = new TTT_Move(Row,Col);
          GameMove* Move = static_cast<GameMove*>(TTTMove);
          Moves.push_back(Move);
        }
    }
  }
  return Moves;
}

std::list<Game*> TTT::PossibleGames()
{
  std::list<GameMove*> Moves = PossibleMoves();
  std::list<Game*>Games;
  TTT* Branch;
  for (GameMove* GMove : Moves) { // c++11 range-based for loop
       Branch = new TTT(*this);
       Branch->Move(GMove);
       Games.push_back(Branch);
       //Free each Move Structure
       delete GMove;
    }
  //printf("Freeing Moves list \n");
  //delete &Moves;
  return Games;
}


Game* TTT::CopyGame(){
  return static_cast<Game*>(new TTT(*this));
}






Game* TTT::RollOut(){
  GameMove* Move;
  int Range;

  TTT_Player* TTTPlayer = static_cast<TTT_Player*>(TestForWinner());
  while(TTTPlayer == NULL){
    TTTPlayer = static_cast<TTT_Player*>(TestForWinner());
    std::list<GameMove*>GameMoves = PossibleMoves();
    Range = GameMoves.size();
    //printf("Range:%d\n",Range);
    Move          = get(GameMoves,(rand() % (Range)));
    this->Move(Move);
    //printf("Freeing memory\n");
    Free_TTTMoveList(GameMoves);
    //delete &GameMoves;
    //delete Move;

    //std::cout << this->Generate_StringRepresentation();
    TTTPlayer = static_cast<TTT_Player*>(TestForWinner());
  }
  return this;
}

void TTT::PlayGame()
{
  GameMove* Move;
  Player* Currentplayer;

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
