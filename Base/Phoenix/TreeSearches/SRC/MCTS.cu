#ifndef MCTS_CU
#define MCTS_CU


#include <iostream>
#include <string>

#include "TreeSearch.cu"

class MCTS : public TreeSearch
{
private:
    int myMember;

public:
    MCTS(){}
    ~MCTS(){}
    void Search(int Depth);
    void Give_MLMethodPointer();
};

// Provide implementation for the first method
void MCTS::Search(int Depth)
{
    std::cout << "Searching Depth:" << Depth << "\n";
}

// Provide implementation for the first method
void MCTS::Give_MLMethodPointer()
{
    std::cout << "Hello World!";
}



#endif //MCTS_CU
