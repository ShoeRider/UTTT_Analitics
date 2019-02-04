# -*- MakeFile -*-
# all Object and header file references for ObjectBase


Games =
#Current DIR
UTTT =
UTickTackToe_CU = UTickTackToe_Base UTickTackToe_MCTS  UTickTackToe_Top


UTTT_O = $(addsuffix .o,$(UTTT))
UTickTackToe_CU_O = $(addsuffix .o,$(UTickTackToe_CU))
UTTT_H = $(addsuffix .h,$(UTTT))
