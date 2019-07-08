# -*- MakeFile -*-
include ../../MakeBase.inc



all: SubDirs $(Maps_C) $(Maps_CU)

SUBDIRS =
#Calls all subdir makefiles
.PHONY: SubDirs $(SUBDIRS)
SubDirs: $(SUBDIRS)
$(SUBDIRS) :
	$(MAKE) -C $@


$(Maps_CU):
	nvcc -arch=$(arch) -c $(addsuffix .cu,$@) -o $(addsuffix .o,$@)

$(Maps_C):
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
	rm -f *.o *.gch HashTable
