#ifndef UTickTackToe_MCTS_C
#define UTickTackToe_MCTS_C

//Header Files
#include "UTickTackToe_MCTS.h"
//Forward declaration





void Set_MCTS_UTTT(MCTS_Handle_t* MCTS_Handle)
{
  MCTS_Handle->GameRules = (GameRules_t*)Get_UTTT_GRules(NULL);
}




float UTTT_MCTS_Rollout(MCTS_Handle_t* MCTS_Handle)
{
	//float BP_Value = 0;
	//Game Over?
	if (MCTS_Handle->GameRules->Winner(MCTS_Handle->RollOutGame))
	{
		//Check Who Is Winner
		//Return 1 if won, 0 if loss
    if(MCTS_Handle->Player == 0 )
    {
      if (((UTTT_t*)MCTS_Handle->RollOutGame)->Winner == 'X')
      {
        return 1;
      }
      else if(((UTTT_t*)MCTS_Handle->RollOutGame)->Winner == 'O')
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
      if (((UTTT_t*)MCTS_Handle->RollOutGame)->Winner == 'O')
      {
        return 1;
      }
      else if(((UTTT_t*)MCTS_Handle->RollOutGame)->Winner == 'X')
      {
        return -1;
      }
      else
      {
        return 0;
      }
    }


	}

  IMatrix_t* PosibleMoves = (IMatrix_t*)MCTS_Handle->GameRules->Player0_Moves((void*)MCTS_Handle->RollOutGame);
  int Move = RandomSelect_IMatrixIndex(PosibleMoves);
  Free_IMatrix((IMatrix_t*)PosibleMoves);

  //PrintInt(Move);
  if (Move == -1)
  {
    // Go to next Open Game~ should change to DLL and Pass all posibilites to NN ~ MCTS Might Be hard...
    ((UTTT_t*)MCTS_Handle->RollOutGame)->Game++;
    if(((UTTT_t*)MCTS_Handle->RollOutGame)->Game == 9)
    {
      ((UTTT_t*)MCTS_Handle->RollOutGame)->Game = 0;
      //Display_UTTT_Game((UTTT_t*)MCTS_Handle->RollOutGame);
    }

    //BreakDef
    //InBreak
    //PrintInt(((UTTT_t*)MCTS_Handle->RollOutGame)->Game)
    return UTTT_MCTS_Rollout(MCTS_Handle);
  }

  Move += ((UTTT_t*)MCTS_Handle->RollOutGame)->Game*9;
  //PrintInt(Move);
  MCTS_GameRules->PlayerMove((UTTT_t*)MCTS_Handle->RollOutGame,(void*)&Move);
  //Display_UTTT_Game((UTTT_t*)MCTS_Handle->RollOutGame);
  //Display_TTT_Game((TTT_t*)MCTS_Handle->RollOutGame);

//else make random move, and rollout
	return UTTT_MCTS_Rollout(MCTS_Handle);
}


void Select_MCTS_UTTT_NodeFromDLL_ByValue(MCTS_Node_t** MCTS_Node)
{
	//printf("in  Select_MCTS_NodeFromDLL_UCB1\n");
	MCTS_Node_t* HighestNode = NULL;
	DLL_Handle_t* MCTS_DLL = (*MCTS_Node)->ChildNodes;
	if(MCTS_DLL->ListLength > 0)
	{
		//printf("Morethan one Element\n");

		float HighestValue = 0;
		float FoundValue = (INT_MIN);
		DLL_Node_t* Node = (DLL_Node_t*)MCTS_DLL->First;
		HighestNode = (MCTS_Node_t*)Node->Given_Struct;

		while(Node->Next != NULL)
		{
			FoundValue = ((MCTS_Node_t*)Node->Given_Struct)->Value;
			if(FoundValue > HighestValue)
			{
        //printf("~%d\n",FoundValue);
				HighestNode = (MCTS_Node_t*)Node->Given_Struct;
        HighestValue = FoundValue;
			}
			Node = (DLL_Node_t*)Node->Next;
		}
		FoundValue = ((MCTS_Node_t*)Node->Given_Struct)->Value;

    if(FoundValue > HighestValue)
		{
      //printf("~%d\n",FoundValue);
			HighestNode = (MCTS_Node_t*)Node->Given_Struct;
      HighestValue = FoundValue;
		}
	}
  //printf("ParentNode\n");
    //Display_TTT_Game((TTT_t*)*MCTS_Node);
  //  printf("Child\n");
  //    Display_TTT_Game((TTT_t*)HighestNode);
	if(HighestNode != NULL)
	{
		(*MCTS_Node)->LeafNode = false;
		*MCTS_Node = HighestNode;
	}
  //printf("NewParent\n");
  //  Display_TTT_Game((TTT_t*)*MCTS_Node);
}

