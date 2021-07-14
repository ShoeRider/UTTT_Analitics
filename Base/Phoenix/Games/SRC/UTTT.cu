/*
Anthony M Schroeder


Purpose:
Implement Ultimate Tic Tac Toe through Game interface. Using rules To be
described...


*/
#ifndef UTTT_CU
#define UTTT_CU


#include <iostream>
#include <string>
#include <list>


#include "Game.cu"
#include "TTT.cu"



/*

*/
struct UTTT_Player : public TTT_Player
{
  public:
    int PlayerNumber;
    char GameRepresentation;
    //UTTT_Player(){}
  UTTT_Player(int GivenPlayer,char GivenGameRepresentation){
    PlayerNumber = GivenPlayer;
    GameRepresentation = GivenGameRepresentation;
  }
  ~UTTT_Player(){}
  GameMove* MakeMove(Game* GivenGame);
};



struct UTTT_Move : public TTT_Move
{

  public:
    int GameRow;
    int GameCol;
    UTTT_Player* Player;

    int Row;
    int Col;

    UTTT_Move(
      int GivenGameRow,
      int GivenGameCol,
      int GivenRow,
      int GivenCol
    ):
    TTT_Move(GivenRow,GivenCol){
          GameRow = GivenGameRow;
          GameCol = GivenGameCol;
          Row = GivenRow;
          Col = GivenCol;
      }
      ~UTTT_Move(){}
};

void Free_UTTTMoveList(std::list<GameMove*> GameMoves)
{
  //std::list<GameMove*> Moves = PossibleMoves();
  for (GameMove* GMove : GameMoves) { // c++11 range-based for loop
      UTTT_Move* Move = static_cast<UTTT_Move*>(GMove);
      delete Move;
    }
}

GameMove* UTTT_Player::MakeMove(Game* GivenGame)
{
  //GameMove TTTPlayer = static_cast<GameMove>(TTT_Move(0,0));
  int GameRow,GameCol,Row,Col;
  std::cout << "Please Enter GameRow: ";
  std::cin >> GameRow;
  std::cout << "Please Enter Col Axis: ";
  std::cin >> GameCol;
  std::cout << "Please Enter Row Axis: ";
  std::cin >> Row;
  std::cout << "Please Enter Col: ";
  std::cin >> Col;
   UTTT_Move* UTTTMove = new UTTT_Move(GameRow,GameCol,Row,Col);
   GameMove* Move = static_cast<GameMove*>(UTTTMove);

   return Move;
}


class UTTT_SubGame : public TTT
{
  public:
    UTTT_Player Draw    = UTTT_Player(-1,'C');
    bool Move(GameMove* Move);
    Player* DeclareWinner(Player* GivenWinner);
    std::list<GameMove*> PossibleMoves();
    //bool ValidMove(GameMove* Move);
};

std::list<GameMove*> UTTT_SubGame::PossibleMoves()
{
  std::list<GameMove*>Moves;

  //GameMove TTTPlayer = static_cast<GameMove>(TTT_Move(0,0));
  for (int Row = 0; Row < 3; Row++)
  {
    for (int Col = 0; Col < 3; Col++)
    {
        if (Board[Row][Col] == ' ')
        {
          UTTT_Move* TTTMove = new UTTT_Move(-1,-1,Row,Col);
          GameMove* Move = static_cast<GameMove*>(TTTMove);
          Moves.push_back(Move);
        }
    }
  }
  return Moves;
}
/*
Player* UTTT_SubGame::DeclareWinner(UTTT_Player* GivenWinner)
{
  if(WinningPlayer == NULL){
    //Player* Winner = static_cast<Player*>(GivenWinner);
    WinningPlayer=GivenWinner;
  }
  return static_cast<Player*>(WinningPlayer);
}
*/

bool UTTT_SubGame::Move(GameMove* Move)
{

  if (this->ValidMove(Move))
  {
    UTTT_Move* UTTTMove = dynamic_cast<UTTT_Move*>(Move);
    Board[UTTTMove->Row][UTTTMove->Col] = UTTTMove->Player->GameRepresentation;
    return true;
  }
  return false;
}

