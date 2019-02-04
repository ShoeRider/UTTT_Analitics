# -*- MakeFile -*-
# all Object and header file references for ObjectBase

ParallelComponents_CU = GPU_Management
ParallelComponents_C =

NNOperations_O = $(addsuffix .o,$(ParallelComponents_CU))
NNOperations_H = $(addsuffix .h,$(ParallelComponents_CU))
