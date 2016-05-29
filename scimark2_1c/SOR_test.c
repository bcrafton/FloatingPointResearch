#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "Random.h"
#include "kernel.h"
#include "constants.h"

void print_banner(void);

int main(int argc, char *argv[])
{
        /* default to the (small) cache-contained version */

        double min_time = RESOLUTION_DEFAULT;

        int SOR_size =  SOR_SIZE;
        /* run the benchmark */

        double res;
        Random R = new_Random_seed(RANDOM_SEED);

	res = kernel_measureSOR( SOR_size, min_time, R); 

	printf("SOR             Mflops: %8.2f    (%d x %d)\n", 		
				res, SOR_size, SOR_size);

        Random_delete(R);

        return 0;
  
}

void print_banner()
{
 printf("**                                                              **\n");
 printf("** SciMark2 Numeric Benchmark, see http://math.nist.gov/scimark **\n");
 printf("** for details. (Results can be submitted to pozo@nist.gov)     **\n");
 printf("**                                                              **\n");
}
