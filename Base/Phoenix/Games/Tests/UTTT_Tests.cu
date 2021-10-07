#ifndef UTTT_Tests_CU
#define UTTT_Tests_CU

#include "../SRC/TTT.cu"
#include "../SRC/UTTT.cu"



bool Validate_UTTT(UTTT*Given_UTTT){
  Given_UTTT->_Players.size();
  return 0;
}

bool UTTT_INIT(){
  //std::cout << "Hello World!";
  UTTT_Player Player0 = UTTT_Player(0,'X');
  UTTT_Player Player1 = UTTT_Player(1,'O');
  Game *_Game = new UTTT({&Player0,&Player1});

  delete _Game;
  return 0;
}

bool UTTT_PossibleGames_0(){
  //std::cout << "Hello World!";
  UTTT_Player Player0 = UTTT_Player(0,'X');
  UTTT_Player Player1 = UTTT_Player(1,'O');
  Game *_Game = new UTTT({&Player0,&Player1});
  std::list<Game*> Games = _Game->PossibleGames();

  delete _Game;
  return 0;
}

bool UTTT_RollOut(){
  //std::cout << "Hello World!";
  UTTT_Player Player0 = UTTT_Player(0,'X');
  UTTT_Player Player1 = UTTT_Player(1,'O');
  Game *_Game = new UTTT({&Player0,&Player1});
  _Game->RollOut();
  delete _Game;
  return 0;
}

int main() {


}

#endif //UTTT_Tests_CU
