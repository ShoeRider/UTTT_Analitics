#ifndef TTT_Tests_CU
#define TTT_Tests_CU

#include "../SRC/TTT.cu"



int main() {
 //std::cout << "Hello World!";
 Game *f = new TTT();
 f->PlayAsHuman();

 std::cout << f->GenerateStringRepresentation();
 f->Move(0,0);
 std::cout << f->GenerateStringRepresentation();
 f->Move(0,1);
 std::cout << f->GenerateStringRepresentation();
 delete f;
 return 0;
}

#endif //TTT_Tests_CU
