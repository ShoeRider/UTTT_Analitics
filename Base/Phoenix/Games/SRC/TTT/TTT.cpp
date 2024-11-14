/*
====================================================================================================
Description TTT(Tic Tac Toe):
Purpose:
  Implement Tic Tac Toe through Game interface. Using standard rules.
Contains(Classes):
  TTT_Player
  TTT_Move
  TTT
TODO:
  Add *Radio?* Player functionality: Takes Pointer to code -> Runs -> returns move
====================================================================================================
Date:           NA
Script Version: 1.0
Name:           Anthony M Schroeder
Email:          as3379@nau.edu
==========================================================
Date:           15 September 2021
Script Version: 1.1
Description: Remove Game* from TTT to create usable version for MCTS Templates.
==========================================================
Date:           21 September 2021
Script Version: 1.2
Description:
  Changed:
    - Player Pointers to TTT_Player.
    - GameMove Pointers to TTT_Move.
    TODO: Move:
      T* get(std::list<T*> _list, int _i)
      to new base library folder.
==========================================================
Date:           30 September 2021
Script Version: 1.3
Description:
  Added hash function to TTT class.
==========================================================
Date:           4 October 2021
Script Version: 1.4
Description:
  - Added JSON Read/Write Functionality using: nlohman JSON Library.
  - Changed File extension to CPP.
TODO: Change JSON Libary to compatable CUDA.
Possible interests:
- SIMDJSON (GitHub: https://github.com/simdjson/simdjson)
-
==========================================================
Date:           11 October 2021
Script Version: 1.4.01
Description:
  Changed File extension back to CU. attempting to compile with:
- SIMDJSON (GitHub: https://github.com/simdjson/simdjson)
TODO: Generalize JSON Saves to account for different Player Oders,
  IE: Player0 has different game representation than X.
==========================================================
Date:           20 October 2024
Script Version: 1.5
Description:
Modify TTT to support Binary Writer.
==========================================================
*/
#ifndef TTT_CPP
#define TTT_CPP


//////////////////////////////////////////////////////////////////////////////
// Game Library for inheritance structure.
//////////////////////////////////////////////////////////////////////////////

#include "TTT.h"

#include <iostream>
#include <fstream>

#include <cstring>

#include <iomanip>
#include <unordered_map>


//Read and save Game states.

//#include "TTT.cu"

//Move to Bit format.
#include <fstream>
#include <bitset>


//TODO Move to Basic Libaries
//Example:
/*
int a_size = sizeof(p->Board) / sizeof(char);
std::string str = convertToString(p->Board, a_size);
*/
std::string convertToString(char* a, int size)
{
    int i;
    std::string s = "";
    for (i = 0; i < size; i++) {
        s = s + a[i];
        //std::cout << a[i] << "\n";
    }
    //std::cout << s << "\n";
    return s;
}
/**
 * @brief Retrieve the element at a specific index in a list of pointers.
 *
 * This template function allows you to retrieve a pointer to an element at the given index
 * from a `std::list` of pointers. The function iterates through the list and returns a pointer
 * to the element at the specified index.
 *
 * @tparam T The type of the elements pointed to in the list.
 * @param _list The list of pointers to elements of type T.
 * @param _i The zero-based index of the element you wish to retrieve.
 * @return T* A pointer to the element at the given index, or undefined behavior if the index is out of bounds.
 *
 * @note The index is zero-based, meaning that 0 refers to the first element in the list.
 *       If `_i` is greater than or equal to the size of the list, it will result in undefined behavior.
 *
 * @example
 * // Define a list of integers and retrieve the element at index 2.
 * std::list<int*> numbers;
 * numbers.push_back(new int(10));
 * numbers.push_back(new int(20));
 * numbers.push_back(new int(30));
 *
 * int* thirdElement = get(numbers, 2); // Retrieves the element at index 2 (30)
 * std::cout << *thirdElement << std::endl; // Output: 30
 *
 * // Clean up memory
 * for (auto& num : numbers) {
 *     delete num;
 * }
 */
template <typename T>
T* get(std::list<T*> _list, int _i){
    typename std::list<T*>::iterator it = _list.begin();
    for(int i = 0; i<_i; i++){
        ++it;
    }
    return *it;
}





