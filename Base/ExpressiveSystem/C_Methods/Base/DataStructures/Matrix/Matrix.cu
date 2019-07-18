#ifndef MMath_CU
#define MMath_CU

#include "Matrix.h"

void MMath_V()
{
  printf("Matrix Math \t\tV:2.00\n");
}
void MMath_D()
{
  printf("Matrix Math \t\tV:2.00\n");
}


#define ReLU(X)      ((x > 0) ? x : 0)
#define d_ReLU(X)    ((x > 0) ? 1 : 0)
#define LeakyReLU(X,_hA)   ((x > 0) ? x : (x * A))
#define d_LeakyReLU(X,_hA) ((x > 0) ? 1 : (A))



void int_MinMaxClip(int Clip,int* Value)
{
  if (*Value > Clip)
  {
    *Value = Clip;
  }
  else if(*Value < -Clip)
  {
    *Value = -Clip;
  }
}



void float_MinMaxClip(float Clip,float* Value)
{
  if (*Value > Clip)
  {
    *Value = Clip;
  }
  else if(*Value < -Clip)
  {
    *Value = -Clip;
  }
}

void FMatrix_t_MinMaxClip(float Clip,FMatrix_t* FMatrix)
{
  for (int i = 0; i < FMatrix->X; i++)
  {
    for (int j = 0; j < FMatrix->Y; j++)
    {
      float_MinMaxClip(Clip,(FMatrix->Array + i*FMatrix->Y + j));
    }
  }
}


IMatrix_t* Create_IMatrix_t(int x,int y)
{
  IMatrix_t* Matrix =(IMatrix_t*) malloc(sizeof(IMatrix_t));

  Matrix->Array = (int *)malloc(x * y * sizeof(int));
  Matrix->X = x;
  Matrix->Y = y;
  qSet_2D_Matrix_Elements(Matrix,0)

  return Matrix;
}

void Copy(IMatrix_t* IMatrix0,IMatrix_t* IMatrix1)
{
  for (int i = 0; i < IMatrix0->X; i++)
  {
    for (int j = 0; j < IMatrix0->Y; j++)
    {
      *(IMatrix1->Array + i*IMatrix1->Y + j) = *(IMatrix0->Array + i*IMatrix0->Y + j);
    }
  }
}


IMatrix_t* Copy(IMatrix_t* IMatrix0)
{
  IMatrix_t* IMatrix1 = Create_IMatrix_t(IMatrix0->Y,IMatrix0->Y);
  for (int i = 0; i < IMatrix0->X; i++)
  {
    for (int j = 0; j < IMatrix0->Y; j++)
    {
      *(IMatrix1->Array + i*IMatrix1->Y + j) = *(IMatrix0->Array + i*IMatrix0->Y + j);
    }
  }
  return IMatrix1;
}

int GetSum_IMatrix(IMatrix_t* IMatrix)
{
  register int Sum = 0;
  for (int i = 0; i < IMatrix->X; i++)
  {
    for (int j = 0; j < IMatrix->Y; j++)
    {
      Sum += *(IMatrix->Array + i*IMatrix->Y + j);
    }
  }
  return Sum;
}

bool Equivalent(IMatrix_t*Matrix0,IMatrix_t*Matrix1)
{
  if((Matrix0->X)   != (Matrix1->X) ||
     (Matrix0->Y)   != (Matrix1->Y)
   )
   {
     return false;
   }
   for(int i = 0; i < Matrix0->X ;i++)
   {
     for(int j = 0; j < Matrix0->Y ;j++)
     {
        if((*(Matrix0->Array+i*Matrix0->Y+j)) != (*(Matrix1->Array+i*Matrix1->Y+j)))
        {
          return false;
        }
     }
   }
   return true;
}

IMatrix_t* CreateIntegerIdentityMatrix(int x,int y)
{
  IMatrix_t* Matrix = (IMatrix_t*) malloc(sizeof(IMatrix_t));

  Matrix->Array = (int *)malloc(x * y * sizeof(int));
  Matrix->X = x;
  Matrix->Y = y;
  for (int i = 0; i < Matrix->X; i++)
  {
    for (int j = 0; j < Matrix->Y; j++)
    {
      if(i == j)
      {
        *(Matrix->Array + i*Matrix->Y + j) = 1;
      }
      else
      {
        *(Matrix->Array + i*Matrix->X + j) = 0;
      }

    }
  }
  return Matrix;
}

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

FMatrix_t* Create_FMatrix_t(int x,int y)
{
  FMatrix_t* FMatrix = (FMatrix_t*)malloc(sizeof(FMatrix_t));

  FMatrix->Array = (float *)malloc(x * y * sizeof(float));
  FMatrix->X = x;
  FMatrix->Y = y;
  //float Zero = 0;
  //qSet_2D_Matrix_Elements(FMatrix,0)
  return FMatrix;
}

