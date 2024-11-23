# -*- MakeFile -*-

all: PMCTS_Tests
	#nvcc -o ./MCTS ./SRC/MCTS.cu
	#//./MCTS
#make -B

#Compile and run tests within ./Tests Folder
MCTS_Tests:
	@echo "Compiling(Tests) ..."
	nvcc -o ./MCTS_Tests ./Tests/MCTS_Tests.cu -ljsoncpp
	#gcc -std=c++11 ./Tests/MCTS_Tests.cpp -lstdc++ -o ./MCTS_Tests
	@echo "Running(Tests) ..."
	#valgrind --leak-check=yes ./MCTS_Tests
	./MCTS_Tests

MCHS_Tests:
	#rm ./TTT_Test
	@echo "Compiling(Tests) ..."
	nvcc -o ./MCHS_Tests ./Tests/MCHS_Tests.cu -ljsoncpp
	#gcc -pthread -std=c++11 ./Tests/PMCTS_Tests.cpp -lm -lstdc++ -o ./PMCTS_Tests
	@echo "Running(Tests) ..."
	valgrind --leak-check=yes --track-origins=yes -s ./MCHS_Tests
	#./MCHS_Tests

PMCTS_Tests:
	#rm ./TTT_Test
	@echo "Compiling(Tests) ..."
	nvcc -o ./PMCTS_Tests ./Tests/PMCTS_Tests.cu -ljsoncpp
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


TTT_MCTS_Play_Tests:
	@echo "Compiling(Tests) ..."
	nvcc -o ./TTT_MCTS_Play_Tests ./Tests/TTT_MCTS_Play_Tests.cu -ljsoncpp
	#gcc -std=c++11 ./Tests/MCTS_Tests.cpp -lstdc++ -o ./MCTS_Tests
	@echo "Running(Tests) ..."
	valgrind --leak-check=yes ./TTT_MCTS_Play_Tests
	#./TTT_MCTS_Tests

TTT_PMCTS_Play_Tests1:
	rm -f TTT_MCTS_Tests
.PHONY: TTT_PMCTS_Play_Tests
TTT_PMCTS_Play_Tests:
	@echo "Compiling(Tests) ..."
	nvcc -o ./TTT_PMCTS_Play_Tests ./Tests/TTT_PMCTS_Play_Tests.cu -ljsoncpp
	#gcc -std=c++11 ./Tests/MCTS_Tests.cpp -lstdc++ -o ./MCTS_Tests
	@echo "Running(Tests) ..."
	valgrind --leak-check=yes ./TTT_PMCTS_Play_Tests
	#./TTT_PMCTS_Play_Tests




.PHONY: UTTT_MCTS_Play_Tests
UTTT_MCTS_Play_Tests:
	@echo "Compiling(Tests) ..."
	nvcc -o ./UTTT_MCTS_Play_Tests ./Tests/UTTT_MCTS_Play_Tests.cu -ljsoncpp
	#gcc -std=c++11 ./Tests/MCTS_Tests.cpp -lstdc++ -o ./MCTS_Tests
	@echo "Running(Tests) ..."
	valgrind --leak-check=yes ./UTTT_MCTS_Play_Tests
	#./TTT_MCTS_Tests

.PHONY: UTTT_PMCTS_Play_Tests
UTTT_PMCTS_Play_Tests:
	@echo "Compiling(Tests) ..."
	nvcc -o ./UTTT_PMCTS_Play_Tests ./Tests/UTTT_PMCTS_Play_Tests.cu -ljsoncpp
	#gcc -std=c++11 ./Tests/MCTS_Tests.cpp -lstdc++ -o ./MCTS_Tests
	@echo "Running(Tests) ..."
	valgrind --leak-check=yes ./UTTT_PMCTS_Play_Tests
	#./UTTT_PMCTS_Play_Tests








TTT_MCTS_GenerateGameData:
	nvcc -DPRINT_TO_SCREEN -o TTT_MCTS_GenerateSearchGames ./Tests/TTT_MCTS_GenerateSearchGames.cu -ljsoncpp
	#./TTT_GenerateSearchGames -g 10000 -p 10000_RandomSearchResults.csv
	valgrind --leak-check=yes --track-origins=yes --leak-check=full --show-leak-kinds=all -s ./TTT_MCTS_GenerateSearchGames -g 10 -p TTT_MCTS_GenerateSearchGames.csv

TTT_MCHS_GenerateGameData:
	nvcc -DPRINT_TO_SCREEN -o TTT_MCHS_GenerateGameData ./Tests/TTT_MCHS_GenerateGameData.cu -ljsoncpp
	#./TTT_MCHS_GenerateGameData -g 10000 -p 10000_RandomSearchResults.csv
	valgrind --leak-check=yes --track-origins=yes --leak-check=full --show-leak-kinds=all -s ./TTT_MCHS_GenerateGameData -g 10 -p TTT_MCHS_GenerateGameData.csv

TTT_PMCTS_GenerateGameData:
	nvcc -DPRINT_TO_SCREEN -o TTT_PMCTS_GenerateSearchGames ./Tests/TTT_PMCTS_GenerateSearchGames.cu -ljsoncpp
	#./TTT_GenerateSearchGames -g 10000 -p 10000_RandomSearchResults.csv
	#valgrind --leak-check=yes --track-origins=yes --leak-check=full --show-leak-kinds=all -s ./TTT_PMCTS_GenerateSearchGames -g 10 -p TTT_PMCTS_GenerateSearchGames.csv
	./TTT_PMCTS_GenerateSearchGames -g 1 -p TTT_PMCTS_GenerateSearchGames.csv