void Select_MCTS_UTTT_NodeFromDLL_ByAverage(MCTS_Node_t** MCTS_Node)
{
	//printf("in  Select_MCTS_NodeFromDLL_UCB1\n");
	MCTS_Node_t* HighestNode = NULL;
	DLL_Handle_t* MCTS_DLL = (*MCTS_Node)->ChildNodes;
	if(MCTS_DLL->ListLength > 0)
	{
		//printf("Morethan one Element\n");

		float HighestValue = 0;
		float FoundValue = (INT_MIN);
		DLL_Node_t* Node = (DLL_Node_t*)MCTS_DLL->First;
		HighestNode = (MCTS_Node_t*)Node->Given_Struct;

		while(Node->Next != NULL)
		{
			FoundValue = ((MCTS_Node_t*)Node->Given_Struct)->AverageValue;
			if(FoundValue > HighestValue)
			{
        //printf("~%d\n",FoundValue);
				HighestNode = (MCTS_Node_t*)Node->Given_Struct;
        HighestValue = FoundValue;
			}
			Node = (DLL_Node_t*)Node->Next;
		}
		FoundValue = ((MCTS_Node_t*)Node->Given_Struct)->AverageValue;

    if(FoundValue > HighestValue)
		{
      //printf("~%d\n",FoundValue);
			HighestNode = (MCTS_Node_t*)Node->Given_Struct;
      HighestValue = FoundValue;
		}
	}
  //printf("ParentNode\n");
    //Display_TTT_Game((TTT_t*)*MCTS_Node);
  //  printf("Child\n");
  //    Display_TTT_Game((TTT_t*)HighestNode);
	if(HighestNode != NULL)
	{
		(*MCTS_Node)->LeafNode = false;
		*MCTS_Node = HighestNode;
	}
  //printf("NewParent\n");
  //  Display_TTT_Game((TTT_t*)*MCTS_Node);
}

void Select_MCTS_UTTT_NodeFromDLL_UCB1(MCTS_Node_t** MCTS_Node)
{

	//printf("in  Select_MCTS_NodeFromDLL_UCB1\n");

  if(MCTS_Node != NULL)
  {
    MCTS_Node_t* HighestNode = NULL;
    DLL_Handle_t* MCTS_DLL = (*MCTS_Node)->ChildNodes;
    if(MCTS_DLL->ListLength > 0)
    {
      //printf("transfersing DLL\n");

      float HighestValue = INT_MIN;
      float FoundValue = (0);
      DLL_Node_t* Node = (DLL_Node_t*)MCTS_DLL->First;
      HighestNode = (MCTS_Node_t*)Node->Given_Struct;

      while(Node->Next != NULL)
      {
        FoundValue = Find_MCTS_UCB1((MCTS_Node_t*)Node->Given_Struct, (*MCTS_Node)->NodeVisits);
        if(FoundValue > HighestValue)
        {
          //printf("~%f\n",FoundValue);
          HighestNode = (MCTS_Node_t*)Node->Given_Struct;
          HighestValue = FoundValue;
        }
        Node = (DLL_Node_t*)Node->Next;

      }
      FoundValue = Find_MCTS_UCB1((MCTS_Node_t*)Node->Given_Struct, (*MCTS_Node)->NodeVisits);

      if(FoundValue > HighestValue)
      {
        //printf("~%f\n",FoundValue);
        //      printf("----------------\n");
        HighestNode = (MCTS_Node_t*)Node->Given_Struct;
        HighestValue = FoundValue;
      }
    }
    //printf("ParentNode\n");
      //Display_TTT_Game((TTT_t*)*MCTS_Node);
    //  printf("Child\n");
    //    Display_TTT_Game((TTT_t*)HighestNode);
    if(HighestNode != NULL)
    {
      (*MCTS_Node)->LeafNode = false;
      *MCTS_Node = HighestNode;
    }
  }


  //printf("Leaving SelectMCTS_UTTT\n");
  //  Display_TTT_Game((TTT_t*)*MCTS_Node);
}



//Create_MCTS_Node

