/*
====================================================================================================
Description TreeSearch:
Purpose:
Create a TreeSearch & TreeSimulation interface in order to implement and
integrate different Search Methods easily.
Using a method called: Pure Virtual Functions.
(Link:https://www.tutorialspoint.com/pure-virtual-functions-and-abstract-classes-in-cplusplus)

====================================================================================================
Date:           NA
Script Version: 1.0
Name:           Anthony M Schroeder
Email:          as3379@nau.edu
==========================================================
*/
#ifndef TREESEARCH_CU
#define TREESEARCH_CU

#include <string>
#include <iostream>

#include "../../Games/SRC/Game.cpp"
class TreeSimulation
{

  public:
      TreeSimulation(){}
      virtual ~TreeSimulation(){}

        //The following Methods use the 'Pure Virtual Function' method,
        //  where "= 0" part makes this method pure virtual,
        //  and also makes this class abstract.
      //virtual void Search(int Depth) = 0;
      //virtual void Search(int Depth) = 0;
      //virtual void PruneTree() = 0;

      //virtual void StepSimulation() = 0;
      //virtual void CopySimulation() = 0;
      //virtual void SaveSimulation() = 0;
      //virtual void ReadSimulation() = 0;

};

#endif //TREESEARCH_CU
