# -*- MakeFile -*-
# all Object and header file references for ObjectBase

DataStructures_C = DoublyLinkedList StringFields HashTable
DataStructures_CU = MMath

DataStructures_C_O  = $(addsuffix .o,$(DataStructures_C))
DataStructures_CU_O = $(addsuffix .o,$(DataStructures_CU))

DataStructures_H = $(addsuffix .h,$(DataStructures_C))
DataStructures_H += $(addsuffix .h,$(DataStructures_CU))
