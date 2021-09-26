#ifndef MCTS_Tests_CU
#define MCTS_Tests_CU

#include "../../Games/SRC/Game.cu"
#include "../../Games/SRC/TTT.cu"
#include "../../Games/SRC/UTTT.cu"
#include "../SRC/MCTS.cu"
#include "../SRC/PMCTS.cu"


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

 UTTT *_Game = new UTTT({&Player0,&Player1});
 //printf("_Game:%p\n",_Game);
 // delete _Game;

 PMCTS<UTTT,UTTT_Player> *Sim = new PMCTS<UTTT,UTTT_Player>(_Game,{&Player0,&Player1});
 Sim->Search(12,1000000);
 delete Sim;
   printf("Got Here\n");
 return 0;
}

#endif //MCTS_Tests_CU
