# -*- MakeFile -*-

Sim_CU = SimTest.cu
Sim_C =

#ObjectBase Folder
BASE_CALL = Base/
include  $(BASE_CALL)Base.inc
ObjectBase_OP = $(addprefix Base/,$(ObjectBase_O))
ObjectBase_HP = $(addprefix Base/,$(ObjectBase_H))


SIM_CALL = Simulation/



#combine all object Files
ALLOBJS =  $(ObjectBase_OP)


ALL_CU_OBJS =

#combine all header Files
ALLHDR =  $(ObjectBase_HP)
