#ifndef UTickTackToe_MCHS_C
#define UTickTackToe_MCHS_C

//Header Files
#include "UTickTackToe_MCHS.h"
//Forward declaration





void Set_MCHS_UTTT(MCHS_Handle_t* MCHS_Handle)
{
  MCHS_Handle->GameRules = (GameRules_t*)Get_UTTT_GRules(NULL);
}




float UTTT_MCHS_Rollout(MCHS_Handle_t* MCHS_Handle)
{
	//float BP_Value = 0;
	//Game Over?
	if (MCHS_Handle->GameRules->Winner(MCHS_Handle->RollOutGame))
	{
		//Check Who Is Winner
		//Return 1 if won, 0 if loss
    if(MCHS_Handle->Player == 0 )
    {
      if (((UTTT_t*)MCHS_Handle->RollOutGame)->Winner == 'X')
      {
        return 1;
      }
      else if(((UTTT_t*)MCHS_Handle->RollOutGame)->Winner == 'O')
      {
        return -1;
      }
      else
      {
        return 0;
      }
    }
    else
    {
      if (((UTTT_t*)MCHS_Handle->RollOutGame)->Winner == 'O')
      {
        return 1;
      }
      else if(((UTTT_t*)MCHS_Handle->RollOutGame)->Winner == 'X')
      {
        return -1;
      }
      else
      {
        return 0;
      }
    }


	}

  IMatrix_t* PosibleMoves = (IMatrix_t*)MCHS_Handle->GameRules->Player0_Moves((void*)MCHS_Handle->RollOutGame);
  int Move = RandomSelect_IMatrixIndex(PosibleMoves);
  Free_IMatrix((IMatrix_t*)PosibleMoves);

  //PrintInt(Move);
  if (Move == -1)
  {
    // Go to next Open Game~ should change to DLL and Pass all posibilites to NN ~ MCHS Might Be hard...
    ((UTTT_t*)MCHS_Handle->RollOutGame)->Game++;
    if(((UTTT_t*)MCHS_Handle->RollOutGame)->Game == 9)
    {
      ((UTTT_t*)MCHS_Handle->RollOutGame)->Game = 0;
      //Display_UTTT_Game((UTTT_t*)MCHS_Handle->RollOutGame);
    }

    //BreakDef
    //InBreak
    //PrintInt(((UTTT_t*)MCHS_Handle->RollOutGame)->Game)
    return UTTT_MCHS_Rollout(MCHS_Handle);
  }

  Move += ((UTTT_t*)MCHS_Handle->RollOutGame)->Game*9;
  //PrintInt(Move);
  ((GameRules_t*)MCHS_Handle->GameRules)->PlayerMove((UTTT_t*)MCHS_Handle->RollOutGame,(void*)&Move);
  //Display_UTTT_Game((UTTT_t*)MCHS_Handle->RollOutGame);
  //Display_TTT_Game((TTT_t*)MCHS_Handle->RollOutGame);

//else make random move, and rollout
	return UTTT_MCHS_Rollout(MCHS_Handle);
}

