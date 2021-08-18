 #!/bin/bash
 #Example found at:https://www.youtube.com/watch?v=kuglfQf17SA

 #chmod a+x ./Compile.sh   #Gives everyone execute permissions
 # OR
#chmod 700 /where/i/saved/it/hello_world.sh   #Gives read,write,execute permissions to the Owner
cmake CMakeLists.txt
@echo "Compiling(Tests) ..."
make -b
@echo "Running(Tests) ..."
#./TTT_Tests_GTest
#Standard Compilation method:
#nvcc -o ./UTTT_Test ./Tests/UTTT_Tests.cu
valgrind --leak-check=yes --track-origins=yes  ./UTTT_Tests_GTest
