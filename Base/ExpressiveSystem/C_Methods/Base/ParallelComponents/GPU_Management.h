#ifndef GPU_Management_H
#define GPU_Management_H

#include "../Base.h"
#include <cuda_runtime_api.h>
#include <cuda.h>
#include <iostream>

using namespace std;
void GPU_Management_V();

bool SetGPU(std::string DesiredGPU);
void List_GPUS();
void warmUpGPU();
void GPU_Management_T(int CallSign);

#endif //GPU_Management_H
