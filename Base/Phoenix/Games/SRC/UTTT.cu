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



#include "TTT.cu"
#include "Game.cu"



/*

*/


struct UTTT_Move : public GameMove
{

  public:
    int Row;
    int Col;
    char Player;

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

class UTTT_SubGame : public TTT
{
  public:
    bool Move(GameMove* Move);
    std::string DeclareWinner(char WinningPlayer);
};

std::string UTTT_SubGame::DeclareWinner(char WinningPlayer)
{
  if(WinningPlayer != -1){
    return std::to_string(WinningPlayer);
  }

  switch(WinningPlayer){
    case 'X':
      Player = 1;
      break;
    case 'O':
      Player = 2;
      break;
  }

  return this->DeclareWinner(Player);
}

bool UTTT_SubGame::Move(GameMove* Move)
{


  if (this->ValidMove(Move))
  {
    UTTT_Move* TTTMove = dynamic_cast<UTTT_Move*>(Move);
    Board[TTTMove->Row][TTTMove->Col] = TTTMove->Player;
    return true;
  }
  return false;
}













class UTTT : public Game
{



public:

  int Player;
  int Players;
  int Winner;
  int MovesRemaining;

  int NextMove_Row;
  int NextMove_Col;
  TTT Boards[3][3];

    UTTT(){
      //Declares the winner:
      //0   - No Winner
      //1,2 - Player 1 or 2
      //3   - Cats Game
      Winner  = 0;
      Player  = 1;
      //Players = 2;
      NextMove_Row = -1;
      NextMove_Col = -1;
      MovesRemaining = 81;
      this->SetUpBoards();
    }
    ~UTTT(){
      this->FreeBoards();
    }

    void SetUpBoards();
    void FreeBoards();

    bool Move(GameMove* Move);
    //bool ValidMove(int Row,int Col);
    bool ValidMove(GameMove* Move);
    bool TestForWinner();

    bool PossibleMoves();
    std::string GenerateStringRepresentation();
    std::string DeclareWinner(int Player);
    std::string DeclareWinner(char PlayerMove);
    //void DisplayInTerminal();
    void RollOut();
    void PlayAsHuman();
};


void UTTT::SetUpBoards()
{

}

void UTTT::FreeBoards()
{

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
  char PlayerCharacter;
  switch(Player) {
    case 1:
      PlayerCharacter = 'X';
      Player = 2; //Swap to player 2 for next move.
      break;
    case 2:
      PlayerCharacter = 'O';
      Player = 1; //Swap to player 1 for next move.
      break;
  }

  if (this->ValidMove(Move))
  {
    UTTT_Move* UTTTMove = dynamic_cast<UTTT_Move*>(Move);
    UTTTMove->Player = PlayerCharacter;
    return Boards[UTTTMove->Row][UTTTMove->Col].Move(Move);
  }
  return false;
}




std::string UTTT::GenerateStringRepresentation()
{
  std::string Game = "";

  return Game;
}


std::string UTTT::DeclareWinner(int Player)
{
  std::string WinnerText = "\nPlayer:" + std::to_string(Player) + " Has Won!\n";
  return WinnerText;
}

std::string UTTT::DeclareWinner(char WinningPlayer)
{
  switch(WinningPlayer){
    case 'X':
      Player = 1;
      break;
    case 'O':
      Player = 2;
      break;
  }

  return this->DeclareWinner(Player);
}

// Provide implementation for the first method
bool UTTT::TestForWinner()
{
  for (int Row_Col = 0; Row_Col < 3; Row_Col++)
  {
    if(
      Boards[Row_Col][0].Winner == Boards[Row_Col][1].Winner &&
      Boards[Row_Col][0].Winner == Boards[Row_Col][2].Winner &&
      Boards[Row_Col][0].Winner != ' '
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
      this->DeclareWinner(Boards[Row_Col][0].Winner);

    }
    else if(
      Boards[0][Row_Col].Winner == Boards[1][Row_Col].Winner &&
      Boards[0][Row_Col].Winner == Boards[2][Row_Col].Winner &&
      Boards[0][Row_Col].Winner != ' '
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
      this->DeclareWinner(Boards[0][Row_Col].Winner);

    }
  }


  if(
    Boards[0][0].Winner == Boards[1][1].Winner &&
    Boards[0][0].Winner == Boards[2][2].Winner &&
    Boards[0][0].Winner != ' '
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
  this->DeclareWinner(Boards[0][0].Winner);

  }
  else if(
    Boards[0][2].Winner == Boards[1][1].Winner &&
    Boards[0][2].Winner == Boards[2][0].Winner &&
    Boards[0][2].Winner != ' '
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
  this->DeclareWinner(Boards[0][2].Winner);
  }

  return false;
}



void UTTT::RollOut()
{

}

void UTTT::PlayAsHuman()
{

}

#endif //UTTT_CU
