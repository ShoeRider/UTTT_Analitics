#ifndef MCTS_Tests_CU
#define MCTS_Tests_CU

#include "../../Games/SRC/Game.cpp"
#include "../../Games/SRC/TTT/TTT.cpp"
#include "../../Games/SRC/UTTT/UTTT.cpp"
#include "../../Games/SRC/TTT/TTT.cpp"
#include "../SRC/PMCTS.cu"
#include <malloc.h>

#include <gperftools/profiler.h>
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


void testMemoryAllocation() {
  try {
    // Allocate 5 GB of memory (5 GB = 5 * 1024 * 1024 * 1024 bytes)
    size_t size = static_cast<size_t>(1024) * 1024 * 1024 * 5; // 5 GB
    char* largeBlock = new char[size];

    // Check if allocation was successful
    if (largeBlock != nullptr) {
      std::cout << "Successfully allocated 5 GB of memory." << std::endl;
    }

    // Touch each page of the allocated memory to ensure it is actually committed
    for (size_t i = 0; i < size; i += 4096) {  // Access every 4 KB (page size)
      largeBlock[i] = 'A'; // Writing to each page
    }

    std::cout << "Memory has been touched to force allocation." << std::endl;
    Pause
    // Free the allocated memory
    delete[] largeBlock;
    std::cout << "Memory freed successfully." << std::endl;

  } catch (const std::bad_alloc& e) {
    // Handle memory allocation failure
    std::cerr << "Memory allocation failed: " << e.what() << std::endl;
  }
}
/*
TODO: Fix Rotating Winner priority.
As of right now, Both players are attempting to give Player0 the win.
+I belive its fixed, need further testing, MCTS_Node values are (negative).
*/
int main(int argc, char *argv[]) {
  ProfilerStart("example.prof"); // Start profiling and output to "example.prof"

  mallopt(M_MMAP_THRESHOLD, 0);

  UTTT_Move* SearchMove;
  float randomNumber;
  UTTT_Player* Player0 = new UTTT_Player(0,'X');
  UTTT_Player* Player1 = new UTTT_Player(1,'O');
  std::vector<UTTT_Player*> PlayerList= {Player0, Player1};

  UTTT* Game = new UTTT(PlayerList);
  std::vector<UTTT_Move*> GameHistory;

  PMCTS<UTTT,UTTT_Player,UTTT_Move> *Sim = new PMCTS<UTTT,UTTT_Player,UTTT_Move>(Game);
  Sim->Search(20,200000);
  SearchMove = new UTTT_Move(*Sim->ReturnBestMove());
  GameHistory.push_back(SearchMove);

  Game->Move(SearchMove);
  //delete SearchMove;
  delete Sim;
  GameHistory.clear();

  ProfilerStop(); // Stop profiling
  Pause
  delete Game;
  std::cin >> ASDF;
  return 0;
}

#endif //MCTS_Tests_CU