/*
TTT_Move
Purpose: A Helper class to hold the potential move data for a TTT Game.
  IE: X,Y coordinates. And possibly a Player Pointer.


@Methods:
  No Methods.  Intended to act as a Command pattern.
  TTT_Move to be integrated with ML Model to select move.
 */
struct TTT_Move : public GameMove
{

  public:
    int Row;
    int Col;
    //////////////////////////////////////////////////////////////////////////////
    // Initialization method.
    TTT_Move(int GivenRow,int GivenCol){
      Row = GivenRow;
      Col = GivenCol;
    }
    std::tuple<std::size_t, const char*>  convertToBinary();
    bool convertFromBinary(std::size_t, const char*);
    virtual ~TTT_Move(){}
};

std::tuple<std::size_t, const char*> TTT_Move::convertToBinary()
{
  std::size_t dataSize = sizeof(TTT_Move);
  const char* byteArray = reinterpret_cast<const char*>(this);
  return std::make_tuple(dataSize,byteArray);
}

bool TTT_Move::convertFromBinary(std::size_t size, const char* byteArray)
{
  std::size_t dataSize = sizeof(TTT_Move);

  // Check if the size of the provided binary data matches the size of TTT_Move
  if (size != dataSize) {
    return false; // Size mismatch, can't safely convert
  }

  // Copy the binary data into the object
  std::memcpy(reinterpret_cast<void*>(this), byteArray, dataSize);

  return true; // Successful conversion
}

/*
TTT_Player
@Purpose: Class to track TTT Players.
@Methods:
  MakeMove() function pointer to allow for Humans to play.
*/
struct TTT_Player : public Player
{
  public:
    //////////////////////////////////////////////////////////////////////////////
    // Game Data
    //////////////////////////////////////////////////////////////////////////////
    int PlayerNumber;
    char GameRepresentation;
    bool HumanPlayer;

    //////////////////////////////////////////////////////////////////////////////
    // Initialization method.
    TTT_Player(){}

  TTT_Player(int GivenPlayer,char GivenGameRepresentation, bool Human){
      PlayerNumber = GivenPlayer;
      GameRepresentation = GivenGameRepresentation;
      HumanPlayer = Human;
    }

    //////////////////////////////////////////////////////////////////////////////
    //
   TTT_Player(int GivenPlayer,char GivenGameRepresentation){
    PlayerNumber = GivenPlayer;
    GameRepresentation = GivenGameRepresentation;
    HumanPlayer = false;
  }

  ~TTT_Player(){}
   TTT_Move* MakeMove(TTT* GivenGame);
   void Display();
   std::size_t Hash();

   void Save(std::string FilePath);
};

std::size_t TTT_Player::Hash(){
  //std::size_t HashSum;
  //std::string GameState = convertToString(k->Board,9);
  //HashSum = (std::hash<std::char>());

  return (int)(GameRepresentation);
}

//////////////////////////////////////////////////////////////////////////////
// Move Method for human players.
// TODO: integrate with command pattern, allowing for ML Models to select moves.
//TTT_Move doesnt need to be returned, TTTMove should be applied to Game here.
TTT_Move* TTT_Player::MakeMove(TTT* GivenGame)
{
   int X,Y;
   std::cout << "Please Enter X Axis: ";
   std::cin >> X;
   std::cout << "Please Enter Y Axis: ";
   std::cin >> Y;
   TTT_Move* TTTMove = new TTT_Move(X,Y);
   //TTT_Move* Move = static_cast<TTT_Move*>(TTTMove);

   //TODO: Include Move call here
   //GivenGame->Move(TTTMove);
   return TTTMove;
}

void TTT_Player::Display()
{
   //GameMove TTTPlayer = static_cast<GameMove>(TTT_Move(0,0));
   printf("PlayerNumber:%d\n",PlayerNumber);
   printf("GameRepresentation:%c\n",GameRepresentation);
   printf("HumanPlayer:%d\n",HumanPlayer);
}



