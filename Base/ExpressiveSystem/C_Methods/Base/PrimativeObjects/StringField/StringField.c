#ifndef StringField_C
#define StringField_C


#include "StringField.h"

// Code Implementation File Information ///////////////////////////////////////
/**
* @file CharacterOperations.c
*
* @brief Implementation of different Character Operations regarding Strings,
*           Characters and Integers.
*
*
* @details Implements all functions Related to Strings and bool variable types.
*
* @version 1.10
*
* @note Requires:
*          -"CharacterOperations.h"
*/

void StringFields_V()
{
	printf("Character Ops Version \tV:3.00\n");
}




_2D_CMatrix_t* Create_2D_CMatrix(int X, int Y)
{
	_2D_CMatrix_t* _2D_CMatrix = (_2D_CMatrix_t*)malloc(sizeof(_2D_CMatrix_t));
	_2D_CMatrix->Array = (char*)malloc(sizeof(char)*X*Y);
	//_2D_CMatrix->Array = (char*)realloc(_2D_CMatrix->Array,sizeof(char)*X*Y);
	_2D_CMatrix->X = X;
	_2D_CMatrix->Y = Y;
	_2D_CMatrix->IndexSize = X*Y;


	qSet_2D_Matrix_Elements(_2D_CMatrix,' ')

	return _2D_CMatrix;
}

_2D_CMatrix_t* Copy_CMatrix(_2D_CMatrix_t* Given_2D_CMatrix)
{
	_2D_CMatrix_t* New_2D_CMatrix = (_2D_CMatrix_t*)Create_2D_CMatrix(Given_2D_CMatrix->X,Given_2D_CMatrix->Y);

	_2D_MatrixLoop(New_2D_CMatrix,
		_2D_FL_Matrix_Element_Pointer(New_2D_CMatrix,Array) = _2D_FL_Matrix_Element_Pointer(Given_2D_CMatrix,Array);
	)

	return New_2D_CMatrix;
}

unsigned int PJWHash(const char* str, unsigned int length)
{
   const unsigned int BitsInUnsignedInt = (unsigned int)(sizeof(unsigned int) * 8);
   const unsigned int ThreeQuarters     = (unsigned int)((BitsInUnsignedInt  * 3) / 4);
   const unsigned int OneEighth         = (unsigned int)(BitsInUnsignedInt / 8);
   const unsigned int HighBits          =
                      (unsigned int)(0xFFFFFFFF) << (BitsInUnsignedInt - OneEighth);
   unsigned int hash = 0;
   unsigned int test = 0;
   unsigned int i    = 0;

   for (i = 0; i < length; ++str, ++i)
   {
      hash = (hash << OneEighth) + (*str);

      if ((test = hash & HighBits) != 0)
      {
         hash = (( hash ^ (test >> ThreeQuarters)) & (~HighBits));
      }
   }

   return hash;
}

unsigned long ElfHash ( const unsigned char *s )
{
    unsigned long   h = 0, high;
    while ( *s )
    {
        h = ( h << 4 ) + *s++;
        if ( high = h & 0xF0000000 )
            h ^= high >> 24;
        h &= ~high;
    }
    return h;
}




void Free_2D_CMatrix(_2D_CMatrix_t* _2D_CMatrix)
{
	free(_2D_CMatrix->Array);
	free(_2D_CMatrix);
}



void SetSystemTime(char* String)
{
  time_t rawtime;
  struct tm * timeinfo;
  time (&rawtime);
  timeinfo = localtime (&rawtime);
  CopyStringTillGivenChar(asctime(timeinfo),String,"\n");
}

void SetSystemTime_Slide(char** String)
{
  time_t rawtime;
  struct tm * timeinfo;
  time (&rawtime);
  timeinfo = localtime (&rawtime);
	CopyStringTillGivenCharPostPointer(asctime(timeinfo),*String,"\n",String);

}
/*
* @brief CopyString For copying one string to another Location
*
* @details Function Loops untill end of Given String (From) '\0' and copies
* each caracter to another String(To)
*
* @example:
* char NewStringInTown[100];
* Usage: CopyString("Copy me, Copy you",NewStringInTown);
* NewStringInTown = "Copy me, Copy you"
*/
void CopyString(const char* From,char* To)
{ //CopyString_WEndCar
  int Counter = 0;
  while(From[Counter]!='\0')
  {
    To[Counter] = From[Counter];
    Counter++;
  }
  To[Counter] = '\0';
}