void CreateMCTS_UTTT_Node_DLL(MCTS_Handle_t* MCTS_Handle)
{
	//printf("in CreateMCTSNode_DLL\n");
  MCTS_Handle->PosibleMoves = (IMatrix_t*)(MCTS_Handle->GameRules->Player0_Moves(MCTS_Handle->TransversedNode->Board));
	//IMatrix_t* IMatrix = MCTS_Handle->PosibleMoves;
	//printf("gatheredPosible Moves Matrix\n");
	//PrintIntegerMatrix(MCTS_Handle->PosibleMoves);
	RunTimeFunction CopyGame = MCTS_Handle->GameRules->CopyGame;
	DLL_Handle_t* DLL_Handle = MCTS_Handle->TransversedNode->ChildNodes;
	//printf("about to Add DLL_Nodes\n");
	//Go Through Each Node, for each 1, Create/CopyGame and add to Handle (Could Also Create Matrix Version)

  _2D_MatrixLoop(MCTS_Handle->PosibleMoves,
    if (_2D_FL_Matrix_Element(MCTS_Handle->PosibleMoves) == 1)
    {
      //printf("Accpeptable Move Found\n");
      //printf("(%d,%d)",i,j);
      //PrintInt(_2D_FL_Matrix_Element(MCTS_Handle->PosibleMoves));
      //printf("ParentNode Depth:%d\n",MCTS_Handle->TransversedNode->Depth);
      DLL_Node_t* NewNode = Create_DLL_Node_WithStruct(Create_MCTS_Node(MCTS_GameRules,MCTS_Handle->TransversedNode->Depth+1));
      ((MCTS_Node_t*)NewNode->Given_Struct)->Board = (void*)CopyGame(MCTS_Handle->TransversedNode->Board);


      if ( ((MCTS_Node_t*)NewNode->Given_Struct)->Player == 0 )
      {
        ((MCTS_Node_t*)NewNode->Given_Struct)->Player = 1;
      }
      else
      {
        ((MCTS_Node_t*)NewNode->Given_Struct)->Player = 0;
      }

      int Move = (i*3 + j)+((UTTT_t*)MCTS_Handle->TransversedNode->Board)->Game*9;
      //printf("in Game# :%d\n",((UTTT_t*)MCTS_Handle->TransversedNode->Board)->Game*9);
      //printf("Creating Node with Move :%d\n",Move);
      //MCTS_GameRules->Player0((TTT_t*)((MCTS_Node_t*)NewNode->Given_Struct)->Board,(void*)&Move);
      PlayerMove_UTTT((void*)((MCTS_Node_t*)NewNode->Given_Struct)->Board,(void*)&Move);
      //Display_UTTT_Game((UTTT_t*)((MCTS_Node_t*)NewNode->Given_Struct)->Board);
      //printf("UTTT Copy with move\n");
      //Display_UTTT_Game((UTTT_t*)((MCTS_Node_t*)NewNode->Given_Struct)->Board);
      //printf("displayed game , adding node to handle\n");
      //printf("Adding Node To List \n");
      Add_Node_To_Handle(NewNode,DLL_Handle);
      MCTS_Handle->TransversedNode->LeafNode = false;
    }

  )

  FreeMatrix(MCTS_Handle->PosibleMoves);
	//printf("%d - DLLLenght\n", DLL_Handle->ListLength);

	MCTS_Handle->TransversedNode->ChildNodes = DLL_Handle;
	//printf("%d - DLLLenght\n", MCTS_Handle->TransversedNode->ChildNodes->ListLength);
  //printf("About to leave UTTT DLL node creation To List \n");


}