//Create_MCHS_Node
//TODO CHange all
void CreateMCHS_UTTT_Node_DLL(MCHS_Handle_t* MCHS_Handle)
{
	//printf("in CreateMCHSNode_DLL\n");
  MCHS_Handle->PosibleMoves = (IMatrix_t*)(MCHS_Handle->GameRules->Player0_Moves(MCHS_Handle->TransversedNode->Board));
	//IMatrix_t* IMatrix = MCHS_Handle->PosibleMoves;
	//printf("gatheredPosible Moves Matrix\n");
	//PrintIntegerMatrix(MCHS_Handle->PosibleMoves);
	RunTimeFunction CopyGame = MCHS_Handle->GameRules->CopyGame;
	DLL_Handle_t* DLL_Handle = MCHS_Handle->TransversedNode->ChildNodes;
	//printf("about to Add DLL_Nodes\n");
	//Go Through Each Node, for each 1, Create/CopyGame and add to Handle (Could Also Create Matrix Version)

  _2D_MatrixLoop(MCHS_Handle->PosibleMoves,
    if (_2D_FL_Matrix_Element(MCHS_Handle->PosibleMoves) == 1)
    {
      //printf("Accpeptable Move Found\n");
      //printf("(%d,%d)",i,j);
      //PrintInt(_2D_FL_Matrix_Element(MCHS_Handle->PosibleMoves));
      //printf("ParentNode Depth:%d\n",MCHS_Handle->TransversedNode->Depth);
      DLL_Node_t* NewNode = Create_DLL_Node_WithStruct(Create_MCHS_Node_t(((GameRules_t*)MCHS_Handle->GameRules)));
      ((MCHS_Node_t*)NewNode->Given_Struct)->Board = (void*)CopyGame(MCHS_Handle->TransversedNode->Board);


      if ( ((MCHS_Node_t*)NewNode->Given_Struct)->Player == 0 )
      {
        ((MCHS_Node_t*)NewNode->Given_Struct)->Player = 1;
      }
      else
      {
        ((MCHS_Node_t*)NewNode->Given_Struct)->Player = 0;
      }

      int Move = (i*3 + j)+((UTTT_t*)MCHS_Handle->TransversedNode->Board)->Game*9;
      //printf("in Game# :%d\n",((UTTT_t*)MCHS_Handle->TransversedNode->Board)->Game*9);
      //printf("Creating Node with Move :%d\n",Move);
      //((GameRules_t*)MCHS_Handle->GameRules)->Player0((TTT_t*)((MCHS_Node_t*)NewNode->Given_Struct)->Board,(void*)&Move);

      //PlayerMove_UTTT((void*)((MCHS_Node_t*)NewNode->Given_Struct)->Board,(void*)&Move);
      //Display_UTTT_Game((UTTT_t*)((MCHS_Node_t*)NewNode->Given_Struct)->Board);
      //int Move = 0;
      //GatherTerminalInt("Select Move:",&Move);

      //printf("UTTT Copy with move\n");
      //Display_UTTT_Game((UTTT_t*)((MCHS_Node_t*)NewNode->Given_Struct)->Board);
      //printf("displayed game , adding node to handle\n");
      //printf("Adding Node To List \n");
      Add_Node_To_Handle(NewNode,DLL_Handle);
      MCHS_Handle->TransversedNode->LeafNode = false;
    }

  )

  FreeMatrix(MCHS_Handle->PosibleMoves);
	//printf("%d - DLLLenght\n", DLL_Handle->ListLength);

	MCHS_Handle->TransversedNode->ChildNodes = DLL_Handle;
	//printf("%d - DLLLenght\n", MCHS_Handle->TransversedNode->ChildNodes->ListLength);
  //printf("About to leave UTTT DLL node creation To List \n");


}
/*
void Set_UTTT_MCHS_Node_DLL(MCHS_Handle_t* MCHS_Handle,MCHS_Node_t* MCHS_Node)
{
  //If not ChildNodes DLL then we need to create/account for branches in the game

  if(MCHS_Node->ChildNodes == NULL)
  {
    MCHS_Node->ChildNodes = Create_DLL_Handle();

    printf("Started CreateMCHSNode_DLL\n");
    MCHS_Node->PosibleMoves = (IMatrix_t*)(MCHS_Handle->GameRules->Player0_Moves(MCHS_Node->Board));

    //PrintIntegerMatrix(MCHS_Handle->PosibleMoves);
    RunTimeFunction CopyGame = MCHS_Handle->GameRules->CopyGame;
    DLL_Handle_t* DLL_Handle = MCHS_Node->ChildNodes;
    //printf("about to Add DLL_Nodes\n");
    //Go Through Each Node, for each 1, Create/CopyGame and add to Handle (Could Also Create Matrix Version)

    _2D_MatrixLoop(MCHS_Node->PosibleMoves,
      if (_2D_FL_Matrix_Element(MCHS_Node->PosibleMoves) == 1)
      {
        UTTT_t* NewUTTT_Game = (UTTT_t*) CopyGame(MCHS_Node->Board);
        int Move = (i*3 + j)+((UTTT_t*)MCHS_Handle->TransversedNode->Board)->Game*9;
        PlayerMove_UTTT((void*)NewUTTT_Game,(void*)&Move);

        //Here we see if a current board matches this one, if so we add it,
        //if not we just point to it
        int Hash = 0;
        for (int Game=0; Game<8;Game++)
        {
          Hash += Get_PJWHash_2D_CMatrix_t(Board->TTTGame_Matrix[Game].BoardRep);
        }
        Hash_t* Hash_t = PULL_HashTable(NewUTTT_Game->HashTable,Hash);
        if(Hash_t == NULL)
        {
          MCHS_Node_t* MCHS_Node = Create_MCHS_Node_t(MCHS_Handle->GameRules);
          MCHS_Node->Board = NewUTTT_Game;
          Hash_t = GetSet_TTT_MCHS_Position(MCHS_Handle,NewUTTT_Game);//Create List of child nodes
          //CreateMCTS_TTT_Node_DLL
          Push_HashTable(MCHS_Handle->HashTable,(void*)MCHS_Node,Hash);
        }



        DLL_Node_t* NewNode = Create_DLL_Node_WithStruct((void*) Hash_t->Structure);
            printf("NewNode    %p,Structure  %p\n",NewNode,NewNode->Given_Struct );
        Add_Node_To_Handle(NewNode,MCHS_Handle->TransversedNode->ChildNodes);
      }
    )
    FreeMatrix(MCHS_Node->PosibleMoves);
    MCHS_Node->PosibleMoves = NULL;
    MCHS_Node->LeafNode = false;
  }

}
*/
void Set_UTTT_MCHS_Node_DLL(MCHS_Handle_t* MCHS_Handle,MCHS_Node_t* MCHS_Node)
{
  //If not ChildNodes DLL then we need to create/account for branches in the game
  if(MCHS_Node->ChildNodes == NULL)
  {
    MCHS_Node->ChildNodes = Create_DLL_Handle();

    printf("\t\tStarted CreateMCHSNode_DLL\n");
    MCHS_Node->PosibleMoves = (IMatrix_t*)(MCHS_Handle->GameRules->Player0_Moves(MCHS_Node->Board));

    //PrintIntegerMatrix(MCHS_Handle->PosibleMoves);
    RunTimeFunction CopyGame = MCHS_Handle->GameRules->CopyGame;
    DLL_Handle_t* DLL_Handle = MCHS_Node->ChildNodes;
    //printf("about to Add DLL_Nodes\n");
    //Go Through Each Node, for each 1, Create/CopyGame and add to Handle (Could Also Create Matrix Version)

    _2D_MatrixLoop(MCHS_Node->PosibleMoves,
      if (_2D_FL_Matrix_Element(MCHS_Node->PosibleMoves) == 1)
      {
        UTTT_t* NewUTTT_Game = (UTTT_t*) CopyGame(MCHS_Node->Board);


        int Move = (i*3 + j);
        PlayerMove_UTTT((void*)NewUTTT_Game,(void*)&Move);




        //Here we see if a current board matches this one, if so we add it,
        //if not we just point to it
        int Hash = 0;
        for (int Game=0; Game<8;Game++)
        {
          Hash += (Game+1)*Get_PJWHash_2D_CMatrix_t(NewUTTT_Game->TTTGame_Matrix[Game].BoardRep);
        }
        Hash_t* Hash_t = PULL_HashTable(MCHS_Handle->HashTable,Hash);
        if(Hash_t == NULL)
        {
          MCHS_Node_t* MCHS_Node = Create_MCHS_Node_t(MCHS_Handle->GameRules);
          MCHS_Node->Board = NewUTTT_Game;
          Hash_t = GetSet_UTTT_MCHS_Position(MCHS_Handle,NewUTTT_Game);//Create List of child nodes
          //CreateMCTS_TTT_Node_DLL
          Push_HashTable(MCHS_Handle->HashTable,(void*)MCHS_Node,Hash);
        }



        DLL_Node_t* NewNode = Create_DLL_Node_WithStruct((void*) Hash_t->Structure);
            printf("NewNode    %p,Structure  %p\n",NewNode,NewNode->Given_Struct );
        Add_Node_To_Handle(NewNode,MCHS_Handle->TransversedNode->ChildNodes);
      }
    )
    FreeMatrix(MCHS_Node->PosibleMoves);
    MCHS_Node->PosibleMoves = NULL;
    MCHS_Node->LeafNode = false;
  }

}

void Select_MCHS_UTTT_NodeFromDLL_ByValue(MCHS_Node_t** MCHS_Node)
{
	//printf("in  Select_MCHS_NodeFromDLL_UCB1\n");
	MCHS_Node_t* HighestNode = NULL;
	DLL_Handle_t* MCHS_DLL = (*MCHS_Node)->ChildNodes;
	if(MCHS_DLL->ListLength > 0)
	{
		//printf("Morethan one Element\n");

		float HighestValue = 0;
		float FoundValue = (INT_MIN);
		DLL_Node_t* Node = (DLL_Node_t*)MCHS_DLL->First;
		HighestNode = (MCHS_Node_t*)Node->Given_Struct;

		while(Node->Next != NULL)
		{
			FoundValue = ((MCHS_Node_t*)Node->Given_Struct)->Value;
			if(FoundValue > HighestValue)
			{
        //printf("~%d\n",FoundValue);
				HighestNode = (MCHS_Node_t*)Node->Given_Struct;
        HighestValue = FoundValue;
			}
			Node = (DLL_Node_t*)Node->Next;
		}
		FoundValue = ((MCHS_Node_t*)Node->Given_Struct)->Value;

    if(FoundValue > HighestValue)
		{
      //printf("~%d\n",FoundValue);
			HighestNode = (MCHS_Node_t*)Node->Given_Struct;
      HighestValue = FoundValue;
		}
	}
  //printf("ParentNode\n");
    //Display_TTT_Game((TTT_t*)*MCHS_Node);
  //  printf("Child\n");
  //    Display_TTT_Game((TTT_t*)HighestNode);
	if(HighestNode != NULL)
	{
		(*MCHS_Node)->LeafNode = false;
		*MCHS_Node = HighestNode;
	}
  //printf("NewParent\n");
  //  Display_TTT_Game((TTT_t*)*MCHS_Node);
}

