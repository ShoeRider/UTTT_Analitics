#ifndef AnthonySchroeder_Assignment2_C
#define AnthonySchroeder_Assignment2_C


#include "AnthonySchroeder_Assignment2.h"



/*
* @brief CopyStringTillGivenChar For copying one string to another Location
*
* @details Function Loops given string (From), character by character untill a
* character from (GivenChars), or '\0' is found,  coping each caracter to
* String(To), allong the way.
*
* @example:
* char NewStringInTown[100];
* Usage: CopyStringTillGivenChar("Copy me, Copy you",NewStringInTown,",");
* NewStringInTown = "Copy me"
*/
void CopyStringTillGivenCharPostPointer(char* From,char* To,const char* GivenChars,char** PostPos)
{
  int GivenCharsCounter = 0;
  int FromCounter = 0;

  int EndCharFound = 0; //False
  while(From[FromCounter]!='\0' && !EndCharFound)
  {
    GivenCharsCounter = 0;
    while((GivenChars[GivenCharsCounter]!='\0') && !EndCharFound)
    {
      if(From[FromCounter] == GivenChars[GivenCharsCounter])
      {
        EndCharFound = 1;//True
      }
      else
      {
        To[FromCounter]=From[FromCounter];
        FromCounter++;

        GivenCharsCounter++;
      }
    }
  }
  To[FromCounter] = '\0';
	*PostPos = &To[FromCounter];
}





int MyStrLen(char * String)
{
  int count = 0;
  while(String[count] != '\0')
  {
    count++;
  }
  return count;
}



int TokenPresent(char* Token,char* String)
{
  int StringCounter = 0;
  while(!(Token[StringCounter] == '\0'))
  {
    if((Token[StringCounter] != String[StringCounter]))
    {
      return 0;
    }
    else
    {
      StringCounter++;
      if(Token[StringCounter] == '\0')
      {
        return 1;//true
      }
    }
  }
  return 0; //false
}
/*
char* Example = "Some cool string: 10";
char* Post = PostToken(Example,"string");
printf("%s\n",Post);
*/
char* PostToken(char* CheckingString,const char* GivenString)
{
  int CheckingStringCounter = 0;

  while(&CheckingString[CheckingStringCounter]!='\0')
  {
    if (TokenPresent(GivenString,&CheckingString[CheckingStringCounter]))
    {
      return &CheckingString[CheckingStringCounter];
    }

    CheckingStringCounter++;

  }
  return NULL;
}




#define NumberOf_FASTABlocks 100
#define FASTA_Length         5000
#define Tests                1
#define SM_CharacterOrder    "ACGT"
#define SM_Character(_c)
int SM_CharacterValue(char _c)
{
   if(_c=='A')
    {return 0;}
   else if(_c=='C')
    {return 1;}
   else if(_c=='G')
    {return 2;}
   else if(_c=='T')
    {return 3;}
}
//Needleman_Wunsch and Smith_Waterman direction guide
#define D_Origin  0 // Origin
#define D_Up      1 //
#define D_Left    2
#define D_Diagnal 3

#define Di_Origin  0 // Origin
#define Di_Up      1 //
#define Di_Left    2
#define Di_Diagnal 3



int Free_Benchmark_t(Benchmark_t* Benchmark)
{
  free(Benchmark);
  return 0;
}
Benchmark_t* CreateBenchmark_t()
{

  Benchmark_t* Benchmark = (Benchmark_t*)malloc(sizeof(Benchmark_t));
  return Benchmark;
}
Benchmark_t* StartBenchmark_t(const char* Name,const char* Parameter_0,const char* Parameter_1)
{

  Benchmark_t* Benchmark = (Benchmark_t*)malloc(sizeof(Benchmark_t));

//“algorithm,language,seconds,score,m,n”
  Benchmark->Name = Name;
  Benchmark->Language = "C";

  Benchmark->Parameter_0 = Parameter_0;
  Benchmark->Parameter_1 = Parameter_1;
  Benchmark->Score = 0;

  Benchmark->start = clock();
  Benchmark->seconds = 0;

  return Benchmark;
}

