#ifndef TTT_Tests_CU
#define TTT_Tests_CU

#include "../../Games/SRC/TTT/TTT.cpp"
#include "../SRC/MCTS.cu"

#include <list>
#include <stdlib.h>
#include <fstream>
#include <iostream>
#include <random>

#define PRINT_TO_SCREEN

// Assuming TTT_Move has Row and Col as public members
void SaveMovesToFile(const std::list<TTT_Move*>& RolloutMoves, const std::string& filename) {

    // Open an output file stream to write to a file
    std::ofstream outFile(filename, std::ios::app);

    // Check if the file was successfully opened
    if (!outFile.is_open()) {
        std::cerr << "Error: Could not open the file for writing!" << std::endl;
        return;
    }

    // Iterate through the moves and write to the file
    for (const TTT_Move* p : RolloutMoves) {

        outFile << p->Row << p->Col << ",";  // Write the row and column to the file

        // Conditionally print to the screen if PRINT_TO_SCREEN is defined
        #ifdef PRINT_TO_SCREEN
            std::cout << p->Row << p->Col << ",";
        #endif
    }
    outFile << std::endl;  // Write a new line after all moves are written

    // Conditionally print a new line to the screen if PRINT_TO_SCREEN is defined
    #ifdef PRINT_TO_SCREEN
        std::cout << std::endl;
    #endif

    // Close the file stream
    outFile.close();
}


template <typename T>
void DeleteAllItems(std::list<T> itemList) {
    // Iterate through the list and delete each pointer
    for (T item : itemList) {
        delete item;  // Free the memory
    }
    // Clear the list itself
    //itemList.clear();
}
/**
  @brief Main function parameter options

  This program accepts command-line arguments to configure its behavior. The following options can be passed to the program:

 - **-rd**:
    - Usage: `-rd <Random move Chance>`
    - Description: "Depth of random initial moves."
    - Example: `./TTT_GenerateRandomGames -g`
- **-p**:
    - Usage: `-p <Path to save results>`
    - Example: `./TTT_GenerateRandomGames -d`
- **-sd**:
    - Usage: `-sd <MCTS Depth>`
    - Example: `./UTTT_GenerateRandomGames -sd 1000`
    - Default: 200
 - **-d**:
    - Usage: `-d`
    - Description: This option enables the display of results. When this flag is present, the program will print results to the console.
    - Example: `./TTT_GenerateRandomGames -d`
	- Default: false
**/
int main(int argc, char *argv[]) {
  bool DisplayResults = false;
  long int SearchDepth = 500;
  std::string ResultPath = "X_RandomSearchResults.csv";
  for (int i = 1; i < argc; i++) {

       if (strcmp(argv[i],"-p")==0) {
          if (i + 1 < argc) {      // Ensure the next argument exists
              ResultPath = argv[i + 1];  // Set the path to the next argument
              i++;                 // Increment i to skip over the path value
          } else {
              std::cerr << "Error: -p option requires a path argument." << std::endl;
              return 1;
          }
       }else if (strcmp(argv[i],"-sd")==0) {
           SearchDepth = atof(argv[i+1]);  // Convert the argument to a float
           i++;  // Skip the next argument since it's the value for -rd
       } else if (strcmp(argv[i],"-d")==0) {
          DisplayResults = true;
      }

  }

    TTT_Move* SearchMove;
    float randomNumber = std::rand() % 100;
    TTT_Player* Player0 = new TTT_Player(0,'X',true);
    TTT_Player* Player1 = new TTT_Player(1,'O');


    TTT* Game = new TTT({Player0,Player1});
    std::list<TTT_Move*> GameHistory;

    while(!Game->isGameFinished){
        TTT_Player* Player = Game->Players.front();
        if(!(Player->HumanPlayer)) {
            std::cout << "Performing "<<SearchDepth<<" Node MTCS Search." << std::endl;
            MCTS<TTT,TTT_Player,TTT_Move> *Sim = new MCTS<TTT,TTT_Player,TTT_Move>(Game);
            Sim->Search(SearchDepth);
            SearchMove = new TTT_Move(*Sim->ReturnBestMove());
            GameHistory.push_back(SearchMove);
            Game->Move(SearchMove);
            Sim->DisplayTree(1);
            //delete SearchMove;
            delete Sim;
        }
        else {
            std::cout << Game->Generate_StringRepresentation()<< std::endl;

            std::cout << "Player:"<<Player->GameRepresentation<<" move." << std::endl;

            int x_Move,y_Move;
            std::cout << "Enter x_Move (a number between 0 and 3): ";
            std::cin >> x_Move;
            std::cout << "Enter y_Move (a number between 0 and 3): ";
            std::cin >> y_Move;

            TTT_Move* Move = new TTT_Move(x_Move,y_Move);
            Game->Move(Move);
        }
    }
    std::cout << Game->Generate_StringRepresentation()<< std::endl;
    SaveMovesToFile(GameHistory,ResultPath);
    delete Game;
    DeleteAllItems(GameHistory);


  //delete _Game;
  printf("Freeing  Player0\n");
  delete Player0;
  printf("Freeing  Player1\n");
  delete Player1;
  return 0;
}



#endif //TTT_Tests_CU