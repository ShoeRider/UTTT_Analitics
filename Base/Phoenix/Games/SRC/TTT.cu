#ifndef TTT_CU
#define TTT_CU


#include <iostream>
#include <string>

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


class TTT : public Game
{
private:
  int Player;
  int Players;
  int Winner;
  int MovesRemaining;
  char Board[3][3];

public:
    TTT(){
      //Declares the winner:
      //0   - No Winner
      //1,2 - Player 1 or 2
      //3   - Cats Game
      Winner  = 0;
      Player  = 1;
      //Players = 2;
      MovesRemaining = 9;
      this->SetUpBoard();
    }
    ~TTT(){}
    void SetUpBoard();
    bool Move(GameMove* Move);
    //bool ValidMove(int Row,int Col);
    bool ValidMove(GameMove* Move);
    bool TestForWinner();

    std::string GenerateStringRepresentation();
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
bool TTT::ValidMove(GameMove* Move)
{
  TTT_Move* TTTMove = dynamic_cast<TTT_Move*>(Move);

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
  char PlayerMove;
  switch(Player) {
    case 1:
      PlayerMove = 'X';
      Player = 2;
      break;
    case 2:
      PlayerMove = 'O';
      Player = 1;
      break;
  }

  if (this->ValidMove(Move))
  {
    TTT_Move* TTTMove = dynamic_cast<TTT_Move*>(Move);
    Board[TTTMove->Row][TTTMove->Col] = PlayerMove;
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

// Provide implementation for the first method
bool TTT::TestForWinner()
{
  return false;
}

void TTT::RollOut()
{

}

void TTT::PlayAsHuman()
{

}

#endif //TTT_CU