void Select_MCHS_UTTT_NodeFromDLL_ByAverage(MCHS_Node_t** MCHS_Node)
{
	//printf("in  Select_MCHS_NodeFromDLL_UCB1\n");
	MCHS_Node_t* HighestNode = NULL;
	DLL_Handle_t* MCHS_DLL = (*MCHS_Node)->ChildNodes;
	if(MCHS_DLL->ListLength > 0)
	{
		//printf("Morethan one Element\n");

		float HighestValue = 0;
		float FoundValue = (INT_MIN);
		DLL_Node_t* Node = (DLL_Node_t*)MCHS_DLL->First;
		HighestNode = (MCHS_Node_t*)Node->Given_Struct;

		while(Node->Next != NULL)
		{
			FoundValue = ((MCHS_Node_t*)Node->Given_Struct)->AverageValue;
			if(FoundValue > HighestValue)
			{
        //printf("~%d\n",FoundValue);
				HighestNode = (MCHS_Node_t*)Node->Given_Struct;
        HighestValue = FoundValue;
			}
			Node = (DLL_Node_t*)Node->Next;
		}
		FoundValue = ((MCHS_Node_t*)Node->Given_Struct)->AverageValue;

    if(FoundValue > HighestValue)
		{
      //printf("~%d\n",FoundValue);
			HighestNode = (MCHS_Node_t*)Node->Given_Struct;
      HighestValue = FoundValue;
		}
	}
  //printf("ParentNode\n");
    //Display_TTT_Game((TTT_t*)*MCHS_Node);
  //  printf("Child\n");
  //    Display_TTT_Game((TTT_t*)HighestNode);
	if(HighestNode != NULL)
	{
		(*MCHS_Node)->LeafNode = false;
		*MCHS_Node = HighestNode;
	}
  //printf("NewParent\n");
  //  Display_TTT_Game((TTT_t*)*MCHS_Node);
}

void Select_MCHS_UTTT_NodeFromDLL_UCB1(MCHS_Node_t** MCHS_Node)
{

	//printf("in  Select_MCHS_NodeFromDLL_UCB1\n");
  printf("Line ; if(MCHS_Node != NULL)\n" );
  if(MCHS_Node != NULL)
  {
    MCHS_Node_t* HighestNode = NULL;
    printf("Line; DLL_Handle_t* MCHS_DLL = (*MCHS_Node)->ChildNodes;\n" );
    DLL_Handle_t* MCHS_DLL = (*MCHS_Node)->ChildNodes;
    if(MCHS_DLL->ListLength > 0)
    {
      //printf("transfersing DLL\n");

      float HighestValue = INT_MIN;
      float FoundValue = (0);
      DLL_Node_t* Node = (DLL_Node_t*)MCHS_DLL->First;
      HighestNode = (MCHS_Node_t*)Node->Given_Struct;

      while(Node->Next != NULL)
      {
        FoundValue = Find_MCHS_UCB1((MCHS_Node_t*)Node->Given_Struct, (*MCHS_Node)->NodeVisits);
        if(FoundValue > HighestValue)
        {
          //printf("~%f\n",FoundValue);
          HighestNode = (MCHS_Node_t*)Node->Given_Struct;
          HighestValue = FoundValue;
        }
        Node = (DLL_Node_t*)Node->Next;

      }
      printf("Find_MCHS_UCB1 \n" );
      FoundValue = Find_MCHS_UCB1((MCHS_Node_t*)Node->Given_Struct, (*MCHS_Node)->NodeVisits);
      printf("Found _MCHS_UCB1 \n" );

      if(FoundValue > HighestValue)
      {
        //printf("~%f\n",FoundValue);
        //      printf("----------------\n");
        HighestNode = (MCHS_Node_t*)Node->Given_Struct;
        HighestValue = FoundValue;
      }
    }
    //printf("Found Largest Game, Moving pointers\n");
      //Display_UTTT_Game((UTTT_t*)(*MCHS_Node)->Board);
    //printf("ChildGame \n");
    //  Display_UTTT_Game((UTTT_t*)(HighestNode)->Board);
    if(HighestNode != NULL)
    {
      (*MCHS_Node)->LeafNode = false;
      *MCHS_Node = HighestNode;
    }
  }


  //printf("Leaving SelectMCHS_UTTT\n");
  //  Display_TTT_Game((TTT_t*)*MCHS_Node);
}