void ReStartBenchmark_t(Benchmark_t* Benchmark,char* Name,char* Parameter_0,char* Parameter_1)
{
//“algorithm,language,seconds,score,m,n”
  Benchmark->Name = Name;
  Benchmark->Language = "C";

  Benchmark->Parameter_0 = Parameter_0;
  Benchmark->Parameter_1 = Parameter_1;
  Benchmark->Score = 0;

  Benchmark->start = clock();
  //Benchmark->end = 0;
  Benchmark->seconds = 0;

}

double StopBenchmark_t(Benchmark_t* Benchmark,double score)
{
  Benchmark->end = clock();
  Benchmark->seconds = (double)(Benchmark->end - Benchmark->start)/CLOCKS_PER_SEC;
  Benchmark->Score = score;
  return Benchmark->seconds;
}




IMatrix_t* CreateZero_IMatrix_t(int byX,int byY)
{
  IMatrix_t* IMatrix = (IMatrix_t*)malloc(sizeof(IMatrix_t));
  IMatrix->X = byX;
  IMatrix->Y = byY;
  IMatrix->Array = (int*)malloc(byX*sizeof(int*));

  for(int X = 0 ; X<byX;X++)
  {
    //Malloc Each row of the SubstitutionMatrix
    (IMatrix->Array[X]) = (int*) malloc(sizeof(int)*byY);


    for(int Y=0;Y<byY;Y++)
    {
      IMatrix->Array[X][Y] = 0;
    }
  }

  return IMatrix;
}


int Free_IMatrix(IMatrix_t* IMatrix)
{
  for(int X=0;X<IMatrix->X;X++)
  {
    free(IMatrix->Array[X]);
  }
  free(IMatrix->Array);
  free(IMatrix);
  return 0;
}

FMatrix_t* CreateZero_FMatrix_t(int byX,int byY)
{
  FMatrix_t* FMatrix = (FMatrix_t*)malloc(sizeof(FMatrix_t));
  FMatrix->X = byX;
  FMatrix->Y = byY;
  FMatrix->Array = (float*)malloc(byX*sizeof(float*));

  for(int X = 0 ; X<byX;X++)
  {
    //Malloc Each row of the SubstitutionMatrix
    (FMatrix->Array[X]) = (float*) malloc(sizeof(float)*byY);


    for(int Y=0;Y<byY;Y++)
    {
      FMatrix->Array[X][Y] = 0;
    }
  }

  return FMatrix;
}
void PrintFloatMatrix(FMatrix_t* FMatrix)
{
  if(FMatrix != NULL)
  {
    printf("Print Matrix:\n");
    printf("-------------\n");
    printf("(%d,%d)\n",FMatrix->X,FMatrix->Y);
    for(int X = 0; X < FMatrix->X;X++)
    {
      printf("{");

      for(int Y = 0; Y < FMatrix->Y;Y++)
      {
        printf(" %f ",FMatrix->Array[X][Y]);
      }
      printf(" }\n");
    }
  }
}
int Free_FMatrix_t(FMatrix_t* FMatrix)
{
  for(int X=0;X<FMatrix->X;X++)
  {
    //printf("Freeing index:%d at:%p\n",X,&FASTA_Block[X]);
    //printf("Freeing position:%p\n",(FASTA_Block[X]));
    free(FMatrix->Array[X]);
  }
  free(FMatrix->Array);
  free(FMatrix);
  return 0;
}


//You may assume the substitution matrix is formatted as a CSV, without the labels.
//A,C,G,T
//0,1,1,1
//1,0,1,1
//1,1,0,1
//1,1,1,0
FMatrix_t * ReadCSVSubstitutionMatrix(char* FileDir)
{
  //Reads each row/column in the following order:
  //Note: SM_CharacterOrder = A,C,G,T
  FMatrix_t* SubstitutionMatrix =  CreateZero_FMatrix_t(4,4);
  char Buffer[255];

  //Open File
  FILE *fp;
  fp = fopen(FileDir, "r");

  //Initialize delim characters
  char delim[] = ",\n";
  int init_size;



  for(int X = 0 ; X<4;X++)
  {
    //Gather Each Row
    fgets(Buffer, 255, (FILE*)fp);
    init_size = strlen(Buffer);

    //select character pointer for atof(ptr)
    char *ptr = strtok(Buffer, delim);
    for(int Y=0;Y<4;Y++)
    {
      SubstitutionMatrix->Array[X][Y] = atof(ptr);
      //printf("%f ",representation[X][Y] );
      //printf("'%s'\n", ptr);
      ptr = strtok(NULL, delim);
    }
    //printf("%d->%d\n", X, &(FASTA_Block[X]));
    //printf("%d->%d\n", X, FASTA_Block[X]);
    //printf("-------------------------\n");
  }
  fclose(fp);

  return SubstitutionMatrix;
}

