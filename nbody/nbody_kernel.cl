#define NUM_DIMENSIONS 3


__kernel void
bodies_advance(__global char* device_bodies, int num_bodies, float dt)
{
	// using 3 dimensions each instance of kernel does its own x,y,z coordinate. 
	
	int x = get_global_id(0); 
	int y = get_global_id(1);
	int z = get_global_id(2);

	int i;
	for (i = 0; i < NUM_DIMENSIONS; i++)
     {
        //r[k].dx[m] = bodies[i].x[m] - bodies[j].x[m];
        r[z].dx[i] = bodies[x].x[i] - bodies[y].x[i];
     }

     

	barrier(CLK_LOCAL_MEM_FENCE);

}
