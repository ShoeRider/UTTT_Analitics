#ifndef TTT_CU
#define TTT_CU


#include <iostream>
#include <string>

#include "Game.cu"

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
    bool Move(int Row,int Col);

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
bool TTT::Move(int Row,int Col)
{
  char PlayerMove;
  switch(Player) {
    case 1:
      PlayerMove = 'X';
      break;
    case 2:
      PlayerMove = 'O';
      break;
  }
  
  if (Board[Row][Col] != ' ')
  {
    Board[Row][Col] = PlayerMove;
    return true;
  }
  else
  {
    return false;
  }

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



void TTT::RollOut()
{

}

void TTT::PlayAsHuman()
{

}

#endif //TTT_CU
