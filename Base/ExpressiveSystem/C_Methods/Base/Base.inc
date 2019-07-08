# -*- MakeFile -*-
# all Object and header file references for Base

Base = Base
ObjectBase_O = $(addsuffix .o,$(Base))
ObjectBase_H = $(addsuffix .h,$(Base))


DS_CALL = $(addsuffix DataStructures/,$(BASE_CALL))
# include  $(addsuffix DataStructures.inc,$(DS_CALL))

DataStructures_HP = $(addprefix DataStructures/,$(DataStructures_H))
DataStructures_OP = $(addprefix DataStructures/,$(DataStructures_O))

ObjectBase_O += $(DataStructures_OP)
ObjectBase_H += $(DataStructures_HP)