FMatrix_t* CreateZero_FMatrix_t(int x,int y)
{
  FMatrix_t* FMatrix = (FMatrix_t*)malloc(sizeof(FMatrix_t));

  FMatrix->Array = (float *)malloc(x * y * sizeof(float));
  FMatrix->X = x;
  FMatrix->Y = y;
  //float Zero = 0;
  qSet_2D_Matrix_Elements(FMatrix,0)
  return FMatrix;
}

FMatrix_t* CreateFloatMatrix(int x,int y)
{
  FMatrix_t* FMatrix = (FMatrix_t*)malloc(sizeof(FMatrix_t));

  FMatrix->Array = (float *)malloc(x * y * sizeof(float));
  FMatrix->X = x;
  FMatrix->Y = y;
  //float Zero = 0;
  qSet_2D_Matrix_Elements(FMatrix,0)
  return FMatrix;
}

FMatrix_t* CreatefloatIdentityMatrix(int x,int y)
{
  FMatrix_t* Matrix =(FMatrix_t*) malloc(sizeof(FMatrix_t));

  Matrix->Array = (float *)malloc(x * y * sizeof(float));
  Matrix->X = x;
  Matrix->Y = y;
  float One = 1;
  for (int i = 0; i < Matrix->X; i++)
  {
    for (int j = 0; j < Matrix->Y; j++)
    {
      if(i == j)
      {
        *(Matrix->Array + i*Matrix->Y + j) = One;
      }
      else
      {
        *(Matrix->Array + i*Matrix->Y + j) = 0;
      }

    }
  }
  return Matrix;
}

FMatrix_t* CreateIdentity_FMatrix_t(int x,int y)
{
  FMatrix_t* Matrix =(FMatrix_t*) malloc(sizeof(FMatrix_t));

  Matrix->Array = (float *)malloc(x * y * sizeof(float));
  Matrix->X = x;
  Matrix->Y = y;
  float One = 1;
  for (int i = 0; i < Matrix->X; i++)
  {
    for (int j = 0; j < Matrix->Y; j++)
    {
      if(i == j)
      {
        *(Matrix->Array + i*Matrix->Y + j) = One;
      }
      else
      {
        *(Matrix->Array + i*Matrix->Y + j) = 0;
      }

    }
  }
  return Matrix;
}

void ZeroFloatMatrix(FMatrix_t* FMatrix)
{
  qSet_2D_Matrix_Elements(FMatrix,0)
}

void Zero_FMatrix_t(FMatrix_t* FMatrix)
{
  qSet_2D_Matrix_Elements(FMatrix,0)
}


void CopyFloatMatrix(FMatrix_t* FMatrix0,FMatrix_t* FMatrix1)
{
  for (int i = 0; i < FMatrix0->X; i++)
  {
    for (int j = 0; j < FMatrix0->Y; j++)
    {
      *(FMatrix1->Array + i*FMatrix1->Y + j) = *(FMatrix0->Array + i*FMatrix0->Y + j);
    }
  }
}

FMatrix_t* MakeCopyFMatrix(FMatrix_t* Matrix0)
{
  FMatrix_t* Copy = CreateFloatMatrix(Matrix0->X,Matrix0->Y);
  for(int XAxis = 0; XAxis < Matrix0->X;XAxis++)
  {

    for(int YAxis = 0; YAxis < Matrix0->Y;YAxis++)
    {
      *(Copy->Array+(Copy->X*YAxis+(XAxis))) = *(Matrix0->Array+(Matrix0->X*YAxis+(XAxis)));
    }
  }
  return Copy;
}

float GetSum_FMatrix(FMatrix_t* FMatrix)
{
  register float Sum = 0;
  for (int i = 0; i < FMatrix->X; i++)
  {
    for (int j = 0; j < FMatrix->Y; j++)
    {
      Sum += *(FMatrix->Array + i*FMatrix->Y + j);
    }
  }
  return Sum;
}

void AddFloatMatrix(FMatrix_t* FMatrix0, FMatrix_t* FMatrix1, FMatrix_t* FMatrix2)
{
  for (int i = 0; i < FMatrix2->X; i++)
  {
    for (int j = 0; j < FMatrix2->Y; j++)
    {
      *(FMatrix2->Array + i*FMatrix2->Y + j) = *(FMatrix0->Array + i*FMatrix0->Y + j)+*(FMatrix1->Array + i*FMatrix1->Y + j);
    }
  }
}

void AddTo_FMatrix_t(FMatrix_t* FMatrix0, FMatrix_t* FMatrix1)
{
  for (int i = 0; i < FMatrix0->X; i++)
  {
    for (int j = 0; j < FMatrix0->Y; j++)
    {
      *(FMatrix0->Array + i*FMatrix0->Y + j) += *(FMatrix1->Array + i*FMatrix1->Y + j);
    }
  }
}

