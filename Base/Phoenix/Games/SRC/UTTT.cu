/*
====================================================================================================
Description UTTT(Ultimate Tic Tac Toe):
Purpose:
  Implement Ultimate Tic Tac Toe through Game interface. Using rules To be described...
Contains(Classes):
  UTTT_Player
  UTTT_Move
  UTTT
TODO:
  Fails to compile.
  Add *Radio?* Player functionality: Takes Pointer to code -> Runs -> returns move
====================================================================================================
Date:           NA
Script Version: 1.0
Name:           Anthony M Schroeder
Email:          as3379@nau.edu
==========================================================

*/

#ifndef UTTT_CU
#define UTTT_CU


#include <iostream>
#include <string>
#include <list>


#include "Game.cu"
#include "TTT.cu"
#include "UTTT.h"



/*
UTTT_Player
@Purpose: Class to track UTTT Players.
@Methods:
  MakeMove() function pointer to allow for Humans to play.
*/
struct UTTT_Player : public TTT_Player
{
  public:
    int PlayerNumber;
    bool HumanPlayer;
    char GameRepresentation;
    //UTTT_Player(){}
  UTTT_Player(int GivenPlayer,char GivenGameRepresentation):
  TTT_Player(GivenPlayer,GivenGameRepresentation){
    PlayerNumber = GivenPlayer;
    HumanPlayer = false;
    GameRepresentation = GivenGameRepresentation;
    //printf("Player:%p:%c\n",this,GameRepresentation);
  }
  /**/
  /*UTTT_Player(nlohmann::json &j){
    int iChar = j["GameRepresentation"];
    GameRepresentation = iChar;


    PlayerNumber = j["PlayerNumber"];
    HumanPlayer = j["HumanPlayer"];
  }*/
  ~UTTT_Player(){}

  UTTT_Move* MakeMove(UTTT* GivenGame);
};
/*
void Add(nlohmann::json &j, UTTT_Player*p) {
  j = nlohmann::json::object({
    {"PlayerNumber", p->PlayerNumber},
    {"HumanPlayer", p->HumanPlayer},
    {"GameRepresentation", p->GameRepresentation}
  });
}*/

std::size_t Hash(UTTT_Player* k){
  //std::size_t HashSum;
  //std::string GameState = convertToString(k->Board,9);
  //HashSum = (std::hash<std::char>());

  return (int)(k->GameRepresentation);
}

/*
UTTT_Move
@Purpose: A Helper class to hold the potential move data for a UTTT Game. IE: X,Y coordinates. And possibly a Player Pointer.
@Methods:
  No Methods. Intended to only hold move data.
*/
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




void Free_UTTTMoveList(std::list<UTTT_Move*> GameMoves)
{
  //std::list<GameMove*> Moves = PossibleMoves();
  for (UTTT_Move* Move : GameMoves) { // c++11 range-based for loop
      //UTTT_Move* Move = static_cast<UTTT_Move*>(GMove);
      delete Move;
    }
}

UTTT_Move* UTTT_Player::MakeMove(UTTT* GivenGame)
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

   return UTTTMove;
}


class UTTT_SubGame : public TTT
{
  public:
    UTTT_Player Draw    = UTTT_Player(-1,'C');

    UTTT_SubGame(std::list<UTTT_Player*> GivenPlayers){
        this->DeclarePlayers(GivenPlayers);
        SimulationFinished = false;

        this->WinningPlayer  = NULL;
        MovesRemaining       = 9;
        this->SetUpBoard();
        GameHash = this->Hash();
      }
      //////////////////////////////////////////////////////////////////////////////
      // JSON Initialization method(Reading from file).
      /*
      UTTT_SubGame(nlohmann::json &j){
        WinningPlayer  = NULL;
        MovesRemaining       = 9;




        if(j["Board"].empty()){
          throw std::invalid_argument( "- UTTT_SubGame - UTTT  JSON File doesnt contain Board(char[9])." );
          //throw "TTT JSON File doesnt contain Board(char[9]).";
          exit(1);
        }

        //std::string value = J_Game["Board"].get<std::string>();
        //Board = J_Game["Board"].get<std::string>().c_str();

        const char* JSON_Game = j["Board"].get<std::string>().c_str();

        //strcat produces Valgrind error.
        //https://codereview.stackexchange.com/questions/46619/conditional-jump-or-move-depends-on-uninitialised-value
        strncpy(Board, JSON_Game, strlen(JSON_Game) + 1);

        JsonRead = true;
      }*/