void Free_TTTMoveList(std::list<TTT_Move*> GameMoves)
{
    // Iterate through the list of TTT_Move* pointers
    for (TTT_Move* GMove : GameMoves) {
        delete GMove;  // Free the memory for TTT_Move
    }
}



TTT_Player* CreateHuman_TTT_Player(int PlayerID, char PlayerCharacter){
  TTT_Player* Player = new TTT_Player(PlayerID,PlayerCharacter);
  // Change Player->Move pointer to request input.
  return Player;
}












/*
TTT(Tic Tac Toe):
Implement Tic Tac Toe through Game interface. Using standard rules.

@Methods:
Search()
Algorithm():: A recursive implementation of the MCTS algorithm. Recursively creates a serach tree based on the MCTS, searching for the most optimal move.

 * @param
    Game*_Game,
    std::list<Player*> _GivenPlayers)

 *
 * @see MCTS_Node::Find_MAX_UCB1_Child()
 * @see Game interface(Found within Game.cu)

*/
class TTT : public Game
{
protected:


public:
  //////////////////////////////////////////////////////////////////////////////
  // Player(s) DATA
  //TODO: Take Draw player during Initialization.
  //////////////////////////////////////////////////////////////////////////////
  TTT_Player* Draw ;

  std::list<TTT_Player*> Players;
  TTT_Player*  WinningPlayer = nullptr;

  //////////////////////////////////////////////////////////////////////////////
  // Game Data
  //////////////////////////////////////////////////////////////////////////////
  //MovesRemaining is a decrementing counter to determine if there are any remaining moves.
  int MovesRemaining;
  int MovesMade;  //TODO, Implement MovesMade
  bool isGameFinished;
  //Represenation of the game.
  //char Board[3][3];
  //TTTMove->Row*3+TTTMove->Col
  char Board[9];
  std::size_t GameHash;



  //std::string SaveGameMoves;

  //////////////////////////////////////////////////////////////////////////////
  // Initialization method.
  TTT(){
    //printf("Calling Default Constructor... \n");
    //throw "Calling Default Constructor... \n";


  }



  TTT(std::list<TTT_Player*> GivenPlayers){
      Draw = new TTT_Player(-1, 'C');
      //this->DeclarePlayers(GivenPlayers);
      Players = GivenPlayers;
      this->WinningPlayer  = NULL;
      MovesRemaining       = 9;

      isGameFinished = false;
      this->SetUpBoard();
      GameHash = this->Hash();
      //std::cout<< "GameHash:" << GameHash <<"\n";
    }
    virtual ~TTT(){

    }

    //////////////////////////////////////////////////////////////////////////////
    // Method Declarations.
    //////////////////////////////////////////////////////////////////////////////
    TTT_Player* GetWinner();
    void DisplayWinner();
    void DeclarePlayers(std::list<TTT_Player*> GivenPlayers);
    void PrintPlayers();
    void SetUpBoard();

    void RotatePlayers();
    bool Move(TTT_Move* Move);
    TTT* Move_ReturnNewGame(TTT_Move* Move);

    bool ValidMove(GameMove* Move);
    TTT_Player* TestForWinner();

    std::list<TTT_Move*> PossibleMoves();
    std::list<TTT*>     PossibleGames();
    std::list<TTT*>     PossibleGames(std::list<TTT_Move*> Moves);
    std::string Generate_StringRepresentation();

    TTT_Player* DeclareWinner(TTT_Player* Winner);
    char GetWinnersCharacter();
    //void DisplayInTerminal();
    TTT_Move* FindRandomMove();
    TTT* RollOut();
    std::list<TTT_Move> RollOut_ReturnGameMoves();
    void PlayGame();
    //hash<TTT> GenerateHash(std::list<TTT_Player*> GivenPlayers);
    bool equal(TTT* OtherGame);

    uint16_t MoveToBits(TTT_Move* Move);
    uint16_t CharToBits(char c);
    char BitsToChar(uint8_t bits);
    std::size_t Hash();


    TTT* CopyGame();

};

//#include<bits/stdc++>
//template< class Key >
//struct hash<class template>;



