#include "xsdps.h"		/* SD device driver */
#include "ff.h"

#define	BIAS_STORE_BASEADDR		0x2000000
#define	ACT_STORE_BASEADDR		0x2003300
#define	WEIGHT_STORE_BASEADDR	0x2004000

FIL fil;		/* File object */
FATFS fatfs;
int BiasAddr[14];
int ActAddr[14];
int WeightAddr[14];

int SD_Init();
int SD_Write(char *FileName, u32 SourceAddress, u32 FileSize);
int SD_Read(char *FileName, u32 DestinationAddress, u32 FileSize);

void load_param();
