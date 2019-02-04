# -*- MakeFile -*-
include ../MakeBase.inc
include ParallelComponents.inc


all: SubDirs $(ParallelComponents_CU)

SUBDIRS =
#Calls all subdir makefiles
.PHONY: SubDirs $(SUBDIRS)
SubDirs: $(SUBDIRS)
$(SUBDIRS) :
	$(MAKE) -C $@

$(ParallelComponents_CU): GPU_Management.h
	nvcc -arch=$(arch) -lcutil -lcudpp -lcuda -lcudart -c $(addsuffix .cu,$@) -o $(addsuffix .o,$@)

$(ParallelComponents_C):
	nvcc -arch=$(arch) -c $(addsuffix .c,$@) -o $(addsuffix .o,$@)



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
