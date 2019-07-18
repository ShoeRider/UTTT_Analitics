#ifndef TickTackToe_H
#define TickTackToe_H

#include "../../Matrix/Matrix.h"
#include "../../DoublyLinkedList/DoublyLinkedList.h"

typedef struct TTT_t
{
  IMatrix_t* Board;
  //Let :
  //0: represent an empty square
  //1: represent an X
  //2: represent an O

  int Player;
  //1: represent an X
  //2: represent an O

  int Winner;
  //-1: represents no Winner/Game is still ongoing.
  //0: represents a tie
  //1: represent an X
  //2: represent an O

  int MovesMade;
} TTT_t;


MCHS__FL_t* Create_MCHS_TTT_FL();
TTT_t* Copy(TTT_t*TTT);
TTT_t* Create_TTT_t();
#endif //TickTackToe_H
