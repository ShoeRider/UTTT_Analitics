#ifndef MCTS_C
#define MCTS_C

#include "MCTS.h"


// Code Implementation File Information ///////////////////////////////////////
/**
* @file DoublyLinkedList.c
*
* @brief Implementation for structures:
*          -DLL_Node_t
*          -DLL_Handle_t
*
*
* @details Implements all functions Related to Basic DLL(Doubly Linked List)
*           functionality.
*
* @version 1.10
*
* @note Requires:
*          -"CharacterOperations.h"
*          -"DoublyLinkedList.h"
*/

/*
* @brief
*
* @details
*
* @example:
*
*/
void MCTS_V()
{
	printf("MCTS  \tV:1.00\n");
}

MCTS_Node_t* Create_MCTS_Node(GameRules_t* GameRules, int Depth)
{
	MCTS_Node_t* MCTS = (MCTS_Node_t*)malloc(sizeof(MCTS_Node_t));
	//MCTS->RolloutValue = 0;

	MCTS->AverageValue = 0;
	MCTS->Value        = 0;
  MCTS->EndValue     = 0;
	MCTS->NodeVisits   = 0;
  MCTS->End          = 0;
	MCTS->Depth        = Depth;
	MCTS->Board        = NULL;
	MCTS->Player       = 0;
	MCTS->LeafNode     = true;
	MCTS->GameRules    = GameRules;

	MCTS->ChildNodes = Create_DLL_Handle();
	return MCTS;
}

MCTS_Handle_t* Create_MCTS_Handle(int SearchDepth,RunTimeFunction GameRules)
{
	MCTS_Handle_t* MCTS_Handle = (MCTS_Handle_t*)malloc(sizeof(MCTS_Handle_t));
	MCTS_Handle->NodeVisits      = 0;
	MCTS_Handle->NodesToSearch   = SearchDepth;
	MCTS_Handle->NodesCreated    = 0;

	MCTS_Handle->Player          = 0;
	MCTS_Handle->PlayersMove     = 0;
	MCTS_Handle->PosibleMoves    = NULL;

	MCTS_Handle->RollOutGame    = NULL;

	MCTS_Handle->GameRules     = (GameRules_t*)GameRules(NULL);
	MCTS_Handle->TransversedNode = NULL;
	MCTS_Handle->MCTS_Node0      = NULL;
	return MCTS_Handle;
}


#define MCTS_Node_Slide ((MCTS_Node_t*)Node->Given_Struct)
//Take Node and add it to another node
void ADD_MCTS_ToTree(MCTS_Node_t* MCTS_Node0, MCTS_Node_t* MCTS_Node1)
{
	DLL_Node_t* Temp = Create_DLL_Node_WithStruct(MCTS_Node0);
	Add_Node_To_Handle(Temp,MCTS_Node1->ChildNodes);
}

void Free_MCTS_Child_DLL(DLL_Handle_t* Child_MCTS_DLL)
{

	if(Child_MCTS_DLL != NULL)
	{
		if(Child_MCTS_DLL->ListLength > 0)
		{
			DLL_Node_t* Node = (DLL_Node_t*)Child_MCTS_DLL->First;
			while(Node->Next != NULL)
			{
				//FreeGame(MCTS_Node_Slide->Board);
				Free_MCTS_Node(MCTS_Node_Slide);

				Node = (DLL_Node_t*)Node->Next;
				free(Node->Prev);

			}
			//FreeGame(MCTS_Node_Slide->Board);
			Free_MCTS_Node(MCTS_Node_Slide);
			free(Node);

		}
		free(Child_MCTS_DLL->Mutex);
		free(Child_MCTS_DLL);
	}

}

