/*
Anthony M Schroeder


Purpose:
Create a TreeSearch & TreeSimulation interface in order to implement and
integrate different Search Methods easily.

Using a method called: Pure Virtual Functions.
(Link:https://www.tutorialspoint.com/pure-virtual-functions-and-abstract-classes-in-cplusplus)

*/

#include <string>
#include <iostream>

class TreeSimulation
{
private:
  void* MLMethodPointer;
  public:
      TreeSimulation(){}
      ~TreeSimulation(){}

        //The following Methods use the 'Pure Virtual Function' method,
        //  where "= 0" part makes this method pure virtual,
        //  and also makes this class abstract.
      virtual void RollOut()          = 0;
      virtual void RollOut(int Depth) = 0;
      //virtual void PruneTree() = 0;

      virtual void StepSimulation() = 0;
      virtual void CopySimulation() = 0;
      virtual void SaveSimulation() = 0;
      virtual void ReadSimulation() = 0;

};


class SimulationTreeSearch
{
  private:
    void* MLMethodPointer;
    TreeSimulation* Simulation;
  public:
      SimulationTreeSearch(){}
      SimulationTreeSearch(TreeSimulation* Simulation){}
      ~SimulationTreeSearch(){}

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
