#ifndef Base_C
#define Base_C

#include "Base.h"

void Base_V()
{
  printf("Base \t\t\tV:1.00\n");
}

void Random_IntegerMatrix(int Quantity,int* Array)
{
  for(int x=0;x<Quantity;x++)
  {
    Array[x] = ((int)rand() % (INT_MAX - 0)) + 0;
  }
}

void Random_FloatMatrix(int Quantity,float* Array)
{
  for(int x=0;x<Quantity;x++)
  {
    Array[x] = ((float)rand()/(RAND_MAX/(RAND_MAX-0))) + 0;
  }
}

//void GatherTerminalInt(const char* Prompt, int* IntValue)
//Example:
//   GatherTerminalInt("Please enter an integer:",&Integer);
void GatherTerminalInt(const char* Prompt, int* IntValue)
{
  int num, nitems;
  printf("%s",Prompt);
  nitems = scanf("%d", &num);
  if (nitems == EOF)
  {
      /* Handle EOF/Failure */
  }
  else if (nitems == 0)
  {
      /* Handle no match */
  }
  else
  {
    *IntValue = num;
  }
}

void GatherTerminalFloat(const char* Prompt, float* IntValue)
{
  float num, nitems;
  printf("%s",Prompt);
  nitems = scanf("%f", &num);
  if (nitems == EOF)
  {
      /* Handle EOF/Failure */
      printf("Nothing Was entered!\n");
  }
  else if (nitems == 0)
  {
      /* Handle no match */
  }
  else
  {
    *IntValue = num;
  }
}

void GatherTerminalString(const char* Prompt, char* charString)
{
  int nitems;
  printf("%s",Prompt);
  nitems = scanf("%s", charString);
  if (nitems == EOF)
  {
      /* Handle EOF/Failure */
  }
  else if (nitems == 0)
  {
      /* Handle no match */
  }
  else
  {

  }
}
#define Tests
//#ifdef Tests

void InterpreatedVariable_T()
{
printf("InterpreatedVariable_T !\n");

  int IV(Name,00) = 55;
  printf("%d\n", Name00);


  DII(Name,01,100)
  printf("%d\n", Name01);

  DIV(int,Name,02,200)
  printf("%d\n", Name02);

  //char* Name03 = (char*) malloc(sizeof(char));
  DIV_S(char,Name,03)
  printf("%c\n", *Name03);
  free(Name03);
}

void PointerSize_T()
{
  printf("PointerSize_T !\n");
  printf("Integer PointerSize %lu\n",sizeof(int*));
  printf("Double PointerSize %lu\n",sizeof(double*));
}

void Assert_T()
{
printf("Assert_T !\n");
//fputs("Testing Assert Fail Test should Assert Failure and abort \n",stderr);
//printf("Some Test text\n");
//assert(0);
}

void Base_T(int CallSign)
{
  printf("Base_T !\n");
  InterpreatedVariable_T();
  Assert_T();
  PointerSize_T();
}
//#endif //Tests

#endif // Base_C