int FreeSubstitutionMatrix(char** SubstitutionMatrix)
{
  for(int X=0;X<4;X++)
  {
    //printf("Freeing index:%d at:%p\n",X,&FASTA_Block[X]);
    //printf("Freeing position:%p\n",(FASTA_Block[X]));
    free(SubstitutionMatrix[X]);
  }
  free(SubstitutionMatrix);
  return 0;
}
// Reads FASTA File
FASTA_t* ReadFASTA(char* FileDir)
{

  printf("Reading FASTA: %s\n",FileDir);
 // Reads each row/column in the following order:
 // A,C,G,T
    char Buffer[FASTA_Length];

    int Block_Count = 0;

    FILE *fp;
    fp = fopen(FileDir, "r");
    while (fgets(Buffer, FASTA_Length, fp) != NULL)
    {
      if(Buffer[0] == '>')
      {
        Block_Count++;

      }
    }
    fclose(fp);
    //printf("Block_Count:%d\n",Block_Count );

  FASTA_t* FASTA = (FASTA_t*)malloc(sizeof(FASTA_t));
  FASTA->GenomeLength = 10000;
  FASTA->LabelLength  = 1000;
  FASTA->BlockCount   = Block_Count;
  FASTA->Block        = (char**)malloc(Block_Count*sizeof(char*));
  FASTA->BlockLabel   = (char**)malloc(Block_Count*sizeof(char*));

  //printf("Initial MAlloc :%p\n",FASTA_Block);
  //printf("Starting at :%p\n", FASTA_Block);
  //printf("Starting at :%p\n", &(FASTA_Block[2]));

  for(int X = 0 ; X<FASTA->BlockCount;X++)
  {
    //printf("%d->%p\n", X, &(FASTA_Block[X]));
    //printf("%d->%p\n", X, FASTA_Block[X]);
    (FASTA->Block[X])      = (char*) malloc(sizeof(char)*FASTA->GenomeLength);
    (FASTA->BlockLabel[X]) = (char*) malloc(sizeof(char)*FASTA->LabelLength);
    //printf("%d->%d\n", X, &(FASTA_Block[X]));
    //printf("%d->%d\n", X, FASTA_Block[X]);
    //printf("-------------------------\n");
  }
    //Open File
    //printf("Checking File\n");


    fp = fopen(FileDir, "r");
    //printf("File Exists\n");

    //while(ptr != NULL)
    int NewSequence = 1;
    int Current_FASTA_Block = -1;
    char* CurrentSquenceSlide = FASTA->Block[0];
    while (fgets(Buffer, FASTA_Length, fp) != NULL)
    {
      //printf("b:%s",Buffer);
      if(Buffer[0] == '>')
      {
        //printf("\t%s\n",&FASTA_Block[Current_FASTA_Block]);
        Current_FASTA_Block++;

        char* Post = PostToken(Buffer,"locus_tag");
        if(Post == NULL)
        {
          Post ="locus_tag=NA";
        }
        CopyStringTillGivenCharPostPointer(Post,(char*)FASTA->BlockLabel[Current_FASTA_Block],"]] \n\0",&CurrentSquenceSlide);

        CurrentSquenceSlide = (char*)FASTA->Block[Current_FASTA_Block];


        printf("%s\n",FASTA->BlockLabel[Current_FASTA_Block]);
        //printf("> Detected\n");

      }
      else
      {
        //printf("%p\n",CurrentSquenceSlide);
        CopyStringTillGivenCharPostPointer(Buffer,(char*)CurrentSquenceSlide,"\n\0",&CurrentSquenceSlide);
        //printf("\t%s\n",FASTA_Block[Current_FASTA_Block]);
      }
      //printf("%d->%p\n",Current_FASTA_Block,FASTA_Block[Current_FASTA_Block]);
    }

    //fclose(fp);
    //printf("returning FASTA\n");
    //printf("Pre retrun position:%p\n",FASTA_Block);
  return FASTA;
}

