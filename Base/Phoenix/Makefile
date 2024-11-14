# -*- MakeFile -*-

#Run Example:
#make TTT_Test -B

all: Test TTT_Test UTTT_Test
	#nvcc -o ./MCTS ./SRC/MCTS.cu
	#./MCTS

Libs:
	nvcc -o ./BinaryWriter ./Libs/BinaryWriter.cu

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

TTT_GenerateGameData:
	nvcc -o TTT_GenerateRandomGames ./Tests/TTT_GenerateRandomGames.cu -ljsoncpp
	./TTT_GenerateRandomGames -g 1000 -p 1000_RandomResults.csv

.PHONY: clean
clean :
	for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir clean; \
	done
	rm -f *.o *.gch
