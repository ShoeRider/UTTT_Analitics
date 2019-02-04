# -*- MakeFile -*-
include ../MakeBase.inc
include NNOperations.inc


all: SubDirs

SUBDIRS =
#Calls all subdir makefiles
.PHONY: SubDirs $(SUBDIRS)
SubDirs: $(SUBDIRS)
$(SUBDIRS) :
	$(MAKE) -C $@

$(NNOperations_CU):
	nvcc -arch=$(arch) -lcutil -lcudpp -lcuda -lcudart -c $(addsuffix .cu,$@) -o $(addsuffix .o,$@)

$(NNOperations_C):
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
