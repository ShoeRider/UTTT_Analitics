
void Save_SFMatrix(FILE* FilePointer,FMatrix_t* Matrix)
{
  //Opens File at Provided Destination in Congiguration File
  //fflush(NULL);
  //FILE* FilePointer = fopen(FilePath,"a");
  //fflush(File_Pointer);

  //Start Marker for ManagedStructure
  fputs("<MS, Name = \"Test\", Type = \"FMatrix_t\", Function = \"Structure\">\n",FilePointer);
  char General[MAXCHAR];
  char* General_Slide = &General[0];
  char Temp[MAXCHAR];


  IntXY_ToString_WPostOp(Matrix->X,Matrix->Y,&General_Slide);
  fputs("\t{",FilePointer);
  fputs(General,FilePointer);
  fputs("}\n",FilePointer);

  //Save Matrix It self
  for(int XAxis = 0; XAxis < Matrix->X;XAxis++)
  {
    fputs("\t\t",FilePointer);
    for(int YAxis = 0; YAxis < Matrix->Y;YAxis++)
    {
      snprintf(Temp,MAXCHAR,"%0.5f",*(Matrix->Array+(Matrix->X*YAxis)+(XAxis)));
      fputs(Temp,FilePointer);
      fputs(" ",FilePointer);
      //Save individual matrix value->

    }
    fputs("\n",FilePointer);
  }
  //end Marker for reproof
  fputs("</MS>.",FilePointer);
  fputs(" \n",FilePointer);

  fclose(FilePointer);
}


void Save_VFMatrix(char* FilePath,FMatrix_t* Matrix)
{
  //Opens File at Provided Destination in Congiguration File
  //fflush(NULL);
  FILE* FilePointer = fopen(FilePath,"a");
  //fflush(File_Pointer);

  //Start Marker for ManagedVariable
  fputs("<MV, Name = \"Test\", Type = \"FMatrix_t\", Function = \"Variable\">\n",FilePointer);
  char General[MAXCHAR];
  char* General_Slide = &General[0];
  char Temp[MAXCHAR];


  IntXY_ToString_WPostOp(Matrix->X,Matrix->Y,&General_Slide);
  fputs("\t{",FilePointer);
  fputs(General,FilePointer);
  fputs("}\n",FilePointer);

  //Save Matrix It self
  for(int XAxis = 0; XAxis < Matrix->X;XAxis++)
  {
    fputs("\t\t",FilePointer);
    for(int YAxis = 0; YAxis < Matrix->Y;YAxis++)
    {
      snprintf(Temp,MAXCHAR,"%0.5f",*(Matrix->Array+(Matrix->X*YAxis)+(XAxis)));
      fputs(Temp,FilePointer);
      fputs(" ",FilePointer);
      //Save individual matrix value->

    }
    fputs("\n",FilePointer);
  }
  //end Marker for reproof
  fputs("</MV>.",FilePointer);
  fputs(" \n",FilePointer);

  fclose(FilePointer);
}
void Save_VIMatrix(char* FilePath,IMatrix_t* Matrix)
{
  //Opens File at Provided Destination in Congiguration File
  //fflush(NULL);
  FILE* FilePointer = fopen(FilePath,"a");
  //fflush(File_Pointer);

  //Start Marker for ManagedVariable
  fputs("<MV, Name = \"Test\", Type = \"IMatrix_t\", Function = \"Variable\">\n",FilePointer);
  char General[MAXCHAR];
  char* General_Slide = &General[0];
  char Temp[MAXCHAR];


  IntXY_ToString_WPostOp(Matrix->X,Matrix->Y,&General_Slide);
  fputs("\t{",FilePointer);
  fputs(General,FilePointer);
  fputs("}\n",FilePointer);

  //Save Matrix It self
  for(int XAxis = 0; XAxis < Matrix->X;XAxis++)
  {
    fputs("\t\t",FilePointer);
    for(int YAxis = 0; YAxis < Matrix->Y;YAxis++)
    {
      snprintf(Temp,MAXCHAR,"%d",*(Matrix->Array+(Matrix->X*YAxis)+(XAxis)));
      fputs(Temp,FilePointer);
      fputs(" ",FilePointer);
      //Save individual matrix value->

    }
    fputs("\n",FilePointer);
  }
  //end Marker for reproof
  fputs("</MV>.",FilePointer);
  fputs(" \n",FilePointer);

  fclose(FilePointer);
}
void Read_VIMatrix(char* FilePath,IMatrix_t* Matrix)
{
  //Opens File at Provided Destination in Congiguration File
  //fflush(NULL);
  FILE* FilePointer = fopen(FilePath,"a");
  //fflush(File_Pointer);

  //Start Marker for ManagedVariable
  fputs("<MV, Name = \"Test\", Type = \"IMatrix_t\", Function = \"Variable\">\n",FilePointer);
  char General[MAXCHAR];
  char* General_Slide = &General[0];
  char Temp[MAXCHAR];


  IntXY_ToString_WPostOp(Matrix->X,Matrix->Y,&General_Slide);
  fputs("\t{",FilePointer);
  fputs(General,FilePointer);
  fputs("}\n",FilePointer);

  //Save Matrix It self
  for(int XAxis = 0; XAxis < Matrix->X;XAxis++)
  {
    fputs("\t\t",FilePointer);
    for(int YAxis = 0; YAxis < Matrix->Y;YAxis++)
    {
      snprintf(Temp,MAXCHAR,"%d",*(Matrix->Array+(Matrix->X*YAxis)+(XAxis)));
      fputs(Temp,FilePointer);
      fputs(" ",FilePointer);
      //Save individual matrix value->

    }
    fputs("\n",FilePointer);
  }


  //end Marker for reproof
  fputs("</MV>.",FilePointer);
  fputs(" \n",FilePointer);

  fclose(FilePointer);
}