float Transverse_UTTT_MCHS(MCHS_Handle_t* MCHS_Handle,int FromBranch)
{
  //Print_UTTT_MCHS_Node(MCHS_Handle->MCHS_Node0,MCHS_Handle->MCHS_Node0->NodeVisits);
  //printf("Transverse_UTTT_MCHS 0\n");
		float BP_Value = 0;
    //printf("	MCHS_Node_t* Local_MCHS_Node = MCHS_Handle->TransversedNode; 0\n");
		MCHS_Node_t* Local_MCHS_Node = MCHS_Handle->TransversedNode;
    //printf("	if (Local_MCHS_Node->End == 1) \n");
    if (Local_MCHS_Node->End == 1)
    {
      printf("Path 0\n");
      //Local_MCHS_Node->Value += Local_MCHS_Node->EndValue;
      //Local_MCHS_Node->NodeVisits += 1;
      //Local_MCHS_Node->AverageValue = Local_MCHS_Node->Value /Local_MCHS_Node->NodeVisits;
      return Local_MCHS_Node->EndValue;
    }
		//int PlayersMove = MCHS_Handle->PlayersMove;
		//Loop for NodesToSearch
		//printf("Starting Transverse_MCHS:\n");
    //Print_TTT_MCHS_Node(Local_MCHS_Node,0);

    //Print_UTTT_MCHS_UCB1(Local_MCHS_Node,0);
    //Print_TTT_MCHS_Handle(Local_MCHS_Node->ChildNodes,0);
		if(Local_MCHS_Node->LeafNode == false)
		{
      printf("Path 1\n");
      //printf("Depth:%d\n",MCHS_Handle->TransversedNode->Depth);
      //printf("ListLength:%d\n",MCHS_Handle->TransversedNode->ChildNodes->ListLength);
      //printf("End?:%d\n",MCHS_Handle->TransversedNode->End);
			//if not find UCB1's Best Move
      //Print_UTTT_MCHS_Node(MCHS_Handle->TransversedNode,1);

      Select_MCHS_UTTT_NodeFromDLL_UCB1(&MCHS_Handle->TransversedNode);
      BP_Value = Transverse_UTTT_MCHS(MCHS_Handle,1);


      //printf("\tTransversed TTT BP_Value:%f\n",BP_Value);

			//assign Value, add and return
		}
		else if(Local_MCHS_Node->NodeVisits == 0)
		{
      printf("Path 2\n");
      //printf("Testing if Board won..\n");
      if(MCHS_Handle->GameRules->Winner(MCHS_Handle->TransversedNode->Board))
      {
        //printf("Found Winning Game \n");
        if (((UTTT_t*)MCHS_Handle->TransversedNode->Board)->Winner == 'X')
        {
          if(MCHS_Handle->Player == 0)
          {
            //printf("X was found as the Winnter\n");
            MCHS_Handle->TransversedNode->End = 1;//*MCHS_Handle->TransversedNode->Depth;
            //Local_MCHS_Node->NodeVisits++
            MCHS_Handle->TransversedNode->EndValue = 1;
            MCHS_Handle->TransversedNode->Value = INT_MAX;
            MCHS_Handle->TransversedNode->NodeVisits = 1;
            MCHS_Handle->TransversedNode->AverageValue = INT_MAX;
            return 1;//*MCHS_Handle->TransversedNode->Depth + 1;
          }
          else
          {
            //printf("O was found as the Winnter\n");
            MCHS_Handle->TransversedNode->End = 1;//
            //Local_MCHS_Node->NodeVisits++;
            MCHS_Handle->TransversedNode->EndValue = -1;
            MCHS_Handle->TransversedNode->Value = INT_MAX;
            MCHS_Handle->TransversedNode->NodeVisits = 1;
            MCHS_Handle->TransversedNode->AverageValue = INT_MAX;
            return -1;//*MCHS_Handle->TransversedNode->Depth - 1;
          }

        }
        else if(((UTTT_t*)MCHS_Handle->TransversedNode->Board)->Winner == 'O')
        {
          if(MCHS_Handle->Player == 1)
          {
            //printf("0 was found as the Winnter\n");
            MCHS_Handle->TransversedNode->End = 1;//*MCHS_Handle->TransversedNode->Depth;
            //Local_MCHS_Node->NodeVisits++
            MCHS_Handle->TransversedNode->EndValue = 1;
            MCHS_Handle->TransversedNode->Value = INT_MAX;
            MCHS_Handle->TransversedNode->NodeVisits = 1;
            MCHS_Handle->TransversedNode->AverageValue = INT_MAX;
            return 1;//*MCHS_Handle->TransversedNode->Depth + 1;
          }
          else
          {
            //printf("O was found as the Winnter\n");
            MCHS_Handle->TransversedNode->End = 1;//
            //Local_MCHS_Node->NodeVisits++;
            MCHS_Handle->TransversedNode->EndValue = -1;
            MCHS_Handle->TransversedNode->Value = INT_MAX;
            MCHS_Handle->TransversedNode->NodeVisits = 1;
            MCHS_Handle->TransversedNode->AverageValue = INT_MAX;
            return -1;//*MCHS_Handle->TransversedNode->Depth - 1;
          }

        }
        else
        {
          //printf("C was found as the Winner\n");
          MCHS_Handle->TransversedNode->End = 1;
          //Local_MCHS_Node->NodeVisits++;
          MCHS_Handle->TransversedNode->EndValue = 0;
          MCHS_Handle->TransversedNode->Value = 0;
          MCHS_Handle->TransversedNode->NodeVisits = 1;
          MCHS_Handle->TransversedNode->AverageValue = 0;
          return 0;
        }
      }
			//printf("Visits not Zero ->Rolling out\n");
      //printf("Rollout\n");

			//No-> so RollOut -> Back Propigate
     //PrintInt(Local_MCHS_Node->NodeVisits)
      MCHS_Handle->RollOutGame = Copy_UTTT_Game(MCHS_Handle->TransversedNode->Board);

      //Display_TTT_Game((TTT_t*)MCHS_Handle->RollOutGame);
			BP_Value = UTTT_MCHS_Rollout(MCHS_Handle);
      //BP_Value += Local_MCHS_Node->Depth*BP_Value;
      //BP_Value *= MCHS_Handle->TransversedNode->Depth;
      //printf("\t\tRollout Value:%f\n",BP_Value);
      Free_UTTT_Board(MCHS_Handle->RollOutGame);
		}
		else
		{
      //printf("\n");
      IMatrix_t* PosibleMoves = (IMatrix_t*)MCHS_Handle->GameRules->Player0_Moves((void*)MCHS_Handle->TransversedNode->Board);
      int Move = GetSum_IMatrix(PosibleMoves);
      Free_IMatrix((IMatrix_t*)PosibleMoves);

      if(Move == 0)
      {
        if(MCHS_Handle->GameRules->Winner(MCHS_Handle->TransversedNode->Board))
        {
          //printf("Found Winning Game \n");
          if (((UTTT_t*)MCHS_Handle->TransversedNode->Board)->Winner == 'X')
          {
            if(MCHS_Handle->Player == 0)
            {
              //printf("X was found as the Winnter\n");
              MCHS_Handle->TransversedNode->End = 1;//*MCHS_Handle->TransversedNode->Depth;
              //Local_MCHS_Node->NodeVisits++
              MCHS_Handle->TransversedNode->EndValue = 1;
              MCHS_Handle->TransversedNode->Value = INT_MAX;
              MCHS_Handle->TransversedNode->NodeVisits = 1;
              MCHS_Handle->TransversedNode->AverageValue = INT_MAX;
              return 1;//*MCHS_Handle->TransversedNode->Depth + 1;
            }
            else
            {
              //printf("O was found as the Winnter\n");
              MCHS_Handle->TransversedNode->End = 1;//
              //Local_MCHS_Node->NodeVisits++;
              MCHS_Handle->TransversedNode->EndValue = -1;
              MCHS_Handle->TransversedNode->Value = INT_MAX;
              MCHS_Handle->TransversedNode->NodeVisits = 1;
              MCHS_Handle->TransversedNode->AverageValue = INT_MAX;
              return -1;//*MCHS_Handle->TransversedNode->Depth - 1;
            }

          }
          else if(((UTTT_t*)MCHS_Handle->TransversedNode->Board)->Winner == 'O')
          {
            if(MCHS_Handle->Player == 1)
            {
              //printf("0 was found as the Winnter\n");
              MCHS_Handle->TransversedNode->End = 1;//*MCHS_Handle->TransversedNode->Depth;
              //Local_MCHS_Node->NodeVisits++
              MCHS_Handle->TransversedNode->EndValue = 1;
              MCHS_Handle->TransversedNode->Value = INT_MAX;
              MCHS_Handle->TransversedNode->NodeVisits = 1;
              MCHS_Handle->TransversedNode->AverageValue = INT_MAX;
              return 1;//*MCHS_Handle->TransversedNode->Depth + 1;
            }
            else
            {
              //printf("O was found as the Winnter\n");
              MCHS_Handle->TransversedNode->End = 1;//
              //Local_MCHS_Node->NodeVisits++;
              MCHS_Handle->TransversedNode->EndValue = -1;
              MCHS_Handle->TransversedNode->Value = INT_MAX;
              MCHS_Handle->TransversedNode->NodeVisits = 1;
              MCHS_Handle->TransversedNode->AverageValue = INT_MAX;
              return -1;//*MCHS_Handle->TransversedNode->Depth - 1;
            }

          }
          else
          {
            //printf("C was found as the Winner\n");
            MCHS_Handle->TransversedNode->End = 1;
            //Local_MCHS_Node->NodeVisits++;
            MCHS_Handle->TransversedNode->EndValue = 0;
            MCHS_Handle->TransversedNode->Value = 0;
            MCHS_Handle->TransversedNode->NodeVisits = 1;
            MCHS_Handle->TransversedNode->AverageValue = 0;
            return 0;
          }
        }


        // Go to next Open Game~ should change to DLL and Pass all posibilites to NN ~ MCHS Might Be hard...
        ((UTTT_t*)MCHS_Handle->TransversedNode->Board)->Game++;
        if(((UTTT_t*)MCHS_Handle->TransversedNode->Board)->Game == 9)
        {
          ((UTTT_t*)MCHS_Handle->TransversedNode->Board)->Game = 0;
          //Display_UTTT_Game((UTTT_t*)MCHS_Handle->RollOutGame);
        }

        //BreakDef
        //InBreak
        //PrintInt(((UTTT_t*)MCHS_Handle->RollOutGame)->Game)
        return Transverse_UTTT_MCHS(MCHS_Handle,1);

      }
      else
      {
        printf("Path 3\n");
        Set_UTTT_MCHS_Node_DLL(MCHS_Handle,MCHS_Handle->TransversedNode);

        if(MCHS_Handle->TransversedNode->ChildNodes->ListLength != 0)
        {
          Select_MCHS_UTTT_NodeFromDLL_UCB1(&MCHS_Handle->TransversedNode);
          BP_Value = Transverse_UTTT_MCHS(MCHS_Handle,1);
        }
      }


		}


	//save best move

	//reset Nodes Created
  //printf("BP_Value %f\n", BP_Value);
  if(((UTTT_t*)Local_MCHS_Node->Board)->Player == 1)
  {
    //BP_Value *= -1;
  }

	Local_MCHS_Node->Value += BP_Value;

  Local_MCHS_Node->NodeVisits++;
  Local_MCHS_Node->AverageValue = Local_MCHS_Node->Value/Local_MCHS_Node->NodeVisits;


  //Print_TTT_MCHS_Node(Local_MCHS_Node);
	return BP_Value ;
}