void SubTo_FMatrix_t(FMatrix_t* FMatrix0, FMatrix_t* FMatrix1)
{
  for (int i = 0; i < FMatrix0->X; i++)
  {
    for (int j = 0; j < FMatrix0->Y; j++)
    {
      *(FMatrix0->Array + i*FMatrix0->Y + j) -= *(FMatrix1->Array + i*FMatrix1->Y + j);
    }
  }
}

void Add_FMatrix_t_To_FMatrix_t(FMatrix_t* FMatrix0, FMatrix_t* FMatrix1)
{
  for (int i = 0; i < FMatrix0->X; i++)
  {
    for (int j = 0; j < FMatrix0->Y; j++)
    {
      *(FMatrix0->Array + i*FMatrix0->Y + j) += *(FMatrix1->Array + i*FMatrix1->Y + j);
    }
  }
}


//Tested and works
void FAbs_Sigmoid_FMatrix_t(FMatrix_t* PropigatedActivation)
{
  //PrintFloatMatrix(PropigatedActivation);
  //printf("Sigmoid_FMatrix_t recieved proper PropigatedActivation structure\n");

  //x*log(fabs(x)+1)/fabs(x);
  for(int XAxis = 0; XAxis < PropigatedActivation->X;XAxis++)
  {
    for(int YAxis = 0; YAxis < PropigatedActivation->Y;YAxis++)
    {
      (*(PropigatedActivation->Array+(PropigatedActivation->X*YAxis)+(XAxis)))
        =          (*(PropigatedActivation->Array+(PropigatedActivation->X*YAxis)+(XAxis)))
          /(1+fabs((*(PropigatedActivation->Array+(PropigatedActivation->X*YAxis)+(XAxis)))));
    }
  }
  //printf("exiting with PropigatedActivation structure\n");
  //PrintFloatMatrix(PropigatedActivation);
  //printf("exiting with Proper PropigatedActivation structure\n");
}




//Two activation methods for back propigation !
//Front end/ Back end DLL storage !
//Stack storage to implement! storage

//NN Layer Nultiplication
// use Assert -> Create To hide/ Produce Test code
void LayerMultiplication(FMatrix_t* WeightMatrix,FMatrix_t** Given_PropigatedActivation)
{
  FMatrix_t* PropigatedActivation = *Given_PropigatedActivation;
  FMatrix_t* NewPropigatedActivation = (FMatrix_t*)CreateZero_FMatrix_t((PropigatedActivation)->X,(PropigatedActivation)->Y);
  float Element0 = 0;
  float Element1 = 0;
  for(int YAxis = 0; YAxis < (PropigatedActivation)->Y; YAxis++)
  {
    for(int XAxis = 0; XAxis < (PropigatedActivation)->X; XAxis++)
    {

      //Loop Through Weight Matrix and Add To NewPropigatedActivation Matrix
      Element0 = *((PropigatedActivation)->Array+((PropigatedActivation)->X*YAxis)+(XAxis));
      //printf("Activation %f\n",Element0);

      for(int XSlide = 0; XSlide < (PropigatedActivation)->X;XSlide++)
      {
        for(int YSlide = 0; YSlide < (PropigatedActivation)->Y;YSlide++)
        {
          Element1 = *(WeightMatrix->Array+(WeightMatrix->X * (PropigatedActivation)->X*YAxis + (PropigatedActivation)->X*(PropigatedActivation)->Y*XAxis +(PropigatedActivation)->Y*XSlide + YSlide));
          float Result = Element0 * Element1;
          (*(NewPropigatedActivation->Array+NewPropigatedActivation->Y*XSlide+YSlide)) += Result;
          /*
          printf("==================================================================\n");
          printf("\tElement0 %f\n",Element0);
          printf("\tElement1 %f\n",Element1);
          printf("\tResult %f\n",(*(NewPropigatedActivation->Array+NewPropigatedActivation->Y*XSlide+YSlide)));
          printf("Result-> %d\n", NewPropigatedActivation->Y*XSlide+YSlide);
          printf("YAxis %d, XAxis %d, XSlide %d, YSlide %d, Position %d \n",YAxis,XAxis,XSlide,YSlide,(WeightMatrix->X*(*PropigatedActivation)->X*YAxis + (*PropigatedActivation)->X*(*PropigatedActivation)->Y*XAxis +(*PropigatedActivation)->Y*XSlide + YSlide));
          //(*(NewPropigatedActivation->Array+(WeightMatrix->X*(*PropigatedActivation)->X*YAxis + (*PropigatedActivation)->X*(*PropigatedActivation)->Y*XAxis +(*PropigatedActivation)->Y*XSlide + YSlide))) += Element0 * Element1;
          printf("==================================================================\n");
          */

        }
      }



    }
  }

  //printf("Propigated Matrix\n");
  //PrintFloatMatrix(NewPropigatedActivation);

  //PrintFloatMatrix(*Given_PropigatedActivation);
  Free((PropigatedActivation));
  *Given_PropigatedActivation = NewPropigatedActivation;

  //PrintFloatMatrix(*Given_PropigatedActivation);
  //printf("Exiting Layer Multiplication\n");
}




