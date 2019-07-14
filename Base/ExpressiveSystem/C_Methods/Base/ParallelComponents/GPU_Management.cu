#ifndef GPU_Management_CU
#define GPU_Management_CU

#include "GPU_Management.h"

void GPU_Management_V()
{
	printf("GPU_Management \t\tV:1.00\n");
}


bool SetGPU(std::string DesiredGPU)
{
		int devicesCount;
		cudaGetDeviceCount(&devicesCount);
		for(int deviceIndex = 0; deviceIndex < devicesCount; ++deviceIndex)
		{
				cudaDeviceProp deviceProperties;
				cudaGetDeviceProperties(&deviceProperties, deviceIndex);
				if (deviceProperties.name == DesiredGPU)
				{
						cudaSetDevice(deviceIndex);
						return true;
				}
		}

		return false;
}


void List_GPUS()
{
	int devicesCount;
	cudaGetDeviceCount(&devicesCount);
	for(int deviceIndex = 0; deviceIndex < devicesCount; ++deviceIndex)
	{
	    cudaDeviceProp deviceProperties;
	    cudaGetDeviceProperties(&deviceProperties, deviceIndex);
			printf("%s\n",deviceProperties.name);
	}
}

__global__ void warmup(unsigned int * tmp)
{
if (threadIdx.x==0)
{
	*tmp=555;
}
return;
}

void warmUpGPU()
{
	printf("\nWarming up GPU for time trialing...\n");
	unsigned int * dev_tmp;
	unsigned int * tmp;
	tmp=(unsigned int*)malloc(sizeof(unsigned int));
	*tmp=0;
  cudaError_t errCode = cudaSuccess;
  errCode=cudaMalloc((unsigned int**)&dev_tmp, sizeof(unsigned int));
	if(errCode != cudaSuccess)
	{
		printf("\nError: dev_tmp error with code:%d\n",errCode);
	}
	warmup<<<1,256>>>(dev_tmp);

//copy data from device to host
	errCode=cudaMemcpy( tmp, dev_tmp, sizeof(unsigned int), cudaMemcpyDeviceToHost);
	if(errCode != cudaSuccess)
	{
		printf("\nError: getting tmp result form GPU error with code :%d\n",errCode);
	}
cudaDeviceSynchronize();
printf("\ntmp (changed to 555 on GPU): %d\n",*tmp);
cudaFree(dev_tmp);

return;
}

/*
* @brief
*
* @details
*
* @example:
*/
void GPU_Management_T(int CallSign)
{
	int devicesCount;
	cudaGetDeviceCount(&devicesCount);
	for(int deviceIndex = 0; deviceIndex < devicesCount; ++deviceIndex)
	{
	    cudaDeviceProp deviceProperties;
	    cudaGetDeviceProperties(&deviceProperties, deviceIndex);
			printf("%s\n",deviceProperties.name);
	}
	printf("GPU Set? : %d\n",SetGPU("GeForce GTX 1070"));
	warmUpGPU();
}

#endif // GPU_Management_CU
