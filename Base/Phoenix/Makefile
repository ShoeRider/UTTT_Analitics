# -*- MakeFile -*-

#Run Example:
#make TTT_Test -B

all: Test TTT_Test UTTT_Test
	#nvcc -o ./MCTS ./SRC/MCTS.cu
	#./MCTS

UTTT_Test:
	@echo "Compiling(Tests) ..."
	nvcc -o ./UTTT_Test ./Tests/UTTT_Tests.cu
	@echo "Running(Tests) ..."
	valgrind --leak-check=yes --track-origins=yes ./UTTT_Test

#Compile and run tests within ./Tests Folder
TTT_Test:
	#rm ./TTT_Test
	@echo "Compiling(Tests) ..."
	nvcc -o ./TTT_Test ./Tests/TTT_Tests.cu
	@echo "Running(Tests) ..."
	valgrind --leak-check=yes --track-origins=yes -s ./TTT_Test
TTT:
	@echo "Compiling(Tests no valgrind) ..."
	nvcc -o ./TTT_Test ./Tests/TTT_Tests.cu
	./TTT_Test

.PHONY: clean
clean :
	for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir clean; \
	done
	rm -f *.o *.gch
