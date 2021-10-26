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
  Fix Memory Leak.
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
*/
#ifndef TTT_CU
#define TTT_CU


//////////////////////////////////////////////////////////////////////////////
// Game Library for inheritance structure.
//////////////////////////////////////////////////////////////////////////////
#include "TTT.h"

#include <iostream>
#include <fstream>
#include "../../ExternalLibraries/json-develop/single_include/nlohmann/json.hpp"
#include <iomanip>




/*
TTT_Move
Purpose: A Helper class to hold the potential move data for a TTT Game.
  IE: X,Y coordinates. And possibly a Player Pointer.


@Methods:
  No Methods.  Intended to only hold move data.
 */
struct TTT_Move : public GameMove
{

  public:
    int Row;
    int Col;

    TTT_Move(int GivenRow,int GivenCol){
      Row = GivenRow;
      Col = GivenCol;
    }
    virtual ~TTT_Move(){}
};
template <typename T>
T* get(std::list<T*> _list, int _i){
    typename std::list<T*>::iterator it = _list.begin();
    for(int i = 0; i<_i; i++){
        ++it;
    }
    return *it;
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
    int PlayerNumber;
    char GameRepresentation;
    bool HumanPlayer;


    TTT_Player(){}
    TTT_Player(nlohmann::json &j){
      //char digits[] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9' };
      //GameRepresentation = digits[iChar];
      int iChar = j["GameRepresentation"];
      //j["GameRepresentation"]
      //std::string value = j["PlayerNumber"].get<std::string>().c_str();
      PlayerNumber = j["PlayerNumber"];//char
      HumanPlayer = j["HumanPlayer"];//char
      GameRepresentation = (char)iChar;

      Display();

    }
   TTT_Player(int GivenPlayer,char GivenGameRepresentation){
    PlayerNumber = GivenPlayer;
    GameRepresentation = GivenGameRepresentation;
    HumanPlayer = false;
  }
  ~TTT_Player(){}
   TTT_Move* MakeMove(TTT* GivenGame);
   void Display();
};

TTT_Move* TTT_Player::MakeMove(TTT* GivenGame)
{
   //GameMove TTTPlayer = static_cast<GameMove>(TTT_Move(0,0));

   int X,Y;
   std::cout << "Please Enter X Axis: ";
   std::cin >> X;
   std::cout << "Please Enter Y Axis: ";
   std::cin >> Y;
   TTT_Move* TTTMove = new TTT_Move(X,Y);
   //GameMove* Move = static_cast<GameMove*>(TTTMove);

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
  //std::list<GameMove*> Moves = PossibleMoves();
  for (TTT_Move* GMove : GameMoves) { // c++11 range-based for loop
      //TTT_Move* Move = static_cast<TTT_Move*>(GMove);
      delete GMove;
    }
}


TTT_Player* CreateHuman_TTT_Player(int PlayerID, char PlayerCharacter){
  TTT_Player* Player = new TTT_Player(PlayerID,PlayerCharacter);
  // Change Player->Move pointer to request input.
  return Player;
}


void Add(nlohmann::json &j,   TTT_Player &p) {
  //nlohmann::json data;
  printf("p.GameRepresentation:%c\n",p.GameRepresentation);
    printf("p.GameRepresentation(int):%d\n",p.GameRepresentation);
      printf("p.GameRepresentation(int):%c\n",(char)79);
    Pause;
    j = nlohmann::json::object({
      {"PlayerNumber", p.PlayerNumber},
      {"HumanPlayer", p.HumanPlayer},
      {"GameRepresentation", p.GameRepresentation}
    });

/*
char Test = 'O';
  printf("Test:%c\n",Test);

  printf("p.GameRepresentation:%c\n",p.GameRepresentation);
  j = nlohmann::json{
      {"PlayerNumber",  p.PlayerNumber},
      {"HumanPlayer",  p.HumanPlayer},
      {"GameRepresentation", p.GameRepresentation}};
      */
    //return data;
}


nlohmann::json Json(TTT_Player &p) {
  nlohmann::json data;
  Add(data,p);
  return data;
}