/*

bool UTTT_SubGame::ValidMove(GameMove* Move)
{
  printf("TTT MovesRemaining:%d\n",MovesRemaining);
  if(MovesRemaining == 0 ){
    //TODO Re-Implement DRAW DECLARATION
    //DeclareWinner(&Draw);
    return false;
  }

  UTTT_Move* TTTMove = static_cast<UTTT_Move*>(Move);

  printf("TTTMove->Row:%d\n",TTTMove->Row);
  printf("TTTMove->Col:%d\n",TTTMove->Col);
  printf("Board[TTTMove->Row][TTTMove->Col]:%c\n",Board[TTTMove->Row][TTTMove->Col]);
  if (Board[TTTMove->Row][TTTMove->Col] == ' ')
  {
    //Valid Move
      printf("TTT Valid Move\n");
    return true;
  }
  else
  {
    //Invalid Move
      printf("TTT InValid Move\n");
    return false;
  }
}

*/











class UTTT : public Game
{



public:

  UTTT_Player Draw    = UTTT_Player(-1,'C');
  UTTT_Player Player0 = UTTT_Player(0,'X');
  UTTT_Player Player1 = UTTT_Player(1,'Y');

  std::list<UTTT_Player*> Players;


  UTTT_Player*  WinningPlayer;


  int NextMove_Row;
  int NextMove_Col;
  UTTT_SubGame Boards[3][3];
  int MovesRemaining;

  UTTT(){
      this->DeclarePlayers({&Player0,&Player1});
      this->WinningPlayer  = NULL;

      NextMove_Row   = -1;
      NextMove_Col   = -1;
      MovesRemaining = 81;
      this->SetUpBoards();
    }
    UTTT(std::list<Player*> GivenPlayers){
        this->DeclarePlayers(GivenPlayers);

        this->WinningPlayer  = NULL;
        NextMove_Row   = -1;
        NextMove_Col   = -1;
        MovesRemaining = 81;
        this->SetUpBoards();
      }
    ~UTTT(){
      this->FreeBoards();
    }

    void SetUpBoards();
    void FreeBoards();

    bool Move(GameMove* Move);

    bool ValidMove(GameMove* Move);
    Player* TestForWinner();
    void DisplayWinner();
    std::list<GameMove*> PossibleMoves();
    std::list<Game*>     PossibleGames();
    std::string Generate_GameRowRepresentation(int Row);
    std::string Generate_StringRepresentation();

    //void DisplayInTerminal();
    Game* RollOut();
    Game* CopyGame();
    void PlayGame();
    void DeclarePlayers(std::list<Player*> GivenPlayers);
    void SetUpBoard();
    Player* DeclareWinner(UTTT_Player* Winner);

};


void UTTT::SetUpBoards()
{

}

void UTTT::FreeBoards()
{

}

void UTTT::DeclarePlayers(std::list<Player*> GivenPlayers)
{
  for (Player* i : GivenPlayers) { // c++11 range-based for loop
      UTTT_Player* UTTTPlayer = static_cast<UTTT_Player*>(i);
      Players.push_back(UTTTPlayer);
    }
}



bool UTTT::ValidMove(GameMove* Move)
{

  UTTT_Move* UTTTMove = dynamic_cast<UTTT_Move*>(Move);
  if(
    NextMove_Row == -1 ||
    NextMove_Col == -1
  ){
    return Boards[UTTTMove->GameRow][UTTTMove->GameCol].ValidMove(Move);
  }

  if(
    UTTTMove->GameRow == NextMove_Row &&
    UTTTMove->GameCol == NextMove_Col
  ){
    return Boards[UTTTMove->GameRow][UTTTMove->GameCol].ValidMove(Move);
  }

  return false;
}



