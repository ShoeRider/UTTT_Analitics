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

 - **-g**:
    - Usage: `-g <Games to save>`
    - Example: `./TTT_GenerateRandomGames -g`
	- Default: 10
 - **-rc**:
    - Usage: `-rm <Random move Chance>`
    - Description: "Depth of random initial moves."
    - Example: `./TTT_GenerateRandomGames -g`
 - **-rd**:
    - Usage: `-rd <Random move Chance>`
    - Description: "Depth of random initial moves."
    - Example: `./TTT_GenerateRandomGames -g`
- **-p**:
    - Usage: `-p <Path to save results>`
    - Example: `./TTT_GenerateRandomGames -d`
 - **-d**:
    - Usage: `-d`
    - Description: This option enables the display of results. When this flag is present, the program will print results to the console.
    - Example: `./TTT_GenerateRandomGames -d`
	- Default: false
**/
int main(int argc, char *argv[]) {
  float RandomMovePercentage = 20;
  long int GamesToSimulate = 20;
  bool DisplayResults = false;
  std::string ResultPath = "X_RandomSearchResults.csv";
  for (int i = 1; i < argc; i++) {

      if (strcmp(argv[i],"-g")==0) {
          GamesToSimulate = atol(argv[i+1]);
          //printf("GamesToSimulate: %ld",GamesToSimulate);
      } else if (strcmp(argv[i],"-rd")==0) {
          RandomMovePercentage = atof(argv[i+1]);  // Convert the argument to a float
          i++;  // Skip the next argument since it's the value for -rd
      } else if (strcmp(argv[i],"-p")==0) {
          if (i + 1 < argc) {      // Ensure the next argument exists
              ResultPath = argv[i + 1];  // Set the path to the next argument
              i++;                 // Increment i to skip over the path value
          } else {
              std::cerr << "Error: -p option requires a path argument." << std::endl;
              return 1;
          }
      } else if (strcmp(argv[i],"-d")==0) {
          DisplayResults = true;
      }

  }

    TTT_Move* SearchMove;
    float randomNumber = std::rand() % 100;
    TTT_Player* Player0 = new TTT_Player(0,'X');
    TTT_Player* Player1 = new TTT_Player(1,'O');

    for (int i = 0; i < GamesToSimulate; i++) {
        TTT* Game = new TTT({Player0,Player1});
        std::list<TTT_Move*> GameHistory;

        while(!Game->isGameFinished){
            randomNumber = std::rand() % 100;
            std::cout << randomNumber << std::endl;
            if (randomNumber < RandomMovePercentage) {
                std::cout << "Adding Random Move." << std::endl;
                SearchMove = Game->FindRandomMove();
                GameHistory.push_back(SearchMove);
                Game->Move(SearchMove);
                //delete SearchMove;

            } else {
                std::cout << "Performing 100 Node MTCS Search." << std::endl;
                MCTS<TTT,TTT_Player,TTT_Move> *Sim = new MCTS<TTT,TTT_Player,TTT_Move>(Game);
                Sim->Search(250);
                SearchMove = new TTT_Move(*Sim->ReturnBestMove());
                GameHistory.push_back(SearchMove);
                Game->Move(SearchMove);
                //delete SearchMove;
                delete Sim;
            }

            std::cout << Game->Generate_StringRepresentation()<< std::endl;
        }
        SaveMovesToFile(GameHistory,ResultPath);
        delete Game;
        DeleteAllItems(GameHistory);
    }


  //delete _Game;
  printf("Freeing  Player0\n");
  delete Player0;
  printf("Freeing  Player1\n");
  delete Player1;
  return 0;
}



#endif //TTT_Tests_CU