/*
void from_json(const nlohmann::json &j, TTT_Player &p) {

  j.at("PlayerNumber").get_to(p.PlayerNumber);
  j.at("HumanPlayer").get_to(p.HumanPlayer);
  j.at("GameRepresentation").get_to(p.GameRepresentation);
}
*/








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
  TTT_Player Draw    = TTT_Player(-1,'C');

  std::list<TTT_Player*> Players;
  TTT_Player*  WinningPlayer = NULL;

  //////////////////////////////////////////////////////////////////////////////
  // Game Data
  //////////////////////////////////////////////////////////////////////////////
  //MovesRemaining is a decrementing counter to determine if there are any remaining moves.
  int MovesRemaining;
  int MovesMade;  //TODO, Implement MovesMade
  //Represenation of the game.
  //char Board[3][3];
  //TTTMove->Row*3+TTTMove->Col
  char Board[9];



  //////////////////////////////////////////////////////////////////////////////
  // Initialization method.
  TTT(){
    //printf("Calling Default Constructor... \n");
    //throw "Calling Default Constructor... \n";
  }

  //////////////////////////////////////////////////////////////////////////////
  // JSON Initialization method(Reading from file).
  TTT(nlohmann::json &j){

    //////////////////////////////////////////////////////////////////////////////
    // For Each Player within JSON file, place back within Players list.
    // NOTE: When Saving TTT Players to JSON file, the order is swapped(The
    //   First player is at the bottom of the list); the for loop automatically
    //   adds the players back into the order(The first player within the JSON
    //   file becomes the last player within the Player order).
    for (nlohmann::json ji: j["Players"]) { // c++11 range-based for loop
      Players.push_back(new TTT_Player(ji));
    }

    //std::string value = J_Game["Board"].get<std::string>();
    //Board = J_Game["Board"].get<std::string>().c_str();
    strcat(Board, j["Game"]["Board"].get<std::string>().c_str());
  }

  TTT(std::list<TTT_Player*> GivenPlayers){
      //this->DeclarePlayers(GivenPlayers);
      Players = GivenPlayers;
      this->WinningPlayer  = NULL;
      MovesRemaining       = 9;
      this->SetUpBoard();
    }
    virtual ~TTT(){
      for (TTT_Player* Player: Players) { // c++11 range-based for loop
        //free(Player);
        delete Player;
      }
    }

    //////////////////////////////////////////////////////////////////////////////
    // Method Declarations.
    //////////////////////////////////////////////////////////////////////////////
    TTT_Player* GetWinner();
    void DisplayWinner();
    void DeclarePlayers(std::list<TTT_Player*> GivenPlayers);
    void SetUpBoard();
    TTT* CopyGame();
    void RotatePlayers();
    bool Move(GameMove* Move);

    bool ValidMove(GameMove* Move);
    TTT_Player* TestForWinner();

    std::list<TTT_Move*> PossibleMoves();
    std::list<TTT*>     PossibleGames();
    std::string Generate_StringRepresentation();

    TTT_Player* DeclareWinner(TTT_Player* Winner);
    char GetWinnersCharacter();
    //void DisplayInTerminal();
    TTT* RollOut();
    void PlayGame();
    //hash<TTT> GenerateHash(std::list<TTT_Player*> GivenPlayers);

    void Save(std::string LogPath);
    void Read(std::string LogPath);
};

//#include<bits/stdc++>
//template< class Key >
//struct hash<class template>;

#include <unordered_map>


template <>
struct std::hash<TTT>
{
  std::size_t Hash(TTT* k) const
  {
    using std::size_t;
    using std::hash;
    using std::string;
    std::string GameState;

    // Compute individual hash values for first,
    // second and third and combine them using XOR
    // and bit shifting:
    std::size_t Itteration = 0;
    std::size_t Sum = 0;
/*
for (int Row = 0; Row < 3; Row++)
{
  for (int Col = 0; Col < 3; Col++)
  {
    GameState += k->Board[Row][Col];
  }
}*/

    Itteration = (hash<char*>()(k->Board));
    Sum        += Itteration;
    //printf("Itteration:'%s':/8 %zu\n",GameState.c_str(),Itteration);
    //printf("Sum: %zu\n",Sum);
    //printf("----------------------------\n");

    //return ((
    //         ^ (hash<string>()(k.second) << 1)) >> 1)
    //         ^ (hash<int>()(k.third) << 1);
    return Itteration;
  }
};




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


void TTT::RotatePlayers(){
  Players.splice(Players.end(),        // destination position
                 Players,              // source list
                 Players.begin());     // source position
// _Players.splice(_Players.end(),        // destination position
//                _Players,              // source list
//                _Players.begin());     // source position
};


//////////////////////////////////////////////////////////////////////////////
// Game Functionality
//////////////////////////////////////////////////////////////////////////////

bool TTT::ValidMove(GameMove* Move)
{
  //printf("TTT MovesRemaining:%d\n",MovesRemaining);
  if(MovesRemaining == 0 ){
    DeclareWinner(&Draw);
    return false;
  }

  TTT_Move* TTTMove = static_cast<TTT_Move*>(Move);

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


bool TTT::Move(GameMove* Move)
{
  TTT_Move* TTTMove = static_cast<TTT_Move*>(Move);

  if (this->ValidMove(Move))
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
        Game.append(&position);
        Game.append("|");
    }
    Game.append("\n--------\n");
  }
  return Game;
}