void NN_MaskedLayerMultiplication(FMatrix_t* WeightMatrix,FMatrix_t** Given_PropigatedActivation,FMatrix_t* DropOutMask)
{
  FMatrix_t* PropigatedActivation = *Given_PropigatedActivation;
  FMatrix_t* NewPropigatedActivation = (FMatrix_t*)CreateZero_FMatrix_t((PropigatedActivation)->X,(PropigatedActivation)->Y);
  float Element0 = 0;
  float Element1 = 0;
  for(int YAxis = 0; YAxis < (PropigatedActivation)->Y; YAxis++)
  {
    for(int XAxis = 0; XAxis < (PropigatedActivation)->X; XAxis++)
    {

      //Loop Through Weight Matrix and Add To NewPropigatedActivation Matrix
      Element0 = *((PropigatedActivation)->Array+((PropigatedActivation)->X*YAxis)+(XAxis));
      //printf("Activation %f\n",Element0);
      if(*((DropOutMask)->Array+((DropOutMask)->X*YAxis)+(XAxis)) == 1)
      {
        for(int XSlide = 0; XSlide < (PropigatedActivation)->X;XSlide++)
        {
          for(int YSlide = 0; YSlide < (PropigatedActivation)->Y;YSlide++)
          {
            Element1 = *(WeightMatrix->Array+(WeightMatrix->X * (PropigatedActivation)->X*YAxis + (PropigatedActivation)->X*(PropigatedActivation)->Y*XAxis +(PropigatedActivation)->Y*XSlide + YSlide));
            float Result = Element0 * Element1;
            (*(NewPropigatedActivation->Array+NewPropigatedActivation->Y*XSlide+YSlide)) += Result;
            /*
            printf("==================================================================\n");
            printf("\tElement0 %f\n",Element0);
            printf("\tElement1 %f\n",Element1);
            printf("\tResult %f\n",(*(NewPropigatedActivation->Array+NewPropigatedActivation->Y*XSlide+YSlide)));
            printf("Result-> %d\n", NewPropigatedActivation->Y*XSlide+YSlide);
            printf("YAxis %d, XAxis %d, XSlide %d, YSlide %d, Position %d \n",YAxis,XAxis,XSlide,YSlide,(WeightMatrix->X*(*PropigatedActivation)->X*YAxis + (*PropigatedActivation)->X*(*PropigatedActivation)->Y*XAxis +(*PropigatedActivation)->Y*XSlide + YSlide));
            //(*(NewPropigatedActivation->Array+(WeightMatrix->X*(*PropigatedActivation)->X*YAxis + (*PropigatedActivation)->X*(*PropigatedActivation)->Y*XAxis +(*PropigatedActivation)->Y*XSlide + YSlide))) += Element0 * Element1;
            printf("==================================================================\n");
            */

          }
        }
      }


    }
  }

  //printf("Propigated Matrix\n");
  //PrintFloatMatrix(NewPropigatedActivation);

  //PrintFloatMatrix(*Given_PropigatedActivation);
  Free((PropigatedActivation));
  *Given_PropigatedActivation = NewPropigatedActivation;

  //PrintFloatMatrix(*Given_PropigatedActivation);
  //printf("Exiting Layer Multiplication\n");
}


//Takes the Hypothesised value from a NN for a given input, and takes the
// Desired Output to find the RootMeanSquareError
//RMSE (RootMeanSquareError)
float Cost_RMSE(FMatrix_t* Activation,FMatrix_t* Desired)
{
  //TODO Make Definition for quick defining Methods
  //float Cost = 0;
  float Cost = 0;
  for (int i = 0; i < Activation->X; i++)
  {
    for (int j = 0; j < Activation->Y; j++)
    {
      //TotalChange
      Cost += ((*(Desired->Array + i*Desired->Y + j)) - (*(Activation->Array + i*Activation->Y + j)));
    }
  }
  return Cost/(2* Activation->X * Activation->Y);
}

//TODO Rename this
//Tested and works
void Sigmoid_FMatrix_t(FMatrix_t* PropigatedActivation)
{
  //PrintFloatMatrix(PropigatedActivation);
  //printf("Sigmoid_FMatrix_t recieved proper PropigatedActivation structure\n");

  //x*log(fabs(x)+1)/fabs(x);
  for(int XAxis = 0; XAxis < PropigatedActivation->X;XAxis++)
  {
    for(int YAxis = 0; YAxis < PropigatedActivation->Y;YAxis++)
    {
      (*(PropigatedActivation->Array+(PropigatedActivation->X*YAxis)+(XAxis)))
        =          (*(PropigatedActivation->Array+(PropigatedActivation->X*YAxis)+(XAxis)))
          /(1+fabs((*(PropigatedActivation->Array+(PropigatedActivation->X*YAxis)+(XAxis)))));
    }
  }
  //printf("exiting with PropigatedActivation structure\n");
  //PrintFloatMatrix(PropigatedActivation);
  //printf("exiting with Proper PropigatedActivation structure\n");
}

