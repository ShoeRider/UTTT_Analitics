#ifndef UTTT_Tests_CU
#define UTTT_Tests_CU

#include "../../Games/SRC/UTTT/UTTT.cpp"
#include "../SRC/MCTS.cu"

#include <list>
#include <stdlib.h>
#include <fstream>
#include <iostream>
#include <random>

#define PRINT_TO_SCREEN



template <typename T>
void DeleteAllItems(std::vector<T> itemList) {
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
    - Example: `./UTTT_GenerateRandomGames -g`
- **-p**:
    - Usage: `-p <Path to save results>`
    - Example: `./UTTT_GenerateRandomGames -d`
- **-sd**:
    - Usage: `-sd <MCTS Depth>`
    - Example: `./UUTTT_GenerateRandomGames -sd 1000`
    - Default: 200
 - **-d**:
    - Usage: `-d`
    - Description: This option enables the display of results. When this flag is present, the program will print results to the console.
    - Example: `./UTTT_GenerateRandomGames -d`
	- Default: false
**/
int main(int argc, char *argv[]) {
  bool DisplayResults = false;
  long int SearchDepth = 200000;
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

    UTTT_Move* SearchMove;
    float randomNumber = std::rand() % 100;
    UTTT_Player* Player0 = new UTTT_Player(0,'X',true);
    UTTT_Player* Player1 = new UTTT_Player(1,'O');


    UTTT* Game = new UTTT({Player0,Player1});
    std::vector<UTTT_Move*> GameHistory;

    while(!Game->isGameFinished){
        UTTT_Player* Player = Game->Players.front();
        if(!(Player->HumanPlayer)) {
            std::cout << "Performing "<<SearchDepth<<" Node MTCS Search." << std::endl;
            MCTS<UTTT,UTTT_Player,UTTT_Move> *Sim = new MCTS<UTTT,UTTT_Player,UTTT_Move>(Game);
            Sim->Search(SearchDepth);
            SearchMove = new UTTT_Move(*Sim->ReturnBestMove());
            GameHistory.push_back(SearchMove);
            Game->Move(SearchMove);
            Sim->DisplayTree(1);
            //delete SearchMove;
            delete Sim;
        }
        else {
            std::cout << Game->Generate_StringRepresentation()<< std::endl;

            std::cout << "Player:"<<Player->GameRepresentation<<" move." << std::endl;

            int x_game,y_game,x_Move,y_Move;
            std::cout << "Enter x_game (a number between 0 and 3): ";
            std::cin >> x_game;
            std::cout << "Enter y_game (a number between 0 and 3): ";
            std::cin >> y_game;
            std::cout << "Enter x_Move (a number between 0 and 3): ";
            std::cin >> x_Move;
            std::cout << "Enter y_Move (a number between 0 and 3): ";
            std::cin >> y_Move;

            UTTT_Move* Move = new UTTT_Move(x_game,y_game,x_Move,y_Move);
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



#endif //UTTT_Tests_CU