////////////////////////////////////////////////////////////////////////////////

#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <CL/cl.h>
#include <stdbool.h>
#include "Random.h"
#include "constants.h"

////////////////////////////////////////////////////////////////////////////////
#define M 100
#define N 100

#define INTEL 0
#define NVIDIA 1
#define AMD_CPU 2
#define AMD_GPU 3

#define HARDWARE NVIDIA
////////////////////////////////////////////////////////////////////////////////

 
// Allocates a matrix with random float entries.
void randomMemInit(float* data, int size)
{
   int i;

   for (i = 0; i < size; ++i)
   	data[i] = rand() / (float)RAND_MAX;
}

long LoadOpenCLKernel(char const* path, char **buf)
{
    FILE  *fp;
    size_t fsz;
    long   off_end;
    int    rc;

    /* Open the file */
    fp = fopen(path, "r");
    if( NULL == fp ) {
        return -1L;
    }

    /* Seek to the end of the file */
    rc = fseek(fp, 0L, SEEK_END);
    if( 0 != rc ) {
        return -1L;
    }

    /* Byte offset to the end of the file (size) */
    if( 0 > (off_end = ftell(fp)) ) {
        return -1L;
    }
    fsz = (size_t)off_end;

    /* Allocate a buffer to hold the whole file */
    *buf = (char *) malloc( fsz+1);
    if( NULL == *buf ) {
        return -1L;
    }

    /* Rewind file pointer to start of file */
    rewind(fp);

    /* Slurp file into buffer */
    if( fsz != fread(*buf, 1, fsz, fp) ) {
        free(*buf);
        return -1L;
    }

    /* Close the file */
    if( EOF == fclose(fp) ) {
        free(*buf);
        return -1L;
    }


    /* Make sure the buffer is NUL-terminated, just in case */
    (*buf)[fsz] = '\0';

    /* Return the file size */
    return (long)fsz;
}

