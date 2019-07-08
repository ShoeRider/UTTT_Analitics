# -*- MakeFile -*-
ENVDIR =

include ../../Base/MakeBase.inc
include Games.inc

SUBDIRS =  

all: Games.o SubDirs #Simulation.o

#Calls all subdir makefiles
.PHONY: SubDirs $(SUBDIRS)
SubDirs: $(SUBDIRS)
$(SUBDIRS) :
	$(MAKE) -C $@

Games.o: Games.c Games.h
	$(CC) $(MLIB) $(CFLAGS) Games.c Games.h

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
