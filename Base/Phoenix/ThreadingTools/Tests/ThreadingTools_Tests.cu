#ifndef ThreadingTools_Tests_CU
#define ThreadingTools_Tests_CU


#include "../SRC/ThreadingTools.cu"

void* SomeFunction(void*data){
  return NULL;
}


int main() {
 //std::cout << "Hello World!";
  TTT_Player Player0 = ParallelControlBlock();
 return 0;
}

#endif //ThreadingTools_Tests_CU
