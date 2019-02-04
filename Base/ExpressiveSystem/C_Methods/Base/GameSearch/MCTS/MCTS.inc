# -*- MakeFile -*-
# all Object and header file references for ObjectBase

MCTS_C = MCTS_HashTable MCTS MCTS_NN
MCTS_CU =


MCTS_O = $(addsuffix .o,$(MCTS))
MCTS_H = $(addsuffix .h,$(MCTS))
