#ifndef TTT_Tests_CU
#define TTT_Tests_CU

#include "../SRC/TTT/TTT.h"

#include <list>
#include <stdlib.h>
#include <fstream>
#include <iostream>

/*
https://github.com/open-source-parsers/jsoncpp/issues/507
*/
// Assuming TTT_Move has Row and Col as public members
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


/**
  @brief Main function parameter options

  This program accepts command-line arguments to configure its behavior. The following options can be passed to the program:

 - **-g**:
    - Usage: `-g <Games to save>`
    - Example: `./TTT_GenerateRandomGames -g`
- **-p**:
    - Usage: `-p <Path to save results>`
    - Example: `./TTT_GenerateRandomGames -d`
 - **-d**:
      - Usage: `-d`
      - Description: This option enables the display of results. When this flag is present, the program will print results to the console.
      - Example: `./TTT_GenerateRandomGames -d`
**/
int main(int argc, char *argv[]) {
  long int GamesToSimulate = 10;
  bool DisplayResults = false;
  std::string ResultPath = "";
  for (int i = 1; i < argc; i++) {

      if (strcmp(argv[i],"-g")==0) {
          GamesToSimulate = atol(argv[i+1]);
          //printf("GamesToSimulate: %ld",GamesToSimulate);
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

    TTT_Player* Player0 = new TTT_Player(0,'X');
    TTT_Player* Player1 = new TTT_Player(1,'O');
    for (int i = 0; i < GamesToSimulate; i++) {
        TTT *_Game = new TTT({Player0,Player1});
        std::list<TTT_Move> RolloutMoves = _Game->RollOut_ReturnGameMoves();
        SaveMovesToFile(RolloutMoves,ResultPath);
    }

    return 0;
 }



#endif //TTT_Tests_CU