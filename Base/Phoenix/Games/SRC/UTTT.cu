/*
Anthony M Schroeder


Purpose:
Implement Ultimate Tic Tac Toe through Game interface. Using rules To be
described...


*/
#ifndef UTTT_CU
#define UTTT_CU


#include <iostream>
#include <string>
#include <list>


#include "Game.cu"
#include "TTT.cu"



/*

*/
struct UTTT_Player : public TTT_Player
{
  public:
    int PlayerNumber;
    char GameRepresentation;
    //UTTT_Player(){}
  UTTT_Player(int GivenPlayer,char GivenGameRepresentation){
    PlayerNumber = GivenPlayer;
    GameRepresentation = GivenGameRepresentation;
  }
  ~UTTT_Player(){}
  GameMove* MakeMove();
};



struct UTTT_Move : public GameMove
{

  public:
    int Row;
    int Col;
    UTTT_Player* Player;

    int SubRow;
    int SubCol;
    UTTT_Move(
      int GivenRow,
      int GivenCol,
      int GivenSubRow,
      int GivenSubCol
      ){
          Row = GivenRow;
          Col = GivenCol;
          SubRow = GivenSubRow;
          SubCol = GivenSubCol;
      }
      ~UTTT_Move(){}
};

GameMove* UTTT_Player::MakeMove()
{
  //GameMove TTTPlayer = static_cast<GameMove>(TTT_Move(0,0));
  int Row,Col,SubRow,SubCol;
  std::cout << "Please Enter Row: ";
  std::cin >> Row;
  std::cout << "Please Enter Col Axis: ";
  std::cin >> Col;
  std::cout << "Please Enter SubRow Axis: ";
  std::cin >> SubRow;
  std::cout << "Please Enter SubCol: ";
  std::cin >> SubCol;
   UTTT_Move* UTTTMove = new UTTT_Move(Row,Col,SubRow,SubCol);
   GameMove* Move = static_cast<GameMove*>(UTTTMove);

   return Move;
}


class UTTT_SubGame : public TTT
{
  public:
    bool Move(GameMove* Move);
    Player* DeclareWinner(UTTT_Player* GivenWinner);
};

/*
Player* UTTT_SubGame::DeclareWinner(UTTT_Player* GivenWinner)
{
  if(WinningPlayer == NULL){
    //Player* Winner = static_cast<Player*>(GivenWinner);
    WinningPlayer=GivenWinner;
  }
  return static_cast<Player*>(WinningPlayer);
}
*/

bool UTTT_SubGame::Move(GameMove* Move)
{


  if (this->ValidMove(Move))
  {
    UTTT_Move* UTTTMove = dynamic_cast<UTTT_Move*>(Move);
    Board[UTTTMove->SubRow][UTTTMove->SubCol] = UTTTMove->Player->GameRepresentation;
    return true;
  }
  return false;
}













class UTTT : public Game
{



public:

  UTTT_Player Draw    = UTTT_Player(-1,'C');
  UTTT_Player Player0 = UTTT_Player(0,'X');
  UTTT_Player Player1 = UTTT_Player(1,'Y');

  std::list<UTTT_Player*> Players;


  UTTT_Player*  WinningPlayer;


  int NextMove_Row;
  int NextMove_Col;
  TTT Boards[3][3];
  int MovesRemaining;

  UTTT(){
      this->DeclarePlayers({&Player0,&Player1});
      this->WinningPlayer  = NULL;

      NextMove_Row   = -1;
      NextMove_Col   = -1;
      MovesRemaining = 81;
      this->SetUpBoards();
    }
    ~UTTT(){
      this->FreeBoards();
    }

    void SetUpBoards();
    void FreeBoards();

    bool Move(GameMove* Move);

    bool ValidMove(GameMove* Move);
    Player* TestForWinner();
    void DisplayWinner();
    bool PossibleMoves();
    std::string GenerateStringRepresentation();

    //void DisplayInTerminal();
    void RollOut();
    void PlayGame();
    void DeclarePlayers(std::list<Player*> GivenPlayers);
    void SetUpBoard();
    Player* DeclareWinner(UTTT_Player* Winner);

};


void UTTT::SetUpBoards()
{

}

void UTTT::FreeBoards()
{

}

void UTTT::DeclarePlayers(std::list<Player*> GivenPlayers)
{

  for (Player* i : GivenPlayers) { // c++11 range-based for loop
      UTTT_Player* UTTTPlayer = static_cast<UTTT_Player*>(i);
      Players.push_back(UTTTPlayer);
    }
}


