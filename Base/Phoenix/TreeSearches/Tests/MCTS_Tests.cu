#ifndef MCTS_Tests_CU
#define MCTS_Tests_CU

#include "../../Games/SRC/Game.cu"
#include "../../Games/SRC/TTT.cu"
#include "../../Games/SRC/UTTT.cu"
#include "../SRC/MCTS.cu"


/*
//Test TTT with MCTS
TTT_Player Player0 = TTT_Player(0,'X');
TTT_Player Player1 = TTT_Player(1,'O');
Game *_Game = new TTT({&Player0,&Player1});

TreeSimulation *Sim = new MCTS(_Game);
Sim->Search(15000,&Player0);

//delete &Player0;
//delete &Player1;
//delete _Game;
delete Sim;
*/
int main() {
 //std::cout << "Hello World!";
 UTTT_Player Player0 = UTTT_Player(0,'X');
 UTTT_Player Player1 = UTTT_Player(1,'O');

 Game *_Game = new UTTT({&Player0,&Player1});
 // delete _Game;

 TreeSimulation *Sim = new MCTS(_Game);
 Sim->Search(3,&Player0);
 delete Sim;
 return 0;
}

#endif //MCTS_Tests_CU
