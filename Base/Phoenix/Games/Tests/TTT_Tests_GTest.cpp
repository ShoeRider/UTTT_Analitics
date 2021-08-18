#ifndef TTT_Tests_CU
#define TTT_Tests_CU

#include "../SRC/TTT.cu"

#include <list>
#include <stdlib.h>
#include <gtest/gtest.h>
/*
Game *f = new TTT();

  GM = new TTT_Move(2,2);
  f->Move(GM);
  std::cout << f->GenerateStringRepresentation();
  delete GM;



f->DisplayWinner();
*/


/*
std::list<GameMove*>GameMoves = f->PossibleMoves();
Free_TTTList(GameMoves);
*/
TEST(SquareRootTest, PositiveNos)
    {
      TTT_Player Player0 = TTT_Player(0,'X');
      TTT_Player Player1 = TTT_Player(1,'O');
      Game *_Game = new TTT({&Player0,&Player1});
      _Game->RollOut();
      _Game->TestForWinner();
       delete _Game;
    }

int main(int argc, char **argv)
    {
    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
    }


 /*
 GameMove* GM = new TTT_Move(2,2);
 f->Move(GM);
 std::cout << f->GenerateStringRepresentation();
 delete GM;
 */


#endif //TTT_Tests_CU

/*


 */
