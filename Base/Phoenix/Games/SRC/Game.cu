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

#include <list>
#include "Game.h"

//Game Move interface. Used as a place holder for child classes holding
//   game move data.
struct GameMove
{
  public:
      GameMove(){}
      virtual ~GameMove()= default;
};


GameMove* get(std::list<GameMove*> _list, int _i){
    std::list<GameMove*>::iterator it = _list.begin();
    for(int i=0; i<_i; i++){
        ++it;
    }
    return *it;
}


//Player interface. Used as a place holder for child classes holding
//   game Player data.
struct Player
{
  public:
    int PlayerNumber;
    void (*ExternalSimulation)();
    bool HumanPlayer;
    Player(){}
    virtual GameMove* MakeMove(Game* GivenGame)=0;
    virtual ~Player(){};

};


class Game
{
private:

protected:

  public:
      std::list<Player*> Players;
      Player*  WinningPlayer = NULL;
      Player*  DrawPlayer    = NULL;
      Game(){}
      virtual ~Game(){}

        //The following Methods use the 'Pure Virtual Function' method,
        //  where "= 0" part makes this method pure virtual,
        //  and also makes this class abstract.

      //virtual bool ValidMove(int Row,int Col) = 0;
      virtual std::list<GameMove*> PossibleMoves() = 0;
      virtual std::list<Game*> PossibleGames()     = 0;
      virtual bool ValidMove(GameMove* Move)       = 0;
      virtual bool Move(GameMove* Move)            = 0;
      virtual Game* CopyGame()                     = 0;
      //virtual void AvaliableMoves(int Depth) = 0;

      virtual std::string Generate_StringRepresentation() = 0;

      //virtual void DisplayInTerminal(int Depth) = 0;
      //virtual void ConfigurePlayers()   = 0;
      //virtual std::string GameHash()        = 0;
      virtual void PlayGame()           = 0;
      virtual Player* TestForWinner()   = 0;
      //virtual std::string DeclareWinner(int Player) = 0;
      //virtual void StepSimulation() = 0;
      //virtual void CopySimulation() = 0;
      //virtual void SaveSimulation() = 0;
      //virtual void ReadSimulation() = 0;
      virtual Game* RollOut()            = 0;
      virtual void DisplayWinner()            = 0;

      virtual void DeclarePlayers(std::list<Player*> GivenPlayers) {
        for (Player* i : GivenPlayers) { // c++11 range-based for loop
            //printf("%p\n",i);
            Players.push_back(i);
          }
      };

};

Game* get(std::list<Game*> _list, int _i){
    std::list<Game*>::iterator it = _list.begin();
    for(int i=0; i<_i; i++){
        ++it;
    }
    return *it;
}


#endif //GAME_CU