std::size_t TTT::Hash(){
  std::size_t HashSum;
  std::string GameState = convertToString(this->Board,9);
  //std::cout << GameState <<"\n";
  HashSum = (std::hash<std::string>()(GameState));
  //std::cout << HashSum <<"\n";

/*
int Position = 0;
for (TTT_Player* Player: this->Players) { // c++11 range-based for loop
  Position+=1;
  HashSum += Player->Hash()*Position;
}*/
  GameHash = HashSum;
  return HashSum;
}




void TTT::SetUpBoard()
{
  for (int EachPositions = 0; EachPositions < 9; EachPositions++)
  {
    Board[EachPositions] = ' ';
  }
}



void TTT::DeclarePlayers(std::list<TTT_Player*> GivenPlayers)
{
  //printf("Adding Players\n");
  for (TTT_Player* i : GivenPlayers) { // c++11 range-based for loop
      TTT_Player* TTTPlayer = static_cast<TTT_Player*>(i);
      Players.push_back(TTTPlayer);
      //_Players.push_back(i);
    }
}

void TTT::PrintPlayers()
{
  //printf("Adding Players\n");
  for (TTT_Player* i : Players) { // c++11 range-based for loop
    printf("     GivenPlayer:%p\n",i);
    printf("     PlayerREP:%c\n",i->GameRepresentation);
  }
}

void TTT::RotatePlayers(){
  Players.splice(Players.end(),        // destination position
                 Players,              // source list
                 Players.begin());     // source position

};


//////////////////////////////////////////////////////////////////////////////
// Game Functionality
//////////////////////////////////////////////////////////////////////////////

bool TTT::ValidMove(GameMove* Move)
{
  TTT_Move* TTTMove = static_cast<TTT_Move*>(Move);
  //printf("TTT MovesRemaining:%d\n",MovesRemaining);
  if(MovesRemaining == 0 ){
    DeclareWinner(Draw);
    return false;
  }

  //printf("TTTMove->Row:%d\n",TTTMove->Row);
  //printf("TTTMove->Col:%d\n",TTTMove->Col);
  //printf("Board[TTTMove->Row][TTTMove->Col]:%c\n",Board[TTTMove->Row][TTTMove->Col]);
  if (Board[TTTMove->Row*3+TTTMove->Col] == ' ')
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


bool TTT::Move(TTT_Move* TTTMove)
{
  if (this->ValidMove(TTTMove))
  {
    MovesRemaining--;

    // move first element to the end
    Board[TTTMove->Row*3+TTTMove->Col] = Players.front()->GameRepresentation;
    TestForWinner();
    RotatePlayers();
    return true;
  }
  return false;
}

TTT* TTT::Move_ReturnNewGame(TTT_Move* TTTMove)
{
    // Create a new game object as a copy of the current game (deep copy)
    TTT* newGame = static_cast<TTT*>(new TTT(*this));  // Use copy constructor to clone the current game

    // Check if the move is valid on the new game object
    if (newGame->ValidMove(TTTMove))
    {
        newGame->MovesRemaining--;  // Decrease the moves remaining

        // Make the move on the new game board
        newGame->Board[TTTMove->Row * 3 + TTTMove->Col] = newGame->Players.front()->GameRepresentation;

        // Test for winner on the new game object
        newGame->TestForWinner();

        // Rotate players for the next turn
        newGame->RotatePlayers();

        // Return the new game (as a pointer to Game)
        return newGame;  // Return as Game* (pointer to base class)
    }

    // If the move is not valid, clean up and return null
    delete newGame;  // Clean up if invalid move
    return nullptr;  // Return nullptr to signal failure
}



void TTT::DisplayWinner(){
  printf("WinningPlayer:%p\n",WinningPlayer);
  if(this->WinningPlayer != NULL){
    TTT_Player* TTTPlayer = static_cast<TTT_Player*>(WinningPlayer);
    printf("Player %c Has won!",TTTPlayer->GameRepresentation);
  }

};


std::string TTT::Generate_StringRepresentation()
{

  std::string Game = "Winner: ";

  if (WinningPlayer != NULL){
    //Convert from Generic Player to TTT_Player Structure
    TTT_Player* TTTPlayer = static_cast<TTT_Player*>(WinningPlayer);

    Game += (TTTPlayer->GameRepresentation); //Use '+=' when appending a char
  }
  else{
    Game.append("C");
  }

  Game.append("\n");
  for (int Row = 0; Row < 3; Row++)
  {
    for (int Col = 0; Col < 3; Col++)
    {
        char position = Board[Row*3+Col];
        //Game.append(&position);
        Game.push_back(position);
        Game.append("|");
    }
    Game.append("\n--------\n");
  }
  return Game;
}

TTT_Player* TTT::DeclareWinner(TTT_Player* GivenWinner)
{
  if(WinningPlayer == nullptr){
    //Player* Winner = static_cast<Player*>(GivenWinner);
    WinningPlayer=GivenWinner;
    isGameFinished = true;
    //std::cout << this->Generate_StringRepresentation();
    //printf("WinningPlayer:%p\n",WinningPlayer);

  }
  return GetWinner();
}


char TTT::GetWinnersCharacter()
{
  TTT_Player* Winner = TestForWinner();
  if(Winner != NULL)
  {
  return static_cast<TTT_Player*>(TestForWinner())->GameRepresentation;
  }
  else{
    return ' ';
  }
}


TTT_Player* TTT::GetWinner(){
  return (WinningPlayer);
};

// Returns True/False If Winner is found
TTT_Player* TTT::TestForWinner()
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
      return this->DeclareWinner(Players.front());

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
      return this->DeclareWinner(Players.front());

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
      return this->DeclareWinner(Players.front());

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
      return this->DeclareWinner(Players.front());
  }

  if(this->MovesRemaining == 0){
    //return WinningPlayer;
    return this->DeclareWinner(Draw);
  }
  return WinningPlayer;
}