void CopyToSlide(const char* From,char** LineSlide)
{
	char* To = *LineSlide;
  int Counter = 0;

  while(From[Counter] != '\0')
  {
    To[Counter] = From[Counter];
    Counter++;
  }
  To[Counter] = '\0';
	*LineSlide = &To[Counter];
}


void CopyConst(const char* From,char* To)
{ //CopyString_WEndCar
  int Counter = 0;
  while(From[Counter]!='\0')
  {
    To[Counter] = From[Counter];
    Counter++;
  }
  To[Counter] = '\0';

}

void IntegerToHex(int Integer,char* HexString)
{
	snprintf(HexString,MAXCHAR,"%X",Integer);
}

void HexToInteger(char* HexString,int* Integer)
{
	*Integer = (int)strtol(HexString, NULL, 16);
}

/*
* @brief CopyString For copying one string to another Location
*
* @details Function Loops untill end of Given String (From) '\0' and copies
* each caracter to another String(To)
*
* @example:
* char NewStringInTown[100];
* Usage: CopyString("Copy me, Copy you",NewStringInTown);
* NewStringInTown = "Copy me, Copy you"
*/
void CopyString_WPostOp(char* From,char* To,char** PostOp)
{ //Not Tested
	int Counter = 0;
  while(From[Counter]!='\0')
  {
    To[Counter]=From[Counter];
    Counter++;
  }
	To[Counter] = '\0';
	*PostOp = &To[Counter];
}

void CopyConst_WPostOp(const char* From,char* To,char** PostOp)
{ //Not Tested
	int Counter = 0;
  while(From[Counter] != '\0')
  {
    To[Counter]=From[Counter];
    Counter++;
  }
	To[Counter] = '\0';
	*PostOp = &To[Counter];
}

