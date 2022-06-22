#ifndef MCTS_Tests_CU
#define MCTS_Tests_CU

#include "../../Games/SRC/Game.cpp"
#include "../../Games/SRC/TTT/TTT.cpp"
#include "../../Games/SRC/UTTT/UTTT.cpp"
#include "../SRC/MCHS.cu"


#include <iostream>
#include <chrono>
//#include "chrono_io"



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


  MCHS<TTT,TTT_Player> *Sim = new MCHS<TTT,TTT_Player>(_Game,{&Player0,&Player1});
  Sim->Search(100000);
*/
/*
UTTT_Player Player0 = UTTT_Player(0,'X');
UTTT_Player Player1 = UTTT_Player(1,'O');

//Player* Player0 = static_cast<Player*>(&TTTPlayer0);
//Player* Player1 = static_cast<Player*>(&TTTPlayer1);

UTTT *_Game = new UTTT({&Player0,&Player1});

MCHS<UTTT,UTTT_Player> *Sim = new MCHS<UTTT,UTTT_Player>(_Game,{&Player0,&Player1});
Sim->Search(1000000);

//delete &Player0;
//delete &Player1;
//delete _Game;
delete Sim;
*/


/*
TODO: Fix Rotating Winner priority.
As of right now, Both players are attempting to give Player0 the win.
+I belive its fixed, need further testing, MCTS_Node values are (negative).
*/
int main(int argc, char *argv[]) {
  long int SearchDepth = 10;
  bool DisplayResults = false;
  for (int i = 1; i < argc; i++) {

      if (strcmp(argv[i],"-sd")==0) {
          SearchDepth = atol(argv[i+1]);
          printf("SearchDepth: %ld",SearchDepth);
      } else if (strcmp(argv[i],"-d")==0) {
          DisplayResults = true;
      }

  }

  std::clock_t    start;
  start = std::clock();

  UTTT_Player Player0 = UTTT_Player(0,'X');
  UTTT_Player Player1 = UTTT_Player(1,'O');

  //Player* Player0 = static_cast<Player*>(&TTTPlayer0);
  //Player* Player1 = static_cast<Player*>(&TTTPlayer1);

  UTTT *_Game = new UTTT({&Player0,&Player1});

  MCHS<UTTT,UTTT_Player> *Sim = new MCHS<UTTT,UTTT_Player>(_Game,{&Player0,&Player1});
  Sim->Search(SearchDepth);

  if(DisplayResults){
    Sim->DisplayStats(1);
  }
  //delete &Player0;
  //delete &Player1;
  //delete _Game;

  std::cout << "Time: " << (std::clock() - start) / (double)(CLOCKS_PER_SEC / 1000) << " ms" << std::endl;

  //delete &Player0;
  //delete &Player1;
  //delete _Game;
  delete Sim;

 return 0;
}

#endif //MCTS_Tests_CU
