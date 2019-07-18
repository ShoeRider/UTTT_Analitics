#ifndef MCHS_T_C
#define MCHS_T_C

#include "MCHS.c"




void MCHS_TT()
{
	int SelectedTest = 0;
  printf("0 = MallocFree_MCHT_t()\n");
  printf("1 = ()\n");
  printf("2 = \n");
  printf("100 =\n");
  GatherTerminalInt("Please Select Test:",&SelectedTest);
  if (SelectedTest == 0)
  {
  }
  else if (SelectedTest == 1)
  {

  }
  else if (SelectedTest == 2)
  {

  }
  else if (SelectedTest == 3)
  {

  }
  else if (SelectedTest == 4)
  {

  }
  else if (SelectedTest == 100)
  {

  }
}

void MCHS_T(int CallSign)
{
	printf("\n\n");
	printf("Starting MCHS_TT Tests:\n");
	printf("----------------------------\n");

	if (CallSign == 1)
	{
		//
	}
	else
	{
		MCHS_TT();
	}


}

#endif // MCHS_T_C