int FreeFASTA(FASTA_t* FASTA)
{
  for(int X=0;X<FASTA->BlockCount;X++)
  {
    free(FASTA->Block[X]);
    free(FASTA->BlockLabel[X]);
  }
  free(FASTA);
  return 0;
}


int _MaxOf2( int a, int b ) { return a>b ? a : b ; }
int _MaxOf3( int a, int b, int c ) { return _MaxOf2( _MaxOf2(a,b), c ) ; }
int _MaxOf4( int a, int b, int c, int d ) { return _MaxOf2( _MaxOf3(a,b,c), d) ; }

void _Needleman_Wunsch_ComputeScore(FMatrix_t*F_FMatrix, IMatrix_t* T_IMatrix,char* String_0,char* String_1,int gap_penalty,int _penalty, FMatrix_t * SubstitutionMatrix)
{
  int Diagnal,Left,Up,Max;
  int cIndex_0,cIndex_1;
  for (int X = 1;X<(F_FMatrix->X);X++)
  {
    for (int Y = 1;Y<(F_FMatrix->Y); Y++)
    {
      //Get Gap Index's in SubstitutionMatrix, in respect to the Definied CSV format: "ACGT" for the rows and columns
      cIndex_0 =  SM_CharacterValue(String_0[X-1]);
      cIndex_1 =  SM_CharacterValue(String_1[Y-1]);


      //printf("%d,%d->,(%d,%d)=%f\n",X,Y,cIndex_0,cIndex_1,SubstitutionMatrix->Array[cIndex_0][cIndex_1]);
      //Find the Diagnal, Left, and Up values
      Diagnal = F_FMatrix->Array[X-1][Y-1] + SubstitutionMatrix->Array[cIndex_0][cIndex_1];
      Left = F_FMatrix->Array[X-1][Y] - gap_penalty;
      Up = F_FMatrix->Array[X][Y-1] - gap_penalty;

      Max = _MaxOf3(Diagnal,Left,Up);
      if(Max==Up)
      {
        T_IMatrix->Array[X][Y] = 2;
      }
      else if(Max==Left)
      {
        T_IMatrix->Array[X][Y] = 4;
      }
      else if(Max==Diagnal)
      {
        T_IMatrix->Array[X][Y] = 8;
      }

      //set F_IMatrix to max value
      F_FMatrix->Array[X][Y] = Max;

    }
  }
  //Debug Print matrix
  //PrintFloatMatrix(F_FMatrix);
}


double _Needleman_Wunsch_TraceBack(FMatrix_t*F_FMatrix, IMatrix_t* T_IMatrix,char* String_0,char* String_1)
{
  int MaxLen = F_FMatrix->X + F_FMatrix->Y;


  char NString_0[MaxLen];
  char NString_1[MaxLen];

  int NString_Index = 0;

  int X = F_FMatrix->X-1;
  int Y = F_FMatrix->Y-1;


  while(!((X==0)&&(Y==0)))
  {

    if(T_IMatrix->Array[X][Y] == 2)
    {
      //UP
      NString_0[NString_Index]='-';
      NString_1[NString_Index]=String_1[Y-1];
      NString_Index++;
      Y--;
    }
    else if(T_IMatrix->Array[X][Y] == 4)
    {
      //Left
      NString_0[NString_Index]=String_0[X-1];
      NString_1[NString_Index]='-';
      NString_Index++;
      X--;
    }
    else if(T_IMatrix->Array[X][Y] == 8)
    {
      //Diagnal
      NString_0[NString_Index]=String_0[X-1];
      NString_1[NString_Index]=String_1[Y-1];


      NString_Index++;
      X--;
      Y--;
    }
  }

  NString_0[NString_Index] = '\0';
  NString_1[NString_Index] = '\0';
  //Reverse String

  //printf("%s\n",NString_0);
  //printf("%s\n",NString_1);
  //printf("%f\n",F_FMatrix->Array[F_FMatrix->X-1][F_FMatrix->Y-1]);
  return F_FMatrix->Array[F_FMatrix->X-1][F_FMatrix->Y-1];
}

