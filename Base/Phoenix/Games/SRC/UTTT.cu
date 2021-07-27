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
  UTTT_Player(int GivenPlayer,char GivenGameRepresentation):
  TTT_Player(GivenPlayer,GivenGameRepresentation){
    PlayerNumber = GivenPlayer;
    GameRepresentation = GivenGameRepresentation;
    //printf("Player:%p:%c\n",this,GameRepresentation);
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

    UTTT_SubGame(std::list<Player*> GivenPlayers){
        this->DeclarePlayers(GivenPlayers);

        this->WinningPlayer  = NULL;
        MovesRemaining       = 9;
        this->SetUpBoard();
      }

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

    if(UTTTMove->Player->GameRepresentation != Players.front()->GameRepresentation){
      Players.splice(Players.end(),        // destination position
                     Players,              // source list
                     Players.begin());     // source position
    }
    TestForWinner();
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










/*
UTTT - (Ultimate Tic Tac Toe) buisness logic.
This class simulates UTTT (Ultimate Tic Tac Toe) and follows the Game class interface structure to allow for the easy integration of Tree Searches.

@param (std::list<Player*> GivenPlayers), as the players to play the game.

@relatesalso Game, TTT



Long -
Ultimate Tick Tack Toe is a simple advancement to Tick Tack Toe’s game, except
the board is expanded to contain nine miniature tick tack toe games. For a general
idea about the game, check out this YouTube video: https://www.youtube.com/watch?v=37PC0bGMiTI
Note the implemented rules in my program are slightly different and will be
added in an additional document/Tutorial.

*/
class UTTT : public Game
{
public:

//Default Player Values.
  UTTT_Player Draw    = UTTT_Player(-1,'C');
  UTTT_Player Player0 = UTTT_Player(0,'X');
  UTTT_Player Player1 = UTTT_Player(1,'O');

  //Players are placed in the following list as a rotating queue.
  std::list<UTTT_Player*> Players;

  //Pointer to declare the winner.
  UTTT_Player*  WinningPlayer;


  //NextMove_Row/NextMove_Col determines where the next player must play based on the previous player’s move.
  int NextMove_Row;
  int NextMove_Col;

  //Represenations of each game within the larger 3x3 game.
  UTTT_SubGame* Boards[3][3];

  //MovesRemaining is a decrementing counter to determine if there are any remaining moves.
  int MovesRemaining;

  UTTT(){
      this->DeclarePlayers({&Player0,&Player1});
      this->WinningPlayer  = NULL;

      NextMove_Row   = -1;
      NextMove_Col   = -1;
      MovesRemaining = 81;
      this->SetUpBoards({&Player0,&Player1});
    }
    UTTT(std::list<Player*> GivenPlayers){
        this->DeclarePlayers(GivenPlayers);

        this->WinningPlayer  = NULL;
        NextMove_Row   = -1;
        NextMove_Col   = -1;
        MovesRemaining = 81;
        this->SetUpBoards(GivenPlayers);
      }
    ~UTTT(){
      this->FreeBoards();
      //delete Boards;
    }

    void SetUpBoards(std::list<Player*> GivenPlayers);
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
    Player* DeclareWinner(UTTT_Player* Winner);

};

/*
SetUpBoard
  Generic method to initilize each sub-Game class within the 3x3 game.

param (std::list<Player*> GivenPlayers), as the players to play the game.
*/
void UTTT::SetUpBoards(std::list<Player*> GivenPlayers)
{

  for (int Row = 0; Row < 3; Row++)
  {
    for (int Col = 0; Col < 3; Col++)
    {
        Boards[Row][Col] =  new UTTT_SubGame(GivenPlayers);
    }
  }
}

/*
FreeBoards frees all sub-games to prevent memory leaks.
*/
void UTTT::FreeBoards()
{
  for (int Row = 0; Row < 3; Row++)
  {
    for (int Col = 0; Col < 3; Col++)
    {
        delete Boards[Row][Col];
    }
  }
}


void UTTT::DeclarePlayers(std::list<Player*> GivenPlayers)
{
  for (Player* i : GivenPlayers) { // c++11 range-based for loop
      UTTT_Player* UTTTPlayer = static_cast<UTTT_Player*>(i);
      Players.push_back(UTTTPlayer);
    }
}


/*
CopyGame creates a complete copy of the game representation(Except for Players).
*/
Game* UTTT::CopyGame(){
  UTTT* New_UTTT = new UTTT(*this);
  for (int Row = 0; Row < 3; Row++)
  {
    for (int Col = 0; Col < 3; Col++)
    {
      UTTT_SubGame* SubGame = this->Boards[Row][Col];
      New_UTTT->Boards[Row][Col] =  new UTTT_SubGame(*SubGame);
    }
  }
  /*
  TODO: Check Players List Pointers are created.
  */
  for (Player* i : New_UTTT->Players) { // c++11 range-based for loop
      printf("UTTT Player List:%p\n",i);
    }
  return static_cast<Game*>(New_UTTT);
}


bool UTTT::ValidMove(GameMove* Move)
{

  UTTT_Move* UTTTMove = dynamic_cast<UTTT_Move*>(Move);
  if(
    NextMove_Row == -1 ||
    NextMove_Col == -1
  ){
    return Boards[UTTTMove->GameRow][UTTTMove->GameCol]->ValidMove(Move);
  }

  if(
    UTTTMove->GameRow == NextMove_Row &&
    UTTTMove->GameCol == NextMove_Col
  ){
    return Boards[UTTTMove->GameRow][UTTTMove->GameCol]->ValidMove(Move);
  }

  return false;
}



bool UTTT::Move(GameMove* Move)
{
  UTTT_Move* UTTTMove = dynamic_cast<UTTT_Move*>(Move);
  //printf("UTTTMove:%p\n",&UTTTMove);
  //printf("UTTTMove->GameRow:%d\n",UTTTMove->GameRow);
  //printf("UTTTMove->GameCol:%d\n",UTTTMove->GameCol);

  UTTTMove->Player = Players.front();
  //printf("UTTTMove->Row:%d\n",UTTTMove->Row);
  //printf("UTTTMove->Col:%d\n",UTTTMove->Col);


  if (this->ValidMove(Move))
  {
    MovesRemaining--;

    // move first element to the end
    Boards[UTTTMove->GameRow][UTTTMove->GameCol]->Move(Move);

    NextMove_Row = UTTTMove->Row;
    NextMove_Col = UTTTMove->Col;
    TestForWinner();

    Players.splice(Players.end(),        // destination position
                   Players,              // source list
                   Players.begin());     // source position
    //printf("valid Move");
    return true;
  }
  //printf("Invalid Move");
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

  std::string GameRep = "";
  /*
  Here is a graph of the individual smaller games.
  X|X|X|
  --------
   | | |
  --------
   | | |
  */
  for (int SubRow = 0; SubRow < 3; SubRow++)
  {
    for (int Col = 0; Col < 3; Col++)
    {
        for (int SubCol = 0; SubCol < 3; SubCol++)
        {
            char GameCharacter = Boards[Row][Col]->Board[SubRow][SubCol];
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
  TestForWinner();
  std::string GameRep = "UTTT Winner: ";
  printf("UTTT Winner:%p\n",WinningPlayer);
  if (WinningPlayer != NULL){
    //Convert from Generic Player to TTT_Player Structure
    UTTT_Player* UTTTPlayer = static_cast<UTTT_Player*>(WinningPlayer);

    GameRep += (UTTTPlayer->GameRepresentation); //Use '+=' when appending a char
  }
  else{
    GameRep.append("C");
  }
  GameRep.append("\n");


  for (int Row = 0; Row < 3; Row++)
  {
    for (int Col = 0; Col < 3; Col++)
    {
      //printf("%p,%p\n",Boards[Row][Col].WinningPlayer,Boards[Row][Col].TestForWinner());
      //std::cout << Boards[Row][Col].Generate_StringRepresentation();
      //std::cout << "\n";
      //
      if (Boards[Row][Col]->WinningPlayer != NULL){
        TTT_Player* TTTPlayer = static_cast<TTT_Player*>(Boards[Row][Col]->WinningPlayer);
        char position = TTTPlayer->GameRepresentation;
        GameRep.append(&position);

      }
      else{
        GameRep.append("C");
      }
        GameRep.append("|");
    }
    GameRep.append("\n--------\n");
  }
  GameRep.append("\n\n");
  for (int Row = 0; Row < 3; Row++)
  {
    GameRep.append(Generate_GameRowRepresentation(Row));
    GameRep.append("---------------------------\n");
  }
  return GameRep;
}


Player* UTTT::DeclareWinner(UTTT_Player* GivenWinner)
{
  //printf("DeclareWinner:%p\n",GivenWinner);

  if(WinningPlayer == NULL){
    //Player* Winner = static_cast<Player*>(GivenWinner);
    WinningPlayer = GivenWinner;
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
//printf("TestForWinner\n");
  if(
    WinningPlayer != NULL
  ){
    return WinningPlayer;
  }
  //printf("UTTT Winner%p\n",WinningPlayer);
  for (int Row_Col = 0; Row_Col < 3; Row_Col++)
  {


/*
if(Boards[Row_Col][0]->WinningPlayer != NULL)
{
  std::cout << "[Row_Col][0]" << Boards[Row_Col][0]->WinningPlayer <<"'"<< static_cast<TTT_Player*>(Boards[Row_Col][0]->WinningPlayer)->GameRepresentation << "'\n";
}
if(Boards[Row_Col][1]->WinningPlayer != NULL)
{
  std::cout << "[Row_Col][1]" << Boards[Row_Col][1]->WinningPlayer <<"'"<< static_cast<TTT_Player*>(Boards[Row_Col][1]->WinningPlayer)->GameRepresentation << "'\n";
}
if(Boards[Row_Col][2]->WinningPlayer != NULL)
{
  std::cout << "[Row_Col][2]" << Boards[Row_Col][2]->WinningPlayer <<"'"<< static_cast<TTT_Player*>(Boards[Row_Col][2]->WinningPlayer)->GameRepresentation << "'\n\n";
}*/



    if(
      Boards[Row_Col][0]->TestForWinner() == Boards[Row_Col][1]->TestForWinner() &&
      Boards[Row_Col][0]->TestForWinner() == Boards[Row_Col][2]->TestForWinner() &&
      Boards[Row_Col][0]->TestForWinner() != NULL
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
      //printf("Found solution\n");
      return DeclareWinner(static_cast<UTTT_Player*>(Boards[Row_Col][Row_Col]->TestForWinner()));

    }
    else if(
      Boards[0][Row_Col]->TestForWinner() == Boards[1][Row_Col]->TestForWinner() &&
      Boards[0][Row_Col]->TestForWinner() == Boards[2][Row_Col]->TestForWinner() &&
      Boards[0][Row_Col]->TestForWinner() != NULL
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
      //printf("Found solution\n");
      return DeclareWinner(static_cast<UTTT_Player*>(Boards[0][Row_Col]->TestForWinner()));
      //this->DeclareWinner(Boards[0][Row_Col].WinningPlayer);

    }
  }


  if(
    Boards[0][0]->TestForWinner() == Boards[1][1]->TestForWinner() &&
    Boards[0][0]->TestForWinner() == Boards[2][2]->TestForWinner() &&
    Boards[0][0]->TestForWinner() != NULL
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
  //printf("Found solution\n");
  return DeclareWinner(static_cast<UTTT_Player*>(Boards[0][0]->TestForWinner()));

  }
  else if(
    Boards[0][2]->TestForWinner() == Boards[1][1]->TestForWinner() &&
    Boards[0][2]->TestForWinner() == Boards[2][0]->TestForWinner() &&
    Boards[0][2]->TestForWinner() != NULL
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
  //printf("Found solution\n");
  return DeclareWinner(static_cast<UTTT_Player*>(Boards[0][2]->TestForWinner()));
  }
  if(this->MovesRemaining == 0){
    WinningPlayer = &Draw;
    //printf("No Remaining Moves\n");
    return WinningPlayer;
  }
  //printf("Reached End Returning NULL:%p\n",WinningPlayer);
  return WinningPlayer;
}

std::list<GameMove*> UTTT::PossibleMoves()
{
  //printf("NextMove(%i,%i)\n",NextMove_Row,NextMove_Col);
  std::list<GameMove*>Moves;
  if(
    NextMove_Row == -1 ||
    NextMove_Col == -1
  ){
    for (int Row = 0; Row < 2; Row++)
    {
      for (int Col = 0; Col < 2; Col++)
      {
        std::list<GameMove*> GMoves = Boards[Row][Col]->PossibleMoves();
        //printf("GMoves(%lu)\n",(GMoves.size()));
        for (GameMove* GMove : GMoves) { // c++11 range-based for loop

             UTTT_Move* UTTT_GMove = static_cast<UTTT_Move*>(GMove);
             UTTT_GMove->GameRow = Row;
             UTTT_GMove->GameCol = Col;

             GMove = static_cast<GameMove*>(UTTT_GMove);
             Moves.push_back(GMove);
          }
      }
    }
    //printf("Moves(%lu)\n",(Moves.size()));
    return Moves;
  }
  else{

    for (GameMove* GMove : Boards[NextMove_Row][NextMove_Col]->PossibleMoves()) { // c++11 range-based for loop
         UTTT_Move* UTTT_GMove = static_cast<UTTT_Move*>(GMove);
         UTTT_GMove->GameRow = NextMove_Row;
         UTTT_GMove->GameCol = NextMove_Col;

         GMove = static_cast<GameMove*>(UTTT_GMove);
         Moves.push_back(GMove);
      }
    //printf("UTTT_:NextMove_Row:%d\n",NextMove_Row);
    //printf("UTTT_:NextMove_Col:%d\n",NextMove_Col);
    return Moves;
  }

}
std::list<Game*> UTTT::PossibleGames()
{
  std::list<GameMove*> Moves = PossibleMoves();
  std::list<Game*>Games;
  UTTT* Branch;
  for (GameMove* GMove : Moves) { // c++11 range-based for loop
       //Branch = new UTTT(*this);
       Branch = static_cast<UTTT*>(CopyGame());
       Branch->Move(GMove);
       Games.push_back(static_cast<Game*>(Branch));
       //Free each Move Structure
       delete GMove;
    }


  return Games;
}


Game* UTTT::RollOut()
{
  //std::cout << Generate_StringRepresentation();
  //printf("Prefoming Rollout\n");
  GameMove* Move;

  int Range;

  TTT_Player* TTTPlayer = static_cast<TTT_Player*>(TestForWinner());
  while(TTTPlayer == NULL){

    std::list<GameMove*>GameMoves = PossibleMoves();
    Range = GameMoves.size();
    if(Range == 0){
      return this;
    }
    //printf("Range:%d\n",Range);
    Move          = get(GameMoves,(rand() % (Range)));
    //printf("Move:%p\n",Move);
    this->Move(Move);
    //printf("Freeing memory\n");
    Free_TTTMoveList(GameMoves);
    //delete &GameMoves;
    //delete Move;

    //std::cout << this->Generate_StringRepresentation();
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
