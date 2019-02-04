# -*- MakeFile -*-
BASDIR = Base/
SIMDIR = Simulation/

include Base/Base.inc
include Sim.inc
#include Simulation/Simulation.inc
#include Simulation/Environment/Environment.inc

SUBDIRS = Base

all: SubDirs Test CGoop

#Calls all subdir makefiles
.PHONY: SubDirs $(SUBDIRS)
SubDirs: $(SUBDIRS)
$(SUBDIRS) :
	$(MAKE) -C $@





#make Test Executable
Test: SimTest $(ALLOBJS)
	#@echo $(ALLOBJS)
	#@echo $(ALLHDR)
	#$(CC) $(LFLAGS) SimTest.o $(ALLOBJS) -O3 -o $@ -lm
	nvcc -arch=compute_61 -code=sm_61 -lcuda -Xcompiler -fopenmp SimTest.o $(ALLOBJS) -o $@

SimTest :SimTest.cu Sim.h $(ALLHDR)
	#$(CC) $(CFLAGS) SimTest.cu Sim.h $(ALLHDR)
	nvcc -arch=sm_61 -c $@.cu -o $@.o


.PHONY: CGoop $(SUBDIRS)
CGoop :
	for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir CGoop; \
	done
	\rm -f *.gch .fuse* *.data

.PHONY: clean $(SUBDIRS)
clean :
	for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir clean; \
	done
	rm -f *.o *.gch .fuse* Test Test_fS_Address Test_fS_Leak Test_fS_Kernel_Address Test_fS_Thread CommandPrompt