void MaskedSigmoid_FMatrix_t(FMatrix_t* PropigatedActivation,FMatrix_t* DropOutMask)
{
  //PrintFloatMatrix(PropigatedActivation);
  //printf("Sigmoid_FMatrix_t recieved proper PropigatedActivation structure\n");

  //x*log(fabs(x)+1)/fabs(x);
  for(int XAxis = 0; XAxis < PropigatedActivation->X;XAxis++)
  {
    for(int YAxis = 0; YAxis < PropigatedActivation->Y;YAxis++)
    {
      if((*(DropOutMask->Array+(DropOutMask->X*YAxis)+(XAxis))) == 1)
      {
        (*(PropigatedActivation->Array+(PropigatedActivation->X*YAxis)+(XAxis)))
          =          (*(PropigatedActivation->Array+(PropigatedActivation->X*YAxis)+(XAxis)))
            /(1+fabs((*(PropigatedActivation->Array+(PropigatedActivation->X*YAxis)+(XAxis)))));
      }
      else
      {
        (*(PropigatedActivation->Array+(PropigatedActivation->X*YAxis)+(XAxis))) = 0 ;
      }

    }
  }
  //printf("exiting with PropigatedActivation structure\n");
  //PrintFloatMatrix(PropigatedActivation);
  //printf("exiting with Proper PropigatedActivation structure\n");
}

void Free(FMatrix_t* Matrix)
{
  if (Matrix != NULL)
  {
    if(Matrix->Array != NULL)
    {
      free(Matrix->Array);
    }

    free(Matrix);
  }
}
//void Free_DLL_FMatrix_t(DLL_Handle_t* DLL_Handle);
QDefineFree_DLL_GivenStruct(Free,FMatrix_t)
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&



//Produces a 'DropOut' Matrix for a described matrix
//Note should always have at least 1 selected element and 1 non selected element
//Rates still apply correctly
//Rate 0-1
FMatrix_t* RandomMask_FMatrixMatrix(int x,int y, float Rate)
{
  FMatrix_t* GeneratedMask = CreateFloatMatrix(x,y);
  //Select 2 Random elements ->
  //increment SumSlide, from Node to Node, and test when Sum Region is reached

  for (int i = 0; i < x; i++)
  {
    for (int j = 0; j < y; j++)
    {
      if ( RandomFloat(0,1) < Rate)
      {
        *(GeneratedMask->Array +y*i +j) = 1;
      }
      else
      {
        *(GeneratedMask->Array +y*i +j) = 0;
      }
    }
  }
  int chance = RandomInteger(0,x*y);
  //printf("%d,%d\n",chance%x,chance/x);
  *(GeneratedMask->Array +y*(chance%x) +(chance/x)) = 1;
  //Get Sum
  return GeneratedMask;
}





FMatrix_t* RandomSelect_FMatrixMatrix(FMatrix_t* FMatrix)
{
  //float Sum = GetSum_FMatrix(FMatrix);
  float SumSlide = 0;
  float RandomNumber = 0;//Generate RandomNumber from [0,Sum]
  FMatrix_t* SelectMatrix = CreateFloatMatrix(FMatrix->X,FMatrix->Y);
  //increment SumSlide, from Node to Node, and test when Sum Region is reached

  for (int i = 0; i < FMatrix->X; i++)
  {
    for (int j = 0; j < FMatrix->Y; j++)
    {
      SumSlide += *(FMatrix->Array + i*FMatrix->Y + j);
      if (SumSlide <= RandomNumber)
      {

        *(SelectMatrix->Array) = *(SelectMatrix->Array + i*FMatrix->Y + j);
      }
    }
  }
  //Get Sum
  return 0;
}


int RandomSelect_FMatrixIndex(FMatrix_t* FMatrix)
{
  float Sum = GetSum_FMatrix(FMatrix);
  int SumSlide = 0;
  int RandomNumber = RandomFloat(0,Sum);//Generate RandomNumber from [0,Sum]
  int SelectedNode = -1;
  //increment SumSlide, from Node to Node, and test when Sum Region is reached
  printf("Matrix(%d,%d)\n", FMatrix->X,FMatrix->Y);

  for (int i = 0; i < FMatrix->X; i++)
  {
    for (int j = 0; j < FMatrix->Y; j++)
    {
      SumSlide += *(FMatrix->Array + i*FMatrix->Y + j);
      printf("%d=>(%d,%d)",RandomNumber, i,j);printf("SS->%d\n",SumSlide);

      if (SumSlide > RandomNumber   &&
        *(FMatrix->Array + i*FMatrix->Y + j) != 0 )
      {
        SelectedNode = (i*FMatrix->Y+j);
        printf("selected %d\n",SelectedNode);
      }
    }
  }
  //Get Sum
  return SelectedNode;
}