float Transverse_UTTT_MCTS(MCTS_Handle_t* MCTS_Handle,int FromBranch)
{
  //printf("Transverse_UTTT_MCTS\n");
		float BP_Value = 0;
		MCTS_Node_t* Local_MCTS_Node = MCTS_Handle->TransversedNode;
    if (Local_MCTS_Node->End == 1)
    {
      //Local_MCTS_Node->Value += Local_MCTS_Node->EndValue;
      //Local_MCTS_Node->NodeVisits += 1;
      //Local_MCTS_Node->AverageValue = Local_MCTS_Node->Value /Local_MCTS_Node->NodeVisits;
      return Local_MCTS_Node->EndValue;
    }
		//int PlayersMove = MCTS_Handle->PlayersMove;
		//Loop for NodesToSearch
		//printf("Starting Transverse_MCTS:\n");
    //Print_TTT_MCTS_Node(Local_MCTS_Node,0);

    //Print_UTTT_MCTS_UCB1(Local_MCTS_Node,0);
    //Print_TTT_MCTS_Handle(Local_MCTS_Node->ChildNodes,0);
		if(Local_MCTS_Node->LeafNode == false)
		{
			//printf("Not a Leaf Node\n");
      //printf("Depth:%d\n",MCTS_Handle->TransversedNode->Depth);
      //printf("ListLength:%d\n",MCTS_Handle->TransversedNode->ChildNodes->ListLength);
      //printf("End?:%d\n",MCTS_Handle->TransversedNode->End);
			//if not find UCB1's Best Move
      //Print_UTTT_MCTS_Node(MCTS_Handle->TransversedNode,1);
      Select_MCTS_UTTT_NodeFromDLL_UCB1(&MCTS_Handle->TransversedNode);
      BP_Value = Transverse_UTTT_MCTS(MCTS_Handle,1);


      //printf("\tTransversed TTT BP_Value:%f\n",BP_Value);

			//assign Value, add and return
		}
		else if(Local_MCTS_Node->NodeVisits == 0)
		{
      //printf("Testing if Board won..\n");
      if(MCTS_Handle->GameRules->Winner(MCTS_Handle->TransversedNode->Board))
      {
        //printf("Found Winning Game \n");
        if (((UTTT_t*)MCTS_Handle->TransversedNode->Board)->Winner == 'X')
        {
          if(MCTS_Handle->Player == 0)
          {
            //printf("X was found as the Winnter\n");
            MCTS_Handle->TransversedNode->End = 1;//*MCTS_Handle->TransversedNode->Depth;
            //Local_MCTS_Node->NodeVisits++
            MCTS_Handle->TransversedNode->EndValue = 1;
            MCTS_Handle->TransversedNode->Value = INT_MAX;
            MCTS_Handle->TransversedNode->NodeVisits = 1;
            MCTS_Handle->TransversedNode->AverageValue = INT_MAX;
            return 1;//*MCTS_Handle->TransversedNode->Depth + 1;
          }
          else
          {
            //printf("O was found as the Winnter\n");
            MCTS_Handle->TransversedNode->End = 1;//
            //Local_MCTS_Node->NodeVisits++;
            MCTS_Handle->TransversedNode->EndValue = -1;
            MCTS_Handle->TransversedNode->Value = INT_MAX;
            MCTS_Handle->TransversedNode->NodeVisits = 1;
            MCTS_Handle->TransversedNode->AverageValue = INT_MAX;
            return -1;//*MCTS_Handle->TransversedNode->Depth - 1;
          }

        }
        else if(((UTTT_t*)MCTS_Handle->TransversedNode->Board)->Winner == 'O')
        {
          if(MCTS_Handle->Player == 1)
          {
            //printf("0 was found as the Winnter\n");
            MCTS_Handle->TransversedNode->End = 1;//*MCTS_Handle->TransversedNode->Depth;
            //Local_MCTS_Node->NodeVisits++
            MCTS_Handle->TransversedNode->EndValue = 1;
            MCTS_Handle->TransversedNode->Value = INT_MAX;
            MCTS_Handle->TransversedNode->NodeVisits = 1;
            MCTS_Handle->TransversedNode->AverageValue = INT_MAX;
            return 1;//*MCTS_Handle->TransversedNode->Depth + 1;
          }
          else
          {
            //printf("O was found as the Winnter\n");
            MCTS_Handle->TransversedNode->End = 1;//
            //Local_MCTS_Node->NodeVisits++;
            MCTS_Handle->TransversedNode->EndValue = -1;
            MCTS_Handle->TransversedNode->Value = INT_MAX;
            MCTS_Handle->TransversedNode->NodeVisits = 1;
            MCTS_Handle->TransversedNode->AverageValue = INT_MAX;
            return -1;//*MCTS_Handle->TransversedNode->Depth - 1;
          }

        }
        else
        {
          //printf("C was found as the Winner\n");
          MCTS_Handle->TransversedNode->End = 1;
          //Local_MCTS_Node->NodeVisits++;
          MCTS_Handle->TransversedNode->EndValue = 0;
          MCTS_Handle->TransversedNode->Value = 0;
          MCTS_Handle->TransversedNode->NodeVisits = 1;
          MCTS_Handle->TransversedNode->AverageValue = 0;
          return 0;
        }
      }
			//printf("Visits not Zero ->Rolling out\n");
      //printf("Rollout\n");

			//No-> so RollOut -> Back Propigate
     //PrintInt(Local_MCTS_Node->NodeVisits)
      MCTS_Handle->RollOutGame = Copy_UTTT_Game(MCTS_Handle->TransversedNode->Board);

      //Display_TTT_Game((TTT_t*)MCTS_Handle->RollOutGame);
			BP_Value = UTTT_MCTS_Rollout(MCTS_Handle);
      //BP_Value += Local_MCTS_Node->Depth*BP_Value;
      //BP_Value *= MCTS_Handle->TransversedNode->Depth;
      //printf("\t\tRollout Value:%f\n",BP_Value);
      Free_UTTT_Board(MCTS_Handle->RollOutGame);
		}
		else
		{

      //printf("Local_MCTS_Node->NodeVisits:%d,\n",Local_MCTS_Node->NodeVisits);
      //printf("\n");
      IMatrix_t* PosibleMoves = (IMatrix_t*)MCTS_Handle->GameRules->Player0_Moves((void*)MCTS_Handle->TransversedNode->Board);
      int Move = GetSum_IMatrix(PosibleMoves);
      Free_IMatrix((IMatrix_t*)PosibleMoves);


      if(Move == 0)
      {
        if(MCTS_Handle->GameRules->Winner(MCTS_Handle->TransversedNode->Board))
        {
          //printf("Found Winning Game \n");
          if (((UTTT_t*)MCTS_Handle->TransversedNode->Board)->Winner == 'X')
          {
            if(MCTS_Handle->Player == 0)
            {
              //printf("X was found as the Winnter\n");
              MCTS_Handle->TransversedNode->End = 1;//*MCTS_Handle->TransversedNode->Depth;
              //Local_MCTS_Node->NodeVisits++
              MCTS_Handle->TransversedNode->EndValue = 1;
              MCTS_Handle->TransversedNode->Value = INT_MAX;
              MCTS_Handle->TransversedNode->NodeVisits = 1;
              MCTS_Handle->TransversedNode->AverageValue = INT_MAX;
              return 1;//*MCTS_Handle->TransversedNode->Depth + 1;
            }
            else
            {
              //printf("O was found as the Winnter\n");
              MCTS_Handle->TransversedNode->End = 1;//
              //Local_MCTS_Node->NodeVisits++;
              MCTS_Handle->TransversedNode->EndValue = -1;
              MCTS_Handle->TransversedNode->Value = INT_MAX;
              MCTS_Handle->TransversedNode->NodeVisits = 1;
              MCTS_Handle->TransversedNode->AverageValue = INT_MAX;
              return -1;//*MCTS_Handle->TransversedNode->Depth - 1;
            }

          }
          else if(((UTTT_t*)MCTS_Handle->TransversedNode->Board)->Winner == 'O')
          {
            if(MCTS_Handle->Player == 1)
            {
              //printf("0 was found as the Winnter\n");
              MCTS_Handle->TransversedNode->End = 1;//*MCTS_Handle->TransversedNode->Depth;
              //Local_MCTS_Node->NodeVisits++
              MCTS_Handle->TransversedNode->EndValue = 1;
              MCTS_Handle->TransversedNode->Value = INT_MAX;
              MCTS_Handle->TransversedNode->NodeVisits = 1;
              MCTS_Handle->TransversedNode->AverageValue = INT_MAX;
              return 1;//*MCTS_Handle->TransversedNode->Depth + 1;
            }
            else
            {
              //printf("O was found as the Winnter\n");
              MCTS_Handle->TransversedNode->End = 1;//
              //Local_MCTS_Node->NodeVisits++;
              MCTS_Handle->TransversedNode->EndValue = -1;
              MCTS_Handle->TransversedNode->Value = INT_MAX;
              MCTS_Handle->TransversedNode->NodeVisits = 1;
              MCTS_Handle->TransversedNode->AverageValue = INT_MAX;
              return -1;//*MCTS_Handle->TransversedNode->Depth - 1;
            }

          }
          else
          {
            //printf("C was found as the Winner\n");
            MCTS_Handle->TransversedNode->End = 1;
            //Local_MCTS_Node->NodeVisits++;
            MCTS_Handle->TransversedNode->EndValue = 0;
            MCTS_Handle->TransversedNode->Value = 0;
            MCTS_Handle->TransversedNode->NodeVisits = 1;
            MCTS_Handle->TransversedNode->AverageValue = 0;
            return 0;
          }
        }


        // Go to next Open Game~ should change to DLL and Pass all posibilites to NN ~ MCTS Might Be hard...
        ((UTTT_t*)MCTS_Handle->TransversedNode->Board)->Game++;
        if(((UTTT_t*)MCTS_Handle->TransversedNode->Board)->Game == 9)
        {
          ((UTTT_t*)MCTS_Handle->TransversedNode->Board)->Game = 0;
          //Display_UTTT_Game((UTTT_t*)MCTS_Handle->RollOutGame);
        }

        //BreakDef
        //InBreak
        //PrintInt(((UTTT_t*)MCTS_Handle->RollOutGame)->Game)
        return Transverse_UTTT_MCTS(MCTS_Handle,1);

      }
      else
      {
        CreateMCTS_UTTT_Node_DLL(MCTS_Handle);
        //printf("SEcondStop\n");
        if(MCTS_Handle->TransversedNode->ChildNodes->ListLength != 0)
        {
          Select_MCTS_UTTT_NodeFromDLL_UCB1(&MCTS_Handle->TransversedNode);
          BP_Value = Transverse_UTTT_MCTS(MCTS_Handle,1);
        }
      }


		}


	//save best move

	//reset Nodes Created
  //printf("BP_Value %f\n", BP_Value);
  if(((UTTT_t*)Local_MCTS_Node->Board)->Player == 1)
  {
    //BP_Value *= -1;
  }

	Local_MCTS_Node->Value += BP_Value;

  Local_MCTS_Node->NodeVisits++;
  Local_MCTS_Node->AverageValue = Local_MCTS_Node->Value/Local_MCTS_Node->NodeVisits;


  //Print_TTT_MCTS_Node(Local_MCTS_Node);
	return BP_Value ;
}


