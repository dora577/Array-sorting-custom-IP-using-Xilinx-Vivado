#include<xil_types.h>
#include<xil_io.h>
#include"xparameters.h"


int main(){

	u32 a[] = {6,5,4,3,2,1};
	u32 out[6];
	u32 status;


	for(int i = 0;i<6;i++){
		Xil_Out32(XPAR_MYSORTCORE_V1_0_0_BASEADDR+8,a[i]);
		}

		status = Xil_In32(XPAR_MYSORTCORE_V1_0_0_BASEADDR+4);


		while(!status)
			status = Xil_In32(XPAR_MYSORTCORE_V1_0_0_BASEADDR+4);

		for(int i = 0;i<6;i++){
			out[i] = Xil_In32(XPAR_MYSORTCORE_V1_0_0_BASEADDR+12);
			xil_printf("%d\n\r",out[i]);
		}

}

