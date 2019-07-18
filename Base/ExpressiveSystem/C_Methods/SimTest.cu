#ifndef SIMTEST_C
#define SIMTEST_C

//Header Files
#include "Sim.h"



//Forward declaration


// Program Information
////////////////////////////////////////////////////////////////////////////////
/**
* @file Sim~~.c
*
* @brief Driver program to exercise:
*
*
* @details Allows for the reading of a Configure File, MetaData File, Specified
*
* @version Sim~~.~~
*      -To Create SIMD instruction for increased preformance
*

*
*
* @note Requires to Compile:
-ALL*
*/
void ScreenShotLoop(int CallSign)
{
  printf("Starting Command Prompt.. \n");
  sleep(5);
  system("import -window root Test1.png");
}

void PrintGenericVersion(bool Print)
{
    if(Print)
    {
      printf("General Version:\n");
      printf("================\n");
      printf("SimBase  \t\t\tV:%d.%d\n\n",SimVersion,SimRevision);
      //OBJECTBASE FILES
      printf("BASE FILES:\n");
      printf("-----------\n");
      Base_V();

      printf("DataStructures:\n");
      printf("-----------\n");
      DoublyLinkedList_V();
      StringFields_V();
      MMath_V();

      printf("ParallelComponenets:\n");
      printf("-----------\n");
      GPU_Management_V();
    }
}
void TerminalUnitTesting(bool Print, int CallSign)
{
  int Option = 0;
  printf("0: PrintVersion Control:\n");
  printf("===================\n");
  printf("99: ALL:\n");
  printf("1: Base_T:\n");
  printf("2: DoublyLinkedList:\n");
  printf("3: UTTT_T:\n");
  printf("4: XML_Light:\n");
  printf("5: NNLayer_T:\n");
  printf("6: HashTable_T:\n");
  printf("7: NNOperations_T:\n");
  printf("8: GPU_Management:\n");
  printf("10: MCHT_T:\n");
  printf("11: TTT_T:\n");
  printf("===================\n");
  GatherTerminalInt("Select the Test Program you wish to Use:",&Option);
  printf("\n\n");

  if (Option == 0)
  {
    PrintGenericVersion(true);
  }
  else if (Option == 1)
  {
    Base_T(CallSign);
  }
  else if (Option == 2)
  {
    DoublyLinkedList_T(CallSign);
  }
  else if (Option == 3)
  {
    //UTTT_T(CallSign);
  }
  else if (Option == 4)
  {

  }
  else if (Option == 5)
  {

  }
  else if (Option == 6)
  {
    HashTable_T(CallSign);
  }
  else if (Option == 7)
  {
     GenericNNetwork_T(CallSign);
  }
  else if (Option == 8)
  {
    GPU_Management_T(CallSign);
  }
  else if (Option ==10)
  {
     MCHS_T(CallSign);
  }
  else if (Option == 11)
  {
    TTT_T(CallSign);
  }
}

void AutomatedUnitTesting(bool Print, int CallSign)
{
  printf("\n\n");
  printf("Game Tests:\n");
  printf("===================\n");
  //MMath_T(CallSign);
}



void UnitTesting(bool Print,int CallSign)
{
    if(Print)
    {
      printf("\n\n");
      printf("Unit Tests Version:\n");
      printf("===================\n");
      printf("Sim Base \t\t\tV:%d.%d\n",SimVersion,SimRevision);
      if(CallSign != 0)
      {
        AutomatedUnitTesting(Print,CallSign);

      }
      else
      {
        TerminalUnitTesting(Print,CallSign);
      }



      //Threading_T();

      //CharacterOperations_T();





      //printf("\n\n");
      //printf("Math And NN Tests:\n");
      //printf("===================\n");
      //AIV_Light_T();
      //FileServices_T();
      //NNOperations_T();
      //MMath_T();

      //MCTS_T();
      //ManagedVariables_T();
      //TestingVersion();
      //SFS_Tests();
    }
}
/*
ToDo:
-MCTS
-MCTS+NN
-XML Light
-Save MCTS
-Read MCTS

//----------------------------------------------------------------------*/
int main(int argc, char** argv)
{
  //PrintGenericVersion(true);
  int CallSign = 0;
  if (argc == 1)
  {
    UnitTesting(true,0);
  }
  else
  {
    printf("Selected Callsign:%s\n",argv[1]);
    if (argv[1] == NULL)
    {
      CallSign = 0;
    }
    else
    {
      CallSign = atoi(argv[1]);
    }

    UnitTesting(true,CallSign);
  }

  return 0;
}







#endif // SIMTEST_C
