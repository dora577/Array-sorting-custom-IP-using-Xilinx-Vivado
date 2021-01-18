/*
 * mySortCore.c
 *
 *  Created on: Apr 20, 2020
 *      Author: D577
 */

#include "mySortCore.h"


int initSortCore(sortCore* mySortCore,u32 baseAddress){
	mySortCore->baseAddress = baseAddress;
	return 0;

}

void start_SortCore(sortCore* mySortCore,u32 writeData){
	Xil_Out32(mySortCore -> baseAddress,writeData);
}

void write_SortCore(sortCore* mySortCore,u32 writeData){
	Xil_Out32(mySortCore -> baseAddress+8,writeData);
}


u32 read_status_SortCore(sortCore* mySortCore){
	return Xil_In32(mySortCore -> baseAddress+4);
}

u32 read_Array_SortCore(sortCore* mySortCore){
	return Xil_In32(mySortCore -> baseAddress+12);
}