      ~UTTT_SubGame(){


        if(JsonRead){
          for (TTT_Player* Player: Players) { // c++11 range-based for loop
            //free(Player);
            delete Player;
          }
        }

      }
    bool Move(UTTT_Move* Move);
    void DeclarePlayers(std::list<UTTT_Player*> GivenPlayers);
    void AddPlayers(std::list<UTTT_Player*> Players);
    UTTT_Player* DeclareWinner(UTTT_Player* GivenWinner);
    std::list<UTTT_Move*> PossibleMoves();
    bool equal(TTT* OtherGame);
    //bool ValidMove(GameMove* Move);
};


void UTTT_SubGame::DeclarePlayers(std::list<UTTT_Player*> GivenPlayers)
{
  //printf("Adding Players\n");
  for (UTTT_Player* player : GivenPlayers) { // c++11 range-based for loop
      Players.push_back(player);
      //_Players.push_back(i);
    }
}

std::list<UTTT_Move*> UTTT_SubGame::PossibleMoves()
{
  std::list<UTTT_Move*>Moves;

  //GameMove TTTPlayer = static_cast<GameMove>(TTT_Move(0,0));
  for (int Row = 0; Row < 3; Row++)
  {
    for (int Col = 0; Col < 3; Col++)
    {
        if (Board[Row*3+Col] == ' ')
        {
          UTTT_Move* Move = new UTTT_Move(-1,-1,Row,Col);
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

bool UTTT_SubGame::Move(UTTT_Move* Move)
{

  //////////////////////////////////////////////////////////////////////////////
  // Validate Move is legal, before preforming move.
  if (this->ValidMove(Move))
  {
    //////////////////////////////////////////////////////////////////////////////
    // Modify Sub Game's Board, by adding the current Player's GameRepresentation
    Board[Move->Row*3+Move->Col] = Move->Player->GameRepresentation;

    Players.splice(Players.end(),        // destination position
                   Players,              // source list
                   Players.begin());     // source position
    //printf("TestForWinner() \n");
    TestForWinner();
    return true;
  }
  return false;
}


void UTTT_SubGame::AddPlayers(std::list<UTTT_Player*> Players)
{
  for (UTTT_Player* Player: Players) { // c++11 range-based for loop
    Players.push_back(Player);
  }
}

bool UTTT_SubGame::equal(TTT* OtherGame)
{
  if(GameHash != OtherGame->GameHash){
    return false;
  }
  for (int Row = 0; Row < 9; Row++)
  {
    if (Board[Row] != OtherGame->Board[Row]){
      return false;
    }
  }
  return true;
}


std::size_t Hash(UTTT_SubGame* k)
{
  std::size_t HashSum;
  std::string GameState = convertToString(k->Board,9);
  //std::cout << GameState <<"\n";
  HashSum = (std::hash<std::string>()(GameState));
  //std::cout << HashSum <<"\n";

  k->GameHash = HashSum;
  return HashSum;
}









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
added in an additional documentation/Tutorial.
*/
class UTTT : public Game
{
public:
  //////////////////////////////////////////////////////////////////////////////
  // Player(s) DATA
  //TODO: Take Draw player during Initialization.
  //////////////////////////////////////////////////////////////////////////////
  UTTT_Player Draw    = UTTT_Player(-1,'C');

  //Players are placed in the following list as a rotating queue.
  //Based on the structure, std::list<Player*> needs to be casted to std::list<UTTT_Player*>
  std::list<UTTT_Player*> Players;

  //Pointer to declare the winner.
  UTTT_Player*  WinningPlayer;

  //////////////////////////////////////////////////////////////////////////////
  // Game Data
  //////////////////////////////////////////////////////////////////////////////
  //NextMove_Row/NextMove_Col determines where the next player must play based on the previous player’s move.
  int NextMove_Row;
  int NextMove_Col;

  //MovesRemaining is a decrementing counter to determine if there are any remaining moves.
  int MovesRemaining;
  bool SimulationFinished;

  //Represenations of each game within the larger 3x3 game.
  UTTT_SubGame* Boards[3][3];
  std::size_t GameHash;


  //////////////////////////////////////////////////////////////////////////////
  // JSON File Data
  //////////////////////////////////////////////////////////////////////////////
  bool JsonRead;

  //////////////////////////////////////////////////////////////////////////////
  // JSON Initialization method(Reading from file).
  /*
  UTTT(nlohmann::json &j){

    NextMove_Row   = -1;
    NextMove_Col   = -1;
    MovesRemaining = 81;
    WinningPlayer  = NULL;

    //////////////////////////////////////////////////////////////////////////////
    // For Each Player within JSON file, place back within Players list.
    // NOTE: When Saving TTT Players to JSON file, the order is swapped(The
    //   First player is at the bottom of the list); the for loop automatically
    //   adds the players back into the order(The first player within the JSON
    //   file becomes the last player within the Player order).
    for (nlohmann::json ji: j["Players"]) { // c++11 range-based for loop
      Players.push_back(new UTTT_Player(ji));
    }


    //this->SetUpBoards(Players);

    for (int Row = 0; Row < 3; Row++)
    {
      for (int Col = 0; Col < 3; Col++)
      {
        std::cout <<"Game"+std::to_string(Row)+std::to_string(Col)<< '\n';

        Boards[Row][Col] = new UTTT_SubGame(j["Games"]["Game"+std::to_string(Row)+std::to_string(Col)]);

        if(j["Games"]["Game"+std::to_string(Row)+std::to_string(Col)].empty()){
          throw std::invalid_argument( "TTT JSON File doesnt contain Board(char[9])." );
          //throw "TTT JSON File doesnt contain Board(char[9]).";
          exit(1);
        }
      }
    }


    JsonRead = true;
  }
  */

  //////////////////////////////////////////////////////////////////////////////
  // Initialization method.
  UTTT(std::list<UTTT_Player*> GivenPlayers){
      Players = GivenPlayers;
      //this->DeclarePlayers(GivenPlayers);

      this->WinningPlayer  = NULL;
      NextMove_Row   = -1;
      NextMove_Col   = -1;
      MovesRemaining = 81;
      this->SetUpBoards(GivenPlayers);
      JsonRead = false;
      SimulationFinished = false;
      GameHash = this->Hash();

    }
    ~UTTT(){
      this->FreeBoards();
      //delete Boards;
    }

    //////////////////////////////////////////////////////////////////////////////
    // Method Declarations.
    //////////////////////////////////////////////////////////////////////////////
    void SetUpBoards(std::list<UTTT_Player*> GivenPlayers);
    void FreeBoards();

    bool Move(UTTT_Move* Move);

    bool ValidMove(GameMove* Move);
    UTTT_Player* TestForWinner();
    void DisplayWinner();
    std::list<UTTT_Move*> PossibleMoves();
    std::list<UTTT*>     PossibleGames();
    std::string Generate_GameRowRepresentation(int Row);
    std::string Generate_StringRepresentation();

    //void DisplayInTerminal();
    UTTT* RollOut();
    UTTT* CopyGame();
    void PlayGame();
    void DeclarePlayers(std::list<UTTT_Player*> GivenPlayers);
    UTTT_Player* DeclareWinner(UTTT_Player* Winner);
    bool equal(UTTT* OtherGame);

    void Save(std::string LogPath);
    std::size_t Hash();

};


std::size_t UTTT::Hash()
{
  // Compute individual hash values for first,
  // second and third and combine them using XOR
  // and bit shifting:
  //std::hash<UTTT_SubGame>* Hash = new std::hash<UTTT_SubGame>;// = std::hash<TTT>(* _Game);
  std::size_t Itteration = 0;
  std::size_t HashSum = 0;
  for (int Row = 0; Row < 3; Row++)
  {
    for (int Col = 0; Col < 3; Col++)
    {
        //Board[Row][Col] = ' ';
        Itteration = this->Boards[Row][Col]->Hash()*(Col+1)*(Row+1)>> 1;
        //std::cout << this->Boards[Row][Col]->Hash() << "\n";
        //Pause;
        HashSum        += Itteration;
        //printf("Itteration: %zu\n",Itteration);
    }
  }

/*
int Position = 0;
for (UTTT_Player* Player: Players) { // c++11 range-based for loop
  Position+=1;
  HashSum += Hash(Player)*Position;
}
*/
  //printf("\tSum: %zu\n",Sum);
  //printf("----------------------------\n");
  //delete Hash;
  //return ((
  //         ^ (hash<string>()(k.second) << 1)) >> 1)
  //         ^ (hash<int>()(k.third) << 1);
  return HashSum;
}



/*
SetUpBoard
  Generic method to initilize each sub-Game class within the 3x3 game.

param (std::list<Player*> GivenPlayers), as the players to play the game.
*/
void UTTT::SetUpBoards(std::list<UTTT_Player*> GivenPlayers)
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

/*
DeclarePlayers
 */
void UTTT::DeclarePlayers(std::list<UTTT_Player*> GivenPlayers)
{
  for (UTTT_Player* i : GivenPlayers) { // c++11 range-based for loop
      //UTTT_Player* UTTTPlayer = static_cast<UTTT_Player*>(i);
      Players.push_back(i);
    }
}


/*
DeclarePlayers
 */
bool UTTT::equal(UTTT* OtherGame)
{
  if(GameHash != OtherGame->GameHash){
    return false;
  }
  for (int Row = 0; Row < 3; Row++)
  {
    for (int Col = 0; Col < 3; Col++)
    {
        if (!Boards[Row][Col]->equal(OtherGame->Boards[Row][Col])){
          return false;
        }
    }
  }
  return true;
}



/*
CopyGame creates a complete copy of the game representation(Except for Players).
*/
UTTT* UTTT::CopyGame(){

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

  //for (Player* i : New_UTTT->Players) { // c++11 range-based for loop
      //printf("UTTT Player List:%p\n",i);
    //}

  return (New_UTTT);
}


//////////////////////////////////////////////////////////////////////////////
// Game Functionality
//////////////////////////////////////////////////////////////////////////////
/*
*/
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



bool UTTT::Move(UTTT_Move* Move)
{
  UTTT_Move* UTTTMove = dynamic_cast<UTTT_Move*>(Move);
  //printf("UTTTMove:%p\n",&UTTTMove);
  //printf("UTTTMove->GameRow:%d\n",UTTTMove->GameRow);
  //printf("UTTTMove->GameCol:%d\n",UTTTMove->GameCol);

  UTTTMove->Player = *Players.begin();
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
            char GameCharacter = Boards[Row][Col]->Board[SubRow*3+SubCol];
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
  //printf("UTTT Winner:%p\n",WinningPlayer);
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


UTTT_Player* UTTT::DeclareWinner(UTTT_Player* GivenWinner)
{
  //printf("DeclareWinner:%p\n",GivenWinner);

  if(WinningPlayer == NULL){
    //Player* Winner = static_cast<Player*>(GivenWinner);

    SimulationFinished = true;
    WinningPlayer = GivenWinner;
  }
  return (WinningPlayer);
}

void UTTT::DisplayWinner(){
  if(WinningPlayer!=NULL){
    printf("Player %d Has won!",WinningPlayer->PlayerNumber);
  }
};


UTTT_Player* UTTT::TestForWinner()
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

std::list<UTTT_Move*> UTTT::PossibleMoves()
{
  //printf("NextMove(%i,%i)\n",NextMove_Row,NextMove_Col);
  std::list<UTTT_Move*>Moves;
  if(
    NextMove_Row == -1 ||
    NextMove_Col == -1
  ){
    for (int Row = 0; Row < 2; Row++)
    {
      for (int Col = 0; Col < 2; Col++)
      {
        std::list<UTTT_Move*> GMoves = Boards[Row][Col]->PossibleMoves();
        //printf("GMoves(%lu)\n",(GMoves.size()));
        for (GameMove* GMove : GMoves) { // c++11 range-based for loop

             UTTT_Move* UTTT_GMove = static_cast<UTTT_Move*>(GMove);
             UTTT_GMove->GameRow = Row;
             UTTT_GMove->GameCol = Col;

             //GMove = static_cast<GameMove*>(UTTT_GMove);
             Moves.push_back(UTTT_GMove);
          }
      }
    }
    //printf("Moves(%lu)\n",(Moves.size()));
    return Moves;
  }
  else{

    for (UTTT_Move* GMove : Boards[NextMove_Row][NextMove_Col]->PossibleMoves()) { // c++11 range-based for loop
         UTTT_Move* UTTT_GMove = static_cast<UTTT_Move*>(GMove);
         UTTT_GMove->GameRow = NextMove_Row;
         UTTT_GMove->GameCol = NextMove_Col;

         //GMove = static_cast<GameMove*>(UTTT_GMove);
         Moves.push_back(UTTT_GMove);
      }
    //printf("UTTT_:NextMove_Row:%d\n",NextMove_Row);
    //printf("UTTT_:NextMove_Col:%d\n",NextMove_Col);
    return Moves;
  }

}
std::list<UTTT*> UTTT::PossibleGames()
{
  std::list<UTTT_Move*> Moves = PossibleMoves();
  std::list<UTTT*>Games;
  UTTT* Branch;
  for (UTTT_Move* GMove : Moves) { // c++11 range-based for loop
       //Branch = new UTTT(*this);
       Branch = static_cast<UTTT*>(CopyGame());
       Branch->Move(GMove);
       Games.push_back(Branch);
       //Free each Move Structure
       delete GMove;
    }


  return Games;
}





void UTTT::PlayGame()
{
  UTTT_Move* Move;
  UTTT_Player* Currentplayer;

  UTTT_Player* TTTPlayer = static_cast<UTTT_Player*>(TestForWinner());
  while(TTTPlayer == NULL){

    Currentplayer = Players.front();

    Move          = (*Currentplayer).MakeMove(this);
    this->Move(Move);
    delete Move;

    std::cout << this->Generate_StringRepresentation();
    TTTPlayer = static_cast<UTTT_Player*>(TestForWinner());
  }
}


//////////////////////////////////////////////////////////////////////////////
// MCTS/TreeSearch Functionality
//////////////////////////////////////////////////////////////////////////////
UTTT* UTTT::RollOut()
{
  //std::cout << Generate_StringRepresentation();
  //printf("Prefoming Rollout\n");
  UTTT_Move* Move;

  int Range;

  TTT_Player* TTTPlayer = static_cast<TTT_Player*>(TestForWinner());
  while(TTTPlayer == NULL){

    std::list<UTTT_Move*>GameMoves = PossibleMoves();
    Range = GameMoves.size();
    if(Range == 0){
      return this;
    }
    //printf("Range:%d\n",Range);
    Move          = get(GameMoves,(rand() % (Range)));
    //printf("Move:%p\n",Move);
    this->Move(Move);
    //printf("Freeing memory\n");
    Free_UTTTMoveList(GameMoves);
    //delete &GameMoves;
    //delete Move;

    //std::cout << this->Generate_StringRepresentation();
    TTTPlayer = static_cast<TTT_Player*>(TestForWinner());
  }
  return this;
}


/*
void Add(nlohmann::json &j, UTTT*p) {

  for (int Row = 0; Row < 3; Row++)
  {
    for (int Col = 0; Col < 3; Col++)
    {
      //std::cout <<"Game"+std::to_string(Row)+std::to_string(Col)<< '\n';
      Add(j["Game"+std::to_string(Row)+std::to_string(Col)],p->Boards[Row][Col]);
    }
  }
  //printf("Adding UTTT Players\n");

  //Add(j["Players"],p->Players);


}*/

/*
template <typename Game_Tp, typename Player_Tp>
nlohmann::json Json(UTTT* p) {
  nlohmann::json data;
  Add(data,p);
  return data;
}*/

/*
void UTTT::Save(std::string LogPath){
  //printf("Save  _UTTTGame\n");
  nlohmann::json data;

  //printf("Adding TTT games\n");

  Add(data["Games"],this);




  std::ofstream file(LogPath);
  file << std::setw(4) << data << std::endl;
}*/

/*UTTT* Read_UTTT_JSON(std::string LogPath){
    //nlohmann::json data;
    //std::ifstream file(LogPath);
    //file >> data;
    std::ifstream ifs(LogPath);
    nlohmann::json jf = nlohmann::json::parse(ifs);
    UTTT *_Game = new UTTT(jf);


    //TTT* p = (TTT*)malloc( sizeof(TTT) );

    //TTT p = jf.at("Game");

    std::cout << _Game->Generate_StringRepresentation();
    return _Game;
}
*/



#endif //UTTT_CU
