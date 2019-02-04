# -*- MakeFile -*-
ENVDIR =

include ../../../Base/MakeBase.inc
include UTickTackToe.inc

SUBDIRS =

all: $(UTickTackToe_CU) #Simulation.o

#Calls all subdir makefiles
.PHONY: SubDirs $(SUBDIRS)
SubDirs: $(SUBDIRS)
$(SUBDIRS) :
	$(MAKE) -C $@



$(UTickTackToe_CU):
	nvcc -arch=sm_61 -c $(addsuffix .cu,$@) -o $(addsuffix .o,$@)


CGoop :
	for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir CGoop; \
	done
	\rm -f *.gch

.PHONY: clean $(SUBDIRS)
clean :
	for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir clean; \
	done
	rm -f *.o *.gch
