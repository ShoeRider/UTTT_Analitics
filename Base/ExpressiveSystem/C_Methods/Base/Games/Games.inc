# -*- MakeFile -*-
# all Object and header file references for ObjectBase

#Current DIR
Games = Games
Games_O = $(addsuffix .o,$(Games))
Games_H = $(addsuffix .h,$(Games))


#Games DIR
#TTT_CALL = $(GAM_CLL)TickTackToe/
#include $(TTT_CALL)TickTackToe.inc
#TTT_OP = $(addprefix TickTackToe/,$(TTT_O))
#TTT_HP = $(addprefix TickTackToe/,$(TTT_H))
#Games_O += $(TTT_OP)
#Games_H += $(TTT_HP)

#Games DIR
#UTTT_CALL = $(GAM_CLL)UTickTackToe/
#include $(UTTT_CALL)UTickTackToe.inc
#UTTT_OP = $(addprefix UTickTackToe/,$(UTTT_O))
#UTTT_HP = $(addprefix UTickTackToe/,$(UTTT_H))
#Games_O += $(UTTT_OP)
#Games_H += $(UTTT_HP)
