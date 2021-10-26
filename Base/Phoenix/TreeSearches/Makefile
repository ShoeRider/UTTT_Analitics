# -*- MakeFile -*-

all: MCHS_Tests
	#nvcc -o ./MCTS ./SRC/MCTS.cu
	#//./MCTS
#make -B

#Compile and run tests within ./Tests Folder
Test:
	@echo "Compiling(Tests) ..."
	nvcc -o ./MCTS_Tests ./Tests/MCTS_Tests.cu
	#gcc -std=c++11 ./Tests/MCTS_Tests.cpp -lstdc++ -o ./MCTS_Tests
	@echo "Running(Tests) ..."
	valgrind --leak-check=yes ./MCTS_Tests
	#./MCTS_Tests

MCHS_Tests:
	#rm ./TTT_Test
	@echo "Compiling(Tests) ..."
	nvcc -o ./MCHS_Tests ./Tests/MCHS_Tests.cu
	#gcc -pthread -std=c++11 ./Tests/PMCTS_Tests.cpp -lm -lstdc++ -o ./PMCTS_Tests
	@echo "Running(Tests) ..."
	valgrind --leak-check=yes --track-origins=yes -s ./MCHS_Tests

PMCTS_Tests:
	#rm ./TTT_Test
	@echo "Compiling(Tests) ..."
	nvcc -o ./PMCTS_Tests ./Tests/PMCTS_Tests.cu
	#gcc -pthread -std=c++11 ./Tests/PMCTS_Tests.cpp -lm -lstdc++ -o ./PMCTS_Tests
	@echo "Running(Tests) ..."
	valgrind --leak-check=yes --track-origins=yes -s ./PMCTS_Tests


HashTable:
	#rm ./TTT_Test
	@echo "Compiling(Tests) ..."
	nvcc -o ./HashTable_Tests ./Tests/HashTable_Test.cu
	#gcc -pthread -std=c++11 ./Tests/PMCTS_Tests.cpp -lm -lstdc++ -o ./PMCTS_Tests
	@echo "Running(Tests) ..."
	valgrind --leak-check=yes --track-origins=yes -s ./HashTable_Tests

.PHONY: clean $(SUBDIRS)
clean :
	for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir clean; \
	done
	rm -f *.o *.gch
