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
//		MCHS_Node->Parrent     = Parrent;

void Free(MCHS_Node_t* MCHS_Node)
{
	free(MCHS_Node->GivenStruct);
	free(MCHS_Node);
}

//TODO add:  MCHS_FL_fl* MCHS_FL
//SearchDepth - Number of nodes Created/Searched
MCHS_t* Create_MCHS_t(MCHS__FL_t*MCHS_FL,int SearchDepth,void* GivenStruct)
{
	MCHS_t* MCHS      = (MCHS_t*) malloc(sizeof(MCHS_t));
	MCHS->HashTable   = Create_HashTable_t((int)SearchDepth*(4/3));
	MCHS->MCHS_FL     = MCHS_FL;

	MCHS->SearchDepth = SearchDepth;
	MCHS->Node0       = Create_MCHS_Node_t(MCHS,GivenStruct);

	//MCHS->MCHS_FL->Hash((void*)MCHS->Node0->GivenStruct);
	Add(MCHS->HashTable,0,(void*)MCHS->Node0);
	return MCHS;
}

void Free(MCHS_t*MCHS)
{
	//free(MCHS->MCHS_FL);
	Free(MCHS->HashTable);
	free(MCHS);
}


void Simulate(MCHS_t* MCHS)
{
	MCHS->DepthSearched++;
	//1. TreeTransversal
	MCHS_Node_t* MCHS_Node = TreeTransversal(MCHS);

	//2. Node Expansion
	MCHS_Node = NodeExpansion(MCHS,MCHS_Node);
	if(MCHS_Node == NULL)
	{
		//Unexpected error,
		//TODO: Gracefully end GivenStruct.
		for(;;){}
	}

	//3. RollOut
	RollOut(MCHS,MCHS_Node);

	//4. BackPropigation
	BackPropigation(MCHS,MCHS_Node);
}

void* SimulateDepth(MCHS_t* MCHS,int Depth)
{
	for(int GivenStruct=0;GivenStruct<Depth;GivenStruct++)
	{
		Simulate(MCHS);
	}
	return NULL;
}

void* MostVisited(MCHS_Node_t* MCHS_Node)
{
	int MostVisits = INT_MIN;
	DLL_Transverse(MCHS_Node->ChildNodes,

		if(((MCHS_Node_t*)Node->GivenStruct)->Visits=MostVisits)
		{
			MCHS_Node = (MCHS_Node_t*)Node->GivenStruct;
		}
	)
	return MCHS_Node->GivenStruct;
}

float _UCB1(MCHS_Node_t* MCHS_Node,int ParentVisits)
{
	if(MCHS_Node->Visits == 0)
	{
		return INT_MAX;
	}
//printf("%d,",MCTS_Node->AverageValue/MCTS_Node->Visits );
	return (MCHS_Node->Value/MCHS_Node->Visits + 1.4142*sqrt(log((float)ParentVisits)/MCHS_Node->Visits));
}


MCHS_Node_t *TreeTransversal(MCHS_t* MCHS)
{
	MCHS_Node_t* MCHS_Node = MCHS->Node0;
	int ParentVisits;
	int Best_UCB1;

	while(!MCHS_Node->LeafNode)
	{
		ParentVisits = MCHS_Node->Visits;
		Best_UCB1 = INT_MIN;

		//Select Best UCB1's
		DLL_Transverse(MCHS_Node->ChildNodes,
			int ucb1 =_UCB1((MCHS_Node_t*)Node->GivenStruct,ParentVisits);
			if(ucb1>=Best_UCB1)
			{
				Best_UCB1 = ucb1;
				MCHS_Node = (MCHS_Node_t*)Node->GivenStruct;
			}
		)
	}

		return MCHS_Node;
}


MCHS_Node_t* NodeExpansion(MCHS_t* MCHS, MCHS_Node_t* MCHS_Node)
{
	if(MCHS_Node->Visits == 0)
	{
		return MCHS_Node;
	}
	else
	{
		//Use given function: PossibleBreakOuts to create new nodes
		DLL_Handle_t* BreakOut_DLL_Handle = MCHS->MCHS_FL->PossibleBreakOuts(MCHS_Node->GivenStruct);

		int Hash;
		void* ExistingGivenStruct;
		MCHS_Node_t* NewMCHS_Node = NULL;
		if(BreakOut_DLL_Handle->Length > 0)
		{
			DLL_Transverse(BreakOut_DLL_Handle,
				//Take Each Possible move,
				//1.Create MCHS_Node_t

				//2.Find (int)Hash
				Hash = MCHS->MCHS_FL->Hash(Node->GivenStruct);
				//3.Add to hashTable, add pointer to parent Node
				ExistingGivenStruct = Get(MCHS->HashTable,Hash);
				if(ExistingGivenStruct!=NULL)
				{
					if(MCHS->MCHS_FL->Equivalent(Node->GivenStruct,ExistingGivenStruct))
					{//Equivalent structures found! Remove new Structure, and point to old position.
						NewMCHS_Node = (MCHS_Node_t*) Get(MCHS->HashTable,Hash);
						MCHS->MCHS_FL->Free(Pop(BreakOut_DLL_Handle,Node));
					}
					else
					{
						//Problem~Hash overlap has occured!!!
						printf("!!!! Critical error !!!! ~OVERLAPPING HASHES~ Develop better hash function or fix provided 'Equivalent' function!!!\n");
						return NULL;
					}
				}
				else
				{
					//add NewMCHS_Node to Hash Table
					MCHS_Node_t*NewMCHS_Node = Create_MCHS_Node_t(Hash,Node->GivenStruct,MCHS_Node);
					Add(MCHS->HashTable,Hash,(void*)NewMCHS_Node);
				}

				Add(MCHS_Node->ChildNodes,NewMCHS_Node);
			)
			return NewMCHS_Node;
		}
		else
		{
			//No Moves Provided
			return NULL;
		}

	}
}

void RollOut(MCHS_t* MCHS, MCHS_Node_t* MCHS_Node)
{
	int StopCondition = MCHS->MCHS_FL->StopCondition(MCHS_Node->GivenStruct);
	if(StopCondition)
	{
		MCHS_Node->ContinueSimulation = false;
		MCHS_Node->Value              =
															MCHS->MCHS_FL->PositionValue(MCHS_Node->GivenStruct);

	}
	else
	{
		int RolloutResult = MCHS->MCHS_FL->RollOut(MCHS_Node->GivenStruct);

		MCHS_Node->Value = RolloutResult;
	}

}

void BackPropigation(MCHS_t* MCHS,MCHS_Node_t*MCHS_Node)
{
	MCHS_Node_t* MCHS_ParrentNode;
	while(MCHS_Node->Parrent != NULL)
	{
		MCHS_ParrentNode = MCHS_Node->Parrent;
		//Update Values
		MCHS_Node->Visits++;
		MCHS_ParrentNode->AverageValue += MCHS_Node->AverageValue;


		MCHS_Node = MCHS_ParrentNode;
	}
}



#endif // MCHS_C
