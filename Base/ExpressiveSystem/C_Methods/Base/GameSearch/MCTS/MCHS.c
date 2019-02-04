#ifndef MCHS_C
#define MCHS_C

#include "MCHS.h"


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
*#include "../../DataStructures/MMath.h"
* @details
*
* @example:
*
*/
MCTS_HashTable_t* Create_MCTS_HashTable_t(GameRules_t* GameRules,int HashTableSize, int Depth)
{
	MCTS_HashTable_t* MCTS_HashTable = (MCTS_HashTable_t*)malloc(sizeof(MCTS_HashTable_t));
	//MCTS->RolloutValue = 0;

	MCTS_HashTable->MCTS_HashTable  = Create_HashTable_t(HashTableSize);

	MCTS_HashTable->GameRules = GameRules;
	return MCTS_HashTable;
}

MCHS_Node_t* Create_MCHS_Node_t(GameRules_t* GameRules)
{
	MCHS_Node_t* MCHS_Node = (MCHS_Node_t*)malloc(sizeof(MCHS_Node_t));
	//MCHS_Node->RolloutValue = 0;

	MCHS_Node->AverageValue = 0;
	MCHS_Node->Value        = 0;
  MCHS_Node->EndValue     = 0;
	MCHS_Node->NodeVisits   = 0;
  MCHS_Node->End          = 0;
	MCHS_Node->Board        = NULL;
	MCHS_Node->Player       = 0;
	MCHS_Node->LeafNode     = true;
	MCHS_Node->GameRules    = GameRules;
	MCHS_Node->PosibleMoves = NULL;

	MCHS_Node->ChildNodes = NULL;
	return MCHS_Node;
}

MCHS_Handle_t* Create_MCHS_Handle_t(int SearchDepth,int HashSize,RunTimeFunction GameRules)
{
	MCHS_Handle_t* MCHS_Handle = (MCHS_Handle_t*)malloc(sizeof(MCHS_Handle_t));
	MCHS_Handle->NodeVisits      = 0;
	MCHS_Handle->SearchDepth     = SearchDepth;
	MCHS_Handle->NodesSearched   = 0;
	MCHS_Handle->Player          = 0;
	MCHS_Handle->PlayersMove     = 0;
	MCHS_Handle->PosibleMoves    = NULL;

	MCHS_Handle->RollOutGame     = NULL;

	MCHS_Handle->GameRules       = (GameRules_t*)GameRules(NULL);
	MCHS_Handle->TransversedNode = NULL;
	MCHS_Handle->MCHS_Node0      = NULL;

	MCHS_Handle->HashSize				= HashSize;
	MCHS_Handle->HashTable      = Create_HashTable_t(HashSize);
	printf("Returning MCHS_Handle\n");
	return MCHS_Handle;
}


#define MCHS_Node_Slide ((MCHS_Node_t*)Node->Given_Struct)
//Take Node and add it to another node



float Find_MCHS_UCB1(MCHS_Node_t* MCHS_Node,int ParentVisitCount)
{
	// AverageValue + C*squareRoot(nl(ParentVisitCount)/ChildvisitCout)
	/*
	if(MCTS_Node->End == 1)
	{
		return MCTS_Node->Value;
		//printf("Find_MCTS_UCB1 Returning 0\n");
		//return 1;
	}*/
	if(MCHS_Node->NodeVisits == 0)
	{
		return INT_MAX;
	}
//printf("%d,",MCHS_Node->AverageValue/MCHS_Node->NodeVisits );
	return (MCHS_Node->Value/MCHS_Node->NodeVisits + 1.4142*sqrt(log((float)ParentVisitCount)/MCHS_Node->NodeVisits));
}


//
void Select_MCHS_NodeFromDLL_UCB1(MCHS_Node_t** MCHS_Node)
{
	printf("in  Select_MCHS_NodeFromDLL_UCB1\n");
	MCHS_Node_t* HighestNode = NULL;
	DLL_Handle_t* MCTS_DLL = (*MCHS_Node)->ChildNodes;
	if(MCTS_DLL->ListLength > 0)
	{
		printf("Morethan one Element\n");
		int MaxValue = (INT_MIN);
		int FoundValue;

		DLL_Node_t* Node = (DLL_Node_t*)MCTS_DLL->First;
		HighestNode = (MCHS_Node_t*)Node->Given_Struct;
		while(Node->Next != NULL)
		{
			FoundValue = Find_MCHS_UCB1((MCHS_Node_t*)Node->Given_Struct, (*MCHS_Node)->NodeVisits);
			printf("%d\n",FoundValue);
			if(FoundValue > MaxValue)
			{
				HighestNode = (MCHS_Node_t*)Node->Given_Struct;
			}
			Node = (DLL_Node_t*)Node->Next;
		}
		FoundValue = Find_MCHS_UCB1((MCHS_Node_t*)Node->Given_Struct, (*MCHS_Node)->NodeVisits);
		if(FoundValue > MaxValue)
		{
			HighestNode = (MCHS_Node_t*)Node->Given_Struct;
		}
	}
	if(HighestNode != NULL)
	{
		(*MCHS_Node)->LeafNode = false;
		*MCHS_Node = HighestNode;
	}
}


//Create Node (With) Struct (And) Add (to) DLL_Handle

//Returns int as Propigated Value
float Transverse_MCHS(MCHS_Handle_t* MCHS_Handle)
{
	/*
		float BP_Value = 0;
		MCTS_Node_t* Local_MCTS_Node = MCHS_Handle->TransversedNode;
		//int PlayersMove = MCHS_Handle->PlayersMove;
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
			BP_Value = MCTS_Rollout(MCTS_Handle);*//*
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
*/
}


