#ifndef MMath_H
#define MMath_H

#include "../Base.h"
#include "StringFields.h"
#include "DoublyLinkedList.h"

typedef struct IMatrix_t
{
  int* Array;
  char IndexType;
  int IndexSize;
  int X;
  int Y;
} IMatrix_t;

typedef struct FMatrix_t
{
  float* Array;
  char IndexType;
  int IndexSize;
  int X;
  int Y;
} FMatrix_t;





void MMath_V();
//Create Structs
IMatrix_t* CreateIntegerMatrix(int x,int y);

IMatrix_t* CreateIntegerIdentityMatrix(int x,int y);
void PrintIntegerMatrix(IMatrix_t* Matrix);

FMatrix_t* CreateFloatMatrix(int x,int y);
FMatrix_t* Create_FMatrix_t(int x,int y);
FMatrix_t* CreateZero_FMatrix_t(int x,int y);
FMatrix_t* CreateF_RW(int x,int y);
FMatrix_t* CreateIdentity_FMatrix_t(int x,int y);
void Free_FMatrix_t(FMatrix_t* Matrix);
void PrintFloatMatrix(FMatrix_t* Matrix);
void Free_DLL_FMatrix_t(DLL_Handle_t* DLL_Handle);
void Sigmoid_FMatrix_t(FMatrix_t* PropigatedActivation);
void MaskedSigmoid_FMatrix_t(FMatrix_t* PropigatedActivation,FMatrix_t* DropOutMask);
void Scale_FMatrix_t(float Scale,FMatrix_t* Matrix0);
void AddTo_FMatrix_t(FMatrix_t* FMatrix0, FMatrix_t* FMatrix1);
void SubTo_FMatrix_t(FMatrix_t* FMatrix0, FMatrix_t* FMatrix1);
void Add_FMatrix_t_To_FMatrix_t(FMatrix_t* FMatrix0, FMatrix_t* FMatrix1);
float GetSum_FMatrix(FMatrix_t* FMatrix);
FMatrix_t* RandomMask_FMatrixMatrix(int x,int y, float Rate);
void FMatrix_t_MinMaxClip(float Clip,FMatrix_t* FMatrix);

void MultiplyFMatrices(FMatrix_t* Matrix0,FMatrix_t* Matrix1,FMatrix_t* Result);


//
int GetSum_IMatrix(IMatrix_t* IMatrix);
int RandomSelect_IMatrixIndex(IMatrix_t* IMatrix);

void CopyIntegerMatrix(IMatrix_t* IMatrix0,IMatrix_t* IMatrix1);
IMatrix_t* MakeCopyIntegerMatrix(IMatrix_t* IMatrix0);

void CopyFloatMatrix(FMatrix_t* FMatrix0,FMatrix_t* FMatrix1);
FMatrix_t* MakeCopyFMatrix(FMatrix_t* Matrix0);


void ZeroFloatMatrix(FMatrix_t* FMatrix);

//Free Structs
void FreeMatrix(IMatrix_t* Matrix);
void Free_IMatrix(IMatrix_t* Matrix);



void MMath_T(int CallSign);


#endif // MMath_H
