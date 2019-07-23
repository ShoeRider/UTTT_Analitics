#ifndef MMath_CU
#define MMath_CU

#include "Matrix.h"

void MMath_V()
{
  printf("Matrix Math \t\tV:2.00\n");
}
template <class T>
class Matrix
{
  T** matrix ;
  int _rows,_cols;
public:
  Matrix(){
    Matrix(10,10);
  }

  Matrix(int rows,int cols){
    _rows = rows;
    _cols = cols;
    matrix =  MallocHeadlessMatrix();
  }

  T** MallocHeadlessMatrix()
  {
    T** HeadlessMatrix = new T*[_rows];
    if(_rows){
      HeadlessMatrix[0] = new T[_rows*_cols];
      for (int i =1; i <_rows; i ++){
        HeadlessMatrix[i] = HeadlessMatrix[0] + i * _cols;
      }
    }
    return HeadlessMatrix;
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

  //Produces a 'DropOut' Matrix for a described matrix
  //Note should always have at least 1 selected element and 1 non selected element
  //Rates still apply correctly
  //Rate 0-1
  void RandomMask(){
  }

  //Transpose Matrix
  void Transpose()
  {
    T** Headless = MallocHeadlessMatrix();
    for(int i = 0; i < _rows; ++i)
      for(int j = 0; j < _cols; ++j)
      {
          Headless[j][i]=matrix[i][j];
      }
    FreeHeadlessMatrix(matrix);
    matrix=Headless;
  }


  T FindSum(){
    T Sum = 0;
    for(int i = 0; i < _rows ;i++)
    {
      for(int j = 0; j < _cols ;j++)
      {
        Sum += matrix[i][j];
      }
    }
    return Sum;
  }

  void ApplyReLu(){
    for(int i = 0; i < _rows ;i++)
    {
      for(int j = 0; j < _cols ;j++)
      {
        matrix[i][j] = ReLU(matrix[i][j]);
      }
    }
  }

  Matrix* GetReLu(){
    Matrix<T> NewMatrix = Copy();
    NewMatrix->ApplyReLu();
    return NewMatrix;
  }

  Matrix* Multiply(Matrix* Matrix1){
    Matrix<T>* NewMatrix = new Matrix<T>(_rows,Matrix1->_cols);
    NewMatrix->SetAll(0);
    Multiply(Matrix1,NewMatrix);
    return NewMatrix;
  }

  void Multiply(Matrix* Matrix1,Matrix* Result){
    for(int i = 0; i < _rows; ++i){
      for(int j = 0; j < Matrix1->_cols; ++j){
        for(int k = 0; k < _cols; ++k){
          Result->matrix[i][j] += matrix[i][k] * Matrix1->matrix[k][j];
        }
      }
    }

  }

  void SetValues(){
    for(int i = 0; i < _rows; ++i){
      for(int j = 0; j < _cols; ++j){
        cout << "Enter Value At(" << i + 1 <<","<< j + 1 << ") : ";
        cin >> matrix[i][j];
      }
    }

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

  void FreeHeadlessMatrix(T** HeadlessMatrix)
  {
    if (_rows) delete [] HeadlessMatrix[0];
    delete [] HeadlessMatrix;
  }
  ~Matrix(){
    FreeHeadlessMatrix(matrix);
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
