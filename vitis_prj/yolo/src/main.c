#include "xil_printf.h"
#include "xplatform_info.h"
#include "xil_exception.h"
#include "xscugic.h"
#include "yolo_load_param.h"
#include "yolo_accel_ctrl.h"
#include "dma_ctrl.h"


#define INTC_DEVICE_ID		XPAR_SCUGIC_0_DEVICE_ID
#define INTC_DEVICE_INT_ID	XPS_FPGA0_INT_ID


XScuGic InterruptController; 	     /* Instance of the Interrupt Controller */
static XScuGic_Config *GicConfig;    /* The configuration parameters of the
                                       controller */

void DeviceDriverHandler(void *CallbackRef);
int Intr_init();

static char FileName0[32] = "img_data.bin";




int main()
{
	SD_Init();
	DMA_Init();
	Intr_init();
	// 读取Bin文件至 DDR3内存
	SD_Read(FileName0, 0x1000000, 1384448);
	load_param();
	yolo_forward();

	/*

	Xil_Out32(Lite_Reg2, 0x09004100);
	Xil_Out32(Lite_Reg1, 0x4B5A0000);
	Xil_Out32(Lite_Reg0, 0x21);			// 发送bias数据
	DMA_Tx(0x2000000, 64);
	wait_pl_finish();

	Xil_Out32(Lite_Reg0, 0x31);			// 发送LeakyRelu数据
	DMA_Tx(0x2000040, 256);
	wait_pl_finish();

	Xil_Out32(Lite_Reg0, 0x11);			// 发送Weight数据
	DMA_Tx(0x2000140, 1152);
	wait_pl_finish();

	Xil_Out32(Lite_Reg0, 0x101181);		// 发送Feature数据
	DMA_Tx(0x1000000, 29952);
	wait_pl_finish();
	Xil_Out32(Lite_Reg0, 0x101184);		// 卷积计算
	wait_pl_finish();

	Xil_Out32(Lite_Reg0, 0x2);			// 将PL端的数据传至PS端
	DMA_Rx(0x3000000, 6656);			// 9行数据+1行填充=10行数据 --->卷积后，8个416的数据量---》经过池化后，变成4*208---> 总共8个通道，即最终数据量4*208*8=6656
	wait_pl_finish();

	// 不包含第一次发送和最后一次发送数据的计算过程，共循环58次
	int tx_addr = 0x1000000;
	int rx_addr = 0x3000000;
	for(int i=0; i<=57; i++) {
		Xil_Out32(Lite_Reg0, 0x101381);			// 发送Feature数据
		tx_addr = tx_addr + 23296;
		DMA_Tx(tx_addr, 29952);
		wait_pl_finish();
		Xil_Out32(Lite_Reg0, 0x101384);			// 卷积计算
		wait_pl_finish();
		if(i%2 == 0) {
			rx_addr = rx_addr + 6656;
			Xil_Out32(Lite_Reg0, 0x2);			// 将PL端的数据传至PS端
			DMA_Rx(rx_addr, 4992);				//
			wait_pl_finish();
		}
		else {
			rx_addr = rx_addr + 4992;
			Xil_Out32(Lite_Reg0, 0x2);			// 将PL端的数据传至PS端
			DMA_Rx(rx_addr, 6656);
			wait_pl_finish();
		}
	}

	// Layer0 前8个输出通道的最后一次发送数据
	tx_addr = tx_addr + 23296;
	Xil_Out32(Lite_Reg0, 0x41581);		// 发送Feature数据
	DMA_Tx(tx_addr, 9984);
	wait_pl_finish();
	Xil_Out32(Lite_Reg0, 0x41584);		// 卷积计算
	wait_pl_finish();
	rx_addr = rx_addr + 6656;
	Xil_Out32(Lite_Reg0, 0x2);			// 将PL端的数据传至PS端
	DMA_Rx(rx_addr, 1664);
	wait_pl_finish();
//////////////////////////////////////////////////////////
	Xil_Out32(Lite_Reg1, 0x4B5A0101);
	Xil_Out32(Lite_Reg0, 0x101181);		// 发送Feature数据
	DMA_Tx(0x1000000, 29952);
	wait_pl_finish();
	Xil_Out32(Lite_Reg0, 0x101184);		// 卷积计算
	wait_pl_finish();

	Xil_Out32(Lite_Reg0, 0x2);			// 将PL端的数据传至PS端
	DMA_Rx(0x3054800, 6656);			// 9行数据+1行填充=10行数据 --->卷积后，8个416的数据量---》经过池化后，变成4*208---> 总共8个通道，即最终数据量4*208*8=6656
	wait_pl_finish();

	// 不包含第一次发送和最后一次发送数据的计算过程，共循环58次
	tx_addr = 0x1000000;
	rx_addr = 0x3054800;
	for(int i=0; i<=57; i++) {
		Xil_Out32(Lite_Reg0, 0x101381);			// 发送Feature数据
		tx_addr = tx_addr + 23296;
		DMA_Tx(tx_addr, 29952);
		wait_pl_finish();
		Xil_Out32(Lite_Reg0, 0x101384);			// 卷积计算
		wait_pl_finish();
		if(i%2 == 0) {
			rx_addr = rx_addr + 6656;
			Xil_Out32(Lite_Reg0, 0x2);			// 将PL端的数据传至PS端
			DMA_Rx(rx_addr, 4992);				//
			wait_pl_finish();
		}
		else {
			rx_addr = rx_addr + 4992;
			Xil_Out32(Lite_Reg0, 0x2);			// 将PL端的数据传至PS端
			DMA_Rx(rx_addr, 6656);
			wait_pl_finish();
		}
	}

	// Layer0 前8个输出通道的最后一次发送数据
	tx_addr = tx_addr + 23296;
	Xil_Out32(Lite_Reg0, 0x41581);		// 发送Feature数据
	DMA_Tx(tx_addr, 9984);
	wait_pl_finish();
	Xil_Out32(Lite_Reg0, 0x41584);		// 卷积计算
	wait_pl_finish();
	rx_addr = rx_addr + 6656;
	Xil_Out32(Lite_Reg0, 0x2);			// 将PL端的数据传至PS端
	DMA_Rx(rx_addr, 1664);
	wait_pl_finish();
*/
	Xil_DCacheFlushRange(0x3054800, 0x54800);

	return 0;

}



