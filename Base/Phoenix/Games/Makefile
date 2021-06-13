# -*- MakeFile -*-

all: Test
	#nvcc -o ./MCTS ./SRC/MCTS.cu
	#./MCTS

UTTT_Test:
	@echo "Compiling(Tests) ..."
	nvcc -o ./UTTT_Test ./Tests/UTTT_Tests.cu
	@echo "Running(Tests) ..."
	valgrind --leak-check=yes ./UTTT_Test

#Compile and run tests within ./Tests Folder
Test:
	@echo "Compiling(Tests) ..."
	nvcc -o ./TTT_Test ./Tests/TTT_Tests.cu
	@echo "Running(Tests) ..."
	valgrind --leak-check=yes ./TTT_Test


.PHONY: clean $(SUBDIRS)
clean :
	for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir clean; \
	done
	rm -f *.o *.gch
