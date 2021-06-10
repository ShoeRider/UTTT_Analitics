/*
Anthony M Schroeder


Purpose:
create a TreeSearch interface inorder to implement different types of tree
search methods.

Using a meathod called: Pure Virtual Functions.
*/

#include <string>
#include <iostream>


class TreeSearch
{
private:
  void* MLMethodPointer;
  public:
      TreeSearch(){}
      ~TreeSearch(){}

        //The following Methods use the 'Pure Virtual Function' method,
        //  where "= 0" part makes this method pure virtual,
        //  and also makes this class abstract.
      virtual void Search(int Depth) = 0;
      //virtual void PruneTree() = 0;


      //Ideas to implement MCTS and ML algorithms
      virtual void Give_MLMethodPointer() = 0;
      //virtual void Aggregate_Search() = 0;
      //virtual void Aggregate_BP() = 0;
};