void DeviceDriverHandler(void *CallbackRef)
{
	/*
	 * Indicate the interrupt has been processed using a shared variable
	 */
	InterruptProcessed = TRUE;
}

int Intr_init()
{
	int Status;

	/*
	 * Initialize the interrupt controller driver so that it is ready to
	 * use.
	 */
	GicConfig = XScuGic_LookupConfig(INTC_DEVICE_ID);
	if (NULL == GicConfig) {
		return XST_FAILURE;
	}

	Status = XScuGic_CfgInitialize(&InterruptController, GicConfig,
					GicConfig->CpuBaseAddress);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}


	Xil_ExceptionInit();
	/*
	 * Connect the interrupt controller interrupt handler to the hardware
	 * interrupt handling logic in the ARM processor.
	 */
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
			(Xil_ExceptionHandler) XScuGic_InterruptHandler,
			&InterruptController);

	/*
	 * Enable interrupts in the ARM
	 */
	Xil_ExceptionEnable();

	/*
	 * Connect a device driver handler that will be called when an
	 * interrupt for the device occurs, the device driver handler performs
	 * the specific interrupt processing for the device
	 */
	Status = XScuGic_Connect(&InterruptController, INTC_DEVICE_INT_ID,
			   (Xil_ExceptionHandler)DeviceDriverHandler,
			   (void *)&InterruptController);

	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	XScuGic_SetPriTrigTypeByDistAddr(&InterruptController, INTC_DEVICE_INT_ID, 0x0, 0x3);

	/*
	 * Enable the interrupt for the device and then cause (simulate) an
	 * interrupt so the handlers will be called
	 */
	XScuGic_Enable(&InterruptController, INTC_DEVICE_INT_ID);

	return 0;
}



