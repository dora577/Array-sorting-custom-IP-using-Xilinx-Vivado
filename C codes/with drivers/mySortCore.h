/*
 * mySortCore.h
 *
 *  Created on: Apr 20, 2020
 *      Author: D577
 */
#include<xil_types.h>
#include<xil_io.h>

#ifndef SRC_SORTCORE_H_
#define SRC_SORTCORE_H_

typedef struct sortCore{
	u32 baseAddress;
}sortCore;

int initSortCore(sortCore* mySortCore,u32 baseAddress);

void start_SortCore(sortCore* mySortCore,u32 writeData);

void write_SortCore(sortCore* mySortCore,u32 writeData);

u32 read_status_SortCore(sortCore* mySortCore);

u32 read_Array_SortCore(sortCore* mySortCore);

#endif /* SRC_SORTCORE_H_ */
