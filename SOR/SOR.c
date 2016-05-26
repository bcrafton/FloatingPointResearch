#include <stdio.h>
#include <stdlib.h>

#define MATRIX_DIM 3
#define NUM_ITERS	20

double** create_matrix_A()
{
	double** matrix = (double**)malloc(sizeof(double*) * MATRIX_DIM);
	int i;	
	for(i=0; i<MATRIX_DIM; i++)
	{
		matrix[i] = (double*)malloc(sizeof(double) * MATRIX_DIM);
	}
	matrix[0][0] = 3.0;
	matrix[0][1] = -1.0;
	matrix[0][2] = 1.0;

	matrix[1][0] = -1.0;
	matrix[1][1] = 3.0;
	matrix[1][2] = -1.0;

	matrix[2][0] = 1.0;
	matrix[2][1] = -1.0;
	matrix[2][2] = 3.0;

	return matrix;
}

double* create_vector_b()
{
	double* vector = (double*)malloc(sizeof(double) * MATRIX_DIM);
	
	vector[0] = -1;
	vector[1] = 7;
	vector[2] = -7;

	return vector;
}

double* SOR(int n, double** A, double* b, double w, int num_iters)
{
	int i, j;

	double* x;
	double* prev = (double*)malloc(sizeof(double) * n);

	for(i=0; i<n; i++)
	{
		prev[i] = 0.0;
	}
	
	int iter;
	for(iter=0; iter<num_iters; iter++)
	{
		x = (double*)malloc(sizeof(double) * n);

		for ( i = 0; i < n; i++ )
		{
			x[i] = b[i];
			for ( j = 0; j < i; j++ )
			{
				x[i] = x[i] - A[j][i] * x[j];
			}
			for ( j = i + 1; j < n; j++ )
			{
				x[i] = x[i] - A[j][i] * prev[j];
			}
			
			x[i] = x[i] / A[i][i];

		}

		for ( i = 0; i < n; i++ )
		{
			x[i] = ( 1.0 - w ) * prev[i] + w * x[i];
		}

		free(prev);
		prev = x;
	}

	return x;
}

int main()
{
	double omega = 1.25;
	double** A = create_matrix_A();
	double* b = create_vector_b();
	double* x = SOR(MATRIX_DIM, A, b, omega, NUM_ITERS);
	
	int i;
	for(i=0; i<MATRIX_DIM; i++)
	{
		printf("%f ", x[i]);
	}
	printf("\n");
}