bool UTTT::Move(GameMove* Move)
{
  UTTT_Move* UTTTMove = dynamic_cast<UTTT_Move*>(Move);
  printf("UTTTMove:%p\n",&UTTTMove);
  printf("UTTTMove->GameRow:%d\n",UTTTMove->GameRow);
  printf("UTTTMove->GameCol:%d\n",UTTTMove->GameCol);

  UTTTMove->Player = Players.front();
  printf("UTTTMove->Row:%d\n",UTTTMove->Row);
  printf("UTTTMove->Col:%d\n",UTTTMove->Col);

  int stop;
  std::cin >> stop;
  if (this->ValidMove(Move))
  {
    MovesRemaining--;

    // move first element to the end
    Boards[UTTTMove->GameRow][UTTTMove->GameCol].Move(Move);

    NextMove_Row = UTTTMove->Row;
    NextMove_Col = UTTTMove->Col;
    TestForWinner();

    Players.splice(Players.end(),        // destination position
                   Players,              // source list
                   Players.begin());     // source position
    printf("valid Move");
    return true;
  }
  printf("Invalid Move");
  return false;
}
/*
if (this->ValidMove(Move))
{
  UTTT_Move* UTTTMove = dynamic_cast<UTTT_Move*>(Move);
  UTTTMove->Player = PlayerCharacter;
  return Boards[UTTTMove->Row][UTTTMove->Col].Move(Move);
}
return false;
*/


std::string UTTT::Generate_GameRowRepresentation(int Row)
{
  /*
  Here is a graph of the individual smaller games.
  X|X|X|
  --------
   | | |
  --------
   | | |
  */
  std::string GameRep = "";
  for (int SubRow = 0; SubRow < 3; SubRow++)
  {
    for (int Col = 0; Col < 3; Col++)
    {
        for (int SubCol = 0; SubCol < 3; SubCol++)
        {
            char GameCharacter = Boards[Row][Col].Board[SubRow][SubCol];
            GameRep.append(&GameCharacter);
            GameRep.append("|");
        }
        GameRep.append("   ");
    }
    GameRep.append("\n---------------------------\n");
  }
  return GameRep;

}

std::string UTTT::Generate_StringRepresentation()
{
  std::string GameRep = "";
  for (int Row = 0; Row < 3; Row++)
  {
    GameRep.append(Generate_GameRowRepresentation(Row));
    GameRep.append("---------------------------\n");
  }
  return GameRep;
}


Player* UTTT::DeclareWinner(UTTT_Player* GivenWinner)
{
  if(WinningPlayer == NULL){
    //Player* Winner = static_cast<Player*>(GivenWinner);
    WinningPlayer=GivenWinner;
  }
  return static_cast<Player*>(WinningPlayer);
}

void UTTT::DisplayWinner(){
  if(WinningPlayer!=NULL){
    printf("Player %d Has won!",WinningPlayer->PlayerNumber);
  }
};


Player* UTTT::TestForWinner()
{
  for (int Row_Col = 0; Row_Col < 3; Row_Col++)
  {
    if(
      Boards[Row_Col][0].WinningPlayer == Boards[Row_Col][1].WinningPlayer &&
      Boards[Row_Col][0].WinningPlayer == Boards[Row_Col][2].WinningPlayer &&
      Boards[Row_Col][0].WinningPlayer != NULL
    )
    {
      /*
      Winning Row Method Found. Example:
      X|X|X|
      --------
       | | |
      --------
       | | |
      */
      return static_cast<UTTT_Player*>(Boards[Row_Col][Row_Col].WinningPlayer);

    }
    else if(
      Boards[0][Row_Col].WinningPlayer == Boards[1][Row_Col].WinningPlayer &&
      Boards[0][Row_Col].WinningPlayer == Boards[2][Row_Col].WinningPlayer &&
      Boards[0][Row_Col].WinningPlayer != NULL
    )
    {
      /*
      Winning Column Method Found. Example:
      X| | |
      --------
      X| | |
      --------
      X| | |
      */
      return static_cast<UTTT_Player*>(Boards[0][Row_Col].WinningPlayer);
      //this->DeclareWinner(Boards[0][Row_Col].WinningPlayer);

    }
  }


  if(
    Boards[0][0].WinningPlayer == Boards[1][1].WinningPlayer &&
    Boards[0][0].WinningPlayer == Boards[2][2].WinningPlayer &&
    Boards[0][0].WinningPlayer != NULL
  )
  {
/*
Winning Diagonal Method Found. Example:
  X| | |
  --------
   |X| |
  --------
   | |X|
  */
  return static_cast<UTTT_Player*>(Boards[0][0].WinningPlayer);

  }
  else if(
    Boards[0][2].WinningPlayer == Boards[1][1].WinningPlayer &&
    Boards[0][2].WinningPlayer == Boards[2][0].WinningPlayer &&
    Boards[0][2].WinningPlayer != NULL
  )
  {
/*
Winning Diagonal Method Found. Example:
   | |X|
  --------
   |X| |
  --------
  X| | |
  */
  return static_cast<UTTT_Player*>(Boards[0][2].WinningPlayer);;
  }

  return WinningPlayer;
}