void Test_FM_Save()
{
  printf("Testing Float Matrix Save Function \n");
  FMatrix_t* Matrix0 = CreateF_RW(12,12);
  PrintFloatMatrix(Matrix0);

  //Save_VFMatrix("Test.txt",Matrix0);

  Free_FMatrix_t(Matrix0);
}

//Testing
void Test_OperateF_Sigmoid()
{
  printf("Testing Simulated Sigmoid Function \n");
  FMatrix_t* Matrix0 = CreateF_RW(2,2);
  FMatrix_t* Matrix1 = CreateF_RW(2,2);
  PrintFloatMatrix(Matrix0);

  Sigmoid_FMatrix_t(Matrix0);

  PrintFloatMatrix(Matrix1);

  //PrintMatrix(SMatrix);
  //system("gnome-terminal -e \"rm -f Test.txt \"");
  //SaveMatrix("Test.txt",IMatrix);
  Free_FMatrix_t(Matrix0);
  Free_FMatrix_t(Matrix1);
}


//Testing
void Test_I_RW()
{
  printf("Testing Integral Random weight\n");
  IMatrix_t* TMatrix = CreateI_RW(5,5);
  PrintIntegerMatrix(TMatrix);

  //PrintMatrix(SMatrix);
  //system("gnome-terminal -e \"rm -f Test.txt \"");
  //SaveMatrix("Test.txt",IMatrix);
  FreeMatrix(TMatrix);
}

//Testing
void Test_F_RW()
{
  printf("Testing float Random weight\n");
  FMatrix_t* TMatrix = CreateF_RW(5,5);
  PrintFloatMatrix(TMatrix);

  //PrintMatrix(SMatrix);
  //system("gnome-terminal -e \"rm -f Test.txt \"");
  //SaveMatrix("Test.txt",IMatrix);
  Free_FMatrix_t(TMatrix);
}

//Testing
bool Test_I_DOM()
{
  printf("Testing Integral Drop Out Matrix\n");
  IMatrix_t* IMatrix = CreateI_DOM(5,5);
  PrintIntegerMatrix(IMatrix);

  //PrintMatrix(SMatrix);
  //system("gnome-terminal -e \"rm -f Test.txt \"");
  //SaveMatrix("Test.txt",IMatrix);
  FreeMatrix(IMatrix);
  return 1;
}

//Testing
bool Test_F_DOM()
{
  printf("Testing float Drop Out Matrix\n");
  IMatrix_t* IMatrix = CreateI_DOM(5,5);
  PrintIntegerMatrix(IMatrix);

  //PrintMatrix(SMatrix);
  //system("gnome-terminal -e \"rm -f Test.txt \"");
  //SaveMatrix("Test.txt",IMatrix);
  FreeMatrix(IMatrix);
  return 1;
}



void Identity_Matrix_T()
{
  IMatrix_t* IMatrix = CreateIntegerIdentityMatrix(5,5);
  PrintIntegerMatrix(IMatrix);
  //PrintMatrix(SMatrix);
  //system("gnome-terminal -e \"rm -f Test.txt \"");
  //SaveMatrix("Test.txt",IMatrix);
  FreeMatrix(IMatrix);

  srand(time(NULL)); // should only be called once
  Test_I_DOM();
  srand(time(NULL)); // should only be called once
  Test_F_RW();
  Test_MultiplyMatrix();
  Test_OperateF_Sigmoid();
  //Test_IM_Save();
  Test_FM_Save();
  FMatrix_t* FMatrix = CreatefloatIdentityMatrix(5,5);
  PrintFloatMatrix(FMatrix);


  //PrintMatrix(SMatrix);
  //system("gnome-terminal -e \"rm -f Test.txt \"");
  //SaveMatrix("Test.txt",IMatrix);
  Free_FMatrix_t(FMatrix);
}
