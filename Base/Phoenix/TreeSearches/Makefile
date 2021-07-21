# -*- MakeFile -*-

all: Test
	#nvcc -o ./MCTS ./SRC/MCTS.cu
	#//./MCTS


#Compile and run tests within ./Tests Folder
Test:
	@echo "Compiling(Tests) ..."
	nvcc -o ./MCTS_Tests ./Tests/MCTS_Tests.cu
	@echo "Running(Tests) ..."
	#valgrind --leak-check=yes ./MCTS_Tests
	./MCTS_Tests
P_MCTS_Tests:
	#rm ./TTT_Test
	@echo "Compiling(Tests) ..."
	nvcc -o ./PMCTS_Tests ./Tests/PMCTS_Tests.cu
	@echo "Running(Tests) ..."
	valgrind --leak-check=yes --track-origins=yes -s ./PMCTS_Tests
FAST_P_MCTS_Tests:
	#rm ./TTT_Test
	@echo "Compiling(Tests) ..."
	nvcc -o ./PMCTS_Tests ./Tests/PMCTS_Tests.cu
	@echo "Running(Tests) ..."
	#valgrind --leak-check=yes --track-origins=yes -s ./P_MCTS_Tests
	./P_MCTS_Tests

.PHONY: clean $(SUBDIRS)
clean :
	for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir clean; \
	done
	rm -f *.o *.gch
