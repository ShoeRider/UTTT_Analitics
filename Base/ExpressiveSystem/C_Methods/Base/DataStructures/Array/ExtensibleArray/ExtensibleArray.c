#ifndef ExtensibleArray_C
#define ExtensibleArray_C

#include "ExtensibleArray.h"

//Uses:
//Great for Pageing indexes

int Add(ExtensibleArray_t*ExtensibleArray);


//ExtensibleArray_t* Create_ExtensibleArray_t(int ArraySize)
ExtensibleArray_t* Create_ExtensibleArray_t(int ArraySize,int _ArraySize)
{
	ExtensibleArray_t* ExtensibleArray = (ExtensibleArray_t*) malloc(sizeof(ExtensibleArray_t));
  ExtensibleArray->Size          = ArraySize;
	ExtensibleArray->_Size         = _ArraySize;
	ExtensibleArray->Array         = (int*) malloc(_ArraySize*sizeof(int));
	//Size Also ExternalSize

	ExtensibleArray->Elements      = ArraySize;
	return ExtensibleArray;
}

//ExtensibleArray_t* Create_ExtensibleArray_t(int ArraySize)
ExtensibleArray_t* Create_ExtensibleArray_t(int ArraySize)
{
	return Create_ExtensibleArray_t(ArraySize,ArraySize*4);
}




//void _Extend(ExtensibleArray_t*ExtensibleArray,int _Size)
//Checks if the desired size is larger than the hidden size,
//if it is then the hidden array will be resized and transfere the elements over.
void _Extend(ExtensibleArray_t*ExtensibleArray,int _Size)
{
	if (Size > ExtensibleArray->_Size)
	{
		ExtensibleArray_t* Temp = Create_ExtensibleArray_t(ExtensibleArray->Size,_Size);

		//Transfer elements over
		for(int X=0;X<ExtensibleArray->Size;X++)
		{
			Add(Temp,(void*)ExtensibleArray->Array[X]);
		}

		//Once all the elements are moved over, free the old Array pointer,
		//and move reference and values from new ExtensibleArray.
		ExtensibleArray->_Size = Temp->_Size;
		free(ExtensibleArray->Array);
		ExtensibleArray->Array = Temp->Array;
		free(Temp);
	}

}


//void _Extend(ExtensibleArray_t*ExtensibleArray)
//checks if the Number of elements is 2/3's the size of the hidden array,
//if it is then the hidden array will be resized and transfered over.
void _Extend(ExtensibleArray_t*ExtensibleArray)
{
	float Filled = (float)ExtensibleArray->Elements/(float)ExtensibleArray->_Size;
	if (Filled >= ((float)2/(float)3))
	{
		_Extend(ExtensibleArray,ExtensibleArray->_Size);
	}
}

//int Add(ExtensibleArray_t*ExtensibleArray)
//Returns:
//-1: failed to add element
//[0-MAX_INT]: Index
int Add(ExtensibleArray_t*ExtensibleArray,int* Value)
{
	ExtensibleArray->Array[ExtensibleArray->Elements] = Value;
	ExtensibleArray->Elements++;
	_Extend(ExtensibleArray);
	return (ExtensibleArray->Elements-1);
}

//int Set(ExtensibleArray_t*ExtensibleArray,int Position,int Value)
//Returns:
//-1: failed to add element
//0: Success
int Set(ExtensibleArray_t*ExtensibleArray,int Index,int Value)
{
	if(Index < ExtensibleArray->Size)
	{
		ExtensibleArray->Array[Index] = Value;
		_Extend(ExtensibleArray);
	}
	else
	{
		return -1;
	}


}

//int Add(ExtensibleArray_t*ExtensibleArray)
//Returns:
//integer value.
int Get(ExtensibleArray_t*ExtensibleArray,int Index)
{
	if(Index > ExtensibleArray->_Size)
	{
		//attempting to access element outside array
		return NULL;
	}
	return ExtensibleArray->Array[Index];
}


void Free(ExtensibleArray_t*ExtensibleArray)
{
	free(ExtensibleArray->Array);
	free(ExtensibleArray);
}




#endif // ExtensibleArray_C
