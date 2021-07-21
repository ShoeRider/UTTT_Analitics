# -*- MakeFile -*-

all: Test
	#nvcc -o ./MCTS ./SRC/MCTS.cu
	#//./MCTS


#Compile and run tests within ./Tests Folder
Test:
	@echo "Compiling(Tests) ..."
	nvcc -o ./ThreadingTools_Tests ./Tests/ThreadingTools_Tests.cu
	@echo "Running(Tests) ..."
	valgrind --leak-check=yes ./MCTS_Tests
	#./ThreadingTools_Tests


.PHONY: clean $(SUBDIRS)
clean :
	for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir clean; \
	done
	rm -f *.o *.gch
