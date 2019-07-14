#ifndef StringFields_h
#define StringFields_h


//#include "../Base.h"

// Program Header Information ////////////////////////////////////////
/**
* @file CharacterOperations.h
*
* @brief Header file for CharacterOperations.c
* instantiate's The Structues:
*     -bool
*
* @details Specifies:
*     -bool
*
* @note None
*/

typedef struct String_t
{
  char* Array;
  int IndexSize;
  int X;
  int Y;
} String_t;



typedef struct _2D_CMatrix_t
{
  char* Array;
  int IndexSize;
  int X;
  int Y;
} _2D_CMatrix_t;


#define _2D_CMatrix_Element(Varible,i,j) (*(char*)(Varible->Array+i*Varible->Y+j))


#define Print_2D_CMatrix(Varible,iLine,jCharacter)  \
printf("\n\n");                                     \
for(int i = 0; i < Varible->X ;i++)                 \
{                                                   \
  printf("%s\n",iLine);                             \
  printf("%c",jCharacter);                          \
  for(int j = 0; j < Varible->Y ;j++)               \
  {                                                 \
    printf("%c",(*(Varible->Array+i*Varible->Y+j)));\
    printf("%c",jCharacter);                        \
  }                                                 \
  printf("\n");                                     \
}                                                   \
printf("%s\n",iLine);                               \


_2D_CMatrix_t* Create_2D_CMatrix(int X, int Y);
void Free_2D_CMatrix(_2D_CMatrix_t* _2D_CMatrix);
_2D_CMatrix_t* Copy_CMatrix(_2D_CMatrix_t* Given_2D_CMatrix);


void CharacterOperations_V();
void SetSystemTime(char* String);
void SetSystemTime_Slide(char** String);
void CopyString(const char* From,char* To);
void CopyToSlide(const char* From,char** To);

// Decimal functional prototypes
void FloatToString(float fVal,char* String);
void IntToString(int Value,char* String);


//String functional prototypes
int MyStrLen(char * String);

void CopyConst(const char* From,char* To);
void CopyString_WPostOp(char* From,char* To,char** PostOp);
void CopyConst_WPostOp(const char* From,char* To,char** PostOp);

void CopyStringTillGivenChar(char* From,char* To,const char* GivenChars);
void CopyStringTillGivenCharPostPointer(char* From,char* To,const char* GivenChars,char** PostCopy);
bool CopyIntegerTillGivenChar(char* From,int* To,const char* GivenChars);
bool CopyIntegerTillGivenCharPostPointer(char* From,int* To,const char* GivenChars,char** PostInteger);


void SkipGivenCharacters(char* Line,char** postArgv,const char* GivenCharacters);
bool SkipToken(const char* token,char* string,char** returnString);
bool CompareString(char* S1,char* S2);
bool CompareCharacter(char C1,char C2);
void CombineTwoStrings(const char* S1,const char* S2,char Result[]);


bool ValidateNumber(char* Line);
bool TokenPresent(char* Token,char* String);
void IntToString(int Value,char* String);
void IntToString_WPostOp(int Value,char* String,char** PostOp);
void IntXY_ToString_WPostOp(int x,int y,char** LineSlide);

#endif // StringFields_h
