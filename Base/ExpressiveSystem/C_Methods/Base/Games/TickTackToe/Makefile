# -*- MakeFile -*-
ENVDIR =

include ../../../Base/MakeBase.inc
include TickTackToe.inc

SUBDIRS =

all: $(TTT_CU) #Simulation.o

#Calls all subdir makefiles
.PHONY: SubDirs $(SUBDIRS)
SubDirs: $(SUBDIRS)
$(SUBDIRS) :
	$(MAKE) -C $@

$(TTT_CU).o:$(TTT_CU)

$(TTT_CU):
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