void IntXY_ToString_WPostOp(int x,int y,char** LineSlide)
{ //Not Tested
	//printf("%d\n", x);
	//printf("%d\n", y);
	CopyConst_WPostOp("X: ",*LineSlide,LineSlide);
  IntToString_WPostOp(x,*LineSlide,LineSlide);

  //CopyString_WPostOp(char* From,char* To,char* PostOp);
	CopyConst_WPostOp(",Y: ",*LineSlide,LineSlide);
  IntToString(y,*LineSlide);
  //CopyString_WPostOp("\n ",LineSlide,LineSlide);

}

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
void CopyStringTillGivenChar(char* From,char* To,const char* GivenChars)
{
  int GivenCharsCounter = 0;
  int FromCounter = 0;

  bool EndCharFound=false;
  while(From[FromCounter]!='\0' && !EndCharFound)
  {
    GivenCharsCounter = 0;
    while((GivenChars[GivenCharsCounter]!='\0') && !EndCharFound)
    {
      if(From[FromCounter] == GivenChars[GivenCharsCounter])
      {
        EndCharFound = true;
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
}

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
void CopyStringTillGivenCharPostPointer(char* From,char* To,const char* GivenChars,char** PostCopy)
{
  int GivenCharsCounter = 0;
  int FromCounter = 0;

  bool EndCharFound=false;
  while(From[FromCounter]!='\0' && !EndCharFound)
  {
    GivenCharsCounter = 0;
    while((GivenChars[GivenCharsCounter]!='\0') && !EndCharFound)
    {
      if(From[FromCounter] == GivenChars[GivenCharsCounter])
      {
        EndCharFound = true;
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
	*PostCopy = &To[FromCounter];
}

/*
* @brief MyStrLen Short For: My string length
*
* @details Function Loops untill end of string '\0', counting the number of
* characters and returning the number of elements in the string.
*
* @example:
* Usage: MyStrLen("how many are there?")
* Returns : 19
*/
int MyStrLen(char * String)
{
  int count = 0;
  while(String[count] != '\0')
  {
    count++;
  }
  return count;
}


/*
* @brief FloatToString
*
* @details Function
*

to include String modification, and include 6 decimal places
* creates the string backwards, before copying it character-by-character
* to 'String'


* @example:
* Usage: DoubleToString(270.458231,String)
* String = '270.458231'
*/
void FloatToString(float fVal,char* String)
{
    char result[100];
    int dVal, dec, GeneratedStringCounter,OutputStringCounter;


    dVal = fVal;
    dec = (int)(fVal * 1000000);

    result[0] = (dec % 10)/1 + '0';
    result[1] = (dec % 100)/10 + '0';
    result[2] = (dec % 1000)/100 + '0';
    result[3] = (dec % 10000)/1000 + '0';
    result[4] = (dec % 100000)/10000 + '0';
    result[5] = (dec % 1000000)/100000 + '0';

    result[6] = '.';

    GeneratedStringCounter = 7;
    while (dVal > 0)
    {
        result[GeneratedStringCounter] = (dVal % 10) + '0';
        dVal /= 10;
        GeneratedStringCounter++;
    }
    result[GeneratedStringCounter] = '\0';
    OutputStringCounter = 0;
    for (GeneratedStringCounter = MyStrLen(result)-1; GeneratedStringCounter >= 0; GeneratedStringCounter--)
    {
      String[OutputStringCounter] = result[GeneratedStringCounter];
      OutputStringCounter++;
    }
    String[OutputStringCounter] = '\0';
}

void DoubleToString(double dVal,char* String)
{

}

/*
* @brief IntToString
*
* @details Function
*

// Heavily Modified code to include String modification
// creates the string backwards, before copying it character-by-character
// to 'String'


* @example:
* Usage: IntToString(270,String)
* String = '270'
*/
void IntToString(int Value,char* String)
{
  char result[100];
  int GeneratedStringCounter,OutputStringCounter;

  GeneratedStringCounter = 0;
  while (Value > 0)
  {
      result[GeneratedStringCounter] = (Value % 10) + '0';
      Value /= 10;
      GeneratedStringCounter++;
  }
  result[GeneratedStringCounter] = '\0';

  OutputStringCounter = 0;
  for (GeneratedStringCounter = MyStrLen(result)-1; GeneratedStringCounter >= 0; GeneratedStringCounter--)
  {
    String[OutputStringCounter] = result[GeneratedStringCounter];
    OutputStringCounter++;
  }
  if(OutputStringCounter == 0)
  {
    String[OutputStringCounter] = '0';
    OutputStringCounter++;
  }
  String[OutputStringCounter] = '\0';
	result[0]='0';
	result[1]='\0';
}
/*
void IntToString(int Value,char** String)
{
  char result[100];
  int GeneratedStringCounter,OutputStringCounter;

  GeneratedStringCounter = 0;
  while (Value > 0)
  {
      result[GeneratedStringCounter] = (Value % 10) + '0';
      Value /= 10;
      GeneratedStringCounter++;
  }
  result[GeneratedStringCounter] = '\0';

  OutputStringCounter = 0;
  for (GeneratedStringCounter = MyStrLen(result)-1; GeneratedStringCounter >= 0; GeneratedStringCounter--)
  {
    String[OutputStringCounter] = result[GeneratedStringCounter];
    OutputStringCounter++;
  }
  if(OutputStringCounter == 0)
  {
    String[OutputStringCounter] = '0';
    OutputStringCounter++;
  }
  String[OutputStringCounter] = '\0';
}
*/
void IntToString_WPostOp(int Value,char* String,char** PostOp)
{
  char result[100];
  int GeneratedStringCounter,OutputStringCounter;

  GeneratedStringCounter = 0;
  while (Value > 0)
  {
      result[GeneratedStringCounter] = (Value % 10) + '0';
      Value /= 10;
      GeneratedStringCounter++;
  }
  result[GeneratedStringCounter] = '\0';

  OutputStringCounter = 0;
  for (GeneratedStringCounter = MyStrLen(result)-1; GeneratedStringCounter >= 0; GeneratedStringCounter--)
  {
    String[OutputStringCounter] = result[GeneratedStringCounter];
    OutputStringCounter++;
  }
  if(OutputStringCounter == 0)
  {
    String[OutputStringCounter] = '0';
    OutputStringCounter++;
  }
	*PostOp = &String[OutputStringCounter];
}


/*
* @brief IntToString
*
* @details Function Loops through given string (From), character by character
* untill a character from (GivenChars), any character not("0123456789"), or
* '\0' is found, incrementing the Integer(To) along the way.

* @example:
* int SomeInteger;
* Usage: CopyIntegerTillGivenChar("123456.76",SomeInteger,",");
* SomeInteger = "123456"
*/
bool CopyIntegerTillGivenChar(char* From,int* To,const char* GivenChars)
{

	*To = 0;
  bool oneChar=false;
  int FoundValue=0;
  int counter=0;
  while((From[counter] != ';' ||
        From[counter] != ' ' ||
        From[counter] != '\0'||
        From[counter] != '\n'||
        From[counter] != '.'))
  {
    if(From[counter]=='0' ||
       From[counter]=='1' ||
       From[counter]=='2' ||
       From[counter]=='3' ||
       From[counter]=='4' ||
       From[counter]=='5' ||
       From[counter]=='6' ||
       From[counter]=='7' ||
       From[counter]=='8' ||
       From[counter]=='9')
       {
         *To = *To * 10 + From[counter] - '0';
         oneChar=true;
       }
       else
       {
         //character not expected return error
        return false;
       }
      counter+=1;
    }

  if(oneChar)
  {
    //integer given everythings fine
    *To = FoundValue;
    counter+=1;
    return true;
  }
  return false;
}


/*
* HACK @brief CopyIntegerTillGivenCharPostPointer
*
* @details Function Loops through given string (From), character by character,
* untill a character from (GivenChars), any character not("0123456789"), or
* '\0' is found, Incrementing Integer(To) along the way. Also modifies
*  (PostInteger) char** to Point to the end of the found integer.

* @example:
* int SomeInteger;
* char *EndOfTheLine;
* Usage: CopyIntegerTillGivenChar("123456.76",SomeInteger,",",EndOfTheLine);
* SomeInteger = "123456"
* printf("%s",EndOfTheLine); -> prints ".76"
*/
bool CopyIntegerTillGivenCharPostPointer(char* From,int* To,const char* GivenChars,char** PostInteger)
{
		*To = 0;
  bool oneChar   = false;
  int FoundValue = 0;
  int counter    = 0;
  while((From[counter] != ';' ||
        From[counter] != ' ' ||
				From[counter] != ']' ||
        From[counter] != '\0'||
        From[counter] != '\n'||
        From[counter] != '.'))
  {
    if(From[counter]=='0' ||
       From[counter]=='1' ||
       From[counter]=='2' ||
       From[counter]=='3' ||
       From[counter]=='4' ||
       From[counter]=='5' ||
       From[counter]=='6' ||
       From[counter]=='7' ||
       From[counter]=='8' ||
       From[counter]=='9')
       {
         FoundValue = FoundValue*10 + From[counter] - '0';
         oneChar=true;

       }
       else
       {
         if(oneChar)
         {

           *To = FoundValue;

           *PostInteger = &From[counter];

           return true;
         }
       return false;
       }
       counter+=1;
    }
    if(oneChar)
    {
      //integer given everythings fine
      *To = FoundValue;
      *PostInteger = &From[counter];
      return true;
    }
  return false;
}




/*
* @brief SkipGivenCharacters
*
* @details Function Loops through given string (From), character by character,
* while any character from (GivenChars) is present, Also while '\0' is not
* present, modifies the pointer (PostChars), to point after the given characters
*
* @example:
* char Line[100]=" \t  Some Important Stuff";
* char* EndOfTheLine;
* Usage: SkipGivenCharacters(Line,&EndOfTheLine," \t");
* printf("%s",EndOfTheLine); -> prints "Some Important Stuff"
*/
void SkipGivenCharacters(char* Line,char** PostChars,const char* GivenChars)
{
  int GivenCharsCounter = 0;
  int LineCounter = 0;

  bool CharFound = false;
  bool ContinueLoop = true;
  while((Line[LineCounter] != '\0')  &&  ContinueLoop)
  {
    GivenCharsCounter = 0;
    CharFound = false;
    while(!(GivenChars[GivenCharsCounter] == '\0') && !CharFound)
    {
      if(Line[LineCounter] == GivenChars[GivenCharsCounter])
      {
        CharFound = true;
        LineCounter++;
      }
      GivenCharsCounter++;
    }
    ContinueLoop = CharFound;
  }
  *PostChars = &Line[LineCounter];
}



/*
* @brief SkipToken
*
* @details Function Loops through given string (From), character by character,
* and as long as its equivalent to the string (Token), and while '\0' is not
* present,it modifies the pointer (PostChars), to point after the given string.
* Also Returns True if the Complete (Token) was found
*
* @example:
// char Line[100]="Token Some Important Stuff";
// char* EndOfTheLine;
// Usage: SkipToken("Token",Line,&EndOfTheLine);
// printf("%s",EndOfTheLine); -> prints " Some Important Stuff"
*/
bool SkipToken(const char* Token,char* String,char** ReturnString)
{
  int StringCounter = 0;
  while(!(Token[StringCounter] =='\0'))
  {
    if((Token[StringCounter] != String[StringCounter]))
    {
      return false;
    }
    else
    {
      StringCounter++;
      if(Token[StringCounter]=='\0')
      {
        *ReturnString = &String[StringCounter];
        return true;//true
      }
    }
  }
  return false; //false
}



bool TokenPresent(char* Token,char* String)
{
  int StringCounter = 0;
  while(!(Token[StringCounter] == '\0'))
  {
    if((Token[StringCounter] != String[StringCounter]))
    {
      return false;
    }
    else
    {
      StringCounter++;
      if(Token[StringCounter] == '\0')
      {
        return true;//true
      }
    }
  }
  return false; //false
}


/*
* @brief CompareString, Tests If the given string (S1), is equivalent to the
* string (S2), and if both strings end at the same time.
*
* @example:
// Usage: CompareString("Hello","Hello!");
// printf("%d",CompareString("Hello","Hello!"));
//-> prints '0' - strings not equivalent
*/
bool CompareString(char* S1,char* S2)
{
  int counter = 0;
  while(S1[counter] == S2[counter])
  {
    if(S1[counter] == '\0')
    {
      if(S2[counter] == '\0')
      {
        return true;
      }
      return false;
    }
    else
    {
      counter++;
    }
  }
  return false;
}

/*
* @brief CompareCharacter, Tests If the character (C1), is equivalent to the
* character (C2),
*
* @example:
// Usage: CompareCharacter('H','h');
// printf("%d",CompareString('H','h'));
//-> prints '0' - Characters not equivalent
*/
bool CompareCharacter(char C1,char C2)
{
  if(C1 == C2)
  {
    return true;
  }
  return false;
}



void CombineTwoStrings(const char* S1,const char* S2,char Result[])
{
  int StringOneCounter = 0;

  while(S1[StringOneCounter] != '\0' && S1[StringOneCounter] != '\n')
  {
    Result[StringOneCounter] = S1[StringOneCounter];
    StringOneCounter++;
  }

  int StringTwoCounter = 0;
  while(S2[StringTwoCounter] != '\0' && S2[StringTwoCounter] != '\n')
  {
    Result[StringOneCounter + StringTwoCounter] = S2[StringTwoCounter];
    StringTwoCounter++;
  }

  Result[StringOneCounter + StringTwoCounter] = '\0';
}



bool ValidateNumber(char* Line)
{
  if(Line[0]=='0' ||
     Line[0]=='1' ||
     Line[0]=='2' ||
     Line[0]=='3' ||
     Line[0]=='4' ||
     Line[0]=='5' ||
     Line[0]=='6' ||
     Line[0]=='7' ||
     Line[0]=='8' ||
     Line[0]=='9')
     {
       return true;
     }
  else
  {
    return false;
  }
}



#endif // StringField_C
