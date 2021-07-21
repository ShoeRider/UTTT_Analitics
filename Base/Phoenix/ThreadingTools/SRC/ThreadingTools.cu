/*
Anthony M Schroeder


Purpose:
Create ThreadingTools interface to standardize different Threading
Techniques for ease of use.


*/
#ifndef ThreadingTools_CU
#define ThreadingTools_CU
#include "ThreadingTools.h"

#include <string>
#include <iostream>
#include <list>

#include <thread>
#include <mutex>

#include <stdio.h>      /* printf */
#include <time.h>       /* clock_t, clock, CLOCKS_PER_SEC */


typedef void *(*RunTimeFunction)(void *);


class ThreadData_t
{
public:
  ThreadData_t(){
  }
  virtual ~ThreadData_t(){}
};

class ThreadControlBlock
{
  public:
  int ThreadNumber;
  //Integer Representing Program identification

  //Start Time
  double StartTime;
  //Program state
  //  0-New
  //  1-ready
  //  2-Running
  //  3-Blocked
  //  4-Finished
  int ProgramState;
  int AccomplishedTasks;

  ThreadData_t* ThreadData;
  RunTimeFunction ThreadFunction;
  RunTimeFunction Start_Thread;
  RunTimeFunction End_Thread;
  RunTimeFunction Free_Enviornment;
  ThreadControlBlock(ThreadData_t* GivenThreadData){
    StartTime          = clock()*.000001;
  	ThreadNumber       = 0;
    ProgramState       = 0;
  	AccomplishedTasks  = 0;
    ThreadData         = GivenThreadData;

  }
  virtual ~ThreadControlBlock(){}
  virtual void StartThread();
};


class ParallelControlBlock
{

  public:
      //Parallel Components
      int MaximumThreads;
      std::list<ThreadControlBlock*> DispatchedThreads;

      std::mutex RecievingThreads_Mutex;
      std::list<ThreadControlBlock*> RecievingThreads;
      ParallelControlBlock(){

      }
      virtual ~ParallelControlBlock(){}

      virtual void DispatchThread(void *(*start_routine)(void*),void *arg){
        ThreadData_t* ThreadData = new ThreadData_t();
        ThreadControlBlock* Newthread = new ThreadControlBlock(ThreadData);
        DispatchedThreads.push_back(Newthread);
      }

      virtual void RecieveThreads(){
        RecievingThreads_Mutex.lock();
        for (ThreadControlBlock* Thread : RecievingThreads) { // c++11 range-based for loop

            DispatchedThreads.remove(Thread);
          }
        RecievingThreads_Mutex.unlock();
      }

      virtual void RecieveALLThreads(){

      }
};




/*
* @brief Pthread Process For Delaying Time to simulate a Given Process Operation
*
* @details Function Takes an integer, then delays for given time in seconds
*
* @example:
* pthread_t WaitThread;
* int OperationTime = .001;   (Seconds)
* //The Tread will wait for .001 Seconds before starting the next segment of code
* pthread_create(&WaitThread,NULL,WaitFor_x,&OperationTime);
* pthread_join(WaitThread,NULL);
void *WaitFor_x(void *OperationTime)
{
	int *OperationTime_pointer = (int *)OperationTime;

	double CurrentTime = clock()*.000001;

  //float OperationTimeAsDouble = *OperationTime;

  float OperationFinishTime = CurrentTime + (*OperationTime_pointer)* .000001;
  while(CurrentTime <= OperationFinishTime)
  {
    CurrentTime = clock()*.000001;
  }

	return NULL;
}
*/







#endif //ThreadingTools_CU
