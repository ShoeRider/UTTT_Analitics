#ifndef UTTT_Tests_CU
#define UTTT_Tests_CU

#include "../SRC/TTT.cu"
#include "../SRC/UTTT.cu"


int main() {
 //std::cout << "Hello World!";
 Game *f = new UTTT();
 std::cout  << f->Generate_StringRepresentation();
 f->RollOut();
 /*
 GameMove *GM = new UTTT_Move(0,0,0,0);
 std::cout  << f->ValidMove(GM);
 delete GM;
 */

 delete f;
 return 0;
}

#endif //UTTT_Tests_CU