int RandomSelect_IMatrixIndex(IMatrix_t* IMatrix)
{
  int Sum = GetSum_IMatrix(IMatrix);
  int SumSlide = 0;
  if (Sum == 0)
  {
    return -1;
  }
  int RandomNumber = RandomInteger(1,Sum);//Generate RandomNumber from [0,Sum]

  int SelectedNode = -1;
  //increment SumSlide, from Node to Node, and test when Sum Region is reached
  //printf("Matrix(%d,%d)\n", IMatrix->X,IMatrix->Y);

  for (int i = 0; i < IMatrix->X; i++)
  {
    for (int j = 0; j < IMatrix->Y; j++)
    {
      SumSlide += *(IMatrix->Array + i*IMatrix->Y + j);
      //printf("%d=>(%d,%d)",RandomNumber, i,j);printf("SS->%d\n",SumSlide);

      if (SumSlide == RandomNumber   &&
        *(IMatrix->Array + i*IMatrix->Y + j) != 0 )
      {
        SelectedNode = (i*IMatrix->Y+j);
        //printf("selected %d\n",SelectedNode);
      }
    }
  }
  //Print(IMatrix);
  //PrintInt(SelectedNode)
  //Get Sum
  return SelectedNode;
}





//Drop out Matrix
IMatrix_t* CreateI_DOM(int x,int y)
{


  IMatrix_t* Matrix = (IMatrix_t*)malloc(sizeof(IMatrix_t));
  Matrix->Array =(int*) malloc(sizeof(int)*x*y);
  Matrix->X = x;
  Matrix->Y = y;
  //initialized N by N matrix
  //now make it an Identity Matrix

  for(int XAxis = 0; XAxis < Matrix->X;XAxis++)
  {

    for(int YAxis = 0; YAxis < Matrix->Y;YAxis++)
    {
      *(Matrix->Array+(Matrix->X*XAxis)+(YAxis)) = rand()%2;

    }
    //printf("%p",(Matrix->Array+(XAxis*Matrix->Y*sizeof(double))));
  }
  return Matrix;
}


IMatrix_t* CreateI_RW(int y,int x)
{
  srand(time(NULL));   // should only be called once

  IMatrix_t* Matrix = (IMatrix_t*)malloc(sizeof(IMatrix_t));
  Matrix->Array = (int*) malloc(sizeof(int)*x*y);
  Matrix->X = x;
  Matrix->Y = y;
  //initialized N by N matrix
  //now make it an Identity Matrix

  for(int XAxis = 0; XAxis < Matrix->X;XAxis++)
  {

    for(int YAxis = 0; YAxis < Matrix->Y;YAxis++)
    {
      *(Matrix->Array+(Matrix->X*XAxis)+(YAxis)) = ((int)rand() / (int)RAND_MAX)*(2);
    }
    //printf("%p",(Matrix->Array+(XAxis*Matrix->Y*sizeof(double))));
  }
  return Matrix;
}

FMatrix_t* CreateF_RW(int y,int x)
{
  FMatrix_t* Matrix = (FMatrix_t*) malloc(sizeof(FMatrix_t));
  Matrix->Array = (float*)malloc(sizeof(float)*x*y);
  Matrix->X = x;
  Matrix->Y = y;
  //initialized N by N matrix
  //now make it an Identity Matrix

  for(int XAxis = 0; XAxis < Matrix->X;XAxis++)
  {

    for(int YAxis = 0; YAxis < Matrix->Y;YAxis++)
    {
      *(Matrix->Array+(Matrix->X*XAxis)+(YAxis)) = ((float)rand() / (float)RAND_MAX)*(2);
    }
    //printf("%p",(Matrix->Array+(XAxis*Matrix->Y*sizeof(double))));
  }
  return Matrix;
}

void MultiplyFMatrices(FMatrix_t* Matrix0,FMatrix_t* Matrix1,FMatrix_t* Result)
{
  double Sum;
  float Element0 = 0;
  float Element1 = 0;
  for(int YAxis = 0; YAxis < Matrix0->Y; YAxis++)
  {
    for(int XAxis = 0; XAxis < Matrix1->X; XAxis++)
    {
    //  printf("%d,%d\n",XAxis,YAxis );
    //  printf("Value:%lf\n",*(Matrix0->Array+(Matrix0->X*XAxis*sizeof(double))+(YAxis*sizeof(double))));
      Sum = 0;
      for(int Slide = 0; Slide < Matrix0->X;Slide++)
      {
        Element0 = *(Matrix0->Array+(Matrix0->X*Slide)+(XAxis));
        Element1 = *(Matrix1->Array+(Matrix1->X*YAxis)+(Slide));
        //printf(" %f ",Element0);
        //printf(" %f ",Element1);
        //printf("=%f\n",Element0);
        Element0 *=  Element1;
        Sum += Element0;

      }

      (*(Result->Array+(Result->X*YAxis)+(XAxis))) = Sum;
    }
  }
}