void Print_UTTT_MCTS_Node(MCTS_Node_t* MCTS_Node,int ParentVisitCount)
{
  printf("---------------------------------------\n");
  printf("MCTS Node: %p\n",MCTS_Node);
  printf("--------------------\n");
  printf("Visits: %d\n",MCTS_Node->NodeVisits);
  printf("AverageValue: %f\n",MCTS_Node->AverageValue);
  printf("LeafNode: %d\n",MCTS_Node->LeafNode);
  //printf("ChildNodes: %d\n",MCTS_Node->ChildNodes->ListLength);

  //printf("Find_MCTS_UCB1: %f\n",Find_MCTS_UTTT_UCB1(MCTS_Node,ParentVisitCount));
  printf("Depth: %d\n",MCTS_Node->Depth);
  printf("--------------------\n");
  Display_UTTT_Game((UTTT_t*)MCTS_Node->Board);
  printf("^-------------------------------------^\n");
}

void Print_UTTT_MCTS_UCB1(MCTS_Node_t* MCTS_Node,int ParentVisitCount)
{
  Print_UTTT_MCTS_Node(MCTS_Node,ParentVisitCount);

  DLL_Handle_t* DLL_Handle = MCTS_Node->ChildNodes;
  printf("=====================================\n");
  printf("Child Nodes : %d\n",DLL_Handle->ListLength);
  ParentVisitCount = MCTS_Node->NodeVisits;

  DLL_Transverse(DLL_Handle,
  printf("~Node(UCB1): %f",Find_MCTS_UCB1((MCTS_Node_t*)Node->Given_Struct,ParentVisitCount));
  printf(", Average: %f",((MCTS_Node_t*)Node->Given_Struct)->AverageValue);
  printf(", Value: %f",((MCTS_Node_t*)Node->Given_Struct)->Value);
  printf(", Visits: %d\n",((MCTS_Node_t*)Node->Given_Struct)->NodeVisits);
  )
  printf("^===================================^\n");
}

