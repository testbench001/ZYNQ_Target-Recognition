#ifndef DMA_CTRL_H
#define	DMA_CTRL_H

#include "xaxidma.h"
#include "xil_cache.h"
#include "xil_io.h"
#include "xil_types.h"

void DMA_Init();
void DMA_Tx(u32 TxAddr, u32 Length);
void DMA_Rx(u32 RxAddr, u32 Length);



#endif