int main(int argc, char** argv)
{
   int err;                            // error code returned from api calls

   cl_context context;                 // compute context
   cl_command_queue commands;          // compute command queue
   cl_program program;                 // compute program
   cl_kernel kernel;                   // compute kernel

    // OpenCL device memory for matrices
   cl_mem d_A;

   // set seed for rand()
   srand(2014);
 
   //Allocate host memory for matrices A and B
   unsigned int size_A = M * N;
   unsigned int mem_size_A = sizeof(float) * size_A;
   float* h_A = (float*) malloc(mem_size_A);

   Random R = new_Random_seed(RANDOM_SEED);
   double **G = RandomMatrix(M, N, R);
   
   int i, j;
   for(i=0; i<M; i++)
   {
	   for(j=0; j<N; j++)
	   {
		   h_A[i*N + j] = G[i][j];
	   }
   }
   
   printf("Initializing OpenCL device...\n"); 

   cl_uint dev_cnt = 0;
   clGetPlatformIDs(0, 0, &dev_cnt);
	
   cl_platform_id platform_ids[100];
   clGetPlatformIDs(dev_cnt, platform_ids, NULL);
	
   // Connect to a compute device
   cl_uint deviceCount;
   cl_device_id* devices;

#if(HARDWARE == INTEL)
   clGetDeviceIDs(platform_ids[1], CL_DEVICE_TYPE_ALL, 0, NULL, &deviceCount);
   devices = (cl_device_id*) malloc(sizeof(cl_device_id) * deviceCount);
   clGetDeviceIDs(platform_ids[1], CL_DEVICE_TYPE_ALL, deviceCount, devices, NULL);
#else
   clGetDeviceIDs(platform_ids[0], CL_DEVICE_TYPE_ALL, 0, NULL, &deviceCount);
   devices = (cl_device_id*) malloc(sizeof(cl_device_id) * deviceCount);
   clGetDeviceIDs(platform_ids[0], CL_DEVICE_TYPE_ALL, deviceCount, devices, NULL);
#endif

#if(HARDWARE == AMD_CPU)
   cl_device_id device_id = devices[1];
#else
   cl_device_id device_id = devices[0];
#endif
   
   char* value;
   size_t valueSize;
   // print device name
   clGetDeviceInfo(device_id, CL_DEVICE_NAME, 0, NULL, &valueSize);
   value = (char*) malloc(valueSize);
   clGetDeviceInfo(device_id, CL_DEVICE_NAME, valueSize, value, NULL);
   printf("%d. Device: %s\n", j+1, value);
   free(value);
  
   // Create a compute context 
   context = clCreateContext(0, 1, &device_id, NULL, NULL, &err);
   if (!context)
   {
       printf("Error: Failed to create a compute context!\n");
       return EXIT_FAILURE;
   }

   // Create a command commands
   commands = clCreateCommandQueue(context, device_id, 0, &err);
   if (!commands)
   {
       printf("Error: Failed to create a command commands!\n");
       return EXIT_FAILURE;
   }

   // Create the compute program from the source file
   char *KernelSource;
   long lFileSize;

   lFileSize = LoadOpenCLKernel("SOR.cl", &KernelSource);
   if( lFileSize < 0L ) {
       perror("File read failed");
       return 1;
   }

   program = clCreateProgramWithSource(context, 1, (const char **) & KernelSource, NULL, &err);
   if (!program)
   {
       printf("Error: Failed to create compute program!\n");
       return EXIT_FAILURE;
   }

   // Build the program executable
   err = clBuildProgram(program, 0, NULL, NULL, NULL, NULL);
   if (err != CL_SUCCESS)
   {
       size_t len;
       char buffer[2048];
       printf("Error: Failed to build program executable!\n");
       clGetProgramBuildInfo(program, device_id, CL_PROGRAM_BUILD_LOG, sizeof(buffer), buffer, &len);
       printf("%s\n", buffer);
       exit(1);
   }

   // Create the compute kernel in the program we wish to run
   //
   kernel = clCreateKernel(program, "sor", &err);
   if (!kernel || err != CL_SUCCESS)
   {
       printf("Error: Failed to create compute kernel!\n");
       exit(1);
   }

   FILE * fp;
#if(HARDWARE == AMD_GPU)
   fp = fopen("/home/cbrian/amdgpu_sor_in.csv", "w");
#elif(HARDWARE == AMD_CPU)
   fp = fopen("/home/cbrian/amdcpu_sor_in.csv", "w");
#elif(HARDWARE == INTEL)
   fp = fopen("/scratch/crafton.b/intel_sor_in.csv", "w");
#elif(HARDWARE == NVIDIA)
   fp = fopen("/scratch/crafton.b/nvidia_sor_in.csv", "w");
#endif
   
   for(i = 0; i < size_A; i++)
   {
      if(((i + 1) % N) == 0)
      fprintf(fp, "%f\n", h_A[i]);
      else
      fprintf(fp, "%f,", h_A[i]);
   }
   fprintf(fp, "\n");
   
   fclose(fp);
   
    // Query binary (PTX file) size
    size_t bin_sz;
    err = clGetProgramInfo(program, CL_PROGRAM_BINARY_SIZES, sizeof(size_t), &bin_sz, NULL);

    // Read binary (PTX file) to memory buffer
    unsigned char *bin = (unsigned char *)malloc(bin_sz);
    err = clGetProgramInfo(program, CL_PROGRAM_BINARIES, sizeof(unsigned char *), &bin, NULL);

    // Save PTX to add_vectors_ocl.ptx
    fp = fopen("SOR.ptx", "wb");
    fwrite(bin, sizeof(char), bin_sz, fp);
    fclose(fp);
    free(bin);

   // Create the input and output arrays in device memory for our calculation
   d_A = clCreateBuffer(context, CL_MEM_READ_WRITE | CL_MEM_COPY_HOST_PTR, mem_size_A, h_A, &err);

   if (!d_A)
   {
       printf("Error: Failed to allocate device memory!\n");
       exit(1);
   }    
    
   printf("Running SOR for matrix A (%dx%d)\n", M, N); 

   //Launch OpenCL kernel
   size_t localWorkSize[2], globalWorkSize[2];
 
   int m = M;
   int n = N;
   float w = 1.25;
 
   err = clSetKernelArg(kernel, 0, sizeof(cl_mem), (void *)&d_A);
   err |= clSetKernelArg(kernel, 1, sizeof(int), (void *)&m);
   err |= clSetKernelArg(kernel, 2, sizeof(int), (void *)&n);
   err |= clSetKernelArg(kernel, 3, sizeof(float), (void *)&w);

   if (err != CL_SUCCESS)
   {
       printf("Error: Failed to set kernel arguments! %d\n", err);
       exit(1);
   }
 
   localWorkSize[0] = 16;
   localWorkSize[1] = 16;
   globalWorkSize[0] = 1024;
   globalWorkSize[1] = 1024;
 
   err = clEnqueueNDRangeKernel(commands, kernel, 2, NULL, globalWorkSize, localWorkSize, 0, NULL, NULL);

   if (err != CL_SUCCESS)
   {
       printf("Error: Failed to execute kernel! %d\n", err);
       exit(1);
   }
 
   //Retrieve result from device
   err = clEnqueueReadBuffer(commands, d_A, CL_TRUE, 0, mem_size_A, h_A, 0, NULL, NULL);

   if (err != CL_SUCCESS)
   {
       printf("Error: Failed to read output array! %d\n", err);
       exit(1);
   }
 
   //print out the results
#if(HARDWARE == AMD_GPU)
   fp = fopen("/home/cbrian/amdgpu_sor.csv", "w");
#elif(HARDWARE == AMD_CPU)
   fp = fopen("/home/cbrian/amdcpu_sor.csv", "w");
#elif(HARDWARE == INTEL)
   fp = fopen("/scratch/crafton.b/intel_sor.csv", "w");
#elif(HARDWARE == NVIDIA)
   fp = fopen("/scratch/crafton.b/nvidia_sor.csv", "w");
#endif
   
   for(i = 0; i < (int) size_A; i++)
   {
      if(((i + 1) % N) == 0)
      fprintf(fp, "%f\n", h_A[i]);
      else
      fprintf(fp, "%f,", h_A[i]);
   }
   fprintf(fp, "\n");
   
   fclose(fp);

  
   printf("SOR completed...\n"); 

   //Shutdown and cleanup
   free(h_A);
 
   clReleaseMemObject(d_A);

   clReleaseProgram(program);
   clReleaseKernel(kernel);
   clReleaseCommandQueue(commands);
   clReleaseContext(context);

   return 0;
}