void Print_UTTT_MCTS_Handle(MCTS_Node_t* MCTS_Node,int ParentVisitCount)
{
  Print_UTTT_MCTS_Node(MCTS_Node,ParentVisitCount);

  DLL_Handle_t* DLL_Handle = MCTS_Node->ChildNodes;
  printf("=====================================\n");
  printf("Child Nodes : %d\n",DLL_Handle->ListLength);
  ParentVisitCount = MCTS_Node->NodeVisits;
  DLL_Transverse(DLL_Handle,
    Print_UTTT_MCTS_Node((MCTS_Node_t*)Node->Given_Struct,ParentVisitCount);
    //Print_TTT_MCTS_Tree((MCTS_Node_t*)Node->Given_Struct,ParentVisitCount);
  )
  printf("^===================================^\n");
}

void Print_UTTT_MCTS_Tree(MCTS_Node_t* MCTS_Node,int ParentVisitCount)
{
  Print_UTTT_MCTS_Node(MCTS_Node,ParentVisitCount);

  DLL_Handle_t* DLL_Handle = MCTS_Node->ChildNodes;
  printf("=====================================\n");
  printf("Child Nodes : %d\n",DLL_Handle->ListLength);
  ParentVisitCount = MCTS_Node->NodeVisits;
  DLL_Transverse(DLL_Handle,
    Print_UTTT_MCTS_Node((MCTS_Node_t*)Node->Given_Struct,ParentVisitCount);
    //Print_TTT_MCTS_Tree((MCTS_Node_t*)Node->Given_Struct,ParentVisitCount);
  )
  printf("^===================================^\n");
}

