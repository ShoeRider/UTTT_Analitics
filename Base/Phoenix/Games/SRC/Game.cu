/*
Anthony M Schroeder


Purpose:
Create a Game interface in order to implement and integrate different games
easily.

Using a method called: Pure Virtual Functions.

*/

#include <string>
#include <iostream>

struct GameMove
{
  public:
      GameMove(){}
      virtual ~GameMove()= default;
};

class Game
{
private:

  public:
      Game(){}
      ~Game(){}

        //The following Methods use the 'Pure Virtual Function' method,
        //  where "= 0" part makes this method pure virtual,
        //  and also makes this class abstract.

        //** Not standardized ....
      //virtual bool ValidMove(int Row,int Col) = 0;
      virtual bool ValidMove(GameMove* Move)      = 0;
      virtual bool Move(GameMove* Move)           = 0;
      //virtual void AvaliableMoves(int Depth) = 0;

      virtual std::string GenerateStringRepresentation() = 0;

      //virtual void DisplayInTerminal(int Depth) = 0;
      virtual void PlayAsHuman()   = 0;
      virtual bool TestForWinner() = 0;
      //virtual void StepSimulation() = 0;
      //virtual void CopySimulation() = 0;
      //virtual void SaveSimulation() = 0;
      //virtual void ReadSimulation() = 0;
      //virtual void RollOut()        = 0;
};
