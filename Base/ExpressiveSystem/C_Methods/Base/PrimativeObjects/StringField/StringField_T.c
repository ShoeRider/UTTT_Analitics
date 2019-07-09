#ifndef StringFields_C
#define StringFields_C


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

void Test_SSToken()
{
	char Line[100]=" \t  SomeImportantStuff";
	char* LinePointer = &Line[0];
	//SSearchToken(&LinePointer," \t","Some");
	printf("%s\n",LinePointer);  // -> prints "Some Important Stuff"

}

void StringFields_T()
{
	printf("\n\n");
	printf("Character Operations:\n");
	printf("===================\n");
	//IntegerToHex(10);
	//IntegerToHex(12);

	//Test_SSToken();

}

#endif // StringFields_C
