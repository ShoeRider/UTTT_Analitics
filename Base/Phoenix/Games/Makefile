# -*- MakeFile -*-

all: Test
	#nvcc -o ./MCTS ./SRC/MCTS.cu
	#//./MCTS
#make -B

#Compile and run tests within ./Tests Folder
Test:
	@echo "Compiling(Tests) ..."
	#nvcc -std=c++11 ./Tests/TTT_Tests.cu -o ./TTT_Tests
	gcc -std=c++11 ./Tests/TTT_Tests.cpp -lstdc++ -o ./TTT_Tests
	@echo "Running(Tests) ..."
	valgrind --leak-check=yes ./TTT_Tests
	#./MCTS_Tests
#gcc -std=c++11 ./Tests/TTT_Tests.cpp -lstdc++ -o ./TTT_Tests



.PHONY: clean $(SUBDIRS)
clean :
	for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir clean; \
	done
	rm -f *.o *.gch