void Print(IMatrix_t* Matrix)
{
  int XAxis, YAxis;
  printf("Print Matrix:\n");
  printf("-------------\n");
  printf("(%d,%d)\n",Matrix->X,Matrix->Y);
  for(XAxis = 0; XAxis < Matrix->X;XAxis++)
  {
    printf("{");

    for(YAxis = 0; YAxis < Matrix->Y;YAxis++)
    {
      //printf("( %p,",(Matrix->Array+(Matrix->X*XAxis*sizeof(double))+(YAxis*sizeof(double))));
      //printf(" %p",*(Matrix->Array+(Matrix->X*XAxis*sizeof(double))+(YAxis*sizeof(double))));
      printf(" %d ",*(Matrix->Array+(Matrix->X*YAxis+(XAxis))));
    }
    //printf("%p",(Matrix->Array+(XAxis*Matrix->Y*sizeof(double))));
    printf(" }\n");
  }

}


void CopyMatrices(FMatrix_t* Matrix0,FMatrix_t* Final)
{
  for(int XAxis = 0; XAxis < Matrix0->X;XAxis++)
  {

    for(int YAxis = 0; YAxis < Matrix0->Y;YAxis++)
    {
      *(Final->Array+(Final->X*YAxis+(XAxis))) = *(Matrix0->Array+(Matrix0->X*YAxis+(XAxis)));
    }
  }
}



void Scale_FMatrix_t(float Scale,FMatrix_t* Matrix0)
{
  for(int XAxis = 0; XAxis < Matrix0->X;XAxis++)
  {
    for(int YAxis = 0; YAxis < Matrix0->Y;YAxis++)
    {
      *(Matrix0->Array+(Matrix0->X*YAxis+(XAxis))) *= Scale;
    }
  }
}

void PrintFloatMatrix(FMatrix_t* Matrix)
{
  if(Matrix != NULL)
  {
    int XAxis, YAxis;
    printf("Print Matrix:\n");
    printf("-------------\n");
    printf("(%d,%d)\n",Matrix->X,Matrix->Y);
    for(XAxis = 0; XAxis < Matrix->X;XAxis++)
    {
      printf("{");

      for(YAxis = 0; YAxis < Matrix->Y;YAxis++)
      {
        //printf("( %p,",(Matrix->Array+(Matrix->X*XAxis*sizeof(double))+(YAxis*sizeof(double))));
        //printf(" %p",*(Matrix->Array+(Matrix->X*XAxis*sizeof(double))+(YAxis*sizeof(double))));
        //printf(" %p ",(Matrix->Array+(Matrix->X*XAxis+(YAxis))));
        printf(" %f ",*(Matrix->Array+(Matrix->X*YAxis+(XAxis))));
      }
      //printf("%p",(Matrix->Array+(XAxis*Matrix->Y*sizeof(double))));
      printf(" }\n");
    }
  }
}



void Free(IMatrix_t* Matrix)
{
  free(Matrix->Array);
  free(Matrix);
}






/*
bool Read_IMatrix_Parser(char* FilePath,IMatrix_t* Matrix)
{
  //Check If File Exists
  if(!FileExists(FilePath))
  {
    return false;
  }

  //Create Line To store Data Read From File
  char Line[MAXCHAR];
  //Create LineSlide to Parse through lines, skiping over Blank space,
  //and Configuration Data Structure
  char *LineSlide;
  //Create A File Pointer from the given String
  FILE *FilePointer = fopen(FilePath,"r");
  //fflush(NULL);

  bool Gathering_MV = false;
  while(fgets(Line,MAXCHAR,FilePointer) != NULL)
  {

    //Standard Braket found
    if(SkipToken("<",Line,&LineSlide))
    {
      //Test for ManagedVariable(MV)
      if(SkipToken("MV",LineSlide,&LineSlide))
      {

        //"Name = 'Test'"
        if(SkipToken("Name",LineSlide,&LineSlide))
        {

          SkipGivenCharacters(LineSlide,&Line," \t");
          if(SkipToken("=",LineSlide,&LineSlide))
          {

            SkipGivenCharacters(LineSlide,&LineSlide," \t");
            //look for (")- Start String Varible
            if(SkipToken("\"",LineSlide,&LineSlide))
            {
              //Gather Variable

              SkipGivenCharacters(LineSlide,&LineSlide," \t");
              //look for (")- end String Varible
              if(SkipToken("\"",LineSlide,&LineSlide))
              {
Gathering_MV = true;
              }
            }


          }


        }

      }

    }


  }



  fclose(FilePointer);
}
*/



