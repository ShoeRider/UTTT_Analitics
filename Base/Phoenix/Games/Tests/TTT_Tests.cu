#ifndef TTT_Tests_CU
#define TTT_Tests_CU

#include "../SRC/TTT.cu"

/*
Game *f = new TTT();

  GM = new TTT_Move(2,2);
  f->Move(GM);
  std::cout << f->GenerateStringRepresentation();
  delete GM;



f->DisplayWinner();
*/

int main() {
 //std::cout << "Hello World!";
 Game *f = new TTT();
 f->PlayGame();



 Player* Winner = f->TestForWinner();
 f->DisplayWinner();

 delete f;
 return 0;
}

#endif //TTT_Tests_CU

/*


 */
