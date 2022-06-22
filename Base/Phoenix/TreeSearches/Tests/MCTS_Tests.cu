#ifndef MCTS_Tests_CU
#define MCTS_Tests_CU

#include "../../Games/SRC/Game.cpp"
#include "../../Games/SRC/TTT/TTT.cpp"
#include "../../Games/SRC/UTTT/UTTT.cpp"
#include "../SRC/MCTS.cu"



#include <iostream>
#include <chrono>




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
bool UTTT_Player_Init(){
  //std::cout << "Hello World!";
  //UTTT_Player Player0 = UTTT_Player(0,'X');
  //delete Player0;
  return 0;
}

/*
TTT_Player Player0 = TTT_Player(0,'X');
TTT_Player Player1 = TTT_Player(1,'O');

//Player* Player0 = static_cast<Player*>(&TTTPlayer0);
//Player* Player1 = static_cast<Player*>(&TTTPlayer1);

TTT *_Game = new TTT({&Player0,&Player1});

MCTS<TTT,TTT_Player> *Sim = new MCTS<TTT,TTT_Player>(_Game,{&Player0,&Player1});
Sim->Search(100000);


//delete &Player0;
//delete &Player1;
//delete _Game;
*/


/*
TODO: Fix Rotating Winner priority.
As of right now, Both players are attempting to give Player0 the win.
+I belive its fixed, need further testing, MCTS_Node values are (negative).
*/
int main() {
  std::clock_t    start;
  start = std::clock();

  UTTT_Player Player0 = UTTT_Player(0,'X');
  UTTT_Player Player1 = UTTT_Player(1,'O');

  //Player* Player0 = static_cast<Player*>(&TTTPlayer0);
  //Player* Player1 = static_cast<Player*>(&TTTPlayer1);

  UTTT *_Game = new UTTT({&Player0,&Player1});

  MCTS<UTTT,UTTT_Player> *Sim = new MCTS<UTTT,UTTT_Player>(_Game,{&Player0,&Player1});
  Sim->Search(1000000);

  //delete &Player0;
  //delete &Player1;
  //delete _Game;
  std::cout << "Time: " << (std::clock() - start) / (double)(CLOCKS_PER_SEC / 1000) << " ms" << std::endl;



  delete Sim;
 return 0;
}

#endif //MCTS_Tests_CU