void Print_UTTT_MCHS_Node(MCHS_Node_t* MCHS_Node,int ParentVisitCount)
{
  printf("---------------------------------------\n");
  printf("MCHS Node: %p\n",MCHS_Node);
  printf("--------------------\n");
  printf("Visits: %d\n",MCHS_Node->NodeVisits);
  printf("AverageValue: %f\n",MCHS_Node->AverageValue);
  printf("LeafNode: %d\n",MCHS_Node->LeafNode);
  //printf("ChildNodes: %d\n",MCHS_Node->ChildNodes->ListLength);

  //printf("Find_MCHS_UCB1: %f\n",Find_MCHS_UTTT_UCB1(MCHS_Node,ParentVisitCount));
  printf("Depth: %d\n",MCHS_Node->Depth);
  printf("--------------------\n");
  Display_UTTT_Game((UTTT_t*)MCHS_Node->Board);
  printf("^-------------------------------------^\n");
}

void Print_UTTT_MCHS_UCB1(MCHS_Node_t* MCHS_Node,int ParentVisitCount)
{
  Print_UTTT_MCHS_Node(MCHS_Node,ParentVisitCount);

  DLL_Handle_t* DLL_Handle = MCHS_Node->ChildNodes;
  printf("=====================================\n");
  printf("Child Nodes : %d\n",DLL_Handle->ListLength);
  ParentVisitCount = MCHS_Node->NodeVisits;

  DLL_Transverse(DLL_Handle,
  printf("~Node(UCB1): %f",Find_MCHS_UCB1((MCHS_Node_t*)Node->Given_Struct,ParentVisitCount));
  printf(", Average: %f",((MCHS_Node_t*)Node->Given_Struct)->AverageValue);
  printf(", Value: %f",((MCHS_Node_t*)Node->Given_Struct)->Value);
  printf(", Visits: %d\n",((MCHS_Node_t*)Node->Given_Struct)->NodeVisits);
  )
  printf("^===================================^\n");
}

void Print_UTTT_MCHS_Handle(MCHS_Node_t* MCHS_Node,int ParentVisitCount)
{
  Print_UTTT_MCHS_Node(MCHS_Node,ParentVisitCount);

  DLL_Handle_t* DLL_Handle = MCHS_Node->ChildNodes;
  printf("=====================================\n");
  printf("Child Nodes : %d\n",DLL_Handle->ListLength);
  ParentVisitCount = MCHS_Node->NodeVisits;
  DLL_Transverse(DLL_Handle,
    Print_UTTT_MCHS_Node((MCHS_Node_t*)Node->Given_Struct,ParentVisitCount);
    //Print_TTT_MCHS_Tree((MCHS_Node_t*)Node->Given_Struct,ParentVisitCount);
  )
  printf("^===================================^\n");
}

void Print_UTTT_MCHS_Tree(MCHS_Node_t* MCHS_Node,int ParentVisitCount)
{
  Print_UTTT_MCHS_Node(MCHS_Node,ParentVisitCount);

  DLL_Handle_t* DLL_Handle = MCHS_Node->ChildNodes;
  printf("=====================================\n");
  printf("Child Nodes : %d\n",DLL_Handle->ListLength);
  ParentVisitCount = MCHS_Node->NodeVisits;
  DLL_Transverse(DLL_Handle,
    Print_UTTT_MCHS_Node((MCHS_Node_t*)Node->Given_Struct,ParentVisitCount);
    //Print_TTT_MCHS_Tree((MCHS_Node_t*)Node->Given_Struct,ParentVisitCount);
  )
  printf("^===================================^\n");
}

//Takes TTT Game, finds its hash value, Creates a MCHS_Node and points to the existing
Hash_t* GetSet_UTTT_MCHS_Position(MCHS_Handle_t* MCHS_Handle,UTTT_t* Board)
{
  int Hash = 0;
  for (int Game=0; Game<8;Game++)
  {
    Hash += (Game+1)*Get_PJWHash_2D_CMatrix_t(Board->TTTGame_Matrix[Game].BoardRep);
  }

  int Index = GetIndex_HashTable(MCHS_Handle->HashTable,Hash);
  if(Index==-1)
  {
    MCHS_Node_t* MCHS_Node = Create_MCHS_Node_t(MCHS_Handle->GameRules);
    printf("MCHS_Node    %p\n",MCHS_Node );
    MCHS_Node->Board = Board;

    //GetSet_TTT_MCHS_Node_DLL(MCHS_Handle,MCHS_Node);//Create List of child nodes
    //CreateMCTS_TTT_Node_DLL
    return Push_HashTable(MCHS_Handle->HashTable,(void*)MCHS_Node,Hash);
  }
  printf("GetSet_UTTT_MCHS_Position done\n" );
  printf("MCHS_Handle->HashTable[Index] is  At %p\n",MCHS_Handle->HashTable->Table[Index]);
  //printf("MCHS_Handle->HashTable[Index]->Structure is  At %p\n",(&MCHS_Handle->HashTable[Index])->Structure);
  //printf("Board_Hash is  At %p\n",Board_Hash->Structure);
  return (Hash_t*)&MCHS_Handle->HashTable->Table[Index];
}

