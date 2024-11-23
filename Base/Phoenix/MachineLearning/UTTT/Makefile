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