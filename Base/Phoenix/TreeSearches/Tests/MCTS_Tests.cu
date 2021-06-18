#ifndef MCTS_Tests_CU
#define MCTS_Tests_CU

#include "../SRC/MCTS.cu"



int main() {
 //std::cout << "Hello World!";
 TreeSimulation *f = new MCTS();
 f->Search(10);

 delete f;
 return 0;
}

#endif //MCTS_Tests_CU
