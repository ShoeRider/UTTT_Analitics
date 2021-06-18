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
 TTT_Player Player0 = TTT_Player(0,'X');
 TTT_Player Player1 = TTT_Player(1,'Y');
 Game *_Game = new TTT({&Player0,&Player1});
 //f->PlayGame();
 _Game->RollOut();


 /*
 GameMove* GM = new TTT_Move(2,2);
 f->Move(GM);
 std::cout << f->GenerateStringRepresentation();
 delete GM;
 */

//RollOut()

 Player* Winner = _Game->TestForWinner();
 _Game->DisplayWinner();

 delete _Game;
 return 0;
}

#endif //TTT_Tests_CU

/*


 */