std::list<GameMove*> UTTT::PossibleMoves()
{
  std::list<GameMove*>Moves;
  if(
    NextMove_Row == -1 ||
    NextMove_Col == -1
  ){
    for (int Row = 0; Row < 3; Row++)
    {
      for (int Col = 0; Col < 3; Col++)
      {
        for (GameMove* GMove : Boards[Row][Col].PossibleMoves()) { // c++11 range-based for loop
             UTTT_Move* UTTT_GMove = static_cast<UTTT_Move*>(GMove);
             UTTT_GMove->GameRow = Row;
             UTTT_GMove->GameCol = Col;

             GMove = static_cast<GameMove*>(UTTT_GMove);
             Moves.push_back(GMove);
          }
      }
    }
    return Moves;
  }
  else{

    for (GameMove* GMove : Boards[NextMove_Row][NextMove_Col].PossibleMoves()) { // c++11 range-based for loop
         UTTT_Move* UTTT_GMove = static_cast<UTTT_Move*>(GMove);
         UTTT_GMove->GameRow = NextMove_Row;
         UTTT_GMove->GameCol = NextMove_Col;

         GMove = static_cast<GameMove*>(UTTT_GMove);
         Moves.push_back(GMove);
      }
    printf("UTTT_:NextMove_Row:%d\n",NextMove_Row);
    printf("UTTT_:NextMove_Col:%d\n",NextMove_Col);
    return Moves;
  }

}
std::list<Game*> UTTT::PossibleGames()
{
  std::list<GameMove*> Moves = PossibleMoves();
  std::list<Game*>Games;
/*  TTT* Branch;
  for (GameMove* GMove : Moves) { // c++11 range-based for loop
       Branch = new UTTT(*this);
       Branch->Move(GMove);
       Games.push_back(Branch);
    }
    */

  return Games;
}

Game* UTTT::CopyGame(){
  return static_cast<Game*>(new UTTT(*this));
}


Game* UTTT::RollOut()
{
  GameMove* Move;
  int Range;

  TTT_Player* TTTPlayer = static_cast<TTT_Player*>(TestForWinner());
  while(TTTPlayer == NULL){

    std::list<GameMove*>GameMoves = PossibleMoves();
    Range = GameMoves.size();
    printf("Range:%d\n",Range);
    Move          = get(GameMoves,(rand() % (Range)));
    printf("Move:%p\n",Move);
    this->Move(Move);
    printf("Freeing memory\n");
    Free_TTTMoveList(GameMoves);
    //delete &GameMoves;
    //delete Move;

    std::cout << this->Generate_StringRepresentation();
    TTTPlayer = static_cast<TTT_Player*>(TestForWinner());
  }
  return this;
}

void UTTT::PlayGame()
{
  GameMove* Move;
  Player* Currentplayer;

  TTT_Player* TTTPlayer = static_cast<TTT_Player*>(TestForWinner());
  while(TTTPlayer == NULL){
    Currentplayer = Players.front();

    Move          = (*Currentplayer).MakeMove(this);
    this->Move(Move);
    delete Move;

    std::cout << this->Generate_StringRepresentation();
    TTTPlayer = static_cast<TTT_Player*>(TestForWinner());
  }
}

#endif //UTTT_CU
