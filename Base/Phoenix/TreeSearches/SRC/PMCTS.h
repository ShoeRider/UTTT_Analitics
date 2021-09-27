#ifndef PMCTS_H
#define PMCTS_H

#include <thread>


template <typename Game_Tp, typename Player_Tp>
class PMCTS_Node;


template <typename Game_Tp, typename Player_Tp>
struct PMCTS_ThreadData_t {
    pthread_t Thread;
    //Player_Tp*
    PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode;
    double Threads;
    double Depth;
    bool Finished;
};

class TTT_Move;

template <typename Game_Tp, typename Player_Tp>
void * PMCTS_Search_thread(void* GivenPMCTS_ThreadData);
template <typename Game_Tp, typename Player_Tp>
void MCTS_Search(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,double Threads, double ThreadDepth);

template <typename Game_Tp, typename Player_Tp>
PMCTS_ThreadData_t<Game_Tp,Player_Tp>* PMCTS_DispatchBySoftMAX(PMCTS_Node<Game_Tp,Player_Tp>* TransversedNode,int Threads, int Depth);

#endif //PMCTS_H
