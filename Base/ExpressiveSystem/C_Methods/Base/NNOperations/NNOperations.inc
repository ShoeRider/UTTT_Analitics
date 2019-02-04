# -*- MakeFile -*-
# all Object and header file references for ObjectBase

NNOperations_C =
NNOperations_CU = GenericNNetwork


NNOperations_O  = $(addsuffix .o,$(NNOperations_C))
NNOperations_O += $(addsuffix .o,$(NNOperations_CU))

NNOperations_H = $(addsuffix .h,$(NNOperations_C))
NNOperations_H = $(addsuffix .h,$(NNOperations_CU))