TTT_Player* TTT::DeclareWinner(TTT_Player* GivenWinner)
{
  if(WinningPlayer == NULL){
    //Player* Winner = static_cast<Player*>(GivenWinner);
    WinningPlayer=GivenWinner;
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
  if(
    WinningPlayer == &Draw ||
    WinningPlayer != NULL
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
    WinningPlayer = &Draw;
    return WinningPlayer;
  }
  return WinningPlayer;
}


std::list<TTT_Move*> TTT::PossibleMoves()
{
  std::list<TTT_Move*>Moves;

  //GameMove TTTPlayer = static_cast<GameMove>(TTT_Move(0,0));
  for (int Row = 0; Row < 3; Row++)
  {
    for (int Col = 0; Col < 3; Col++)
    {
        if (Board[Row*3+Col] == ' ')
        {
          TTT_Move* TTTMove = new TTT_Move(Row,Col);
          //GameMove* Move = static_cast<GameMove*>(TTTMove);
          Moves.push_back(TTTMove);
        }
    }
  }
  return Moves;
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


TTT* TTT::CopyGame(){
  return (new TTT(*this));
}






TTT* TTT::RollOut(){
  GameMove* Move;
  int Range;

  //TTT_Player* TTTPlayer = static_cast<TTT_Player*>(TestForWinner());
  while(WinningPlayer == NULL){

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

void TTT::PlayGame()
{
  GameMove* Move;
  TTT_Player* Currentplayer;

  TTT_Player* TTTPlayer = static_cast<TTT_Player*>(TestForWinner());
  while(TTTPlayer == NULL){
    Currentplayer = Players.front();

    Move          = (*Currentplayer).MakeMove(this);
    this->Move(Move);
    delete Move;

    //std::cout << this->Generate_StringRepresentation();
    TTTPlayer = static_cast<TTT_Player*>(TestForWinner());
  }
}








//////////////////////////////////////////////////////////////////////////////
// Save and Read from Files using JSON.
//////////////////////////////////////////////////////////////////////////////

/*
#include<jsoncpp/json/value.h>
#include<jsoncpp/json/json.h>
//#include <json.h>
#include <iostream>
#include <fstream>
#include <string>
*/




void JSON_ExampleRead(){
  nlohmann::json data;
  std::ifstream file("../../Files/Example01.json");
  file >> data;
}


void JSON_ExampleWrite(){
  nlohmann::json data;
  data["M_final"] = std::vector<double>(1);
  data["beta"]    = 10.0;
/*
nlohmann::json data = R"(
    {
        "happy": true,
        "pi": 3.141
    }
)"_json;
*/
  std::ofstream file("Test01.json");
  file << std::setw(4) << data << std::endl;
}



void Add(nlohmann::json &j, TTT &p) {
    j = nlohmann::json{
        {"Board",  p.Board},
        {"MovesRemaining", p.MovesRemaining}};
}

nlohmann::json Json(TTT &p) {
  nlohmann::json data;
  Add(data,p);
  return data;
}




void TTT::Save(std::string LogPath){
  nlohmann::json data;

  data["Game"]=Json(*this);

  //nlohmann::json JsonObjects;
  data["Players"] = nlohmann::json::array();
  //nlohmann::json Player;

  //////////////////////////////////////////////////////////////////////////////
  // For Each Player within JSON file, place Players into list.
  // NOTE: When Saving TTT Players to JSON file, the order is swapped(The First
  //   player is at the bottom of the list). Reading the JSON file for loop
  //   automatically adds the players back into the correct order(The first
  //   player within the JSON file becomes the last player within the Player order).
  for (TTT_Player* i : this->Players) { // c++11 range-based for loop
    //Player = (const TTT &)* i;
    data["Players"].push_back(Json(*i));
  }

  std::ofstream file(LogPath);
  file << std::setw(4) << data << std::endl;
}


TTT* Read_TTT_JSON(std::string LogPath){
    //nlohmann::json data;
    //std::ifstream file(LogPath);
    //file >> data;
    std::ifstream ifs(LogPath);
    nlohmann::json jf = nlohmann::json::parse(ifs);
    TTT *_Game = new TTT(jf);


    //TTT* p = (TTT*)malloc( sizeof(TTT) );

    //TTT p = jf.at("Game");

    _Game->Generate_StringRepresentation();
    return _Game;
}









#endif //TTT_CU
