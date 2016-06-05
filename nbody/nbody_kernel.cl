#define NUM_DIMENSIONS 3


__kernel void
bodies_advance(__global char* device_bodies, int num_bodies, float dt)
{
	__global unsigned int N = (num_bodies - 1) * num_bodies / 2;

	__global struct {
		double dx[3];
		fill;
	} r[1000];

	__global __attribute__((aligned(16))) double mag[1000];

	__global __m128d dx[3], dsquared, distance, dmag;

	int i;

	// using 3 dimensions each instance of kernel does its own x,y,z coordinate. 
	int x = get_global_id(0); 
	int y = get_global_id(1);
	int z = get_global_id(2);

	
	// first chunk
	for (i = 0; i < NUM_DIMENSIONS; i++)
	{
		//r[k].dx[m] = bodies[i].x[m] - bodies[j].x[m];
		r[z].dx[i] = bodies[x].x[i] - bodies[y].x[i];
	}
	// 

	barrier(CLK_GLOBAL_MEM_FENCE);

	// second chunk -> this actually needs to be handled differently because different loop conditions.
	for (i = 0; i < NUM_DIMENSIONS; i++) 
	{
		//dx[m] = _mm_loadl_pd(dx[m], &r[i].dx[m]);
		//dx[m] = _mm_loadh_pd(dx[m], &r[i+1].dx[m]);
		dx[i] = _mm_loadl_pd(dx[i], &r[x].dx[i]);
		dx[i] = _mm_loadh_pd(dx[i], &r[x+1].dx[i]);
	}

	dsquared = dx[0] * dx[0] + dx[1] * dx[1] + dx[2] * dx[2];
	distance = _mm_cvtps_pd(_mm_rsqrt_ps(_mm_cvtpd_ps(dsquared)));

	for (i = 0; i < 2; i++)
	{
		distance = distance * _mm_set1_pd(1.5) - ((_mm_set1_pd(0.5) * dsquared) * distance) * (distance * distance);
	}

	dmag = _mm_set1_pd(dt) / (dsquared) * distance;
	_mm_store_pd(&mag[x], dmag);
	//

	barrier(CLK_GLOBAL_MEM_FENCE);

	// third chunk
	for ( m = 0; m < NUM_DIMENSIONS; ++m) 
	{
		//bodies[i].v[m] -= r[k].dx[m] * bodies[j].mass * mag[k];
		//bodies[j].v[m] += r[k].dx[m] * bodies[i].mass * mag[k];

		bodies[x].v[i] -= r[z].dx[i] * bodies[y].mass * mag[z];
		bodies[y].v[i] += r[z].dx[i] * bodies[x].mass * mag[z];
	}
	//

	barrier(CLK_GLOBAL_MEM_FENCE);

	// fourth chunk
	for ( i = 0; i < NUM_DIMENSIONS; i++)
	{
		//bodies[i].x[m] += dt * bodies[i].v[m];

		bodies[x].x[i] += dt * bodies[x].v[i];
	}
	//
     

	

}