/*
//"Style = 'FMatrix'"
if(SkipToken("Style",Line,&LineSlide))
{
  //Start Matrix Aquire ProtoColl

}
*/


float MeanAbsError_FMatrix(FMatrix_t* FMatrix0,FMatrix_t* Desired)
{
  float Cost = 0;
  for (int i = 0; i < FMatrix0->X; i++)
  {
    for (int j = 0; j < FMatrix0->Y; j++)
    {
      Cost += abs(*(FMatrix0->Array + i*FMatrix0->Y + j)-*(Desired->Array + i*Desired->Y + j));
    }
  }
  return Cost/(FMatrix0->X * FMatrix0->Y);
}

//Takes the Hypothesised value from a NN for a given input, and takes the
// Desired Output to find the RootMeanSquareError
float RootMeanSquareError(FMatrix_t* FMatrix0,FMatrix_t* Desired)
{
  float Cost = 0;
  for (int i = 0; i < FMatrix0->X; i++)
  {
    for (int j = 0; j < FMatrix0->Y; j++)
    {
      Cost += pow((*(FMatrix0->Array + i*FMatrix0->Y + j)-*(Desired->Array + i*Desired->Y + j)),2);
    }
  }
  return Cost/(2* FMatrix0->X * FMatrix0->Y);
}



//Takes the Hypothesised value from a NN for a given input, and takes the
// Desired Output to find the SquaredError
float SquaredError_FMatrix(FMatrix_t* FMatrix0,FMatrix_t* Desired)
{
  float Cost = 0;
  for (int i = 0; i < FMatrix0->X; i++)
  {
    for (int j = 0; j < FMatrix0->Y; j++)
    {
      Cost += pow((*(FMatrix0->Array + i*FMatrix0->Y + j)-*(Desired->Array + i*Desired->Y + j)),2);
    }
  }
  return Cost/(2* FMatrix0->X * FMatrix0->Y);
}

//Testing

bool MakeCopyFMatrix_t_T()
{
  printf("Testing MakeCopyFMatrix_t_T()\n");
  FMatrix_t* Matrix0 = CreateF_RW(2,2);
  FMatrix_t* Matrix1 = MakeCopyFMatrix(Matrix0);

  PrintFloatMatrix(Matrix0);
  Free(Matrix0);

  PrintFloatMatrix(Matrix1);
  Free(Matrix1);

  return 1;
}


//Testing
bool Test_MultiplyMatrix()
{
  printf("Testing multiplyMatrices\n");
  FMatrix_t* Matrix0 = CreateF_RW(2,2);
  FMatrix_t* Matrix1 = CreateF_RW(2,2);
  FMatrix_t* Matrix2 = CreateF_RW(2,2);
  PrintFloatMatrix(Matrix0);
  PrintFloatMatrix(Matrix1);

  MultiplyFMatrices(Matrix0,Matrix1,Matrix2);

  PrintFloatMatrix(Matrix2);

  //PrintMatrix(SMatrix);
  //system("gnome-terminal -e \"rm -f Test.txt \"");
  //SaveMatrix("Test.txt",IMatrix);
  Free(Matrix0);
  Free(Matrix1);
  Free(Matrix2);
  return 1;
}

void RandomSelect_T()
{
  IMatrix_t* IMatrix0 = CreateIntegerIdentityMatrix(2,2);
  Print(IMatrix0);
  for(int x=0; x<100;x++)
  {
    int y = RandomSelect_IMatrixIndex(IMatrix0);
    printf("Selected Random int");
    PrintInt(y)
    PrintLines(2)
  }

  //Print(IMatrix1);

  Free(IMatrix0);
  //Free(IMatrix1);
}



void MMath_TT()
{
  int SelectedTest = 0;
  printf("0 = MakeCopyFMatrix_t_T()\n");
  printf("1 = \n");
  printf("2 = \n");
  printf("100 =\n");
  GatherTerminalInt("Please Select Test Move:",&SelectedTest);
  if (SelectedTest == 0)
  {
    MakeCopyFMatrix_t_T();
  }
  else if (SelectedTest == 1)
  {

  }
  else if (SelectedTest == 2)
  {

  }
  else if (SelectedTest == 3)
  {

  }
  else if (SelectedTest == 4)
  {

  }
  else if (SelectedTest == 100)
  {

  }
}

void MMath_T(int CallSign)
{
  printf("\n\n");
  printf("Starting MMath Tests:\n");
  printf("----------------------------\n");

  if (CallSign == 1)
  {
    //NNOperations_AT();
  }
  else
  {
    MMath_TT();
  }

  //NNOperations_OpenSave_T();

}

#endif // MMath_CU
