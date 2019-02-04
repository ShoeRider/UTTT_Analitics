#ifndef UTickTackToe_Top_H
#define UTickTackToe_Top_H

#include "../../Base.h"
#include "../TickTackToe/TickTackToe.h"
#include "../Games.h"
#include "../../DataStructures/StringFields.h"
#include "../../DataStructures/MMath.cu"
#include "../../DataStructures/DoublyLinkedList.c"
#include "../../GameSearch/MCTS/MCTS.c"
#include "UTickTackToe_Base.cu"
#include "UTickTackToe_MCTS.cu"
#include "UTickTackToe_MCHS.cu"

void TickTackToe_V();


void UTTT_T(int CallSign);
#endif //UTickTackToe_Top_H
