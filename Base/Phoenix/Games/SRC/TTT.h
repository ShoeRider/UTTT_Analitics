/*
====================================================================================================
Description TTT(Tic Tac Toe):
- Purpose:
Implement Tic Tac Toe through Game interface. Using standard rules.

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
*/

#ifndef TTT_H
#define TTT_H


//////////////////////////////////////////////////////////////////////////////
// Standard Libraries.
//////////////////////////////////////////////////////////////////////////////
#include <iostream>
#include <string>
#include <list>
#include <cstdlib>

//////////////////////////////////////////////////////////////////////////////
// Game Library for inheritance structure.
//////////////////////////////////////////////////////////////////////////////
#include "Game.cu"

struct GameMove;
struct Player;


class TTT;
class TTT_Player;
class TTT_Move;

#define Pause int ASDF; std::cin >> ASDF;

#endif //TTT_H
