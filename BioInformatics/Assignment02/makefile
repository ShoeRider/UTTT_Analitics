

ALL : clean O3_OMP OMP O3 Normal


O3_OMP:
	gcc -O3 AnthonySchroeder_Assignment2.c -lm -lgomp -fopenmp -o O3_OMP

OMP :
	gcc -O3 AnthonySchroeder_Assignment2.c -lm -lgomp -fopenmp -o OMP

O3 :
	gcc -O3 AnthonySchroeder_Assignment2.c -lm -lgomp -fopenmp -o O3

Normal :
	gcc AnthonySchroeder_Assignment2.c -lm -lgomp -fopenmp -o Normal


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
	rm -f *.o *.gch AnthonySchroeder_Assignment2 Normal O3 OMP O3_OMP
