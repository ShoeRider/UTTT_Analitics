/*
Anthony M Schroeder


Purpose:
Create a Game interface in order to implement and integrate different games
easily.

Using a method called: Pure Virtual Functions.

*/
#ifndef GAME_CU
#define GAME_CU

#include <string>
#include <iostream>
#include <memory>


//Game Move interface. Used as a place holder for child classes holding
//   game move data.
struct GameMove
{
  public:
      GameMove(){}
      virtual ~GameMove()= default;
};

//Player interface. Used as a place holder for child classes holding
//   game Player data.
struct Player
{
  public:
  int PlayerNumber;
  char GameRepresentation;
  Player(int GivenPlayer,char GivenGameRepresentation){
    PlayerNumber = GivenPlayer;
    GameRepresentation = GivenGameRepresentation;
  }
  ~Player(){}
};


class Game
{
private:

protected:

  public:
      Game(){}
      ~Game(){}

        //The following Methods use the 'Pure Virtual Function' method,
        //  where "= 0" part makes this method pure virtual,
        //  and also makes this class abstract.

      //virtual bool ValidMove(int Row,int Col) = 0;
      //virtual bool PossibleMoves()                = 0;
      virtual bool ValidMove(GameMove* Move)      = 0;
      virtual bool Move(GameMove* Move)           = 0;
      //virtual void AvaliableMoves(int Depth) = 0;

      //Use: unique_ptr<Game>
      //#include <memory>
      //When instantiating a unique pointer to avoid a dangling pointer:
      //use: "make_unique", this removes the possibility for exception safety.
      //std::unique_ptr<Game> = std::make_unique<Game>()
      //virtual std::unique_ptr<Game> CopyGame()        = 0;

      //When instantiating a unique pointer to avoid a dangling pointer:
      //use: "make_unique", this removes the possibility for exception safety.
      //std::shared_ptr<Game> = std::make_shared<Game>()
      //virtual std::shared_ptr<Game> CopyGame()        = 0;
      virtual std::string GenerateStringRepresentation() = 0;

      //virtual void DisplayInTerminal(int Depth) = 0;
      //virtual void ConfigurePlayers()   = 0;
      //virtual std::string GameHash()        = 0;
      virtual void PlayAsHuman()        = 0;
      virtual Player* TestForWinner()   = 0;
      //virtual std::string DeclareWinner(int Player) = 0;
      //virtual void StepSimulation() = 0;
      //virtual void CopySimulation() = 0;
      //virtual void SaveSimulation() = 0;
      //virtual void ReadSimulation() = 0;
      virtual void RollOut()            = 0;
};


#endif //GAME_CU