std::list<TTT_Move*> TTT::PossibleMoves()
{
    std::list<TTT_Move*> Moves;  // This will store GameMove pointers

    // Iterate over the board and check for empty spots
    for (int Row = 0; Row < 3; Row++)
    {
        for (int Col = 0; Col < 3; Col++)
        {
            if (Board[Row * 3 + Col] == ' ')
            {
                // Create a new TTT_Move object for the valid move
                TTT_Move* TTTMove = new TTT_Move(Row, Col);

                // Cast TTT_Move* to TTT_Move* and add it to the list
                Moves.push_back(TTTMove);
            }
        }
    }
    return Moves;  // Return the list of possible moves as GameMove pointers
}


std::list<TTT*> TTT::PossibleGames()
{
  std::list<TTT_Move*> Moves = PossibleMoves();
  std::list<TTT*>Games;
  TTT* Branch;
  for (TTT_Move* GMove : Moves) { // c++11 range-based for loop
       Branch = new TTT(*this);
       Branch->Move(GMove);
       Games.push_back(Branch);
       //Free each Move Structure
/*
printf("%p\n",&(Branch));
printf("Create Instance->Players:%p\n",(Branch->_Players));
printf("PossibleGames's Players:%p\n",&(Branch->_Players));
for (Player* _Pl : Branch->_Players){
      printf("\t:%p\n",(_Pl));
}
*/
       delete GMove;
    }
  //printf("Freeing Moves list \n");
  //delete &Moves;
  return Games;
}


std::list<TTT*> TTT::PossibleGames(std::list<TTT_Move*> Moves)
{
  std::list<TTT*>Games;
  TTT* Branch;
  for (TTT_Move* GMove : Moves) { // c++11 range-based for loop
       Branch = new TTT(*this);
       Branch->Move(GMove);
       Games.push_back(Branch);
       //Free each Move Structure
       delete GMove;
    }
  //printf("Freeing Moves list \n");
  //delete &Moves;
  return Games;
}




bool TTT::equal(TTT* OtherGame)
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

TTT_Move* TTT::FindRandomMove(){
  TTT_Move* Move;
  int Range;
    std::list<TTT_Move*>GameMoves = PossibleMoves();
    Range = GameMoves.size();
    //printf("Range:%d\n",Range);
    Move          = get(GameMoves,(rand() % (Range)));
    Move = new TTT_Move(*Move);
    //printf("Freeing memory\n");
    Free_TTTMoveList(GameMoves);
    return Move;
}


