#ifndef MCTS_Tests_CU
#define MCTS_Tests_CU

#include "../../Games/SRC/Game.cu"
#include "../../Games/SRC/TTT.cu"
//#include "../../Games/SRC/UTTT.cu"
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
bool UTTT_Player_Init(){
  //std::cout << "Hello World!";
  //UTTT_Player Player0 = UTTT_Player(0,'X');
  //delete Player0;
  return 0;
}

/*
UTTT_Player_Init();
//std::cout << "Hello World!";
UTTT_Player Player0 = UTTT_Player(0,'X');
UTTT_Player Player1 = UTTT_Player(1,'O');

//std::list<Player*> Players = {&Player0,&Player1};
//std::list<Player*>::iterator Players_it = Players.begin();

Game *_Game = new UTTT({&Player0,&Player1});
printf("_Game->Players.front():%p\n",_Game->_Players.begin());
for (Player* i : _Game->_Players) {
 printf("_Game->Players.front():%p\n",i);
 }
// delete _Game;
printf("new MCTS(_Game,&Player0)'s Player:%p\n",&Player0);
std::cin.get();

TreeSimulation *Sim = new MCTS(_Game,{&Player0,&Player1});
Sim->Search(1000);
delete Sim;
*/


/*
TODO: Fix Rotating Winner priority.
As of right now, Both players are attempting to give Player0 the win.
*/
int main() {
  TTT_Player Player0 = TTT_Player(0,'X');
  TTT_Player Player1 = TTT_Player(1,'O');

  //Player* Player0 = static_cast<Player*>(&TTTPlayer0);
  //Player* Player1 = static_cast<Player*>(&TTTPlayer1);

  TTT *_Game = new TTT({&Player0,&Player1});

  MCTS<TTT,Player> *Sim = new MCTS<TTT,Player>(_Game,{&Player0,&Player1});
  Sim->Search(200000);

  //delete &Player0;
  //delete &Player1;
  //delete _Game;
  delete Sim;
 return 0;
}

#endif //MCTS_Tests_CU
