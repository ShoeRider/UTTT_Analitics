#ifndef TTT_Tests_CU
#define TTT_Tests_CU

#include "../SRC/TTT.cu"

#include <list>
/*
Game *f = new TTT();

  GM = new TTT_Move(2,2);
  f->Move(GM);
  std::cout << f->GenerateStringRepresentation();
  delete GM;



f->DisplayWinner();
*/


/*
std::list<GameMove*>GameMoves = f->PossibleMoves();
Free_TTTList(GameMoves);
*/

int main() {
 //std::cout << "Hello World!";
 Game *f = new TTT();
 //f->PlayGame();
 f->RollOut();


 /*
 GameMove* GM = new TTT_Move(2,2);
 f->Move(GM);
 std::cout << f->GenerateStringRepresentation();
 delete GM;
 */

//RollOut()

 Player* Winner = f->TestForWinner();
 f->DisplayWinner();

 delete f;
 return 0;
}

#endif //TTT_Tests_CU

/*


 */
