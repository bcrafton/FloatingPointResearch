
__kernel void
sor(__global float* A, int M, int N, float w)
{

	int tx = get_global_id(0); 
	int ty = get_global_id(1);

	int i, j;
	for(i=1; i<M-1; i++)
	{
		for(j=1; j<N-1; j++)
		{
			if(i == tx && j == ty)
			{
				A[i*N + j] = (w/4) * (A[i*N + (j + 1)] + A[i*N + (j - 1)] + A[(i+1)*N + j] + A[(i-1)*N + j]) + (1.0-w) * A[i*N + j];
			}
			barrier(CLK_GLOBAL_MEM_FENCE);
		}
	}
}
