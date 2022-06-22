#ifndef MCTS_Tests_CU
#define MCTS_Tests_CU

#include "../../Games/SRC/Game.cpp"
#include "../../Games/SRC/TTT/TTT.cpp"
#include "../../Games/SRC/UTTT/UTTT.cpp"
#include "../SRC/MCTS.cpp"
#include "../SRC/PMCTS.cu"


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



 //DisplayDataTypeSizes();
void DisplayDataTypeSizes(){
  std::cout << "least 8:  " << sizeof(std::int_least8_t) * 8 << " bits\n";
  std::cout << "least 16: " << sizeof(std::int_least16_t) * 8 << " bits\n";
  std::cout << "least 32: " << sizeof(std::int_least32_t) * 8 << " bits\n";
  std::cout << '\n';
  std::cout << "fast 8:  " << sizeof(std::int_fast8_t) * 8 << " bits\n";
  std::cout << "fast 16: " << sizeof(std::int_fast16_t) * 8 << " bits\n";
  std::cout << "fast 32: " << sizeof(std::int_fast32_t) * 8 << " bits\n";
  std::cout << '\n';

  std::string GameState;
  char *Board_i = (char*) malloc(9);
  for (int Row = 0; Row < 3; Row++)
  {
    for (int Col = 0; Col < 3; Col++)
    {
      GameState += ' ';

    }
  }
  char Board[3][3];

  std::cout << "Board[3][3]:  "    << sizeof(Board) * 8 << " bits\n";
  std::cout << "std::string(9): "  << sizeof(GameState) * 8 << " bits\n";
  std::cout << "char *Board_i: "  << sizeof(Board_i) * 8 << " bits\n";
  free(Board_i);
  //std::cout << "fast 32: "      << sizeof(std::int_fast32_t) * 8 << " bits\n";
}






int main(int argc, char *argv[]) {
  int Threads = 1;
  long int SearchDepth = 10;
  bool DisplayResults = false;
  for (int i = 1; i < argc; i++) {
      if (strcmp(argv[i],"-t")==0) {
          Threads = atol(argv[i+1]);
          printf("SearchDepth: %ld",SearchDepth);
      }
      else if (strcmp(argv[i],"-sd")==0) {
          SearchDepth = atol(argv[i+1]);
          printf("SearchDepth: %ld",SearchDepth);
      } else if (strcmp(argv[i],"-d")==0) {
          DisplayResults = true;
      }

  }

 //std::cout << "Hello World!";
 UTTT_Player Player0 = UTTT_Player(0,'X');
 UTTT_Player Player1 = UTTT_Player(1,'O');

 UTTT *_Game = new UTTT({&Player0,&Player1});
 //printf("_Game:%p\n",_Game);
 // delete _Game;

 PMCTS<UTTT,UTTT_Player> *Sim = new PMCTS<UTTT,UTTT_Player>(_Game,{&Player0,&Player1});
//Pause;
 Sim->Search(Threads,SearchDepth);

 std::string LogPath = std::string("Test04.json");
 Sim->Save(LogPath);

 //delete JValue;
 //Sim->SaveSearch(std::string("Test04.json"),1,10);
 delete Sim;
 return 0;
}

#endif //MCTS_Tests_CU
