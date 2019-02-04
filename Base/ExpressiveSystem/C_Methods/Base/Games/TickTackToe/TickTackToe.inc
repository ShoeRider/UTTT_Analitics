# -*- MakeFile -*-
# all Object and header file references for ObjectBase

#Current DIR
TTT = TickTackToe
TTT_CU =

TTT_O = $(addsuffix .o,$(TTT))
TTT_O += $(addsuffix .o,$(TTT_CU))
TTT_H = $(addsuffix .h,$(TTT))
TTT_H += $(addsuffix .h,$(TTT_CU))