float Find_MCTS_UCB1(MCTS_Node_t* MCTS_Node,int ParentVisitCount)
{
	// AverageValue + C*squareRoot(nl(ParentVisitCount)/ChildvisitCout)
	/*
	if(MCTS_Node->End == 1)
	{
		return MCTS_Node->Value;
		//printf("Find_MCTS_UCB1 Returning 0\n");
		//return 1;
	}*/
	if(MCTS_Node->NodeVisits == 0)
	{
		return INT_MAX;
	}
//printf("%d,",MCTS_Node->AverageValue/MCTS_Node->NodeVisits );
	return (MCTS_Node->Value/MCTS_Node->NodeVisits + 1.4142*sqrt(log((float)ParentVisitCount)/MCTS_Node->NodeVisits));
}
//
void Select_MCTS_NodeFromDLL_UCB1(MCTS_Node_t** MCTS_Node)
{
	printf("in  Select_MCTS_NodeFromDLL_UCB1\n");
	MCTS_Node_t* HighestNode = NULL;
	DLL_Handle_t* MCTS_DLL = (*MCTS_Node)->ChildNodes;
	if(MCTS_DLL->ListLength > 0)
	{
		printf("Morethan one Element\n");
		int MaxValue = (INT_MIN);
		int FoundValue;

		DLL_Node_t* Node = (DLL_Node_t*)MCTS_DLL->First;
		HighestNode = (MCTS_Node_t*)Node->Given_Struct;
		while(Node->Next != NULL)
		{
			FoundValue = Find_MCTS_UCB1((MCTS_Node_t*)Node->Given_Struct, (*MCTS_Node)->NodeVisits);
			printf("%d\n",FoundValue);
			if(FoundValue > MaxValue)
			{
				HighestNode = (MCTS_Node_t*)Node->Given_Struct;
			}
			Node = (DLL_Node_t*)Node->Next;
		}
		FoundValue = Find_MCTS_UCB1((MCTS_Node_t*)Node->Given_Struct, (*MCTS_Node)->NodeVisits);
		if(FoundValue > MaxValue)
		{
			HighestNode = (MCTS_Node_t*)Node->Given_Struct;
		}
	}
	if(HighestNode != NULL)
	{
		(*MCTS_Node)->LeafNode = false;
		*MCTS_Node = HighestNode;
	}
}

void Free_MCTS_Node(MCTS_Node_t* MCTS_Node)
{

	if(MCTS_Node != NULL)
	{
		if(MCTS_Node->Board != NULL)
		{
			MCTS_Node->GameRules->FreeGame(MCTS_Node->Board);
		}
		if(MCTS_Node->ChildNodes != NULL)
		{
			Free_MCTS_Child_DLL(MCTS_Node->ChildNodes);
		}
		free(MCTS_Node);
	}
}

void Free_MCTS_Handle(MCTS_Handle_t* MCTS_Handle)
{
	Free_MCTS_Node(MCTS_Handle->MCTS_Node0);
	free(MCTS_Handle->GameRules);
	free(MCTS_Handle);
}
//Create Node (With) Struct (And) Add (to) DLL_Handle




float MCTS_Rollout(MCTS_Handle_t* MCTS_Handle)
{
	//float BP_Value = 0;
	//Game Over?
	if (MCTS_Handle->GameRules->Winner(MCTS_Handle->TransversedNode->Board))
	{
		//Check Who Is Winner
		//Return 1 if won, 0 if loss

		//-> if winner player then return 1
		//-> if winnter othre return 0
		return 1;
	}
	//Select Random Move and Directly_Multiply ProperMove Filter, ->Move and Call Rollout
	//int RandomMove = RandomSelect_IMatrixIndex(IMatrix);
	//Get Posible Moves

	//Make Random Move -> Call MCTS_Rollout

	//return BP_Value, and return
	return 0;
}


void CreateMCTSNode_DLL(MCTS_Handle_t* MCTS_Handle)
{
	printf("Started CreateMCTSNode_DLL\n");
	IMatrix_t* IMatrix = MCTS_Handle->PosibleMoves;
	printf("about to printf Matrix\n");
	PrintIntegerMatrix(IMatrix);
	RunTimeFunction CopyGame = MCTS_Handle->GameRules->CopyGame;
	DLL_Handle_t* DLL_Handle = Create_DLL_Handle();
	printf("about to Add DLL_Nodes\n");
	//Go Through Each Node, for each 1, Create/CopyGame and add to Handle (Could Also Create Matrix Version)
	for (int i = 0; i < IMatrix->X; i++)
	{
		for (int j = 0; j < IMatrix->Y; j++)
		{
			if (*(IMatrix->Array + i*IMatrix->Y + j) == 1)
			{
				DLL_Node_t* NewNode = Create_DLL_Node_WithStruct(Create_MCTS_Node(MCTS_GameRules,0));
				((MCTS_Node_t*)NewNode->Given_Struct)->Board = CopyGame(MCTS_Handle->PosibleMoves);

        int Move = (i*3 + j);
				MCTS_GameRules->Player0(((MCTS_Node_t*)NewNode->Given_Struct)->Board,(void*)&Move);

				Add_Node_To_Handle(NewNode,DLL_Handle);

			}

		}
	}
	printf("%d - DLLLenght\n", DLL_Handle->ListLength);
  MCTS_Handle->TransversedNode->LeafNode = false;
	MCTS_Handle->TransversedNode->ChildNodes = DLL_Handle;
	printf("%d - DLLLenght\n", MCTS_Handle->TransversedNode->ChildNodes->ListLength);
}