void* Simulate_UTTT_MCTS(MCTS_Handle_t* MCTS_Handle,void* Board)
{
  //Free_TTT_Board(Board);
  printf("Starting simulation\n");
	if(MCTS_Handle->MCTS_Node0 == NULL)
	{
		(MCTS_Handle->MCTS_Node0) = (MCTS_Node_t*)Create_MCTS_Node(MCTS_GameRules,0);
	}
  printf("Starting Node0 set\n");

	//CopyGame
	(MCTS_Handle->MCTS_Node0->Board) = (UTTT_t*)Board; //MCTS_Handle->GameRules->InitializeWorld(NULL);
  (MCTS_Handle->MCTS_Node0->NodeVisits) = 1;
  MCTS_Handle->TransversedNode = MCTS_Handle->MCTS_Node0;
  //Display_UTTT_Game((UTTT_t*)Board);
  //Display_UTTT_Game((UTTT_t*)(MCTS_Handle->MCTS_Node0->Board));

  printf("Creating Depth 1 DLL Node set\n");
  CreateMCTS_UTTT_Node_DLL(MCTS_Handle);
  MCTS_Handle->NodesCreated = 0;

  printf("starting While Loop for Iterative Search\n");
	while(MCTS_Handle->NodesCreated < MCTS_Handle->NodesToSearch)
	{

	 MCTS_Handle->TransversedNode = MCTS_Handle->MCTS_Node0;
	 Transverse_UTTT_MCTS(MCTS_Handle,1);
   /*
   if((int)(MCTS_Handle->NodesCreated % 10000))
   {
     printf("<--------------------------->\n");
     printf("Value  :%f\n", MCTS_Handle->MCTS_Node0->AverageValue);
     printf("Visits :%d\n", MCTS_Handle->MCTS_Node0->NodeVisits);
     printf("<--------------------------->\n");
   }
  */
  //printf("%d\n",MCTS_Handle->NodesCreated );
	 MCTS_Handle->NodesCreated++;
 	}

  //printf("BestMove ~?~ \n");
  MCTS_Handle->TransversedNode = MCTS_Handle->MCTS_Node0;
  Print_UTTT_MCTS_UCB1(MCTS_Handle->MCTS_Node0,1);
  //Select_MCTS_TTT_NodeFromDLL_UCB1(&MCTS_Handle->TransversedNode);
  Select_MCTS_UTTT_NodeFromDLL_UCB1(&MCTS_Handle->TransversedNode);
  Print_UTTT_MCTS_Node(MCTS_Handle->TransversedNode,MCTS_Handle->MCTS_Node0->NodeVisits);



  return (UTTT_t*) MCTS_Handle->TransversedNode->Board;
  //Free_MCTS_Node(MCTS_Handle->MCTS_Node0);
	//Select Best Move from Select_MCTS_NodeFromDLL_UCB1() all the way down the Search Tree
	//either Return or Display Move

  return Board;
}



void Free_UTTT_MCTS_Handle(MCTS_Handle_t* MCTS_Handle)
{
	Free_MCTS_Node(MCTS_Handle->MCTS_Node0);
	free(MCTS_Handle->GameRules);
	free(MCTS_Handle);
}

void UTTT_MCTS_T(int Depth,int Game)
{
  printf("MCTS Tests \n");
  printf("Testing with TTT... \n");
  //Create MCTS and Set for TTT
  MCTS_Handle_t* MCTS_Handle = Create_MCTS_Handle(Depth,Get_UTTT_GRules);
  //Simulate Game
  //Game
  printf("Simulating Game \n");
  UTTT_t* UTTT = (UTTT_t*)Create_UTTT_Board(NULL);
  UTTT->Game = Game;
  UTTT_t* Move = (UTTT_t*)Simulate_UTTT_MCTS(MCTS_Handle,(void*)UTTT);
  Display_UTTT_Game(Move);

  printf("Free Board\n");
  //Free_UTTT_Board(Move);
  printf("Freeing MCTS \n");
  Free_UTTT_MCTS_Handle(MCTS_Handle);
}

