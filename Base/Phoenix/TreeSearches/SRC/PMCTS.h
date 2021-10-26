#ifndef PMCTS_H
#define PMCTS_H

#include <thread>
#include <iostream>
#include <string>
#include <list>
#include <cmath>
#include <bits/stdc++.h>
#include <chrono>
#include <thread>



#include <mutex>



#include <fstream>

#include "TreeSearch.cpp"
#include "../SRC/MCTS.cpp"
//#include "../../ThreadingTools/SRC/ThreadingTools.cpp"
#include "../../ExternalLibraries/json-develop/single_include/nlohmann/json.hpp"


template <typename Game_Tp, typename Player_Tp>
class PMCTS_Node;


template <typename Game_Tp, typename Player_Tp>
struct PMCTS_ThreadData_t {

    //////////////////////////////////////////////////////////////////////////////
    // Thread Serach Data
    //////////////////////////////////////////////////////////////////////////////
    pthread_t Thread;
    double Threads;
    double Depth;
    bool Finished;

    //////////////////////////////////////////////////////////////////////////////
    // Game & Tree Data
    //////////////////////////////////////////////////////////////////////////////
    PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode;
    std::list<Player_Tp*> StartingPlayer;

};

class TTT_Move;

template <typename Game_Tp, typename Player_Tp>
void * PMCTS_Search_thread(void* GivenPMCTS_ThreadData);
template <typename Game_Tp, typename Player_Tp>
void MCTS_Search(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,double Threads, double ThreadDepth);

template <typename Game_Tp, typename Player_Tp>
PMCTS_ThreadData_t<Game_Tp,Player_Tp>* PMCTS_DispatchBySoftMAX(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,int Threads, int Depth);

template <typename Game_Tp, typename Player_Tp>
void* MCTS_UCB1PrioritySearch_Thread(void* GivenPMCTS_ThreadData);

template <typename Game_Tp, typename Player_Tp>
PMCTS_ThreadData_t<Game_Tp,Player_Tp>* Dispatch_MCTS_UCB1PrioritySearch_Thread(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,double Threads, int ThreadDepth);


#endif //PMCTS_H