void Simulate_MCTS(MCTS_Handle_t* MCTS_Handle,void* Board)
{
	if(MCTS_Handle->MCTS_Node0 == NULL)
	{
		MCTS_Handle->MCTS_Node0 = Create_MCTS_Node(MCTS_GameRules,0);
	}
	//CopyGame
	(MCTS_Handle->MCTS_Node0->Board) = Board; //MCTS_Handle->GameRules->InitializeWorld(NULL);
	MCTS_Handle->NodesCreated = 0;

	while(MCTS_Handle->NodesCreated < MCTS_Handle->NodesToSearch)
	{

	 MCTS_Handle->TransversedNode = MCTS_Handle->MCTS_Node0;
	 Transverse_MCTS(MCTS_Handle);
   printf("---------------------------\n");
   printf("Value  :%f\n", MCTS_Handle->MCTS_Node0->AverageValue);
   printf("Visits :%d\n", MCTS_Handle->MCTS_Node0->NodeVisits);
   printf("---------------------------\n");
	 MCTS_Handle->NodesCreated++;
 	}
	//Select Best Move from Select_MCTS_NodeFromDLL_UCB1() all the way down the Search Tree
	//either Return or Display Move

}




#define M_MCTS_P1Move_DLL(X) (DLL_Handle_t*)((IMatrix_t*)MCTS_Handle->GameRules->Player1_Moves(X))


//Returns int as Propigated Value
float Transverse_MCTS(MCTS_Handle_t* MCTS_Handle)
{
		float BP_Value = 0;
		MCTS_Node_t* Local_MCTS_Node = MCTS_Handle->TransversedNode;
		//int PlayersMove = MCTS_Handle->PlayersMove;
		//Loop for NodesToSearch
		printf("Starting Transverse_MCTS\n");
		if(Local_MCTS_Node->LeafNode == false)
		{
			printf("Not a Leaf Node\n");
			//Current Node Leaf node ?
			//if not find UCB1's Best Move
			Select_MCTS_NodeFromDLL_UCB1(&MCTS_Handle->TransversedNode);
			BP_Value = Transverse_MCTS(MCTS_Handle);

			//assign Value, add and return
		}
		else if(Local_MCTS_Node->NodeVisits == 0)
		{
			printf("Visits Zero ->Rolling out\n");
			//No-> so RollOut -> Back Propigate
			BP_Value = MCTS_Rollout(MCTS_Handle);

		}
		else
		{
			printf("Visits Greater Than Zero-> (Creating Move Matrix/Move to)->Rolling out\n");
			//Yes-> Create Node For each Move

			MCTS_Handle->PosibleMoves = MCTS_P0Move_IMatrix(MCTS_Handle->TransversedNode->Board);

			CreateMCTSNode_DLL(MCTS_Handle);
			FreeMatrix(MCTS_Handle->PosibleMoves);
			/*
			Local_MCTS_Node->NodeVisits++;
			//PosibleMoves = Player0_Moves(TTT_Game);
			//---------------------------------------------
			//ChosenMove = RandomMove(Possiblemoves);
			Select_MCTS_NodeFromDLL_UCB1(&MCTS_Handle->TransversedNode);

			//RollOut_Game = Player0(ChosenMove);
			BP_Value = MCTS_Rollout(MCTS_Handle);*/
		}

		//DLL_Node_t* Node = Create_DLL_Node_WithStruct(Create_MCTS_Node());
		//Add_Node_To_Handle(Node,Node0->Branch);


	//save best move
	//free Nodes
	//Free Rollout

	//reset Nodes Created
	Local_MCTS_Node->AverageValue += BP_Value;
	Local_MCTS_Node->NodeVisits++;

	//printf("---------------------------\n");
	//printf("Value  :%f\n", Local_MCTS_Node->AverageValue);
	//printf("Visits :%d\n", Local_MCTS_Node->NodeVisits);
	//printf("---------------------------\n");

	return Local_MCTS_Node->AverageValue;
}

void Select_MCTS_NodeFromDLL_UCB1_T()
{

}

void MCTS_T()
{
	printf("\n\n");
	printf("MCTS Tests:\n");
	printf("===================\n");
	Select_MCTS_NodeFromDLL_UCB1_T();
}

#endif // MCTS_C