float MCHS_Rollout(MCHS_Handle_t* MCHS_Handle)
{
	//float BP_Value = 0;
	//Game Over?
	if (MCHS_Handle->GameRules->Winner(MCHS_Handle->TransversedNode->Board))
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


void CreateMCHSNode_DLL(MCHS_Handle_t* MCHS_Handle)
{
	printf("Started CreateMCTSNode_DLL\n");
	IMatrix_t* IMatrix = MCHS_Handle->PosibleMoves;
	printf("about to printf Matrix\n");
	PrintIntegerMatrix(IMatrix);
	RunTimeFunction CopyGame = MCHS_Handle->GameRules->CopyGame;
	DLL_Handle_t* DLL_Handle = Create_DLL_Handle();
	printf("about to Add DLL_Nodes\n");
	//Go Through Each Node, for each 1, Create/CopyGame and add to Handle (Could Also Create Matrix Version)
	for (int i = 0; i < IMatrix->X; i++)
	{
		for (int j = 0; j < IMatrix->Y; j++)
		{
			if (*(IMatrix->Array + i*IMatrix->Y + j) == 1)
			{
				//DLL_Node_t* NewNode = Create_DLL_Node_WithStruct(Create_MCHS_Node(MCHS_Handle,0));
				//((MCTS_Node_t*)NewNode->Given_Struct)->Board = CopyGame(MCHS_Handle->PosibleMoves);

        int Move = (i*3 + j);
				//MCTS_GameRules->Player0(((MCTS_Node_t*)NewNode->Given_Struct)->Board,(void*)&Move);

				//Add_Node_To_Handle(NewNode,DLL_Handle);

			}

		}
	}
	printf("%d - DLLLenght\n", DLL_Handle->ListLength);
  MCHS_Handle->TransversedNode->LeafNode = false;
	MCHS_Handle->TransversedNode->ChildNodes = DLL_Handle;
	printf("%d - DLLLenght\n", MCHS_Handle->TransversedNode->ChildNodes->ListLength);
}


void Simulate_MCHS_Handle(MCHS_Handle_t* MCHS_Handle,void* Board)
{
	if(MCHS_Handle->MCHS_Node0 == NULL)
	{
		//MCHS_Handle->MCTS_Node0 = Create_MCTS_Node(MCTS_GameRules,0);
	}
	//CopyGame
	(MCHS_Handle->MCHS_Node0->Board) = Board; //MCTS_Handle->GameRules->InitializeWorld(NULL);
	MCHS_Handle->NodesSearched = 0;

	while(MCHS_Handle->NodesSearched < MCHS_Handle->SearchDepth)
	{

	 MCHS_Handle->TransversedNode = MCHS_Handle->MCHS_Node0;
	 Transverse_MCHS(MCHS_Handle);//Transverse_MCTS
   printf("---------------------------\n");
   printf("Value  :%f\n", MCHS_Handle->MCHS_Node0->AverageValue);
   printf("Visits :%d\n", MCHS_Handle->MCHS_Node0->NodeVisits);
   printf("---------------------------\n");
	 MCHS_Handle->NodesSearched++;
 	}
	//Select Best Move from Select_MCTS_NodeFromDLL_UCB1() all the way down the Search Tree
	//either Return or Display Move

}




#define M_MCHS_P1Move_DLL(X) (DLL_Handle_t*)((IMatrix_t*)MCTS_Handle->GameRules->Player1_Moves(X))


//Returns int as Propigated Value
float Transverse_MCHS_Handle_t(MCHS_Handle_t* MCHS_Handle)
{
		float BP_Value = 0;
		MCHS_Node_t* Local_MCHS_Node = MCHS_Handle->TransversedNode;
		//int PlayersMove = MCTS_Handle->PlayersMove;
		//Loop for NodesToSearch
		printf("Starting Transverse_MCTS\n");
		if(Local_MCHS_Node->LeafNode == false)
		{
			printf("Not a Leaf Node\n");
			//Current Node Leaf node ?
			//if not find UCB1's Best Move
			Select_MCHS_NodeFromDLL_UCB1(&MCHS_Handle->TransversedNode);
			BP_Value = Transverse_MCHS_Handle_t(MCHS_Handle);

			//assign Value, add and return
		}
		else if(Local_MCHS_Node->NodeVisits == 0)
		{
			printf("Visits Zero ->Rolling out\n");
			//No-> so RollOut -> Back Propigate
			BP_Value = MCHS_Rollout(MCHS_Handle);

		}
		else
		{
			printf("Visits Greater Than Zero-> (Creating Move Matrix/Move to)->Rolling out\n");
			//Yes-> Create Node For each Move

			//TODO MCHS_Handle->PosibleMoves = MCHS_P0Move_IMatrix(MCHS_Handle->TransversedNode->Board);

			CreateMCHSNode_DLL(MCHS_Handle);
			FreeMatrix(MCHS_Handle->PosibleMoves);
			/*
			Local_MCHS_Node->NodeVisits++;
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
	Local_MCHS_Node->AverageValue += BP_Value;
	Local_MCHS_Node->NodeVisits++;

	//printf("---------------------------\n");
	//printf("Value  :%f\n", Local_MCHS_Node->AverageValue);
	//printf("Visits :%d\n", Local_MCHS_Node->NodeVisits);
	//printf("---------------------------\n");

	return Local_MCHS_Node->AverageValue;
}





void Free_MCHS_Handle_t(MCHS_Handle_t* MCHS_Handle)
{
	Free_HashTable_t(MCHS_Handle->HashTable);
  free(MCHS_Handle->GameRules);
  free(MCHS_Handle);
}

#endif // MCHS_C
