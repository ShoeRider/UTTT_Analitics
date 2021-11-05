# UTTT_Analitics
Ultimate Tic Tac Toe is a simple advancement to Tic Tac Toe’s game, except the board is expanded to contain nine miniature tick tack toe games. For a general
idea about the game, check out this YouTube video: https://www.youtube.com/watch?v=37PC0bGMiTI Note the implemented rules in my program are slightly different and will be added in an additional document/Tutorial.

This repository contains a simple CPP program to find the best strategies/moves based on the Monte Carlo Tree Search. 


Finished:
+ Basic MCTS.
+ Parallel MCTS to decrease search time.

In progress: 
+ Save/Read Book Moves for faster initial searches.
+ Unit Testing Through GTest
+ Implementing HashTable and hashes of game states to remove overlapping game branches.
+ Machine learning with Neural Networks with backpropagation to help find moves faster 



requirements:

gcc
valgrind

My System:
nvcc --version:
nvcc: NVIDIA (R) Cuda compiler driver Copyright (c) 2005-2019 NVIDIA Corporation Built on Sun_Jul_28_19:07:16_PDT_2019 Cuda compilation tools, release 10.1, V10.1.243

nvcc-smi:
NVIDIA-SMI 470.74 Driver Version: 470.74 CUDA Version: 11.4 


R5 2600 
48 GB Ram


export PATH="/usr/local/bin:$PATH"
