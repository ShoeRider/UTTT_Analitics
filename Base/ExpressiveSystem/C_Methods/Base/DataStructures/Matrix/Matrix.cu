#ifndef MMath_CU
#define MMath_CU

#include "Matrix.h"

void MMath_V()
{
  printf("Matrix Math \t\tV:2.00\n");
}
template <class T>
class Matrix{
  T** matrix ;
  int _rows,_cols;
public:

  Matrix(){
    Matrix(10,10);
  }

  Matrix(int rows,int cols){
    _rows = rows;
    _cols = cols;
    matrix = new T*[_rows];
    if(_rows){
      matrix[0] = new T[_rows*_cols];
      for (int i =1; i <_rows; i ++){
        matrix[i] = matrix[0] + i * _cols;
      }
    }
  }

  Matrix Copy(){
    Matrix<T> NewMatrix = new Matrix<T>(_rows,_cols);

    for(int i = 0; i < _rows ;i++)
    {
      for(int j = 0; j < _cols ;j++)
      {
        NewMatrix->matrix[i][j] = matrix[i][j];
      }
    }
    return NewMatrix;
  }

  template <typename FCopy>
  Matrix Copy(FCopy fCopy){
    Matrix<T> NewMatrix = new Matrix<T>(_rows,_cols);

    for(int i = 0; i < _rows ;i++)
    {
      for(int j = 0; j < _cols ;j++)
      {
        fCopy(NewMatrix->matrix[i][j],matrix[i][j]);
      }
    }
    return NewMatrix;
  }

  template <class Object>
  void SetAll(Object value){
    for (int i = 0; i < _rows; i++)
    {
      for (int j = 0; j < _cols; j++)
      {
        matrix[i][j] = (T)0;
      }
    }
  }

  void IMatrix(){
    SetAll(0);
    int Slide = 0;
    while(Slide<_rows && Slide<_cols)
    {
      matrix[Slide][Slide] = (T)1;
      Slide++;
    }
  }

  void Print(){
    for(int i = 0; i < _rows ;i++)
    {
      for(int j = 0; j < _cols ;j++)
      {
         cout << matrix[i][j] << " ";
      }
      cout << endl ;
    }
  }

  bool Equivalent(Matrix*Matrix1){
    if((_rows)   != (Matrix1->_rows) ||
       (_cols)   != (Matrix1->_cols)
     )
     {
       return false;
     }
     for(int i = 0; i < _rows ;i++)
     {
       for(int j = 0; j < _cols ;j++)
       {
         if(matrix[i][j] != Matrix1->matrix[i][j])
         {
           return false;
         }
       }
     }
     return true;
  }

  template <typename FCompare>
  bool Equivalent(Matrix*Matrix1,FCompare NotEquivalent){
    if((_rows)   != (Matrix1->_rows) ||
       (_cols)   != (Matrix1->_cols)
     )
     {
       return false;
     }
     for(int i = 0; i < _rows ;i++)
     {
       for(int j = 0; j < _cols ;j++)
       {
         if(NotEquivalent(matrix[i][j], Matrix1->matrix[i][j]))
         {
           return false;
         }
       }
     }
     return true;
  }

  ~Matrix(){
    if (_rows) delete [] matrix[0];
    delete [] matrix;
  }
};

void MMath_TT()
{
  int SelectedTest = 0;
  printf("0 = \n");
  printf("1 = \n");
  printf("2 = \n");
  printf("100 =\n");
  GatherTerminalInt("Please Select Test Move:",&SelectedTest);
  if (SelectedTest == 0)
  {
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
