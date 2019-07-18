#ifndef MCHS_C
#define MCHS_C

#include "MCHS.h"
#include <bits/stdc++.h>

// Code Implementation File Information ///////////////////////////////////////
/**
* @file MCHS_T
*
* @brief Implementation for structures:
*          -MCHS
*
* @details Implements all functions Related to Basic DLL(Doubly Linked List)
*           functionality.
*
* @version 1.10
*
* @note Requires:
*          - HashTable.c/.h
*          -"DoublyLinkedList.h"
*/


MCHS_Node_t* Create_MCHS_Node_t(int Hash,void* GivenStruct)
{
		MCHS_Node_t* MCHS_Node = (MCHS_Node_t*) malloc(sizeof(MCHS_Node_t));
		MCHS_Node->GivenStruct  = GivenStruct;
		MCHS_Node->ChildNodes  = Create_DLL_Handle_t();
		MCHS_Node->ContinueSimulation = true;
		MCHS_Node->Value       = 0;
		MCHS_Node->Visits      = 0;
		MCHS_Node->LeafNode    = true;
		MCHS_Node->UniqueHash  = Hash;
		return MCHS_Node;
}

MCHS_Node_t* Create_MCHS_Node_t(MCHS_t*MCHS,void* GivenStruct)
{
		int Hash = MCHS->MCHS_FL->Hash(GivenStruct);
		return Create_MCHS_Node_t(Hash,GivenStruct);
}




void Free(MCHS_Node_t* MCHS_Node,Free_ Free_GivenStruct)
{
	printf("Free_GivenStruct\n");
	Free_GivenStruct(MCHS_Node->GivenStruct);

	DLL_TransverseFree(MCHS_Node->ChildNodes,
		 Free((MCHS_Node_t*)Node->GivenStruct,Free_GivenStruct);
	)
	free(MCHS_Node);

}

//TODO add:  MCHS_FL_fl* MCHS_FL
//SearchDepth - Number of nodes Created/Searched
MCHS_t* Create_MCHS_t(MCHS__FL_t*MCHS_FL,int SearchDepth,void* GivenStruct)
{
	MCHS_t* MCHS      = (MCHS_t*) malloc(sizeof(MCHS_t));
	MCHS->MCHS_FL     = MCHS_FL;
	MCHS->SearchDepth = SearchDepth;


	MCHS->HashTable   = Create_HashTable_t((int)SearchDepth*(4/3));

	int Hash          = 0;      //MCHS->MCHS_FL->Hash((void*)MCHS->Node0->GivenStruct);
	MCHS->Node0       = Create_MCHS_Node_t(Hash,GivenStruct);
	Add(MCHS->HashTable,Hash,(void*)MCHS->Node0);

	return MCHS;
}


void Free(MCHS_t*MCHS)
{
	Free_DirectStructure(MCHS->HashTable);
	Free(MCHS->Node0,MCHS->MCHS_FL->Free);
	free(MCHS->MCHS_FL);
	free(MCHS);
}



#endif // MCHS_C
