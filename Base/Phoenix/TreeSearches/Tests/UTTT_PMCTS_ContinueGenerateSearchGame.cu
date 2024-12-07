#ifndef UTTT_Tests_CU
#define UTTT_Tests_CU

#include "../../Games/SRC/UTTT/UTTT.cpp"
#include "../SRC/PMCTS.cu"

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

std::vector<std::string> splitByComma(const std::string& str) {
    std::vector<std::string> result;
    std::stringstream ss(str);
    std::string item;

    while (std::getline(ss, item, ',')) {
        if (!item.empty()) { // Exclude empty substrings if necessary
            result.push_back(item);
        }
    }

    return result;
}


UTTT_Move* CreateMove(const std::string& str) {
    if (str.size() != 4) {
        throw std::invalid_argument("Input string must have exactly 4 characters");
    }

    // Convert each character to an integer and assign it to the variables
    int GameRow = str[0] - '0';
    int GameCol = str[1] - '0';
    int Row = str[2] - '0';
    int Col = str[3] - '0';

    UTTT_Move* UTTTMove = new UTTT_Move(GameRow,GameCol,Row,Col);
    return UTTTMove;

}

/**
  @brief Main function parameter options

  This program accepts command-line arguments to configure its behavior. The following options can be passed to the program:
- **-g**:
    - Usage: `-g <Games to save>`
    - Example: `./UTTT_GenerateRandomGames -g`
    - Default: 10
 - **-rc**:
    - Usage: `-rm <Random move Chance>`
    - Description: "Depth of random initial moves."
    - Example: `./UTTT_GenerateRandomGames -g`
 - **-rd**:
    - Usage: `-rd <Random move Chance>`
    - Description: "Depth of random initial moves."
    - Example: `./UTTT_GenerateRandomGames -g`
- **-p**:
    - Usage: `-p <Path to save results>`
    - Example: `./UTTT_GenerateRandomGames -d`
- **-sd**:
    - Usage: `-sd <MCTS Depth>`
    - Example: `./UTTT_GenerateRandomGames -sd 1000`
    - Default: 200
- **-t**:
    - Usage: `-t <Threads to use>`
    - Example: `./UTTT_GenerateRandomGames -t 12`
    - Default: 12
- **-pg**:
    - Past Game
    - Usage: `-pg <Path to save results>`
    - Example: `./UTTT_GenerateRandomGames -pg 0112,1202,0202,0221,`
 - **-d**:
    - Usage: `-d`
    - Description: This option enables the display of results. When this flag is present, the program will print results to the console.
    - Example: `./UTTT_GenerateRandomGames -d`
	- Default: false
- **-m**:
    - Usage: `-m`
    - Description: Moves to investigate
    - Example: `./UTTT_GenerateRandomGames -m <Moves to search>`
    - Default: false
**/

int main(int argc, char *argv[]) {
    long int GamesToSimulate = 1;
    int MoveDepth = -1;
    float RandomMovePercentage = 20;
    long int SearchDepth = 1000;
    long int Threads = 2;
    bool DisplayResults = false;
    std::string ResultPath = "X_RandomSearchResults.csv";
    std::string PastGame = "NA";
    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i],"-g")==0) {
            GamesToSimulate = atol(argv[i+1]);
            //printf("GamesToSimulate: %ld",GamesToSimulate);
        }
        else if (strcmp(argv[i],"-sd")==0) {
            SearchDepth = atof(argv[i+1]);  // Convert the argument to a float
            i++;  // Skip the next argument since it's the value for -sd
        }
        else if (strcmp(argv[i],"-t")==0) {
            Threads = atof(argv[i+1]);  // Convert the argument to a float
            i++;  // Skip the next argument since it's the value for -t
        }
        else if (strcmp(argv[i],"-m")==0) {
            MoveDepth = atof(argv[i+1]);  // Convert the argument to a float
            i++;  // Skip the next argument since it's the value for -t
        }
        else if (strcmp(argv[i],"-rd")==0) {
            RandomMovePercentage = atof(argv[i+1]);  // Convert the argument to a float
            i++;  // Skip the next argument since it's the value for -rd
        }
        else if (strcmp(argv[i],"-pg")==0) {
            if (i + 1 < argc) {      // Ensure the next argument exists
                PastGame = argv[i + 1];  // Set the path to the next argument
                i++;                 // Increment i to skip over the path value
            } else {
                std::cerr << "Error: -p option requires a path argument." << std::endl;
                return 1;
            }
        }
        else if (strcmp(argv[i],"-p")==0) {
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

    UTTT_Move* SearchMove;
    UTTT_Player* Player0 = new UTTT_Player(0,'X');
    UTTT_Player* Player1 = new UTTT_Player(1,'O');


    for (int i = 0; i < GamesToSimulate; i++) {
        UTTT* Game = new UTTT({Player0,Player1});
        std::vector<UTTT_Move*> GameHistory;
        int MoveDepthRemaining = MoveDepth;

        if (PastGame != "NA") {
            std::vector<std::string> result = splitByComma(PastGame);
            for (const auto& s : result) {
                SearchMove = CreateMove(s.c_str());
                /*
                * printf("result: %s\n", s.c_str());
                printf(" GivenGameRow: %d\n", SearchMove->GameRow);
                printf(" GivenGameCol: %d\n", SearchMove->GameCol);
                printf(" Row: %d\n", SearchMove->Row);
                printf(" Col: %d\n", SearchMove->Col);
                 */
                //SearchMove
                Game->Move(SearchMove);
                GameHistory.push_back(SearchMove);
            }
        }
        //std::cout << Game->Generate_StringRepresentation()<< std::endl;


        while(!(Game->isGameFinished) && (MoveDepthRemaining != 0)){
            const float randomNumber = std::rand() % 100;
            std::cout << randomNumber << std::endl;

            SaveMovesToFile(GameHistory,ResultPath);
            if (randomNumber < RandomMovePercentage) {
                std::cout << "Adding Random Move." << std::endl;
                SearchMove = Game->FindRandomMove();
                GameHistory.push_back(SearchMove);
                Game->Move(SearchMove);
                //delete SearchMove;

            } else {
                std::cout << Game->Generate_StringRepresentation() << std::endl;
                std::cout << "GamesToSimulate:"<<i<<"/"<<GamesToSimulate<<", MoveDepthRemaining:"<<MoveDepthRemaining<<"." << std::endl;
                std::cout << "   Performing SearchDepth:"<<SearchDepth<<", Threads:"<<Threads<<" Node PMTCS Search." << std::endl;
                std::cout << "   Game->PossibleMoves().size() :"<< Game->PossibleMoves().size()  << std::endl;
                PMCTS<UTTT,UTTT_Player,UTTT_Move> *Sim = new PMCTS<UTTT,UTTT_Player,UTTT_Move>(Game);

                Sim->Search(Threads,SearchDepth);
                SearchMove = new UTTT_Move(*Sim->ReturnBestMove());
                GameHistory.push_back(SearchMove);

                Game->Move(SearchMove);
                //delete SearchMove;
                delete Sim;
            }
            MoveDepthRemaining--;
        }
        std::cout << Game->Generate_StringRepresentation()<< std::endl;
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



#endif //UTTT_Tests_CU