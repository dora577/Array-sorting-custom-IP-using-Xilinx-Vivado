/*
 * testSorting.c
 *
 *  Created on: Apr 20, 2020
 *      Author: D577
 */
#include "mySortCore.h"
#include "xparameters.h"

int main(){
	sortCore myCore;
	initSortCore(&myCore,XPAR_MYSORTCORE_V1_0_0_BASEADDR);

	u32 a[] = {6,5,4,3,2,1};
	u32 out[6];
	u32 status;

	for(int i = 0;i<6;i++){
		write_SortCore(&myCore,a[i]);
	}
	status = read_status_SortCore(&myCore);

	while(!status)
		status = read_status_SortCore(&myCore);

	for(int i = 0;i<6;i++){
		out[i] = read_Array_SortCore(&myCore);
		xil_printf("%d\n\r",out[i]);
	}
}

