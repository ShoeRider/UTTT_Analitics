#ifndef AnthonySchroeder_Assignment2_H
#define AnthonySchroeder_Assignment2_H

#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <time.h>
#include "omp.h"

typedef struct Benchmark_t
{
  char* Name;
  char* Language;
  double Score;
  char* Parameter_0;
  char* Parameter_1;
  clock_t start;
  clock_t end;
  double seconds;
} Benchmark_t;


typedef struct FASTA_t
{
  int BlockCount;
  int GenomeLength;
  int LabelLength;
  char** Block;
  char** BlockLabel;

} FASTA_t;


typedef struct IMatrix_t
{
  int** Array;
  int X;
  int Y;
} IMatrix_t;


typedef struct FMatrix_t
{
  float** Array;
  int X;
  int Y;
} FMatrix_t;


#endif // AnthonySchroeder_Assignment2_H