//1. Implement the Needleman-Wunsch algorithm in C/C++ that accepts a substitution matrix. See Below
double Needleman_Wunsch(FMatrix_t * SubstitutionMatrix,char* String_0,char* String_1)
{
  int Length_0 = MyStrLen(String_0)+1;
  //printf("%d\n",Length_0);
  int Length_1 = MyStrLen(String_1)+1;
  FMatrix_t* F_FMatrix = CreateZero_FMatrix_t(Length_0,Length_1);
  IMatrix_t* T_IMatrix = CreateZero_IMatrix_t(Length_0,Length_1);

  //Initialize the Matrix's and
  int gap_penalty = 8;
  int _penalty = 1;
  for(int X = 1; X<Length_0;X++)
  {
    F_FMatrix->Array[X][0] = F_FMatrix->Array[X-1][0] - gap_penalty;

    T_IMatrix->Array[X][0] = 4;
    //printf("%d\n",F_IMatrix_t->Array[X][0]);
  }

  for(int Y = 1; Y<Length_1;Y++)
  {
    F_FMatrix->Array[0][Y] = F_FMatrix->Array[0][Y-1] - gap_penalty;

    T_IMatrix->Array[0][Y] = 2;
    //printf("%d\n",F_IMatrix_t->Array[0][Y]);
  }
  //printf("\tStarting _Needleman_Wunsch_ComputeScore");
  _Needleman_Wunsch_ComputeScore(F_FMatrix, T_IMatrix, String_0, String_1, gap_penalty, _penalty, SubstitutionMatrix);
  //printf("_Needleman_Wunsch_ComputeScore\n");
  for(int X =0; X<Length_0;X++)
  {
    for(int Y =0; Y<Length_1;Y++)
    {
      //printf("%f \t",F_FMatrix->Array[X][Y]);
    }
    //printf("\n");
  }
  for(int X =0; X<Length_0;X++)
  {
    for(int Y =0; Y<Length_1;Y++)
    {
      //printf("%d \t",T_IMatrix->Array[X][Y]);
    }
    //printf("\n");
  }
  //printf("... Starting _Needleman_Wunsch_TraceBack");
  double TraceBack = _Needleman_Wunsch_TraceBack(F_FMatrix,  T_IMatrix, String_0, String_1);

  Free_FMatrix_t(F_FMatrix);
  Free_IMatrix(T_IMatrix);

  //printf("... Returning TraceBack \n");
  return TraceBack;
}







void _Smith_Waterman_ComputeScore(FMatrix_t*F_FMatrix, IMatrix_t* T_IMatrix,char* String_0,char* String_1,int gap_penalty,int _penalty, FMatrix_t * SubstitutionMatrix)
{
  int Diagnal,Left,Up,Max;
  int cIndex_0,cIndex_1;

  for (int X = 1;X<(F_FMatrix->X);X++)
  {
    for (int Y = 1;Y<(F_FMatrix->Y); Y++)
    {
      //Get Gap Index's in SubstitutionMatrix, in respect to the Definied CSV format: "ACGT" for the rows and columns
      cIndex_0 =  SM_CharacterValue(String_0[X-1]);
      cIndex_1 =  SM_CharacterValue(String_1[Y-1]);


      //Find the Diagnal, Left, and Up values
      Diagnal = F_FMatrix->Array[X-1][Y-1] + SubstitutionMatrix->Array[cIndex_0][cIndex_1];
      Left = F_FMatrix->Array[X-1][Y] - gap_penalty;
      Up = F_FMatrix->Array[X][Y-1] - gap_penalty;

      Max = _MaxOf4(Diagnal,Left,Up,0);
      if(Max==0)
      {
        T_IMatrix->Array[X][Y] = 0;
      }
      else if(Max==Up)
      {
        T_IMatrix->Array[X][Y] = 2;
      }
      else if(Max==Left)
      {
        T_IMatrix->Array[X][Y] = 4;
      }
      else if(Max==Diagnal)
      {
        T_IMatrix->Array[X][Y] = 8;
      }

      //set F_IMatrix to max value
      F_FMatrix->Array[X][Y] = Max;

    }
  }
  //Debug Print matrix
  //PrintFloatMatrix(F_FMatrix);
  return 0;
}

