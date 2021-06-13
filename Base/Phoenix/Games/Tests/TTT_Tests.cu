#ifndef TTT_Tests_CU
#define TTT_Tests_CU

#include "../SRC/TTT.cu"



int main() {
 //std::cout << "Hello World!";
 Game *f = new TTT();
 f->PlayAsHuman();

 std::cout << f->GenerateStringRepresentation();

 GameMove *GM = new TTT_Move(0,0);
 f->Move(GM);
 std::cout << f->GenerateStringRepresentation();
 delete GM;

 GM = new TTT_Move(0,1);
 f->Move(GM);
 std::cout << f->GenerateStringRepresentation();
 delete GM;

 GM = new TTT_Move(0,2);
 f->Move(GM);
 std::cout << f->GenerateStringRepresentation();
 delete GM;


 f->TestForWinner();
 delete f;
 return 0;
}

#endif //TTT_Tests_CU

/*


 */
