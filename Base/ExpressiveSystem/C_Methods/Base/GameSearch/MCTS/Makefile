# -*- MakeFile -*-
include ../../MakeBase.inc
include MCTS.inc


all: SubDirs CGoop

SUBDIRS =
#Calls all subdir makefiles
.PHONY: SubDirs $(SUBDIRS)
SubDirs: $(SUBDIRS)
$(SUBDIRS) :
	$(MAKE) -C $@




.PHONY: CGoop $(SUBDIRS)
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