double _Smith_Waterman_TraceBack(FMatrix_t*F_FMatrix, IMatrix_t* T_IMatrix,char* String_0,char* String_1)
{
  int MaxLen = F_FMatrix->X + F_FMatrix->Y;


  char NString_0[MaxLen];
  char NString_1[MaxLen];

  int NString_Index = 0;


  //Find Max element
  float v_Max = -1000;
  int x_Max = -1;
  int y_Max = -1;
  for(int x= 0; x<F_FMatrix->X-1 ;x++)
  {
    for(int y=0;y< F_FMatrix->Y-1 ;y++)
    {
      if(v_Max<F_FMatrix->Array[x][y])
      {
        x_Max = x;
        y_Max = y;
        v_Max = F_FMatrix->Array[x][y];
      }
    }
  }

  int X = x_Max;
  int Y = y_Max;


  while(!((X==0)&&(Y==0)))
  {
    if(T_IMatrix->Array[X][Y] == 0)
    {
      //Local origin
      NString_0[NString_Index] = '\0';
      NString_1[NString_Index] = '\0';
      Y=0;
      X=0;
    }
    else if(T_IMatrix->Array[X][Y] == 2)
    {
      //UP
      NString_0[NString_Index]='-';
      NString_1[NString_Index]=String_1[Y-1];
      NString_Index++;
      Y--;
    }
    else if(T_IMatrix->Array[X][Y] == 4)
    {
      //Left
      NString_0[NString_Index]=String_0[X-1];
      NString_1[NString_Index]='-';
      NString_Index++;
      X--;
    }
    else if(T_IMatrix->Array[X][Y] == 8)
    {
      //Diagnal
      NString_0[NString_Index]=String_0[X-1];
      NString_1[NString_Index]=String_1[Y-1];


      NString_Index++;
      X--;
      Y--;
    }
  }

  NString_0[NString_Index] = '\0';
  NString_1[NString_Index] = '\0';
  //Reverse String

  //printf("%s\n",NString_0);
  //printf("%s\n",NString_1);
  //printf("%f\n",v_Max);
  return v_Max;
}

double Smith_Waterman(FMatrix_t * SubstitutionMatrix,char* String_0,char* String_1)
{
  int Length_0 = MyStrLen(String_0)+1;
  int Length_1 = MyStrLen(String_1)+1;
  FMatrix_t* F_FMatrix = CreateZero_FMatrix_t(Length_0,Length_1);
  IMatrix_t* T_IMatrix = CreateZero_IMatrix_t(Length_0,Length_1);

  //Initialize the Matrix's and
  int gap_penalty = 8;
  int _penalty = 1;
  for(int X = 1; X<Length_0;X++)
  {
    F_FMatrix->Array[X][0] = 0;

    T_IMatrix->Array[X][0] = 0;
    //printf("%d\n",F_IMatrix_t->Array[X][0]);
  }

  for(int Y = 1; Y<Length_1;Y++)
  {
    F_FMatrix->Array[0][Y] = 0;

    T_IMatrix->Array[0][Y] = 0;
    //printf("%d\n",F_IMatrix_t->Array[0][Y]);
  }
  //printf("Starting _Smith_Waterman_ComputeScore\n");
  _Smith_Waterman_ComputeScore(F_FMatrix, T_IMatrix, String_0, String_1, gap_penalty, _penalty, SubstitutionMatrix);

  for(int X =0; X<Length_0;X++)
  {
    for(int Y =0; Y<Length_1;Y++)
    {
      //printf("%f \t",F_FMatrix->Array[X][Y]);
    }
    //printf("\n");
  }
  for(int X =0; X<Length_0;X++)
  {
    for(int Y =0; Y<Length_1;Y++)
    {
      //printf("%d \t",T_IMatrix->Array[X][Y]);
    }
    //printf("\n");
  }
  //printf("Starting _Smith_Waterman_TraceBack\n");
  double Score = _Smith_Waterman_TraceBack(F_FMatrix,  T_IMatrix, String_0, String_1);

  Free_FMatrix_t(F_FMatrix);
  Free_IMatrix(T_IMatrix);
  return Score;
}


