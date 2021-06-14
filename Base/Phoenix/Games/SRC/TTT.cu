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
#include "Game.cu"

struct TTT_Move : public GameMove
{

  public:
  char Board[3][3];
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
  TTT_Player(int GivenPlayer,char GivenGameRepresentation){
    PlayerNumber = GivenPlayer;
    GameRepresentation = GivenGameRepresentation;
  }
  ~TTT_Player(){}
  GameMove* MakeMove();
};

GameMove* TTT_Player::MakeMove()
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



class TTT : public Game
{
protected:


public:
  TTT_Player Draw    = TTT_Player(-1,'C');
  TTT_Player Player0 = TTT_Player(0,'X');
  TTT_Player Player1 = TTT_Player(1,'Y');

  std::list<TTT_Player*> Players;
  TTT_Player*  WinningPlayer;

  int MovesRemaining;
  char Board[3][3];

  TTT(){
      this->DeclarePlayers({&Player0,&Player1});
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
    bool Move(GameMove* Move);
    //bool ValidMove(int Row,int Col);
    bool ValidMove(GameMove* Move);
    Player* TestForWinner();

    //bool PossibleMoves();
    std::string GenerateStringRepresentation();
    Player* DeclareWinner(TTT_Player* Winner);
    //void DisplayInTerminal();
    void RollOut();
    void PlayGame();
};


// Provide implementation for the first method
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

// Provide implementation for the first method

void TTT::DeclarePlayers(std::list<Player*> GivenPlayers)
{

  for (Player* i : GivenPlayers) { // c++11 range-based for loop
      TTT_Player* TTTPlayer = static_cast<TTT_Player*>(i);
      Players.push_back(TTTPlayer);
    }
}


// Provide implementation for the first method
bool TTT::ValidMove(GameMove* Move)
{
  if(MovesRemaining == 0 ){
    DeclareWinner(&Draw);
    return false;
  }

  TTT_Move* TTTMove = static_cast<TTT_Move*>(Move);

  if (Board[TTTMove->Row][TTTMove->Col] == ' ')
  {
    //Valid Move
    return true;
  }
  else
  {
    //Invalid Move
    return false;
  }
}

// Provide implementation for the first method
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




std::string TTT::GenerateStringRepresentation()
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


Player* TTT::DeclareWinner(TTT_Player* GivenWinner)
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

  return WinningPlayer;
}



void TTT::RollOut()
{

}

void TTT::PlayGame()
{
  Player* Currentplayer = Players.front();
  GameMove* Move         = (*Currentplayer).MakeMove();
  this->Move(Move);
  delete Move;
  
  std::cout << this->GenerateStringRepresentation();
  while(false){


  }
}

#endif //TTT_CU
