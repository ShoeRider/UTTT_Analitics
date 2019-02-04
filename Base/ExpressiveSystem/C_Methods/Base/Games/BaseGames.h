#ifndef BaseGames_H
#define BaseGames_H

#include "../Base.h"

typedef struct Game
{
  void* GameData;
  //RunTimeFunction InitializeGame;
  RunTimeFunction FreeGame;

  RunTimeFunction Player0;
  RunTimeFunction Player1;
  int Winner;

  RunTimeFunction PossibleMoves0;
  RunTimeFunction PossibleMoves1;

  void* Board0; //DataStructure from Player0 position
  void* Board1; //DataStructure from Player1 position

} Game_t;




#endif //BaseGames_H