UTTT_MCTS_GenerateGameData:
	nvcc -DPRINT_TO_SCREEN -o UTTT_MCTS_GenerateSearchGames ./Tests/UTTT_MCTS_GenerateSearchGames.cu -ljsoncpp -O3 -lineinfo
	#./TTT_GenerateSearchGames -g 10000 -p 10000_RandomSearchResults.csv
	#valgrind --leak-check=yes --track-origins=yes --leak-check=full --show-leak-kinds=all -s ./UTTT_MCTS_GenerateSearchGames -g 1 -p UTTT_MCTS_GenerateSearchGames.csv
	./UTTT_MCTS_GenerateSearchGames -g 1 -p UTTT_MCTS_GenerateSearchGames.csv
	#./UTTT_MCTS_GenerateSearchGames -g 1 -p UTTT_MCTS_GenerateSearchGames.csv

.PHONY: UTTT_PMCTS_GenerateGameData
UTTT_PMCTS_GenerateGameData:
	nvcc -DPRINT_TO_SCREEN -o UTTT_PMCTS_GenerateSearchGames ./Tests/UTTT_PMCTS_GenerateSearchGames.cu -ljsoncpp -O3 -lineinfo

	#./TTT_GenerateSearchGames -g 10000 -p 10000_RandomSearchResults.csv
	valgrind --leak-check=yes --track-origins=yes --leak-check=full --show-leak-kinds=all -s ./UTTT_PMCTS_GenerateSearchGames -g 1 -p UTTT_PMCTS_GenerateSearchGames.csv
	#./UTTT_PMCTS_GenerateSearchGames -g 1 -p UTTT_PMCTS_GenerateSearchGames.csv

.PHONY: Run_UTTT_PMCTS_GenerateGameData
Run_UTTT_PMCTS_GenerateGameData:
	./UTTT_PMCTS_GenerateSearchGames -g 1 -sd 2000000 -t 24 -p UTTT_PMCTS_GenerateSearchGames.csv





.PHONY: UTTT_PMCTS_ContinueGenerateSearchGame
UTTT_PMCTS_ContinueGenerateSearchGame:
	nvcc -DPRINT_TO_SCREEN -o UTTT_PMCTS_ContinueGenerateSearchGame1 ./Tests/UTTT_PMCTS_ContinueGenerateSearchGame.cu -ljsoncpp -O3 -lineinfo

	#./TTT_GenerateSearchGames -g 10000 -p 10000_RandomSearchResults.csv
	valgrind --leak-check=yes --track-origins=yes --leak-check=full --show-leak-kinds=all -s ./UTTT_PMCTS_ContinueGenerateSearchGame1 -pg 0112,1202,0202,0221, -p UTTT_PMCTS_ContinueGenerateSearchGame.csv
	#./UTTT_PMCTS_GenerateSearchGames -g 1 -p UTTT_PMCTS_GenerateSearchGames.csv

.PHONY: Run_UTTT_PMCTS_GenerateGameData
Run_UTTT_PMCTS_ContinueGenerateSearchGame:
	#-m MoveDepthRemaining
	#-t Threads
	#./UTTT_PMCTS_ContinueGenerateSearchGame -pg 0112,1202,0202,0221, -sd 2000 -m 10 -t 9 -rd 0 -g 10 -p UTTT_2K_PMCTS_BookMoveSet1.csv
	./UTTT_PMCTS_ContinueGenerateSearchGame -sd 1000000 -m 30 -t 18 -rd 0 -g 1000 -p UTTT_1M_PMCTS_BookMoveSet1.csv
	./alert.sh

.PHONY: Run_UTTT_PMCTS_GenerateGameData2
Run_UTTT_PMCTS_ContinueGenerateSearchGame2:
	#./UTTT_PMCTS_ContinueGenerateSearchGame -pg 0112,1202,0202,0221, -sd 200000 -m 1 -t 9 -rd 0 -p UTTT_PMCTS_ContinueGenerateSearchGame.csv
	./UTTT_PMCTS_ContinueGenerateSearchGame -sd 1000000 -m 30 -t 12 -rd 0 -g 1000 -p UTTT_1M_PMCTS_BookMoveSet2.csv
	./alert.sh

.PHONY: Run_UTTT_PMCTS_GenerateGameData3
Run_UTTT_PMCTS_ContinueGenerateSearchGame3:
	#./UTTT_PMCTS_ContinueGenerateSearchGame -pg 0112,1202,0202,0221, -sd 200000 -m 1 -t 9 -rd 0 -p UTTT_PMCTS_ContinueGenerateSearchGame.csv
	./UTTT_PMCTS_ContinueGenerateSearchGame -sd 5000000 -m 15 -t 16 -rd 0 -g 1000 -p UTTT_5M_PMCTS_BookMoveSet1.csv
	./alert.sh

.PHONY: Run_UTTT_PMCTS_GenerateGameData4
Run_UTTT_PMCTS_ContinueGenerateSearchGame4:
	#./UTTT_PMCTS_ContinueGenerateSearchGame -pg 0112,1202,0202,0221, -sd 200000 -m 1 -t 9 -rd 0 -p UTTT_PMCTS_ContinueGenerateSearchGame.csv
	./UTTT_PMCTS_ContinueGenerateSearchGame -sd 4500000 -m 15 -t 16 -rd 0 -g 1000 -p UTTT_4.5M_PMCTS_BookMoveSet2.csv
	./alert.sh

.PHONY: Test
Test:
	nvcc -lprofiler -o Test ./Tests/Test.cu -ljsoncpp -O3 -lineinfo
	valgrind --leak-check=yes --track-origins=yes --leak-check=full --show-leak-kinds=all -s ./Test


.PHONY: Test1
Test1:
	nvcc -ltcmalloc -o Test ./Tests/Test.cu -ljsoncpp -O3 -lineinfo
	pprof --text ./Test heap_example.0001.heap




