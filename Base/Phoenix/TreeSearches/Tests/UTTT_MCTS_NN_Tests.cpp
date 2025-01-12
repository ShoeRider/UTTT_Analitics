#ifndef MCTS_NN_Tests_CPP
#define MCTS_NN_Tests_CPP

#include "../../Games/SRC/Game.cpp"
#include "../../Games/SRC/TTT/TTT.cpp"
#include "../../Games/SRC/UTTT/UTTT.cpp"
#include "../SRC/MCTS_NN.cpp"


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
    int SearchDepth = 10000;
    auto start = std::chrono::high_resolution_clock::now();

  UTTT_Player* Player0 = new UTTT_Player(0,'X');
  UTTT_Player* Player1 = new UTTT_Player(1,'O');

  //Player* Player0 = static_cast<Player*>(&TTTPlayer0);
  //Player* Player1 = static_cast<Player*>(&TTTPlayer1);

  UTTT* Game = new UTTT({Player0,Player1});
  std::list<TTT_Move> GameHistory;

  MCTS<UTTT,UTTT_Player,UTTT_Move> *Sim = new MCTS<UTTT,UTTT_Player,UTTT_Move>(Game);
  Sim->Search(SearchDepth);
  //Sim->DisplayTree(0);
  Sim->HeadNode->DisplayStats();
  //Sim->HeadNode->DisplayStats();
  //delete &Player0;
  //delete &Player1;
  //delete _Game;
    // Stop the clock
    auto end = std::chrono::high_resolution_clock::now();

    // Calculate elapsed time in milliseconds
    auto elapsed = std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count();

    std::cout << "Time: " << elapsed << " ms" << std::endl;



  delete Sim;
 return 0;
}

#endif //MCTS_NN_Tests_CPP
