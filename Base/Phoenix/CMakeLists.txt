cmake_minimum_required(VERSION 3.29)
project(Phoenix)

set(CMAKE_CXX_STANDARD 14)

include_directories(Games/SRC)
include_directories(Games/SRC/TTT)
include_directories(Games/SRC/UTTT)
include_directories(ThreadingTools/SRC)
include_directories(TreeSearches/SRC)


set(TF_INCLUDE_DIR "tensorflow/lite/nnapi/sl/include")
set(TF_LIB_DIR "tensorflow/lite/experimental/shlo/legacy/include")
include_directories(${TF_INCLUDE_DIR})
link_directories(${TF_LIB_DIR})

add_executable(Phoenix
    Games/SRC/TTT/JSON_TTT.cpp
    Games/SRC/TTT/TTT.cpp
    Games/SRC/TTT/TTT.h
    Games/SRC/UTTT/UTTT.cpp
    Games/SRC/UTTT/UTTT.h
    Games/SRC/Game.cpp
    Games/SRC/Game.h
    Games/Tests/Random_tests.cu
    Games/Tests/TTT_GenerateRandomGames.cu
    Games/Tests/TTT_Tests.cpp
    Games/Tests/TTT_Tests.cu
    Games/Tests/TTT_Tests_GTest.cpp
    Games/Tests/UTTT_Tests.cpp
    Games/Tests/UTTT_Tests.cu
    ThreadingTools/SRC/ThreadingTools.cu
    ThreadingTools/SRC/ThreadingTools.h
    ThreadingTools/SRC/ThreadingTreeTools.cu
    ThreadingTools/Tests/ThreadingTools_Tests.cu
    TreeSearches/SRC/HashTable.cu
    TreeSearches/SRC/MCHS.cu
    TreeSearches/SRC/MCHS_archive.cu
    TreeSearches/SRC/MCTS.cu
    TreeSearches/SRC/MCTS_archive.cu
    TreeSearches/SRC/PMCHS.cu
    TreeSearches/SRC/PMCTS.cu
    TreeSearches/SRC/PMCTS.h
    TreeSearches/SRC/TreeSearch.cpp
    TreeSearches/SRC/TreeSearch.cu
    TreeSearches/SRC/TreeSearch.h
    TreeSearches/Tests/HashTable_Test.cu
    TreeSearches/Tests/MCHS_Tests.cu
    TreeSearches/Tests/MCTS_Tests.cu
    TreeSearches/Tests/PMCTS_Tests.cu
    TreeSearches/Tests/PMCTS_Tests_0.cu
    TreeSearches/Tests/Test.cu
    TreeSearches/Tests/TTT_GenerateSearchGames.cu
    TreeSearches/Tests/TTT_MCHS_GenerateSearchGames.cu
    TreeSearches/Tests/TTT_MCHS_Tests.cu
    TreeSearches/Tests/TTT_MCTS_GenerateSearchGames.cu
    TreeSearches/Tests/TTT_MCTS_Play_Tests.cu
    TreeSearches/Tests/TTT_MCTS_Tests.cu
    TreeSearches/Tests/TTT_PMCTS_GenerateSearchGames.cu
    TreeSearches/Tests/TTT_PMCTS_Play_Tests.cu
    TreeSearches/Tests/UTTT_MCTS_GenerateSearchGames.cu
    TreeSearches/Tests/UTTT_MCTS_Play_Tests.cu
    TreeSearches/Tests/UTTT_PMCTS_GenerateSearchGames.cu
    TreeSearches/Tests/UTTT_PMCTS_Play_Tests.cu
        TreeSearches/Tests/UTTT_PMCTS_ContinueGenerateSearchGame.cu
        MachineLearning/UTTT/src/MachineLearning_Test.cpp)

target_link_libraries(Phoenix tensorflow_cc tensorflow_framework)