/*
void* Simulate_UTTT_MCHS(MCHS_Handle_t* MCHS_Handle,void* Board)
{
  //Free_TTT_Board(Board);
  printf("Starting simulation\n");
	if(MCHS_Handle->MCHS_Node0 == NULL)
	{
		(MCHS_Handle->MCHS_Node0) = (MCHS_Node_t*)Create_MCHS_Node_t(((GameRules_t*)MCHS_Handle->GameRules));
	}
  printf("Starting Node0 set\n");

	//CopyGame
	(MCHS_Handle->MCHS_Node0->Board) = (UTTT_t*)Board; //MCHS_Handle->GameRules->InitializeWorld(NULL);
  (MCHS_Handle->MCHS_Node0->NodeVisits) = 1;
  MCHS_Handle->TransversedNode = MCHS_Handle->MCHS_Node0;
  //Display_UTTT_Game((UTTT_t*)Board);
  //Display_UTTT_Game((UTTT_t*)(MCHS_Handle->MCHS_Node0->Board));

  printf("Creating Depth 1 DLL Node set\n");
  Set_UTTT_MCHS_Node_DLL(MCHS_Handle_t* MCHS_Handle,MCHS_Node_t* MCHS_Node)(MCHS_Handle);
  MCHS_Handle->NodesSearched = 0;

  printf("starting While Loop for Iterative Search\n");
	while(MCHS_Handle->NodesSearched < MCHS_Handle->SearchDepth)
	{

	 MCHS_Handle->TransversedNode = MCHS_Handle->MCHS_Node0;
	 Transverse_UTTT_MCHS(MCHS_Handle,1);
   /*
   if((int)(MCHS_Handle->NodesSearched % 10000))
   {
     printf("<--------------------------->\n");
     printf("Value  :%f\n", MCHS_Handle->MCHS_Node0->AverageValue);
     printf("Visits :%d\n", MCHS_Handle->MCHS_Node0->NodeVisits);
     printf("<--------------------------->\n");
   }
  *//*
  //printf("%d\n",MCHS_Handle->NodesSearched );
	 MCHS_Handle->NodesSearched++;
 	}

  //printf("BestMove ~?~ \n");
  MCHS_Handle->TransversedNode = MCHS_Handle->MCHS_Node0;
  Print_UTTT_MCHS_UCB1(MCHS_Handle->MCHS_Node0,1);
  //Select_MCHS_TTT_NodeFromDLL_UCB1(&MCHS_Handle->TransversedNode);
  Select_MCHS_UTTT_NodeFromDLL_UCB1(&MCHS_Handle->TransversedNode);
  Print_UTTT_MCHS_Node(MCHS_Handle->TransversedNode,MCHS_Handle->MCHS_Node0->NodeVisits);



  return (UTTT_t*) MCHS_Handle->TransversedNode->Board;
  //Free_MCHS_Node(MCHS_Handle->MCHS_Node0);
	//Select Best Move from Select_MCHS_NodeFromDLL_UCB1() all the way down the Search Tree
	//either Return or Display Move

  return Board;
}
*/
//Print_TTT_MCTS_Node
//Simulate_UTTT_MCHS_Search
void* Simulate_UTTT_MCHS_Search(MCHS_Handle_t* MCHS_Handle,void* Board)
{
  //Find Board Hash value
  Hash_t* Board_Hash = GetSet_UTTT_MCHS_Position(MCHS_Handle,(UTTT_t*)Board);
  printf("GetSet_TTT_MCHS_Position complete\n" );
  printf("Board_Hash is  At %p\n",Board_Hash);
  printf("Board_Hash->Structure is  At %p\n",Board_Hash->Structure);
  printf("Comparison  done\n" );
  MCHS_Handle->TransversedNode = (MCHS_Node_t*)Board_Hash->Structure;
  printf("setting  Set_TTT_MCHS_Node_DLL\n");
  Set_UTTT_MCHS_Node_DLL(MCHS_Handle,MCHS_Handle->TransversedNode);
  printf("Get Set MCHS DLL\n");

  //Prep for new Search
  //Select it as Node0
  MCHS_Handle->MCHS_Node0      = (MCHS_Node_t*)Board_Hash->Structure;
  MCHS_Handle->TransversedNode = (MCHS_Node_t*)Board_Hash->Structure;
  printf("Found/Created the Node0 in hash structure to search \n");

  UTTT_t* NewUTTT_Game = (UTTT_t*) MCHS_Handle->GameRules->CopyGame(Board);


  int Hash = 0;
  for (int Game=0; Game<8;Game++)
  {
    Hash += (Game+1)*Get_PJWHash_2D_CMatrix_t(NewUTTT_Game->TTTGame_Matrix[Game].BoardRep);
  }


  int Index = GetIndex_HashTable(MCHS_Handle->HashTable,Hash);
  if(Index==-1)
  {
    MCHS_Node_t* MCHS_Node = Create_MCHS_Node_t(MCHS_Handle->GameRules);
    MCHS_Node->Board = NewUTTT_Game;
    //GetSet_UTTT_MCHS_Position(MCHS_Handle,NewUTTT_Game);//Create List of child nodes
    //CreateMCTS_TTT_Node_DLL
    Push_HashTable(MCHS_Handle->HashTable,(void*)MCHS_Node,Hash);
  }
  //set Visits to 1
  //(MCHS_Handle->MCTS_Node0->NodeVisits) = 1;

  //MCHS_Handle->NodesSearched = 0;
  //CopyGame



  printf("Preforming Depth Iterations \n");
	while(MCHS_Handle->NodesSearched < MCHS_Handle->SearchDepth)
	{

	 MCHS_Handle->TransversedNode = MCHS_Handle->MCHS_Node0;
	 Transverse_UTTT_MCHS(MCHS_Handle,1);//Transverse_TTT_MCTS
   printf("NodesSearched :%d\n", MCHS_Handle->NodesSearched);

   //printf("Value  :%f\n", MCHS_Handle->MCHS_Node0->AverageValue);
   //printf("Visits :%d\n", MCHS_Handle->MCHS_Node0->NodeVisits);
   //printf("<--------------------------->\n");
	 MCHS_Handle->NodesSearched++;
 	}

  //printf("BestMove ~?~ \n");
  MCHS_Handle->TransversedNode = MCHS_Handle->MCHS_Node0;
  //TODO Print_TTT_MCHS_UCB1(MCHS_Handle->MCHS_Node0,1);


  Select_MCHS_TTT_NodeFromDLL_UCB1(&MCHS_Handle->TransversedNode);
  //Select_MCHS_TTT_NodeFromDLL_ByValue(&MCHS_Handle->TransversedNode);

  //Print_TTT_MCHS_Node(MCHS_Handle->MCHS_Node0,MCHS_Handle->MCHS_Node0->NodeVisits);
  //Print_TTT_MCHS_Handle(MCHS_Handle->MCHS_Node0,MCHS_Handle->MCHS_Node0->NodeVisits);
     printf("Display_TTT_Game \n");
   Display_TTT_Game((TTT_t*)MCHS_Handle->TransversedNode->Board);
   printf("Display_TTT_Game \n");
  return (TTT_t*) MCHS_Handle->TransversedNode->Board;
  //Free_MCTS_Node(MCHS_Handle->MCHS_Node0);
	//Select Best Move from Select_MCTS_NodeFromDLL_UCB1() all the way down the Search Tree
	//either Return or Display Move
}


