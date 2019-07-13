#ifndef Generics_H
#define Generics_H


#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>   // malloc
#include <assert.h>
#include <pthread.h>  //Threading
#include <time.h>
#include <math.h>
#include <limits.h>
#include <stdbool.h>
#include <string.h>
#include <omp.h>
#include <stdarg.h>
//#include "DataStructures/FileServices/sqlite/sqlite3.h"

#define ReadLine 1000
#define MAXCHAR 1000
#define SUPPERMAXCHAR 200000
#define ALLINTEGERS "0123456789"


typedef void *(*RunTimeFunction)(void *);
typedef void (*Print_)(void *);
typedef void (*Free_)(void *);


#define ReturnVoid(X) return ((void*) X)

#define BreakDef int myvariable;
#define InBreak scanf("%d",&myvariable);
#define Break printf("%d",&NULL);

//Scheme - Def example ~Functionality Missing
#define P(OP ,X ,Y) X OP Y
#define _P(OP ,X ,Y) X OP Y

#define IndexedVariable(Variable,ConCat) Variable ##ConCat

#define Flag0 01
#define Flag1 02
#define Flag3 04
#define Flag4 08
#define Flag5 16
#define Flag6 32
#define Flag7 64
#define Flag8 128
#define Flag9 256
#define Flag10 512
#define Flag11 1024
#define Flag12 2048
#define Flag13 4096
#define Flag14 8192
#define Flag15 16384
#define Flag16 32768

#define SetFlagHigh(Variable,Flag) Variable &= Flag
#define SetFlagLow(Variable,Flag) Variable |= Flag

#define GetFlag(Variable,Flag) Variable & Flag
//Q- Function and Structure Definition

#define qMalloc_Defined_Quantity(Type, Variable,of) Type* Variable = (Type*)malloc(sizeof(Type)*of);
#define qMalloc_Defined(Type, Variable) Type* Variable = (Type*)malloc(sizeof(Type));
#define qMalloc(Type) qMalloc_Defined(Type##_t,Type)

typedef struct Mutex_t
{
  int Key;
  int Lock;
} Mutex_t;







#define PrintInt(X) printf("%d\n",X );
#define PrintFloat(X) printf("%0.9f\n",X );

#define PrintXLines(X) PrintLines(X)
#define PrintLines(X)                               \
for(int NewLines = 0; NewLines < X; NewLines++)     \
{                                                   \
  printf("\n");                                     \
}                                                   \

#define RandomInteger(Min,Max) ((int)rand() % (Max - Min + 1)) + Min
#define RandomFloat(Min,Max) ((float)rand()/(RAND_MAX/(Max-Min))) + Min
//#define RandomDouble(Min,Max) ((double)rand()/(((double)RAND_MAX*2)/(Max-Min))) + Min

#define CoinFlip (rand() % (2))
#define _1D_ForLoop(X,Code)                   \
	for(int i = 0; i < X ;i++)                  \
	{                                           \
		Code                                      \
	}                                           \


#define _2D_ForLoop(X,Y,Code)                 \
	for(int i = 0; i < X ;i++)                  \
	{                                           \
		for(int j = 0; j < Y ;j++)                \
		{                                         \
			Code                                    \
		}                                         \
	}                                           \

#define _2D_FL_Matrix_Element(Varible) (*(Varible->Array+i*Varible->Y+j))
#define _2D_XY_Matrix_Element(Varible,i,j) (*(Varible->Array+i*Varible->Y+j))
#define _2D_FL_Matrix_Element_Pointer(Varible,Pointer) (*(Varible->Pointer+i*Varible->Y+j))

#define _2D_MatrixLoop(Matrix,Code)           \
	for(int i = 0; i < Matrix->X ;i++)          \
	{                                           \
		for(int j = 0; j < Matrix->Y ;j++)        \
		{                                         \
      Code                                    \
		}                                         \
	}                                           \

#define _1D_FL_Matrix_Element(Array) (*(Array+i))
#define _1D_FL_Matrix_Element_Pointer(Varible,Pointer) (*(Varible->Pointer+i))

#define qSet_1D_Matrix(Array,ListLength,As)           \
	for(int i = 0; i < ListLength ;i++)                 \
	{                                                   \
		(*(Array+i)) = As;                                \
	}                                                   \


#define qSet_2D_Matrix_Elements(Varible,As)           \
	for(int i = 0; i < Varible->X ;i++)                 \
	{                                                   \
		for(int j = 0; j < Varible->Y ;j++)               \
		{                                                 \
			(*(Varible->Array+i*Varible->Y+j)) = As;        \
		}                                                 \
	}                                                   \


#define _3D_ForLoop(X,Y,Z,Code)               \
	for(int i = 0; i < X ;i++)                  \
	{                                           \
		for(int j = 0; j < Y ;j++)                \
		{                                         \
      for(int k = 0; k < Z ;k++)              \
      {                                       \
        Code                                  \
      }                                       \
		}                                         \
	}                                           \

#define _3D_MatrixLoop(Matrix,Code)           \
	for(int i = 0; i < Matrix->X ;i++)          \
	{                                           \
		for(int j = 0; j < Matrix->Y ;j++)        \
		{                                         \
      for(int k = 0; k < Matrix->Z ;k++)      \
      {                                       \
        Code                                  \
      }                                       \
		}                                         \
	}                                           \

//DeclareInterperetedVariable_Struct
#define DIV_S(Type,Name,ID)                         \
  Type* Name##ID = (Type*) malloc(sizeof(Type));    \

//DeclareInterperetedVariable
#define DIV(Type,Name,ID,As)  \
  Type Name##ID = As;         \

//DeclareInterperetedInt
#define DII(Name,ID,Value)     \
  int Name##ID = Value;        \



#define InterperetedVariable(Name,ID) Name##ID

#define IV(Name,ID) Name##ID



//Standard Version Call
void Base_V();
void GatherTerminalInt(const char* Prompt, int* IntValue);
void GatherTerminalFloat(const char* Prompt, float* IntValue);
void GatherTerminalString(const char* Prompt, char* charString);
void Base_T(int CallSign);
#endif // Generics_H