//3. Benchmark your implementation to the python implementation you found. Record results to a CSV with the following header information “algorithm,language,seconds,score,m,n”
int SaveBenchmark_ToCSVFile(char* FileDir,Benchmark_t* Benchmark_List)
{
  FILE *CSV_OUT = fopen(FileDir, "a");
  fprintf(CSV_OUT, "%s,%s,%f,%f,%s,%s\n",Benchmark_List->Name,Benchmark_List->Language,Benchmark_List->seconds,Benchmark_List->Score,Benchmark_List->Parameter_0,Benchmark_List->Parameter_1);
  fclose(CSV_OUT);
}
int SaveBenchmarkList_ToCSVFile(char* FileDir,Benchmark_t** Benchmark_List,int ListLength)
{
  FILE *CSV_OUT = fopen(FileDir, "a");
  for(int iteration; iteration<ListLength;iteration++)
  {
    fprintf(CSV_OUT, "%s,%s,%f,%f,%s,%s\n",Benchmark_List[iteration]->Name,Benchmark_List[iteration]->Language,Benchmark_List[iteration]->seconds,Benchmark_List[iteration]->Score,Benchmark_List[iteration]->Parameter_0,Benchmark_List[iteration]->Parameter_1);
  }
  fclose(CSV_OUT);
}


double Benchmark(int Threads, char* File_0,char* File_1)
{
  printf("Starting Benchmark\n");
  //Set up general Parameters
  FMatrix_t * SubstitutionMatrix =  ReadCSVSubstitutionMatrix("SubstitutionMatrix.csv");


  char* CSV_File="Test.csv";
  Benchmark_t* ReadFASTA_Benchmark_t;

  double Score;



  //char* File_0 = "Test.fna";
  ReadFASTA_Benchmark_t = StartBenchmark_t("ReadFASTA_Benchmark\0",File_0,"NA\0");
  FASTA_t* FASTA_0 = ReadFASTA(File_0);
  printf("saving benchmark\n");
  StopBenchmark_t(ReadFASTA_Benchmark_t,0);

  SaveBenchmark_ToCSVFile(CSV_File,ReadFASTA_Benchmark_t);
  Free_Benchmark_t(ReadFASTA_Benchmark_t);

  //char* File_1 = "Test.fna";
  ReadFASTA_Benchmark_t = StartBenchmark_t("ReadFASTA_Benchmark\0",File_1,"NA\0");
  FASTA_t* FASTA_1 = ReadFASTA(File_1);
  StopBenchmark_t(ReadFASTA_Benchmark_t,0);
  SaveBenchmark_ToCSVFile(CSV_File,ReadFASTA_Benchmark_t);
  Free_Benchmark_t(ReadFASTA_Benchmark_t);


  Benchmark_t* Needleman_Wunsch_Benchmark_t[Threads][FASTA_1->BlockCount];
  Benchmark_t* Smith_Waterman_Benchmark_t[Threads][FASTA_1->BlockCount];

  for(int thread=0;thread<Threads;thread++)
  {
    for(int x=0;x<FASTA_1->BlockCount;x++)
    {
      Needleman_Wunsch_Benchmark_t[thread][x]= CreateBenchmark_t();
      Smith_Waterman_Benchmark_t[thread][x]= CreateBenchmark_t();
    }
  }


  omp_set_num_threads(Threads);
  int Fx;
  int Fy;
int x;

  #pragma omp parallel private(x,Fx,Fy,Score) shared(FASTA_0,FASTA_1,CSV_File,Needleman_Wunsch_Benchmark_t,Smith_Waterman_Benchmark_t)
  {
  #pragma omp for schedule(dynamic)
  for(int Fx=0; Fx<(FASTA_0->BlockCount);Fx++)
  {




    printf("Iterating through %d/%d Iteration\n",Fx,(FASTA_0->BlockCount));
    for(int Fy=0; Fy<(FASTA_1->BlockCount);Fy++)
    {

      //printf("\tIterating through %d,%d Iteration\n",Fx,Fy);
      //printf("%s\n",FASTA_0->Block[Fx]);
      ReStartBenchmark_t(Needleman_Wunsch_Benchmark_t[omp_get_thread_num()][Fy],"Needleman_Wunsch\0",FASTA_0->BlockLabel[Fx],FASTA_1->BlockLabel[Fy]);
      //printf("\tstarting Needleman_Wunsch\n\t");
      Score = Needleman_Wunsch(SubstitutionMatrix, FASTA_0->Block[Fx],FASTA_1->Block[Fy]);
      //printf("\t... returned from Needleman_Wunsch with %f\n",Score);
      StopBenchmark_t(Needleman_Wunsch_Benchmark_t[omp_get_thread_num()][Fy],Score);




      ReStartBenchmark_t(Smith_Waterman_Benchmark_t[omp_get_thread_num()][Fy],"Smith_Waterman\0",FASTA_0->BlockLabel[Fx],FASTA_1->BlockLabel[Fy]);
      //printf("\tstarting Smith_Waterman\n");
      Score = Smith_Waterman(SubstitutionMatrix, FASTA_0->Block[Fx],FASTA_1->Block[Fy]);
      //printf("\t .. returned from Smith_Waterman\n");
      StopBenchmark_t(Smith_Waterman_Benchmark_t[omp_get_thread_num()][Fy],Score);



    }
    SaveBenchmarkList_ToCSVFile(CSV_File,Needleman_Wunsch_Benchmark_t[omp_get_thread_num()],FASTA_1->BlockCount);
    SaveBenchmarkList_ToCSVFile(CSV_File,Smith_Waterman_Benchmark_t[omp_get_thread_num()],FASTA_1->BlockCount);



  }
}

for(int thread=0;thread<Threads;thread++)
{
  for(int x=0;x<FASTA_1->BlockCount;x++)
  {
    Free_Benchmark_t(Needleman_Wunsch_Benchmark_t[omp_get_thread_num()][x]);
    Free_Benchmark_t(Smith_Waterman_Benchmark_t[omp_get_thread_num()][x]);
  }
}


    FreeFASTA(FASTA_0);
    FreeFASTA(FASTA_1);

  printf("after Iterations\n");

  //SaveBenchmarkList_ToCSVFile(CSV_File,Needleman_Wunsch_Benchmark_t,Tests);
  //SaveBenchmarkList_ToCSVFile(CSV_File,Smith_Waterman_Benchmark_t,Tests);


  Free_FMatrix_t(SubstitutionMatrix);
  return 0;
}




