/**
 * Copyright 1993-2012 NVIDIA Corporation.  All rights reserved.
 *
 * Please refer to the NVIDIA end user license agreement (EULA) associated
 * with this source code for terms and conditions that govern your use of
 * this software. Any use, reproduction, disclosure, or distribution of
 * this software and related documentation outside the terms of the EULA
 * is strictly prohibited.
 */
#include <stdio.h>
#include <stdlib.h>

const int N = 32;
// const int blocksize = 16;
//*/

__global__
void hello(int *a, int *b, int *c) {
	// threadinx.x 从0开始，最大值是blockDim.x 。
	//blockDim.x 限制是dimBlock（）的参数，第一个对应blockDim.x 第二个对blockDim.y 以此类推.
	//blockIdx.x 从0开始，最大值是dimGrid（）第一个参数限制 .y ,z 以此类推。
	int i = blockIdx.x * blockDim.x + threadIdx.x;
	int j = blockIdx.x * blockDim.y + threadIdx.y;
	int k = blockIdx.x * blockDim.z + threadIdx.z;

	a[i] = i;
	b[j] = j;
	c[k] = k;

	/*	int m = blockIdx.z*blockDim.x + threadIdx.x;
	 int n = blockIdx.z*blockDim.y + threadIdx.y;*/
	/*	e[m] = m;
	 f[n] = n;*/

}
/*
__global__
void init(float *vpp, float *vss, float *density, int nx, int ny) {
	int i = blockIdx.x * blockDim.x + threadIdx.x;
	int j = blockIdx.x * blockDim.y + threadIdx.y;
	int k = blockIdx.x * blockDim.z + threadIdx.z;
	vpp[i] = 2300.;
	vss[j] = 1232.;
	density[k] = 1.;
}*/
__global__
void testInit(float *vpp ){
	int i = blockIdx.x * blockDim.x + threadIdx.x;
	vpp[i] = 1.;

}
int main() {

	int b[N] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
	int a[N] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
	int c[N] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
	int *ad;
	int *bd;
	int *cd;
	/*	int b[N] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
	 int a[N] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
	 int *ad;
	 int *bd;
	 int c[N] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
	 int d[N] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
	 int *cd;
	 int *dd;*/
	int nx = 200, ny = 200, nz = 200;
	float *vpp, *density, *vss;
	float *vppd, *densityd, *vssd;

	const int isize = N * sizeof(int);
	const int nxyz = sizeof(float) * nz * ny * nx;

	vpp = (float*) malloc(sizeof(float) * nz * ny * nx);
//	density = (float*) malloc(sizeof(float) * nz * ny * nx);
//	vss = (float*) malloc(sizeof(float) * nz * ny * nx);
	cudaMalloc((void**) &vppd, nxyz);
//	cudaMalloc((void**) &densityd, nxyz);
//	cudaMalloc((void**) &vssd, nxyz);
	cudaMemcpy(vppd, vpp, nxyz, cudaMemcpyHostToDevice);
//	cudaMemcpy(densityd, density, nxyz, cudaMemcpyHostToDevice);
//	cudaMemcpy(vssd, vss, nxyz, cudaMemcpyHostToDevice);

	cudaMalloc((void**) &ad, isize);
	cudaMalloc((void**) &bd, isize);
	cudaMemcpy(ad, a, isize, cudaMemcpyHostToDevice);
	cudaMemcpy(bd, b, isize, cudaMemcpyHostToDevice);
	cudaMalloc((void**) &cd, isize);
	cudaMemcpy(cd, c, isize, cudaMemcpyHostToDevice);
	/*	cudaMalloc( (void**)&ad, isize );
	 cudaMalloc( (void**)&bd, isize );
	 cudaMemcpy( ad, a, isize, cudaMemcpyHostToDevice );
	 cudaMemcpy( bd, b, isize, cudaMemcpyHostToDevice );
	 cudaMalloc( (void**)&cd, isize );
	 cudaMalloc( (void**)&dd, isize );
	 cudaMemcpy( cd, c, isize, cudaMemcpyHostToDevice );
	 cudaMemcpy( dd, d, isize, cudaMemcpyHostToDevice );*/

	/*	dim3 dimGrid(2, 2);
	 dim3 dimBlock(4, 2, 2);
	 hello<<<dimGrid, dimBlock>>>(ad,bd,cd,dd);*/
	dim3 dimGrid(2, 2);
	dim3 dimBlock(nx, ny, nz);
/*	init<<<3, dimBlock>>>(vppd, densityd, vssd, 200, 200);*/
	testInit<<<200,200>>>(vpp);
	dim3 dimGrid1(2, 2);
	dim3 dimBlock1(4, 4, 4);
	hello<<<2, dimBlock1>>>(ad, bd, cd);

//	cudaMemcpy(density, densityd, nxyz, cudaMemcpyDeviceToHost);
	cudaMemcpy(vpp, vppd, nxyz, cudaMemcpyDeviceToHost);
//	cudaMemcpy(vss, vssd, nxyz, cudaMemcpyDeviceToHost);
//	cudaFree(densityd);
	cudaFree(vppd);
//	cudaFree(vssd);

	cudaMemcpy(b, bd, isize, cudaMemcpyDeviceToHost);
	cudaMemcpy(a, ad, isize, cudaMemcpyDeviceToHost);
	cudaFree(bd);
	cudaFree(ad);
	cudaMemcpy(c, cd, isize, cudaMemcpyDeviceToHost);
	cudaFree(cd);
	/*	cudaMemcpy( b, bd, isize, cudaMemcpyDeviceToHost );
	 cudaMemcpy( a, ad, isize, cudaMemcpyDeviceToHost );
	 cudaFree( bd );
	 cudaFree( ad );
	 cudaMemcpy( c, cd, isize, cudaMemcpyDeviceToHost );
	 cudaMemcpy( d, dd, isize, cudaMemcpyDeviceToHost );
	 cudaFree( cd );
	 cudaFree( dd );
	 int i;*/
	/*
	 int e[N] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
	 int f[N] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
	 int *ed;
	 int *fd;
	 cudaMalloc( (void**)&ed, isize );
	 cudaMalloc( (void**)&fd, isize );
	 cudaMemcpy( ed, e, isize, cudaMemcpyHostToDevice );
	 cudaMemcpy( fd, f, isize, cudaMemcpyHostToDevice );
	 cudaFree( ed );
	 cudaFree( fd );
	 printf("\n");
	 for( i=0;i<N;i++){
	 printf("%d=%d ",i,e[i]);
	 }
	 printf("\n");
	 for( i=0;i<N;i++){
	 printf("%d=%d ",i,f[i]);
	 }
	 */

	/*
	 for( i=0;i<N;i++){
	 printf("%d=%d ",i,a[i]);
	 }
	 printf("\n");
	 for( i=0;i<N;i++){
	 printf("%d=%d ",i,b[i]);
	 }
	 printf("\n");
	 for( i=0;i<N;i++){
	 printf("%d=%d ",i,c[i]);
	 }
	 printf("\n");
	 for( i=0;i<N;i++){
	 printf("%d=%d ",i,d[i]);
	 }
	 */
	int i = 0;
/*	for (i = 0; i < N; i++) {
		printf("%d=%f ", i, density[i]);
	}*/
	printf("\n");
	for (i = 0; i < N; i++) {
		printf("%d=%f ", i, vpp[i]);
	}
/*	printf("\n");
	for (i = 0; i < N; i++) {
		printf("%d=%f ", i, vss[i]);
	}*/
	printf("\n");
	for (i = 0; i < N; i++) {
		printf("%d=%d ", i, a[i]);
	}
	printf("\n");
	for (i = 0; i < N; i++) {
		printf("%d=%d ", i, b[i]);
	}
	printf("\n");
	for (i = 0; i < N; i++) {
		printf("%d=%d ", i, c[i]);
	}
	return EXIT_SUCCESS;
}
