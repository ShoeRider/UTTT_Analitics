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
  TTT_Player(int GivenPlayer,char GivenGameRepresentation){
    PlayerNumber = GivenPlayer;
    GameRepresentation = GivenGameRepresentation;
  }
  ~TTT_Player(){}
};


class TTT : public Game
{
protected:


public:
  TTT_Player Draw    = TTT_Player(-1,'C');
  TTT_Player Player0 = TTT_Player(0,'X');
  TTT_Player Player1 = TTT_Player(1,'Y');

  std::list<TTT_Player*> Players;

  TTT_Player*  CurrentPlayer;
  TTT_Player*  WinningPlayer;

  int MovesRemaining;
  char Board[3][3];

  TTT(){
      this->DeclarePlayers({&Player0,&Player1});

      //Players.push_back(Player0);
      //Players.push_back(Player1);

      //Declares the winner:
      //-2   - Cats Game
      //-1   - No Winner
      //1,2 - Player 1 or 2
      this->WinningPlayer  = NULL;

      this->CurrentPlayer  = Players.front();


      //Player         = 1;
      //Players = 2;
      MovesRemaining = 9;
      this->SetUpBoard();
    }

    ~TTT(){
    }
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
    void PlayAsHuman();
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
    //CurrentPlayer  = Players.front();

    // move first element to the end
    Board[TTTMove->Row][TTTMove->Col] = Player0.GameRepresentation;
    //Board[0][0] = CurrentPlayer->GameRepresentation;


    Players.splice(Players.end(),        // destination position
                   Players,              // source list
                   Players.begin());     // source position
    //CurrentPlayer  = Players.front();

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
  return static_cast<Player*>(WinningPlayer);
}

// Returns True/False If Winner is found
Player* TTT::TestForWinner()
{
  if(
    WinningPlayer == NULL ||
    WinningPlayer == &Draw
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

      this->DeclareWinner(Players.front());

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
      this->DeclareWinner(Players.front());

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
      this->DeclareWinner(Players.front());

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
      this->DeclareWinner(Players.front());
  }

  return WinningPlayer;
}



void TTT::RollOut()
{

}

void TTT::PlayAsHuman()
{

}

#endif //TTT_CU