void Free_UTTT_MCHS_Handle(MCHS_Handle_t* MCHS_Handle)
{
	//TODO Free_MCHS_Node_t(MCHS_Handle->MCHS_Node0);
	free(MCHS_Handle->GameRules);
	free(MCHS_Handle);
}

void UTTT_MCHS_T(int Depth,int Game)
{
  printf("MCHS Tests \n");
  printf("Testing with TTT... \n");
  //Create MCHS and Set for TTT
  MCHS_Handle_t* MCHS_Handle = Create_MCHS_Handle_t(Depth,Depth*1.25,Get_UTTT_GRules);
  //Simulate Game
  //Game
  printf("Simulating Game \n");
  UTTT_t* UTTT = (UTTT_t*)Create_UTTT_Board(NULL);
  UTTT->Game = Game;
  UTTT_t* Move = (UTTT_t*)Simulate_UTTT_MCHS_Search(MCHS_Handle,(void*)UTTT);
  Display_UTTT_Game(Move);

  printf("Free Board\n");
  //Free_UTTT_Board(Move);
  printf("Freeing MCHS \n");
  Free_UTTT_MCHS_Handle(MCHS_Handle);
}
//Simulate_UTTT_MCHS_Search
//Player vs Computer
//Monte Carlo Tree Search Neural Neural Network
//Ultimate TickTackToe Test
void PvC_MCHS_NN_UTTT_T(int Depth)
{
  //TODO:integrate with MCHS Handle'

  UTTT_t* UTTT = (UTTT_t*)Create_UTTT_Board(NULL);
  printf("Welcome to UTTT MCHS_NN\n");
  printf("======================\n");
  int Player = 0;
  int Move = -1;
  bool ActiveGame = true;
  while(ActiveGame)
  {
    if(Player == 0)
    {
      printf("Player's 0 Turn ! Please Go ! \n");
      //Project Move
      MCHS_Handle_t* MCHS_Handle = Create_MCHS_Handle_t(Depth,Depth*1.25,Get_UTTT_GRules);
      MCHS_Handle->Player = 0;
      UTTT_t* Move = (UTTT_t*)Simulate_UTTT_MCHS_Search(MCHS_Handle,(void*)UTTT);
      //Free_TTT_Board(TTT);
      Print_UTTT_MCHS_UCB1(MCHS_Handle->MCHS_Node0,1);

      UTTT = (UTTT_t*) Copy_UTTT_Game(Move);
      Free_UTTT_MCHS_Handle(MCHS_Handle);

      printf("Move Made! Player 1's Turn \n");
      Player = 1;
      Display_UTTT_Game(UTTT);

      if(Winner_UTTT(UTTT))
      {
        Player = -1;
        ActiveGame = false;
      }
    }

    if(Player == 1)
    {
      printf("Player's 1 Turn ! Please Go ! \n");
      GatherTerminalInt("Select Move:",&Move);
      if ((int*)PlayerMove_UTTT((void*) UTTT,(void*) &Move))
      {
        printf("Move Made! Player 0's Turn \n");
        Player = 0;
        Display_UTTT_Game(UTTT);
      }
      else
      {
        printf("Invalid Move Please Go again\n");
      }
      if(Winner_UTTT(UTTT))
      {
        Player = -1;
        ActiveGame = false;
      }

    }
  }
  printf("Winner declared !Player: %c Won!\n",UTTT->Winner);
  Free_UTTT_Board(UTTT);
}

//Player vs Computer
//Monte Carlo Tree Search Generic
//Ultimate TickTackToe Test
//Computer Goes First
void PvC_MCHS_G_UTTT_T0(int Depth)
{
  //TODO:integrate with MCHS Handle'
  MCHS_Handle_t* MCHS_Handle = Create_MCHS_Handle_t(Depth,Depth*1.25,Get_UTTT_GRules);

  UTTT_t* UTTT = (UTTT_t*)Create_UTTT_Board(NULL);
  UTTT->Game = 0;
  printf("Welcome to UTTT_Generic T0\n");

  printf("(Player0 - MCHS_Generic)\n");
  printf("(Player1 - Person)\n");
  printf("=======================\n");
  int Player = 0;
  int Move = -1;
  bool ActiveGame = true;
  while(ActiveGame)
  {
    if(Player == 0)
    {
      printf("Player's 0 Turn ! Please Go ! \n");
      //Project Move

      MCHS_Handle->Player = 0;
      UTTT_t* Move = (UTTT_t*) Simulate_UTTT_MCHS_Search(MCHS_Handle,(void*)UTTT);
      //Free_TTT_Board(TTT);
      Print_UTTT_MCHS_UCB1(MCHS_Handle->MCHS_Node0,1);

      UTTT = (UTTT_t*) Copy_UTTT_Game(Move);
      Free_UTTT_MCHS_Handle(MCHS_Handle);

      printf("Move Made! Player 1's Turn \n");
      Player = 1;
      Display_UTTT_Game(UTTT);

      if(Winner_UTTT(UTTT))
      {
        Player = -1;
        ActiveGame = false;
      }
    }

    if(Player == 1)
    {
      printf("Player's 1 Turn ! Please Go ! \n");
      GatherTerminalInt("Select Move:",&Move);
      if ((int*)PlayerMove_UTTT((void*) UTTT,(void*) &Move))
      {
        printf("Move Made! Player 0's Turn \n");
        Player = 0;
        Display_UTTT_Game(UTTT);
      }
      else
      {
        printf("Invalid Move Please Go again\n");
      }
      if(Winner_UTTT(UTTT))
      {
        Player = -1;
        ActiveGame = false;
      }

    }
  }
  printf("Winner declared !Player: %c Won!\n",UTTT->Winner);
  Free_UTTT_Board(UTTT);
}

