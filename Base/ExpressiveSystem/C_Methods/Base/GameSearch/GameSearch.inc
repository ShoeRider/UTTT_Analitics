# -*- MakeFile -*-
# all Object and header file references for ObjectBase






GameSearch_C =
GameSearch_CU =


GameSearch_O  = $(addsuffix .o,$(GameSearch_C))
GameSearch_O += $(addsuffix .o,$(GameSearch_CU))

GameSearch_H = $(addsuffix .h,$(GameSearch_C))
GameSearch_H = $(addsuffix .h,$(GameSearch_CU))
