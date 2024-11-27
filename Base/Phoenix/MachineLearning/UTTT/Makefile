# -*- MakeFile -*-

# Compiler and flags
CXX = g++
CXXFLAGS = -std=c++17 -I/path/to/tensorflow/include \
           -I/path/to/tensorflow/lite/nnapi/sl/include \
           -I/path/to/tensorflow/lite/experimental/shlo/legacy/include \
           -L/path/to/tensorflow/lib
LDFLAGS = -ltensorflow_framework -ltensorflow_cc

# Target executable
TARGET = nn

# Source file
SRC = nn.cpp

ML:
	nvcc -std=c++17 src/MachineLearning_Test.cpp -ltensorflow -o hello_tf

MachineLearning_test:
    #tensorflow/lite/nnapi/sl/include
    #tensorflow/lite/experimental/shlo/legacy/include
	nvcc \
  		-I/home/pc/tensorflow \
		-L/home/pc/tensorflow/bazel-bin/tensorflow \
		-ltensorflow_framework \
		-ltensorflow_cc \
		-o MachineLearning_Test src/MachineLearning_Test.cpp \
		-ljsoncpp -O3 -lineinfo
    #nvcc -I/tensorflow/lite/nnapi/sl/include -L/tensorflow/lite/experimental/shlo/legacy/include -ltensorflow_framework -ltensorflow_cc -o MachineLearning_Test MachineLearning_Test.cpp
    #nvcc -I/path/to/tensorflow/include -I/path/to/tensorflow/lite/nnapi/sl/include -I/path/to/tensorflow/lite/experimental/shlo/legacy/include -L/path/to/tensorflow/lib -ltensorflow_framework -ltensorflow_cc -o MachineLearning_Test MachineLearning_Test.cpp


.PHONY: Generate_UTTT_TrainingData
Generate_UTTT_TrainingData:
	nvcc -DPRINT_TO_SCREEN -o ./bin/Generate_UTTT_TrainingData ./src/Generate_UTTT_TrainingData.cpp -ljsoncpp -O3 -lineinfo

	#./TTT_GenerateSearchGames -g 10000 -p 10000_RandomSearchResults.csv
	valgrind --leak-check=yes --track-origins=yes --leak-check=full --show-leak-kinds=all -s ./bin/Generate_UTTT_TrainingData -i ./data/UTTT_ExampleGames.csv -o ./data/Results.csv
	#./UTTT_PMCTS_GenerateSearchGames -g 1 -p UTTT_PMCTS_GenerateSearchGames.csv




.PHONY: Generate_UTTT_TrainingData_PY

SHELL := /usr/bin/bash

Generate_UTTT_TrainingData_PY:
	@echo "Using Bash shell: $(SHELL)"
	@VENV_PATH=./../tf && \
	source $$VENV_PATH/bin/activate && \
	python3 ./src/GenerateTrainingData.py -i ./data/1.csv -o ./data/Results.csv

	#python3 -c "import tensorflow as tf; print(tf.config.list_physical_devices('GPU'))"