//Player vs Computer
//Monte Carlo Tree Search Generic
//Ultimate TickTackToe Test
//Person Goes First
void PvC_MCHS_G_UTTT_T1(int Depth)
{
  //TODO:integrate with MCHS Handle'


  UTTT_t* UTTT = (UTTT_t*)Create_UTTT_Board(NULL);
  printf("Welcome to UTTT_Generic T1,\n");
  printf("(Player0 - Person)\n");
  printf("(Player1 - MCHS_Generic)\n");
  printf("=======================\n");
  int Player = 0;
  int Move = -1;
  bool ActiveGame = true;
  while(ActiveGame)
  {
    if(Player == 0)
    {
      printf("Player's 0 Turn ! Please Go ! \n");
      GatherTerminalInt("Select Move:",&Move);
      if ((int*)PlayerMove_UTTT((void*) UTTT,(void*) &Move))
      {
        Player = 1;
        Display_UTTT_Game(UTTT);
      }
      else
      {
        printf("Invalid Move Please Go again\n");
      }
      if(Winner_UTTT(UTTT))
      {
        Player = -1;
        ActiveGame = false;
      }
    }
    if(Player == 1)
    {
      printf("Player's 1 Turn ! Please Go ! \n");
      //Project Move
      MCHS_Handle_t* MCHS_Handle = Create_MCHS_Handle_t(Depth,Depth*1.25,Get_UTTT_GRules);
      MCHS_Handle->Player = 1;

      printf("Simulating MCHS_UTTT\n");
      UTTT_t* Move = (UTTT_t*) Simulate_UTTT_MCHS_Search(MCHS_Handle,(void*)UTTT);

      //Free_TTT_Board(TTT);
      printf("Printing Chosen Move MCHS_UTTT\n");
      Print_UTTT_MCHS_UCB1(MCHS_Handle->MCHS_Node0,1);

      UTTT = (UTTT_t*) Copy_UTTT_Game(Move);
      Free_UTTT_MCHS_Handle(MCHS_Handle);

      Player = 0;
      Display_UTTT_Game(UTTT);

      if(Winner_UTTT(UTTT))
      {
        Player = -1;
        ActiveGame = false;
      }
    }
  }
  printf("Winner declared !Player: %c Won!\n",UTTT->Winner);
  Free_UTTT_Board(UTTT);
}

void CvC_MCHS_G_UTTT(int Depth,int Game,int HandyCap)
{
  //TODO:integrate with MCHS Handle'


  UTTT_t* UTTT = (UTTT_t*)Create_UTTT_Board(NULL);
  UTTT->Game = Game;
  printf("Welcome to UTTT_Generic T1,\n");
  printf("(Player0 - Person)\n");
  printf("(Player1 - MCHS_Generic)\n");
  printf("=======================\n");
  int Player = 0;
  bool ActiveGame = true;
  while(ActiveGame)
  {
    if(Player == 0 && !Winner_UTTT(UTTT))
    {
      printf("Player's 0 Turn ! Please Go ! \n");
      //Project Move
      MCHS_Handle_t* MCHS_Handle = Create_MCHS_Handle_t(Depth,Depth*1.25,Get_UTTT_GRules);
      MCHS_Handle->Player = 0;
      printf("Simulating MCHS_UTTT\n");

      UTTT_t* Move = (UTTT_t*) Simulate_UTTT_MCHS_Search(MCHS_Handle,(void*)UTTT);
      //Free_TTT_Board(TTT);
      printf("Printing Chosen Move MCHS_UTTT\n");
      Print_UTTT_MCHS_UCB1(MCHS_Handle->MCHS_Node0,1);

      UTTT = (UTTT_t*) Copy_UTTT_Game(Move);
      Free_UTTT_MCHS_Handle(MCHS_Handle);

      Player = 1;
      Display_UTTT_Game(UTTT);

      if(Winner_UTTT(UTTT))
      {
        Player = -1;
        ActiveGame = false;
      }
    }
    if(Player == 1 && !Winner_UTTT(UTTT))
    {
      printf("Player's 1 Turn ! Please Go ! \n");
      //Project Move
      MCHS_Handle_t* MCHS_Handle = Create_MCHS_Handle_t(Depth*HandyCap,Depth*HandyCap*1.25,Get_UTTT_GRules);
      MCHS_Handle->Player = 1;
      printf("Simulating MCHS_UTTT\n");

      UTTT_t* Move = (UTTT_t*) Simulate_UTTT_MCHS_Search(MCHS_Handle,(void*)UTTT);
      //Free_TTT_Board(TTT);
      printf("Printing Chosen Move MCHS_UTTT\n");
      Print_UTTT_MCHS_UCB1(MCHS_Handle->MCHS_Node0,1);

      UTTT = (UTTT_t*) Copy_UTTT_Game(Move);
      Free_UTTT_MCHS_Handle(MCHS_Handle);

      Player = 0;
      Display_UTTT_Game(UTTT);

      if(Winner_UTTT(UTTT))
      {
        Player = -1;
        ActiveGame = false;
      }
    }
  }
  printf("Winner declared !Player: %c Won!\n",UTTT->Winner);
  Free_UTTT_Board(UTTT);
}

//Tick TickTackToe automated Tests
void UTTT_AT()
{
  //printf("Automated TTT_AT selected\n");
  UTTT_MCHS_T(5000,0);
}
//Tick TickTackToe Terminal Tests
void CoordinateSystem_TTT_TT()
{
  int Move = 0;
  GatherTerminalInt("Select Move:",&Move);
  PrintInt(Move)
  UTTT_t* Game = (UTTT_t*)Create_UTTT_Board(NULL);
  PlayerMove_UTTT(Game,(void*)&Move);
  Display_UTTT_Game(Game);
  Free_TTT_Board(Game);
}

void Play_UTTT_MCHS_T()
{
    int SelectedGame = 0;
        int HandyCap = 0;
  int SelectedTest = 0;
  int SelectedDepth = 1000;
  PrintLines(2)
  printf("0 = PvC_MCHS_G_UTTT_T0\n");
  printf("1 = PvC_MCHS_G_UTTT_T1\n");
  printf("2 = CvC_MCHS_G_UTTT Player 1(O's)\n");
  printf("3 = CvC_MCHS_G_UTTT Night Loop\n");
  printf("4 = \n");
  printf("5 = \n");
  printf("98 = \n");
  printf("99 =\n");
  GatherTerminalInt("Please Select Test Move:",&SelectedTest);
  if (SelectedTest == 0)
  {
    GatherTerminalInt("Please Select a Depth:",&SelectedDepth);
    PvC_MCHS_G_UTTT_T0(SelectedDepth);
  }
  else if (SelectedTest == 1)
  {
    GatherTerminalInt("Please Select a Depth:",&SelectedDepth);
    PvC_MCHS_G_UTTT_T1(SelectedDepth);
  }
  else if (SelectedTest == 2)
  {
    GatherTerminalInt("Please Select Search Starting Game:",&SelectedGame);
    GatherTerminalInt("Please Select a Depth:",&SelectedDepth);
    GatherTerminalInt("Please Select The HandyCap for Player 2:",&HandyCap);
    CvC_MCHS_G_UTTT(SelectedDepth,SelectedGame,HandyCap);
  }
  else if (SelectedTest == 3)
  {
    for(int x= 0;x<100;x++)
    {
        CvC_MCHS_G_UTTT(x,x%3,1);
    }
  }
  else if (SelectedTest == 4)
  {

  }
  else if (SelectedTest == 5)
  {
    printf("\n");
  }
  else if (SelectedTest == 98)
  {
    TwoPlayer_UTTT_T();
  }
  else if (SelectedTest == 99)
  {

  }

}


#endif // UTickTackToe_MCHS_C
