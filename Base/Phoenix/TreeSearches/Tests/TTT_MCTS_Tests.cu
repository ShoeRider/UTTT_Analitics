#ifndef MCTS_Tests_CU
#define MCTS_Tests_CU

#include "../../Games/SRC/Game.cpp"
#include "../../Games/SRC/TTT/TTT.cpp"
#include "../../Games/SRC/UTTT/UTTT.cpp"
#include "../SRC/MCTS.cu"


#include <list>
#include <stdlib.h>
#include <fstream>
#include <iostream>
#include <chrono>




void SaveMovesToFile(const std::list<TTT_Move>& RolloutMoves, const std::string& filename) {
    // Open an output file stream to write to a file
    std::ofstream outFile(filename, std::ios::app);

    // Check if the file was successfully opened
    if (!outFile.is_open()) {
        std::cerr << "Error: Could not open the file for writing!" << std::endl;
        return;
    }

    // Iterate through the moves and write to the file
    for (const TTT_Move& p : RolloutMoves) {
        outFile << p.Row << p.Col << ",";  // Write the row and column to the file
    }
    outFile << std::endl;  // Write a new line after all moves are written

    // Close the file stream
    outFile.close();
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

  TTT_Player Player0 = TTT_Player(0,'X');
  TTT_Player Player1 = TTT_Player(1,'O');

  //Player* Player0 = static_cast<Player*>(&TTTPlayer0);
  //Player* Player1 = static_cast<Player*>(&TTTPlayer1);

  TTT *_Game = new TTT({&Player0,&Player1});
  std::list<TTT_Move> GameHistory;

  MCTS<TTT,TTT_Player,TTT_Move> *Sim = new MCTS<TTT,TTT_Player,TTT_Move>(_Game,{&Player0,&Player1});
  Sim->Search(100);
  //GameHistory.push_back(*Sim->ReturnBestMove()->Move);

  //delete &Player0;
  //delete &Player1;
  //delete _Game;
  std::cout << "Time: " << (std::clock() - start) / (double)(CLOCKS_PER_SEC / 1000) << " ms" << std::endl;



  delete Sim;
 return 0;
}

#endif //MCTS_Tests_CU
