#ifndef MCTS_Tests_CU
#define MCTS_Tests_CU

#include "../SRC/MCTS.cu"



int main() {
 //std::cout << "Hello World!";
 TTT_Player Player0 = TTT_Player(0,'X');
 TTT_Player Player1 = TTT_Player(1,'O');
 Game *_Game = new TTT({&Player0,&Player1});

 TreeSimulation *Sim = new MCTS(_Game);
 Sim->Search(10000,&Player0);

 //delete &Player0;
 //delete &Player1;
 //delete _Game;
 delete Sim;
 return 0;
}

#endif //MCTS_Tests_CU
