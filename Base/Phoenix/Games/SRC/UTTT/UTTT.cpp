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

#include <jsoncpp/json/json.h>

#include "../Game.cpp"
#include "../TTT/TTT.cpp"
#include "UTTT.h"



#include <algorithm>
#include <utility>
#include <vector>



/*
UTTT_Player
@Purpose: Class to track UTTT Players.
@Methods:
  MakeMove() function pointer to allow for Humans to play.
*/
struct UTTT_Player : public Player
{
  public:
    int PlayerNumber;
    bool HumanPlayer;
    char GameRepresentation;
    //UTTT_Player(){}


    //////////////////////////////////////////////////////////////////////////////
    // Initialization method.
  UTTT_Player(int GivenPlayer,char GivenGameRepresentation,bool Human){
    PlayerNumber = GivenPlayer;
    HumanPlayer = Human;
    GameRepresentation = GivenGameRepresentation;
    //printf("Player:%p:%c\n",this,GameRepresentation);
  }
  UTTT_Player(int GivenPlayer,char GivenGameRepresentation){
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




void Free_UTTTMoveList(std::vector<UTTT_Move*> GameMoves)
{
  //std::vector<GameMove*> Moves = PossibleMoves();
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
    UTTT_Player* Draw;
    std::vector<UTTT_Player*>* Players;
    UTTT_Player*  WinningPlayer = nullptr;

    UTTT_SubGame(std::vector<UTTT_Player*>* GivenPlayers,UTTT_Player* UTTTDraw){
        Players = GivenPlayers;
        //this->DeclarePlayers(*GivenPlayers);
        isGameFinished = false;
        Draw    = UTTTDraw;

        this->WinningPlayer  = nullptr;
        MovesRemaining       = 9;
        this->SetUpBoard();
        GameHash = this->Hash();
      }
      //////////////////////////////////////////////////////////////////////////////
      // JSON Initialization method(Reading from file).

      ~UTTT_SubGame(){

      }
    bool Move(UTTT_Move* Move,UTTT_Player* Player);
    void AddPlayers(std::vector<UTTT_Player*> Players);
    UTTT_Player* DeclareWinner(UTTT_Player* GivenWinner);
    std::vector<UTTT_Move*> PossibleMoves();
  //void DeclarePlayers(const std::vector<UTTT_Player*>& GivenPlayers);

  bool ValidMove(UTTT_Move *Move);

  bool equal(TTT* OtherGame);
    //bool ValidMove(GameMove* Move);
  UTTT_Player* TestForWinner();
};
/*
*
void UTTT_SubGame::DeclarePlayers(const std::vector<UTTT_Player*>& GivenPlayers)
{
  std::list<UTTT_Player*> tempList;

  // First, collect all players in a temporary list
  for (UTTT_Player* i : GivenPlayers) {
    tempList.push_back(i);
  }

  // Now reserve space in the Players vector and transfer from list to vector
  Players->reserve(Players.size() + tempList.size());

  for (UTTT_Player* player : tempList) {
    Players.push_back(player);
  }
}

 */

// Returns True/False If Winner is found
UTTT_Player* UTTT_SubGame::TestForWinner()
{
  //std::cout <<"Moves remaining(TTT Game): "<< this->MovesRemaining<<"\n";
  if(
    WinningPlayer != nullptr
  ){
    return WinningPlayer;
  }

  for (int Row_Col = 0; Row_Col < 3; Row_Col++)
  {
    if(
      Board[Row_Col*3] == Board[Row_Col*3+1] &&
      Board[Row_Col*3] == Board[Row_Col*3+2] &&
      Board[Row_Col*3] != ' '
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
      return this->DeclareWinner(Players->front());

    }
    else if(
      Board[Row_Col] == Board[3+Row_Col] &&
      Board[Row_Col] == Board[6+Row_Col] &&
      Board[Row_Col] != ' '
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
      return this->DeclareWinner(Players->front());

    }
  }


  if(
    Board[0] == Board[4] &&
    Board[0] == Board[8] &&
    Board[0] != ' '
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
    return this->DeclareWinner(Players->front());

  }
  else if(
    Board[2] == Board[4] &&
    Board[2] == Board[6] &&
    Board[2] != ' '
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
    return this->DeclareWinner(Players->front());
  }

  if(this->MovesRemaining == 0){
    //return WinningPlayer;
    return this->DeclareWinner(Draw);
  }
  return WinningPlayer;
}


std::vector<UTTT_Move*> UTTT_SubGame::PossibleMoves()
{
  std::list<UTTT_Move*> moveList;

  // First, collect all moves in a list
  for (int Row = 0; Row < 3; Row++)
  {
    for (int Col = 0; Col < 3; Col++)
    {
      if (Board[Row * 3 + Col] == ' ')
      {
        UTTT_Move* Move = new UTTT_Move(-1, -1, Row, Col);
        moveList.push_back(Move);
      }
    }
  }

  // Then create a vector with enough reserved space and copy elements from list to vector
  std::vector<UTTT_Move*> Moves;
  Moves.reserve(moveList.size());

  for (UTTT_Move* move : moveList)
  {
    Moves.push_back(move);
  }

  return Moves;
}


UTTT_Player* UTTT_SubGame::DeclareWinner(UTTT_Player* GivenWinner)
{
  if(WinningPlayer == nullptr){
    //Player* Winner = static_cast<Player*>(GivenWinner);
    WinningPlayer=GivenWinner;
  }
  return WinningPlayer;
}


bool UTTT_SubGame::ValidMove(UTTT_Move* Move)
{
  //printf("TTT MovesRemaining:%d\n",MovesRemaining);
  if(MovesRemaining == 0 ){
    return false;
  }

  //printf("TTTMove->Row:%d\n",TTTMove->Row);
  //printf("TTTMove->Col:%d\n",TTTMove->Col);
  //printf("Board[TTTMove->Row][TTTMove->Col]:%c\n",Board[TTTMove->Row][TTTMove->Col]);
  if (Board[Move->Row*3+Move->Col] == ' ')
  {
    //Valid Move
    //printf("TTT Valid Move\n");
    return true;
  }
  else
  {
    //Invalid Move
    //printf("TTT InValid Move\n");
    return false;
  }
}

bool UTTT_SubGame::Move(UTTT_Move* Move,UTTT_Player* GamePlayer)
{
  //////////////////////////////////////////////////////////////////////////////
  // Validate Move is legal, before preforming move.
  if (this->ValidMove(Move))
  {
    //////////////////////////////////////////////////////////////////////////////
    // Modify Sub Game's Board, by adding the current Player's GameRepresentation
    Board[Move->Row*3+Move->Col] = GamePlayer->GameRepresentation;

    //printf("TestForWinner() \n");
    TestForWinner();
    return true;
  }
  return false;
}


void UTTT_SubGame::AddPlayers(std::vector<UTTT_Player*> Players)
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

@param (std::vector<Player*> GivenPlayers), as the players to play the game.

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
  UTTT_Player* Draw;
  //Players are placed in the following list as a rotating queue.
  //Based on the structure, std::vector<Player*> needs to be cast to std::vector<UTTT_Player*>
  std::vector<UTTT_Player*> Players;

  //Pointer to declare the winner.
  UTTT_Player*  WinningPlayer = nullptr;

  //////////////////////////////////////////////////////////////////////////////
  // Game Data
  //////////////////////////////////////////////////////////////////////////////
  //NextMove_Row/NextMove_Col determines where the next player must play based on the previous player’s move.
  int NextMove_Row;
  int NextMove_Col;

  //MovesRemaining is a decrementing counter to determine if there are any remaining moves.
  int MovesRemaining;
  bool isGameFinished;

  //Represenations of each game within the larger 3x3 game.
  UTTT_SubGame* Boards[3][3];
  std::size_t GameHash;


  //////////////////////////////////////////////////////////////////////////////
  // Initialization method.
  UTTT(std::vector<UTTT_Player*> GivenPlayers){
      Draw    = new UTTT_Player(-1,'C');
      //Players = std::move(GivenPlayers);
      this->DeclarePlayers(GivenPlayers);

      this->WinningPlayer  = nullptr;
      NextMove_Row   = -1;
      NextMove_Col   = -1;
      MovesRemaining = 81;
      this->SetUpBoards(&Players);
      isGameFinished = false;
      GameHash = this->Hash();
    }
    ~UTTT(){
    //std::cout << "Free:" << std::endl;
      //this->PrintPointers();
      this->FreeBoards();

      //delete Draw;
      //delete Boards;
    }

    //////////////////////////////////////////////////////////////////////////////
    // Method Declarations.
    //////////////////////////////////////////////////////////////////////////////
    void PrintPointers() const;
    void SetUpBoards(std::vector<UTTT_Player *> *GivenPlayers);
    void FreeBoards();
    void PrintPlayers();
    void RotatePlayers();
    bool Move(UTTT_Move* Move);
    UTTT* Move_ReturnNewGame(UTTT_Move* Move);
    bool ValidMove(UTTT_Move* Move);
    UTTT_Player* TestForWinner();
    void DisplayWinner();
    std::vector<UTTT_Move*> PossibleMoves();
    std::vector<UTTT*>     PossibleGames();
    UTTT_Move *FindRandomMove();
    std::string Generate_GameRowRepresentation(int Row);
    std::string Generate_StringRepresentation() override;

    //void DisplayInTerminal();
    UTTT* RollOut();
    UTTT* CopyGame();
    void PlayGame();


    void DeclarePlayers(const std::vector<UTTT_Player*>& GivenPlayers);
    UTTT_Player* DeclareWinner(UTTT_Player* Winner);
    bool equal(UTTT* OtherGame);

    std::size_t Hash();
};


void UTTT::PrintPointers() const {
  // Print the address of the UTTT instance itself
  std::cout << "Self (UTTT instance): " << this << std::endl;

  // Print the address of WinningPlayer
  std::cout << "WinningPlayer pointer: " << WinningPlayer << std::endl;

  // Print all players' pointers in the Players list
  std::cout << "Players list pointers:" << std::endl;
  for (const auto& player : Players) {
    std::cout << "  - " << player << std::endl;
  }

  // Print pointers to the Boards (3x3 array of UTTT_SubGame*)
  std::cout << "Boards (3x3 UTTT_SubGame pointers):" << std::endl;
  for (int row = 0; row < 3; ++row) {
    for (int col = 0; col < 3; ++col) {
      std::cout << "  - Boards[" << row << "][" << col << "]: " << Boards[row][col] << std::endl;
    }
  }

  // Print the address of the Draw player
  std::cout << "Draw player address: " << Draw << std::endl;

  // Summary of dynamic memory info
  std::cout << "Note: Only dynamic memory pointers are shown for UTTT_SubGame, UTTT_Player, and WinningPlayer." << std::endl;
}

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

param (std::vector<Player*> GivenPlayers), as the players to play the game.
*/
void UTTT::SetUpBoards(std::vector<UTTT_Player*>* GivenPlayers)
{
  for (int Row = 0; Row < 3; Row++)
  {
    for (int Col = 0; Col < 3; Col++)
    {
        Boards[Row][Col] =  new UTTT_SubGame(GivenPlayers,Draw);
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
void UTTT::DeclarePlayers(const std::vector<UTTT_Player*>& GivenPlayers)
{
  Players={};
  std::list<UTTT_Player*> tempList;

  // First, collect all players in a temporary list
  for (UTTT_Player* i : GivenPlayers) {
    tempList.push_back(i);
  }

  // Now reserve space in the Players vector and transfer from list to vector
  Players.reserve(Players.size() + tempList.size());

  for (UTTT_Player* player : tempList) {
    Players.push_back(player);
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
  New_UTTT->DeclarePlayers(Players);
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
  //std::cout << "Copy:" << std::endl;
  //this->PrintPointers();
  //std::cout << "----------------" << std::endl;
  //New_UTTT->PrintPointers();
  //std::cout << "end copy ----------------" << std::endl;
  return (New_UTTT);
}


//////////////////////////////////////////////////////////////////////////////
// Game Functionality
//////////////////////////////////////////////////////////////////////////////
/*
*/
bool UTTT::ValidMove(UTTT_Move* Move)
{

  if(
    NextMove_Row == -1 ||
    NextMove_Col == -1
  ){
    return Boards[Move->GameRow][Move->GameCol]->ValidMove(Move);
  }

  if(
    Move->GameRow == NextMove_Row &&
    Move->GameCol == NextMove_Col
  ){
    return Boards[Move->GameRow][Move->GameCol]->ValidMove(Move);
  }

  return false;
}

UTTT* UTTT::Move_ReturnNewGame(UTTT_Move* UTTTMove)
{
  // Create a new game object as a copy of the current game (deep copy)
  UTTT* newGame = CopyGame();  // Use copy constructor to clone the current game
  if (newGame->ValidMove(UTTTMove)) {
    newGame->Move(UTTTMove);
    return newGame;
  }


  // If the move is not valid, clean up and return nullptr
  delete newGame;  // Clean up if invalid move
  return nullptr;  // Return nullptr to signal failure
}

void UTTT::PrintPlayers()
{
  //printf("Adding Players\n");
  for (UTTT_Player* i : Players) { // c++11 range-based for loop
    printf("     GivenPlayer:%p\n",i);
    printf("     PlayerREP:%c\n",i->GameRepresentation);
  }
}
void UTTT::RotatePlayers(){
  std::rotate(Players.begin(), Players.begin() + 1, Players.end());
}


bool UTTT::Move(UTTT_Move* Move)
{
  if(this->isGameFinished) {
    return false;
  }
  //UTTT_Move* UTTTMove = dynamic_cast<UTTT_Move*>(Move);


  //printf("UTTTMove:%p\n",&UTTTMove);
  //printf("UTTTMove->GameRow:%d\n",UTTTMove->GameRow);
  //printf("UTTTMove->GameCol:%d\n",UTTTMove->GameCol);

  //printf("UTTTMove->Row:%d\n",UTTTMove->Row);
  //printf("UTTTMove->Col:%d\n",UTTTMove->Col);

  if(this->ValidMove(Move))
  {
    MovesRemaining--;

    // move first element to the end
    Boards[Move->GameRow][Move->GameCol]->Move(Move,Players.front());
    //Boards[Move->GameRow][Move->GameCol]->TestForWinner();
    // Rotate players for the next turn
    NextMove_Row = Move->Row;
    NextMove_Col = Move->Col;

    this->TestForWinner();
    this->RotatePlayers();
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
            GameRep.push_back(GameCharacter);
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
  if (WinningPlayer != nullptr){
    //Convert from Generic Player to TTT_Player Structure

    GameRep += (WinningPlayer->GameRepresentation); //Use '+=' when appending a char

  }
  else{
    GameRep.append("C");
  }
  GameRep.append("\n");

  GameRep.append("MovesRemaining:");
  GameRep.append(std::to_string(MovesRemaining));
  GameRep.append("\n");

  GameRep.append("ActiveGame:");
  GameRep.append(std::to_string(isGameFinished));
  GameRep.append("\n");

  for (int Row = 0; Row < 3; Row++)
  {
    for (int Col = 0; Col < 3; Col++)
    {
      //printf("%p,%p\n",Boards[Row][Col].WinningPlayer,Boards[Row][Col].TestForWinner());
      //std::cout << Boards[Row][Col].Generate_StringRepresentation();
      //std::cout << "\n";
      //
      if (Boards[Row][Col]->WinningPlayer != nullptr){
        UTTT_Player* TTTPlayer = Boards[Row][Col]->WinningPlayer;
        printf("TTTPlayer: %p\n",TTTPlayer);
        char position = TTTPlayer->GameRepresentation;
        //GameRep.append(&position);
        GameRep.push_back(position);
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

  if(WinningPlayer == nullptr){
    //Player* Winner = static_cast<Player*>(GivenWinner);

    isGameFinished = true;
    WinningPlayer = static_cast<UTTT_Player*>(GivenWinner);
  }
  return (WinningPlayer);
}

void UTTT::DisplayWinner(){
  if(WinningPlayer!=nullptr){
    printf("Player %d Has won!",WinningPlayer->PlayerNumber);
  }
};


UTTT_Player* UTTT::TestForWinner()
{

  //printf("TestForWinner(UTTT Game)\n");
  //std::cout <<"MovesRemaining: "<< this->MovesRemaining<<"\n";
  //std::cout <<"WinningPlayer: "<< WinningPlayer<<"\n";

  if(
    WinningPlayer != nullptr
  ){
    return WinningPlayer;
  }
    //printf("TestForWinner(UTTT Game) Game by Game\n");
  //printf("UTTT Winner%p\n",WinningPlayer);
  for (int Row_Col = 0; Row_Col < 3; Row_Col++)
  {


/*
if(Boards[Row_Col][0]->WinningPlayer != nulptr)
{
  std::cout << "[Row_Col][0]" << Boards[Row_Col][0]->WinningPlayer <<"'"<< static_cast<TTT_Player*>(Boards[Row_Col][0]->WinningPlayer)->GameRepresentation << "'\n";
}
if(Boards[Row_Col][1]->WinningPlayer != nulptr)
{
  std::cout << "[Row_Col][1]" << Boards[Row_Col][1]->WinningPlayer <<"'"<< static_cast<TTT_Player*>(Boards[Row_Col][1]->WinningPlayer)->GameRepresentation << "'\n";
}
if(Boards[Row_Col][2]->WinningPlayer != nulptr)
{
  std::cout << "[Row_Col][2]" << Boards[Row_Col][2]->WinningPlayer <<"'"<< static_cast<TTT_Player*>(Boards[Row_Col][2]->WinningPlayer)->GameRepresentation << "'\n\n";
}*/


  //printf("TestForWinner(UTTT Game) Row-COL:%d\n",Row_Col);

    if(
      Boards[Row_Col][0]->TestForWinner() == Boards[Row_Col][1]->TestForWinner() &&
      Boards[Row_Col][0]->TestForWinner() == Boards[Row_Col][2]->TestForWinner() &&
      Boards[Row_Col][0]->TestForWinner() != nullptr
    )
    {
        //printf("TestForWinner(UTTT Game) Row\n");
      /*
      Winning Row Method Found. Example:
      X|X|X|
      --------
       | | |
      --------
       | | |
      */
      //printf("Found solution\n");
      return DeclareWinner(Boards[Row_Col][Row_Col]->TestForWinner());

    }
    else if(
      Boards[0][Row_Col]->TestForWinner() == Boards[1][Row_Col]->TestForWinner() &&
      Boards[0][Row_Col]->TestForWinner() == Boards[2][Row_Col]->TestForWinner() &&
      Boards[0][Row_Col]->TestForWinner() != nullptr
    )
    {
  //printf("TestForWinner(UTTT Game) COL\n");
      /*
      Winning Column Method Found. Example:
      X| | |
      --------
      X| | |
      --------
      X| | |
      */
      //printf("Found solution\n");
      return DeclareWinner(Boards[0][Row_Col]->TestForWinner());
      //this->DeclareWinner(Boards[0][Row_Col].WinningPlayer);

    }
  }


  //printf("TestForWinner(UTTT Game) Diag\n");
  if(
    Boards[0][0]->TestForWinner() == Boards[1][1]->TestForWinner() &&
    Boards[0][0]->TestForWinner() == Boards[2][2]->TestForWinner() &&
    Boards[0][0]->TestForWinner() != nullptr
  )
  {
  //printf("TestForWinner(UTTT Game) Diag1\n");
/*
Winning Diagonal Method Found. Example:
  X| | |
  --------
   |X| |
  --------
   | |X|
  */
  //printf("Found solution\n");
  return DeclareWinner(Boards[0][0]->TestForWinner());

  }
  else if(
    Boards[0][2]->TestForWinner() == Boards[1][1]->TestForWinner() &&
    Boards[0][2]->TestForWinner() == Boards[2][0]->TestForWinner() &&
    Boards[0][2]->TestForWinner() != nullptr
  )
  {
  //printf("TestForWinner(UTTT Game) Diag2\n");
/*
Winning Diagonal Method Found. Example:
   | |X|
  --------
   |X| |
  --------
  X| | |
  */
  //printf("Found solution\n");
    return DeclareWinner(Boards[0][2]->TestForWinner());
  }
  if(this->MovesRemaining == 0){
    WinningPlayer = Draw;
    //printf("No Remaining Moves\n");
    return WinningPlayer;
  }
  //printf("returning WinningPlayer\n");
  //printf("Reached End Returning nullptr:%p\n",WinningPlayer);
  return WinningPlayer;
}



std::vector<UTTT_Move*> UTTT::PossibleMoves()
{
  std::list<UTTT_Move*> moveList;

  if (NextMove_Row == -1 || NextMove_Col == -1) {
    for (int Row = 0; Row < 2; Row++) {
      for (int Col = 0; Col < 2; Col++) {
        std::vector<UTTT_Move*> GMoves = Boards[Row][Col]->PossibleMoves();

        for (GameMove* GMove : GMoves) { // Range-based for loop for C++11
          UTTT_Move* UTTT_GMove = static_cast<UTTT_Move*>(GMove);
          UTTT_GMove->GameRow = Row;
          UTTT_GMove->GameCol = Col;
          moveList.push_back(UTTT_GMove);
        }
      }
    }
  } else {
    std::vector<UTTT_Move*> SubGame_PossibleMoves = Boards[NextMove_Row][NextMove_Col]->PossibleMoves();
    if (!SubGame_PossibleMoves.empty()) {
      for (UTTT_Move* GMove : SubGame_PossibleMoves) {
        UTTT_Move* UTTT_GMove = GMove;
        UTTT_GMove->GameRow = NextMove_Row;
        UTTT_GMove->GameCol = NextMove_Col;
        moveList.push_back(UTTT_GMove);
      }
    } else {
      // Resetting next move and recursively calling PossibleMoves if no moves available
      NextMove_Row = -1;
      NextMove_Col = -1;
      return PossibleMoves();
    }
  }

  // Now transfer from list to vector with reserved space
  std::vector<UTTT_Move*> Moves;
  Moves.reserve(moveList.size());

  for (UTTT_Move* move : moveList) {
    Moves.push_back(move);
  }

  return Moves;
}


std::vector<UTTT*> UTTT::PossibleGames()
{
  std::vector<UTTT_Move*> Moves = PossibleMoves();
  std::vector<UTTT*>Games;
  UTTT* Branch;
  for (UTTT_Move* GMove : Moves) {
       Branch = this->CopyGame();
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
  while(TTTPlayer == nullptr){

    Currentplayer = Players.front();

    Move          = (*Currentplayer).MakeMove(this);
    this->Move(Move);
    delete Move;

    std::cout << this->Generate_StringRepresentation();
    TTTPlayer = static_cast<UTTT_Player*>(TestForWinner());
  }
}

UTTT_Move* UTTT::FindRandomMove(){
  UTTT_Move* Move;
  int Range;
  std::vector<UTTT_Move*>GameMoves = PossibleMoves();
  Range = GameMoves.size();
  if (Range==0) {
    return nullptr;
  }
  //printf("Range:%d\n",Range);
  Move          = get(GameMoves,(rand() % (Range)));
  Move = new UTTT_Move(*Move);
  //printf("Freeing memory\n");
  Free_UTTTMoveList(GameMoves);
  return Move;
}


//////////////////////////////////////////////////////////////////////////////
// MCTS/TreeSearch Functionality
//////////////////////////////////////////////////////////////////////////////
UTTT* UTTT::RollOut()
{
  //std::cout << Generate_StringRepresentation();
  //printf("Prefoming Rollout\n");
  while(WinningPlayer == nullptr){
    std::vector<UTTT_Move*>GameMoves = PossibleMoves();
    unsigned long Range = GameMoves.size();
    if(Range == 0){
      return nullptr;
    }
    //printf("Range:%d\n",Range);
    UTTT_Move *Move = get(GameMoves, (rand() % (Range)));
    //printf("Move:%p\n",Move);
    this->Move(Move);
    //printf("Freeing memory\n");
    Free_UTTTMoveList(GameMoves);
    //delete &GameMoves;
    //delete Move;

    //std::cout << this->Generate_StringRepresentation();
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









void SaveMovesToFile(const std::vector<UTTT_Move*>& RolloutMoves, const std::string& filename) {

  // Open an output file stream to write to a file
  std::ofstream outFile(filename, std::ios::app);

  // Check if the file was successfully opened
  if (!outFile.is_open()) {
    std::cerr << "Error: Could not open the file for writing!" << std::endl;
    return;
  }

  // Iterate through the moves and write to the file
  for (const UTTT_Move* p : RolloutMoves) {

    outFile  << p->GameRow << p->GameCol << p->Row << p->Col << ",";  // Write the row and column to the file

    // Conditionally print to the screen if PRINT_TO_SCREEN is defined
#ifdef PRINT_TO_SCREEN
    std::cout << p->GameRow << p->GameCol << p->Row << p->Col << ",";
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

#endif //UTTT_CU
