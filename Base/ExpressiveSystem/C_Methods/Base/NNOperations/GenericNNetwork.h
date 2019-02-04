#ifndef GenericNNetwork_H
#define GenericNNetwork_H

#include "../Base.h"
#include "../DataStructures/DoublyLinkedList.h"
#include "../DataStructures/MMath.h"
#include "../ParallelComponents/GPU_Management.h"




typedef struct AccumulatedChange_t
{
  FMatrix_t* Weight;

} AccumulatedChange_t;
typedef struct NNLayer_t
{
  int X,Y,InOut;
  FMatrix_t* Weight;
  FMatrix_t* Base;

  int StochasticIterations;
  FMatrix_t* StochasticChange;  //Forward Propigation Value

  FMatrix_t* WeightTemp;
  FMatrix_t* PropigatedTemp;

  DLL_Handle_t* Forward_FPD_DLL; //points to DLL_handle that is in charge of decorator(pipe) functions
  DLL_Handle_t* Back_FPD_DLL;

} NNLayer_t;

typedef struct NNLayerInstance_t
{
  NNLayer_t* Given_Struct;

  //FMatrix_DLL
  FMatrix_t* Input;  //Forward Propigation Value
  //FMatrix_DLL
  FMatrix_t* Output;  //Forward Propigation Value

  //FMatrix_DLL
  FMatrix_t* Desired;       //Back Propigated Value

  //FMatrix_DLL

  DLL_Handle_t* Forward_FPDI_DLL; //points to DLL_handle that is in charge of decorator(pipe) functions
  DLL_Handle_t* Back_FPDI_DLL; //points to DLL_handle that is in charge of decorator(pipe) functions

} NNLayerInstance_t;



void GenericNNetwork_V();
void GenericNNetwork_T(int CallSign);


#endif // GenericNNetwork_H