//Player vs Computer
//Monte Carlo Tree Search Neural Neural Network
//Ultimate TickTackToe Test
void PvC_MCTS_NN_UTTT_T(int Depth)
{
  //TODO:integrate with MCTS Handle'

  UTTT_t* UTTT = (UTTT_t*)Create_UTTT_Board(NULL);
  printf("Welcome to UTTT MCTS_NN\n");
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
      MCTS_Handle_t* MCTS_Handle = Create_MCTS_Handle(Depth,Get_UTTT_GRules);
      MCTS_Handle->Player = 0;
      UTTT_t* Move = (UTTT_t*)Simulate_UTTT_MCTS(MCTS_Handle,(void*)UTTT);
      //Free_TTT_Board(TTT);
      Print_UTTT_MCTS_UCB1(MCTS_Handle->MCTS_Node0,1);

      UTTT = (UTTT_t*) Copy_UTTT_Game(Move);
      Free_UTTT_MCTS_Handle(MCTS_Handle);

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
void PvC_MCTS_G_UTTT_T0(int Depth)
{
  //TODO:integrate with MCTS Handle'


  UTTT_t* UTTT = (UTTT_t*)Create_UTTT_Board(NULL);
  UTTT->Game = 0;
  printf("Welcome to UTTT_Generic T0\n");
  printf("(Player0 - MCTS_Generic)\n");
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
      MCTS_Handle_t* MCTS_Handle = Create_MCTS_Handle(Depth,Get_UTTT_GRules);
      MCTS_Handle->Player = 0;
      UTTT_t* Move = (UTTT_t*) Simulate_UTTT_MCTS(MCTS_Handle,(void*)UTTT);
      //Free_TTT_Board(TTT);
      Print_UTTT_MCTS_UCB1(MCTS_Handle->MCTS_Node0,1);

      UTTT = (UTTT_t*) Copy_UTTT_Game(Move);
      Free_UTTT_MCTS_Handle(MCTS_Handle);

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
void PvC_MCTS_G_UTTT_T1(int Depth)
{
  //TODO:integrate with MCTS Handle'


  UTTT_t* UTTT = (UTTT_t*)Create_UTTT_Board(NULL);
  printf("Welcome to UTTT_Generic T1,\n");
  printf("(Player0 - Person)\n");
  printf("(Player1 - MCTS_Generic)\n");
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
      MCTS_Handle_t* MCTS_Handle = Create_MCTS_Handle(Depth,Get_UTTT_GRules);
      MCTS_Handle->Player = 1;

      printf("Simulating MCTS_UTTT\n");
      UTTT_t* Move = (UTTT_t*) Simulate_UTTT_MCTS(MCTS_Handle,(void*)UTTT);

      //Free_TTT_Board(TTT);
      printf("Printing Chosen Move MCTS_UTTT\n");
      Print_UTTT_MCTS_UCB1(MCTS_Handle->MCTS_Node0,1);

      UTTT = (UTTT_t*) Copy_UTTT_Game(Move);
      Free_UTTT_MCTS_Handle(MCTS_Handle);

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

void CvC_MCTS_G_UTTT(int Depth,int Game,int HandyCap)
{
  //TODO:integrate with MCTS Handle'


  UTTT_t* UTTT = (UTTT_t*)Create_UTTT_Board(NULL);
  UTTT->Game = Game;
  printf("Welcome to UTTT_Generic T1,\n");
  printf("(Player0 - Person)\n");
  printf("(Player1 - MCTS_Generic)\n");
  printf("=======================\n");
  int Player = 0;
  bool ActiveGame = true;
  while(ActiveGame)
  {
    if(Player == 0 && !Winner_UTTT(UTTT))
    {
      printf("Player's 0 Turn ! Please Go ! \n");
      //Project Move
      MCTS_Handle_t* MCTS_Handle = Create_MCTS_Handle(Depth,Get_UTTT_GRules);
      MCTS_Handle->Player = 0;
      printf("Simulating MCTS_UTTT\n");

      UTTT_t* Move = (UTTT_t*) Simulate_UTTT_MCTS(MCTS_Handle,(void*)UTTT);
      //Free_TTT_Board(TTT);
      printf("Printing Chosen Move MCTS_UTTT\n");
      Print_UTTT_MCTS_UCB1(MCTS_Handle->MCTS_Node0,1);

      UTTT = (UTTT_t*) Copy_UTTT_Game(Move);
      Free_UTTT_MCTS_Handle(MCTS_Handle);

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
      MCTS_Handle_t* MCTS_Handle = Create_MCTS_Handle(Depth*HandyCap,Get_UTTT_GRules);
      MCTS_Handle->Player = 1;
      printf("Simulating MCTS_UTTT\n");

      UTTT_t* Move = (UTTT_t*) Simulate_UTTT_MCTS(MCTS_Handle,(void*)UTTT);
      //Free_TTT_Board(TTT);
      printf("Printing Chosen Move MCTS_UTTT\n");
      Print_UTTT_MCTS_UCB1(MCTS_Handle->MCTS_Node0,1);

      UTTT = (UTTT_t*) Copy_UTTT_Game(Move);
      Free_UTTT_MCTS_Handle(MCTS_Handle);

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



void Play_UTTT_MCTS_T()
{
    int SelectedGame = 0;
        int HandyCap = 0;
  int SelectedTest = 0;
  int SelectedDepth = 1000;
  PrintLines(2)
  printf("0 = PvC_MCTS_G_UTTT_T0\n");
  printf("1 = PvC_MCTS_G_UTTT_T1\n");
  printf("2 = CvC_MCTS_G_UTTT Player 1(O's)\n");
  printf("3 = CVC Night Loop\n");
  printf("4 = \n");
  printf("5 = \n");
  printf("98 = TwoPlayer_UTTT_T();\n");
  printf("99 =\n");
  GatherTerminalInt("Please Select Test Move:",&SelectedTest);
  if (SelectedTest == 0)
  {
    GatherTerminalInt("Please Select a Depth:",&SelectedDepth);
    PvC_MCTS_G_UTTT_T0(SelectedDepth);
  }
  else if (SelectedTest == 1)
  {
    GatherTerminalInt("Please Select a Depth:",&SelectedDepth);
    PvC_MCTS_G_UTTT_T1(SelectedDepth);
  }
  else if (SelectedTest == 2)
  {
    GatherTerminalInt("Please Select Search Starting Game:",&SelectedGame);
    GatherTerminalInt("Please Select a Depth:",&SelectedDepth);
    GatherTerminalInt("Please Select The HandyCap for Player 2:",&HandyCap);
    CvC_MCTS_G_UTTT(SelectedDepth,SelectedGame,HandyCap);
  }
  else if (SelectedTest == 3)
  {
    for(int x= 0;x<100;x++)
    {
        CvC_MCTS_G_UTTT(x,x%3,1);
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


#endif // UTickTackToe_MCTS_C