TTT* TTT::RollOut(){
  TTT_Move* Move;
  int Range;

  //TTT_Player* TTTPlayer = static_cast<TTT_Player*>(TestForWinner());
  while(WinningPlayer == nullptr){

    //TTTPlayer = static_cast<TTT_Player*>(TestForWinner());
    std::list<TTT_Move*>GameMoves = PossibleMoves();
    Range = GameMoves.size();
    //printf("Range:%d\n",Range);
    Move          = get(GameMoves,(rand() % (Range)));
    this->Move(Move);
    //printf("Freeing memory\n");
    Free_TTTMoveList(GameMoves);
    //delete &GameMoves;
    //delete Move;

    //std::cout << this->Generate_StringRepresentation();
    //TTTPlayer = static_cast<TTT_Player*>(TestForWinner());
  }
  //printf("WinningPlayer:%p\n",WinningPlayer);
  return this;
}

std::list<TTT_Move> TTT::RollOut_ReturnGameMoves(){
  std::list<TTT_Move> GameHistory;
  TTT_Move* Move;
  int Range;
  //TTT_Player* TTTPlayer = static_cast<TTT_Player*>(TestForWinner());
  while(WinningPlayer == NULL){

    //TTTPlayer = static_cast<TTT_Player*>(TestForWinner());
    std::list<TTT_Move*>GameMoves = PossibleMoves();
    Range = GameMoves.size();
    //printf("Range:%d\n",Range);
    Move          = get(GameMoves,(rand() % (Range)));
    GameHistory.push_back(*Move);
    this->Move(Move);
    //printf("Freeing memory\n");
    Free_TTTMoveList(GameMoves);
  }
  return GameHistory;
}

void TTT::PlayGame()
{
  TTT_Move* Move;
  TTT_Player* Currentplayer;

  TTT_Player* TTTPlayer = static_cast<TTT_Player*>(TestForWinner());
  while(!isGameFinished){
    Currentplayer = Players.front();

    Move          = (*Currentplayer).MakeMove(this);
    this->Move(Move);
    delete Move;

    std::cout << this->Generate_StringRepresentation();
    //TTTPlayer = static_cast<TTT_Player*>(TestForWinner());
  }
}

TTT* TTT::CopyGame() {
  	//return static_cast<Game*>(new TTT(*this));
  	return new TTT(*this);
}






// Helper function to create unit8 move representation.
uint16_t TTT::MoveToBits(TTT_Move* Move) {
    /*
    int Row;
    int Col;
    */

    return 0b00;                // empty = 00
}


// Helper function to convert char to 2-bit representation
uint16_t TTT::CharToBits(char c) {
    if (c == 'X'){
        std::cout << "--> " << 0b01 << std::endl;
      return 0b01;
    }  // X = 01

    if (c == 'O'){
        std::cout << "--> " << 0b10 << std::endl;
     return 0b10;
    }  // O = 10

    return 0b00;                // empty = 00
}

// Helper function to convert 2-bit representation to char
char TTT::BitsToChar(uint8_t bits) {
    if (bits == 0b01) return 'X';
    if (bits == 0b10) return 'O';
    return ' ';
}

std::string ToBinaryString(uint32_t value, int bitSize) {
    return std::bitset<32>(value).to_string().substr(32 - bitSize, bitSize);
}






// Assuming TTT_Move has Row and Col as public members
void SaveMovesToFile(const std::list<TTT_Move*>& RolloutMoves, const std::string& filename) {

  // Open an output file stream to write to a file
  std::ofstream outFile(filename, std::ios::app);

  // Check if the file was successfully opened
  if (!outFile.is_open()) {
    std::cerr << "Error: Could not open the file for writing!" << std::endl;
    return;
  }

  // Iterate through the moves and write to the file
  for (const TTT_Move* p : RolloutMoves) {

    outFile << p->Row << p->Col << ",";  // Write the row and column to the file

    // Conditionally print to the screen if PRINT_TO_SCREEN is defined
#ifdef PRINT_TO_SCREEN
    std::cout << p->Row << p->Col << ",";
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


#endif //TTT_CPP