// Provide implementation for the first method
bool UTTT::ValidMove(GameMove* Move)
{
  UTTT_Move* UTTTMove = dynamic_cast<UTTT_Move*>(Move);
  if(
    NextMove_Row != -1 ||
    NextMove_Col != -1
  ){
    return Boards[UTTTMove->Row][UTTTMove->Col].ValidMove(UTTTMove);
  }

  if(
    UTTTMove->Row == NextMove_Row &&
    UTTTMove->Col == NextMove_Col
  ){
    return Boards[UTTTMove->Row][UTTTMove->Col].ValidMove(UTTTMove);
  }

  return false;
}


// Provide implementation for the first method
bool UTTT::Move(GameMove* Move)
{
  UTTT_Move* UTTTMove = dynamic_cast<UTTT_Move*>(Move);
  UTTTMove->Player = Players.front();
  if (this->ValidMove(Move))
  {
    MovesRemaining--;

    // move first element to the end
    Boards[UTTTMove->Row][UTTTMove->Col].Move(Move);


    Players.splice(Players.end(),        // destination position
                   Players,              // source list
                   Players.begin());     // source position

    return true;
  }
  return false;
}
/*
if (this->ValidMove(Move))
{
  UTTT_Move* UTTTMove = dynamic_cast<UTTT_Move*>(Move);
  UTTTMove->Player = PlayerCharacter;
  return Boards[UTTTMove->Row][UTTTMove->Col].Move(Move);
}
return false;
*/



std::string UTTT::GenerateStringRepresentation()
{
  std::string Game = "";

  return Game;
}


Player* UTTT::DeclareWinner(UTTT_Player* GivenWinner)
{
  if(WinningPlayer == NULL){
    //Player* Winner = static_cast<Player*>(GivenWinner);
    WinningPlayer=GivenWinner;
  }
  return static_cast<Player*>(WinningPlayer);
}

void UTTT::DisplayWinner(){
  if(WinningPlayer!=NULL){
    printf("Player %d Has won!",WinningPlayer->PlayerNumber);
  }
};
// Provide implementation for the first method

Player* UTTT::TestForWinner()
{
  for (int Row_Col = 0; Row_Col < 3; Row_Col++)
  {
    if(
      Boards[Row_Col][0].WinningPlayer == Boards[Row_Col][1].WinningPlayer &&
      Boards[Row_Col][0].WinningPlayer == Boards[Row_Col][2].WinningPlayer &&
      Boards[Row_Col][0].WinningPlayer != NULL
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
      return static_cast<UTTT_Player*>(Boards[Row_Col][Row_Col].WinningPlayer);

    }
    else if(
      Boards[0][Row_Col].WinningPlayer == Boards[1][Row_Col].WinningPlayer &&
      Boards[0][Row_Col].WinningPlayer == Boards[2][Row_Col].WinningPlayer &&
      Boards[0][Row_Col].WinningPlayer != NULL
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
      return static_cast<UTTT_Player*>(Boards[0][Row_Col].WinningPlayer);
      //this->DeclareWinner(Boards[0][Row_Col].WinningPlayer);

    }
  }


  if(
    Boards[0][0].WinningPlayer == Boards[1][1].WinningPlayer &&
    Boards[0][0].WinningPlayer == Boards[2][2].WinningPlayer &&
    Boards[0][0].WinningPlayer != NULL
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
  return static_cast<UTTT_Player*>(Boards[0][0].WinningPlayer);

  }
  else if(
    Boards[0][2].WinningPlayer == Boards[1][1].WinningPlayer &&
    Boards[0][2].WinningPlayer == Boards[2][0].WinningPlayer &&
    Boards[0][2].WinningPlayer != NULL
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
  return static_cast<UTTT_Player*>(Boards[0][2].WinningPlayer);;
  }

  return WinningPlayer;
}



void UTTT::RollOut()
{

}

void UTTT::PlayGame()
{
  GameMove* Move;
  Player* Currentplayer;

  TTT_Player* TTTPlayer = static_cast<TTT_Player*>(TestForWinner());
  while(TTTPlayer == NULL){
    Currentplayer = Players.front();

    Move          = (*Currentplayer).MakeMove();
    this->Move(Move);
    delete Move;

    std::cout << this->GenerateStringRepresentation();
    TTTPlayer = static_cast<TTT_Player*>(TestForWinner());
  }
}

#endif //UTTT_CU
