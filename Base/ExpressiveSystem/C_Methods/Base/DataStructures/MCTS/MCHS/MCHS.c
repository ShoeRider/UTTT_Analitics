#ifndef MCHS_C
#define MCHS_C

#include "MCHS.h"


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

PRHS_fl* Create_PRHS_fl(
	PossibleBreakOuts_f* PossibleBreakOuts,
	RollOut_f* RollOut,
	Hash_f   *Hash,
	StopCondition_f*StopCondition)
{
	PRHS_fl* PRHS = (PRHS_fl*)malloc(sizeof(PRHS_fl));
	PRHS->PossibleBreakOuts = PossibleBreakOuts;
	PRHS->RollOut = RollOut;
	PRHS->Hash    = Hash;
	PRHS->StopCondition = StopCondition;
	return PRHS;
}

MCHS_Node_t* Create_MCHS_Node_t(void* Simulation)
{
		MCHS_Node_t* MCHS_Node = (MCHS_Node_t*) malloc(sizeof(MCHS_Node_t));
		MCHS_Node->Simulation  = Simulation;
		MCHS_Node->ChildNodes  = Create_DLL_Handle_t();
		MCHS_Node->ContinueSimulation = true;
		MCHS_Node->Value       = 0;
		MCHS_Node->Visits  = 0;
		MCHS_Node->LeafNode    = true;
		return MCHS_Node;
}

MCHS_Node_t* Create_MCHS_Node_t(void* Simulation,MCHS_Node_t* Parrent)
{
		MCHS_Node_t* MCHS_Node =  Create_MCHS_Node_t(void* Simulation)
		MCHS_Node->Parrent     = Parrent;
		return MCHS_Node;
}

void Free(MCHS_Node_t* MCHS_Node)
{
	free(MCHS_Node->Simulation);
	free(MCHS_Node);
}

//TODO add:  PRHS_fl* PRHS
MCHS_t* Create_MCHS_t(int Depth,void* Simulation)
{
	MCHS_t* MCHS      = (MCHS_t*) malloc(sizeof(MCHS_t));
	MCHS->HashTable   = Create_HashTable_t((int)Depth*(4/3));
	//MCHS->PRHS      = PRHS;

	MCHS->SearchDepth = SearchDepth;
	MCHS->Node0       = Create_MCHS_Node_t(Simulation);

	//MCHS->PRHS->Hash((void*)MCHS->Node0->Simulation);
	Add(MCHS->HashTable,0,(void*)MCHS->Node0);
	return MCHS;
}

void Free(MCHS_t*MCHS)
{
	//free(MCHS->PRHS);
	Free(MCHS->HashTable);
	free(MCHS);
}

void* SimulateDepth(MCHS_t* MCHS,int Depth)
{
	for(int Simulation=0;Simulation<Depth;Simulation++)
	{
		Simulate(MCHS);
	}

}

void Simulate(MCHS_t* MCHS)
{
	MCHS->DepthSearched++;
	//1. TreeTransversal
	MCHS_Node_t* MCHS_Node = TreeTransversal(MCHS);

	//2. Node Expansion
	MCHS_Node = NodeExpansion(MCHS,MCHS_Node);

	//3. RollOut
	RollOut(MCHS,MCHS_Node);

	//4. BackPropigation
	BackPropigation(MCHS,MCHS_Node);
}

void* MostVisited(MCHS_Node_t* MCHS_Node)
{
	int MostVisits = INT_MIN;
	MCHS_Node_t* MostVisited;
	DLL_Transverse(MCHS_Node->ChildNodes,

		if((MCHS_Node_t*)Node->GivenStruct->Visits=MostVisits)
		{
			MCHS_Node = (MCHS_Node_t*)Node->GivenStruct;
		}
	)
	return MCHS_Node->Simulation;
}

float _UCB1(MCHS_Node_t* MCHS_Node,int ParentVisitCount)
{
	if(MCHS_Node->Visits == 0)
	{
		return INT_MAX;
	}
//printf("%d,",MCTS_Node->AverageValue/MCTS_Node->Visits );
	return (MCHS_Node->Value/MCHS_Node->Visits + 1.4142*sqrt(log((float)ParentVisitCount)/MCHS_Node->Visits));
}


MCHS_Node_t *TreeTransversal(MCHS_t* MCHS)
{
	MCHS_Node_t* MCHS_Node = MCHS->Node0;
	int ParentVisitCount;
	int Best_UCB1;

	while(!MCHS_Node->LeafNode)
	{
		ParentVisitCount = MCHS_Node->VisitCount;
		Best_UCB1 = INT_MIN;

		//Select Best UCB1's
		DLL_Transverse(MCHS_Node->ChildNodes,
			if(_UCB1((MCHS_Node_t*)Node->GivenStruct,ParentVisitCount)>=Best_UCB1)
			{
				MCHS_Node = (MCHS_Node_t*)Node->GivenStruct;
			}
		)

		return MCHS_Node;
}


MCHS_Node_t* NodeExpansion(MCHS_t* MCHS, MCHS_Node_t*MCHS_Node)
{
	if(MCHS_Node->VisitCount == 0)
	{
		return MCHS_Node;
	}
	else
	{
		//Use given function: PossibleBreakOuts to create new nodes
		DLL_Handle_t BreakOut_DLL_Handle = MCHS->PRHS->PossibleBreakOuts(MCHS_Node->GivenStruct);

		int Hash,Exists;
		bool EquivalentStructs;
		MCHS_Node_t* NewMCHS_Node;
		if(BreakOut_DLL_Handle->Length > 0)
		{
			DLL_Transverse(BreakOut_DLL_Handle,
				//Take Each Possible move,
				//1.Create MCHS_Node_t
				NewMCHS_Node = Create_MCHS_Node_t(node->GivenStruct,MCHS_Node);
				//2.Find (int)Hash
				Hash = MCHS->PRHS->Hash(node->GivenStruct);
				//3.Add to hashTable, add pointer to parent Node
				Exists = Exists(MCHS->HashTable,Hash);
				if(Exists>=0)
				{
					if(MCHS->PRHS->Equivalent(node->GivenStruct,MCHS_Node->GivenStruct))
					{//Equivalent structures found! Remove new Structure, and point to old position.
						NewMCHS_Node = Get(MCHS->HashTable,Hash);
						MCHS->PRHS->Free(pop(BreakOut_DLL_Handle,node));
					}
					else
					{
						//Problem~Hash overlap has occured!!!
						printf("Overlapping Hashes!!!\n");
					}
				}
				else
				{
					//add NewMCHS_Node to Hash Table
					Add(MCHS->HashTable,Hash,NewMCHS_Node);
				}

				Add(MCHS_Node->ChildNodes,NewMCHS_Node);
			)
		}
		else
		{

		}

	}
	//return First_MCHS_Node;
}

void RollOut(MCHS_t* MCHS, MCHS_Node_t* MCHS_Node)
{
	int StopCondition = MCHS->PRHS->StopCondition(MCHS_Node->Simulation);
	if(StopCondition)
	{
		MCHS_Node->ContinueSimulation = false;
		MCHS_Node->Value              =
															MCHS->PRHS->PositionValue(MCHS_Node->Simulation);

	}
	else
	{
		int RolloutResult = MCHS->PRHS->RollOut(MCHS_Node->Simulation);

		MCHS_Node->Value = RolloutResult;
	}

}

void BackPropigation(MCHS_t* MCHS,MCHS_Node_t*MCHS_Node)
{
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
