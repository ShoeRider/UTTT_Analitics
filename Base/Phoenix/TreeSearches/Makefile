# -*- MakeFile -*-

all:
	nvcc -o ./MCTS ./SRC/MCTS.cu
	./MCTS


#Compile and run tests within ./Tests Folder
Test:
	nvcc -o ./MCTS_Test ./Tests/MCTS_Tests.cu
	@echo "Running(Tests) ..."
	./MCTS_Test


.PHONY: clean $(SUBDIRS)
clean :
	for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir clean; \
	done
	rm -f *.o *.gch
