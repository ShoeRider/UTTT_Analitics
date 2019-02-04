#ifndef GenericNNetwork_CU
#define GenericNNetwork_CU

#include "GenericNNetwork.h"

void GenericNNetwork_V()
{
  printf("NNLayer  \tV:2.00\n");
}








//Network strucutres,
//Note these Modules should allow for additional NN Structure Types, and
//NN operations, including MCTS - integration ?




//Creates:
//FPP_NNLayer
//FPD_NNLayer_t
//FPDI_NNLayer_t
/*
typedef struct NNLayerOperation_t
{

} NNLayerOperation_t;
*/



typedef struct PropigatedGradients_t
{
  NNLayer_t* Given_Struct;

  //FMatrix_DLL
  FMatrix_t* PropigatedGradient;  //Forward Propigation Value
  //FMatrix_DLL
  FMatrix_t* Output;  //Forward Propigation Value

  //FMatrix_DLL
  FMatrix_t* Desired;       //Back Propigated Value


} PropigatedGradients_t;




//TODO Create Functions:
//1. Stokastic Accumulation
//2. Apply Stokastic Accumulation
typedef struct NNLayerStocasticGradientDecent_t{
    FMatrix_t* AccumulatedChange;
}NNLayerStocasticGradientDecent_t;


//TODO Create Functions:
//1. Multiplication DropOut
//2. Activation DropOut
//2. Addition DropOut
typedef struct NNLayerDropOut_t{
  FMatrix_t* DropOutMask;
}NNLayerDropOut_t;

typedef struct FreezeNNLayer_t{
  //from Instance Produce the associated FMatrix_t
  FMatrix_t* associatedActivation;

} FreezeNNLayer_t;

typedef struct BatchNormalization_t{
  int Fan_In;
  int Fan_Out;
} BatchNormalization_t;


//NNLayerOperation_t
//-----------------------------------------------------------------------------
NNLayerInstance_t* Create_NNLayerInstance_t(NNLayer_t* NNLayer)
{
  //NNLayerOperation_t* NNLayerOperation = (NNLayerOperation_t*)malloc(sizeof(NNLayerOperation_t));
  qMalloc(NNLayerInstance)
  NNLayerInstance->Input             = NULL;
  NNLayerInstance->Output            = NULL;
  NNLayerInstance->Desired           = NULL;
  NNLayerInstance->Given_Struct      = NNLayer;

  //NNLayerInstance->Forward_FPDI_DLL = Create_DLL_Handle();
  //NNLayerInstance->Back_FPDI_DLL    = Create_DLL_Handle();
  return NNLayerInstance;
}

void Free_NNLayerInstance_t(NNLayerInstance_t* NNLayerInstance)
{
  Free_FMatrix_t(NNLayerInstance->Input);
  Free_FMatrix_t(NNLayerInstance->Output);
  Free_FMatrix_t(NNLayerInstance->Desired);
  Free_FMatrix_t(NNLayerInstance->Desired);

  //Free_FPDI_t_DLL(NNLayerInstance->Forward_FPDI_DLL);
  //Free_FPDI_t_DLL(NNLayerInstance->Back_FPDI_DLL);
  free(NNLayerInstance);
}


void GenericNNetwork_T(int CallSign)
{
  printf("\n\n");
  printf("Starting NNLayer Tests:\n");
  printf("----------------------------\n");

  if (CallSign == 1)
  {

  }
  else
  {

  }


}

#endif // GenericNNetwork_CU