int main(int argc, char *argv[])
{
    FMatrix_t * SubstitutionMatrix =  ReadCSVSubstitutionMatrix("SubstitutionMatrix.csv");
  //Question 1:
  //Note i have commented out the print commands for question 3 implementation
  Needleman_Wunsch(SubstitutionMatrix, "TTCAGAAAC","AATTTATATC");

  //Question 2:
  Smith_Waterman(SubstitutionMatrix, "TTCAGAAAC","AATTTATATC");

  Free_FMatrix_t(SubstitutionMatrix);

  //Question 3:
  Benchmark_t* ReadFASTA_Benchmark = StartBenchmark_t("Entire C Bench","1 Threads","-O3");
  Benchmark(4,"Test.fna","Test.fna");
  StopBenchmark_t(ReadFASTA_Benchmark,0);
  printf("1 Took:%f\n",ReadFASTA_Benchmark->seconds);
  Free_Benchmark_t(ReadFASTA_Benchmark);

  //Produced +3.5 GB file, didnt upload ...
  //Benchmark_t* FasterReadFASTA_Benchmark = StartBenchmark_t("Entire C Bench","8 Threads","-O3");
  //Benchmark(8,"GCF_000007825.fna","GCF_000007845.fna");
  //StopBenchmark_t(FasterReadFASTA_Benchmark,0);
  //printf("8 Took:%f\n",FasterReadFASTA_Benchmark->seconds);
  //Free_Benchmark_t(FasterReadFASTA_Benchmark);
  return 0;
}




















#endif // AnthonySchroeder_Assignment2_C
