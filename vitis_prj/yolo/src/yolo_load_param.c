#include "yolo_load_param.h"



char FileBias[13][32] 		= {"l0_b.bin", "l2_b.bin", "l4_b.bin", "l6_b.bin", "l8_b.bin", "l10_b.bin", "l12_b.bin",
                         	 	"l13_b.bin", "l14_b.bin", "l15_b.bin", "l8_b.bin", "l21_b.bin", "l22_b.bin"};
char FileLeakyRelu[13][32] 	= {"l0_r.bin", "l2_r.bin", "l4_r.bin", "l6_r.bin", "l8_r.bin", "l10_r.bin", "l12_r.bin",
                         	 	"l13_r.bin", "l14_r.bin", "l15_r.bin", "l8_r.bin", "l21_r.bin", "l22_r.bin"};
char FileWeight[13][32] 	= {"l0_w.bin", "l2_w.bin", "l4_w.bin", "l6_w.bin", "l8_w.bin", "l10_w.bin", "l12_w.bin",
                         	 	"l13_w.bin", "l14_w.bin", "l15_w.bin", "l8_w.bin", "l21_w.bin", "l22_w.bin"};
int BiasAddr[14] = {BIAS_STORE_BASEADDR,
                    BIAS_STORE_BASEADDR+16*4,
                    BIAS_STORE_BASEADDR+(16+32)*4,
                    BIAS_STORE_BASEADDR+(16+32+64)*4,
                    BIAS_STORE_BASEADDR+(16+32+64+128)*4,
                    BIAS_STORE_BASEADDR+(16+32+64+128+256)*4,
                    BIAS_STORE_BASEADDR+(16+32+64+128+256+512)*4,
                    BIAS_STORE_BASEADDR+(16+32+64+128+256+512+1024)*4,
                    BIAS_STORE_BASEADDR+(16+32+64+128+256+512+1024+256)*4,
                    BIAS_STORE_BASEADDR+(16+32+64+128+256+512+1024+256+512)*4,
                    BIAS_STORE_BASEADDR+(16+32+64+128+256+512+1024+256+512+24)*4,
                    BIAS_STORE_BASEADDR+(16+32+64+128+256+512+1024+256+512+24+128)*4,
                    BIAS_STORE_BASEADDR+(16+32+64+128+256+512+1024+256+512+24+128+256)*4,
                    BIAS_STORE_BASEADDR+(16+32+64+128+256+512+1024+256+512+24+128+256+24)*4};

int ActAddr[14] =  {ACT_STORE_BASEADDR,
		    ACT_STORE_BASEADDR+256,
		    ACT_STORE_BASEADDR+256*2,
		    ACT_STORE_BASEADDR+256*3,
		    ACT_STORE_BASEADDR+256*4,
		    ACT_STORE_BASEADDR+256*5,
		    ACT_STORE_BASEADDR+256*6,
		    ACT_STORE_BASEADDR+256*7,
		    ACT_STORE_BASEADDR+256*8,
		    ACT_STORE_BASEADDR+256*9,
		    ACT_STORE_BASEADDR+256*10,
		    ACT_STORE_BASEADDR+256*11,
		    ACT_STORE_BASEADDR+256*12,
		    ACT_STORE_BASEADDR+256*13};

int WeightAddr[14] =   {WEIGHT_STORE_BASEADDR,
                        WEIGHT_STORE_BASEADDR+16*8*9,
                        WEIGHT_STORE_BASEADDR+16*8*9+32*16*9,
                        WEIGHT_STORE_BASEADDR+16*8*9+32*16*9+64*32*9,
                        WEIGHT_STORE_BASEADDR+16*8*9+32*16*9+64*32*9+128*64*9,
                        WEIGHT_STORE_BASEADDR+16*8*9+32*16*9+64*32*9+128*64*9+256*128*9,
                        WEIGHT_STORE_BASEADDR+16*8*9+32*16*9+64*32*9+128*64*9+256*128*9+512*256*9,
                        WEIGHT_STORE_BASEADDR+16*8*9+32*16*9+64*32*9+128*64*9+256*128*9+512*256*9+1024*512*9,
                        WEIGHT_STORE_BASEADDR+16*8*9+32*16*9+64*32*9+128*64*9+256*128*9+512*256*9+1024*512*9+256*1024,
                        WEIGHT_STORE_BASEADDR+16*8*9+32*16*9+64*32*9+128*64*9+256*128*9+512*256*9+1024*512*9+256*1024+512*256*9,
                        WEIGHT_STORE_BASEADDR+16*8*9+32*16*9+64*32*9+128*64*9+256*128*9+512*256*9+1024*512*9+256*1024+512*256*9+24*512,
                        WEIGHT_STORE_BASEADDR+16*8*9+32*16*9+64*32*9+128*64*9+256*128*9+512*256*9+1024*512*9+256*1024+512*256*9+24*512+128*256,
                        WEIGHT_STORE_BASEADDR+16*8*9+32*16*9+64*32*9+128*64*9+256*128*9+512*256*9+1024*512*9+256*1024+512*256*9+24*512+128*256+256*384*9,
                        WEIGHT_STORE_BASEADDR+16*8*9+32*16*9+64*32*9+128*64*9+256*128*9+512*256*9+1024*512*9+256*1024+512*256*9+24*512+128*256+256*384*9+24*256};

void load_param()
{
	//////////////////////////////////////
	// Bias
	//////////////////////////////////////
	for(int i=0; i<13; i++) {
		SD_Read(FileBias[i], BiasAddr[i], BiasAddr[i+1]-BiasAddr[i]);
	}
	//////////////////////////////////////
	// LeakyRelu
	//////////////////////////////////////
	for(int i=0; i<13; i++) {
		SD_Read(FileLeakyRelu[i], ActAddr[i], ActAddr[i+1]-ActAddr[i]);
	}
	//////////////////////////////////////
	// Weight
	//////////////////////////////////////
	for(int i=0; i<13; i++) {
		SD_Read(FileWeight[i], WeightAddr[i], WeightAddr[i+1]-WeightAddr[i]);
	}
}
int SD_Init()
{
	FRESULT Res;
	/*
	 * To test logical drive 0, Path should be "0:/"
	 * For logical drive 1, Path should be "1:/"
	 */
	TCHAR *Path = "0:/";

	/*
	 * Register volume work area, initialize device
	 */
	Res = f_mount(&fatfs, Path, 0);

	if (Res != FR_OK) {
		return XST_FAILURE;
	}

	/*
	 * Path - Path to logical driver, 0 - FDISK format.
	 * 0 - Cluster size is automatically determined based on Vol size.
	 */
//	Res = f_mkfs(Path, FM_FAT32, 0, work, sizeof work);
//	if (Res != FR_OK) {
//		return XST_FAILURE;
//	}
	return XST_SUCCESS;
}

int SD_Write(char *FileName, u32 SourceAddress, u32 FileSize)
{
	FRESULT Res;
	UINT NumBytesWritten;

	Res = f_open(&fil, FileName, FA_CREATE_ALWAYS | FA_WRITE);
	if (Res) {
		return XST_FAILURE;
	}

	/*
	 * Pointer to beginning of file .
	 */
	Res = f_lseek(&fil, 0);
	if (Res) {
		return XST_FAILURE;
	}

	/*
	 * Write data to file.
	 */
	Res = f_write(&fil, (const void*)SourceAddress, FileSize,
			&NumBytesWritten);
	if (Res) {
		return XST_FAILURE;
	}


	/*
	 * Close file.
	 */
	Res = f_close(&fil);
	if (Res) {
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}

int SD_Read(char *FileName, u32 DestinationAddress, u32 FileSize)
{
	FRESULT Res;
	UINT NumBytesRead;

	Res = f_open(&fil, FileName, FA_READ);
	if (Res) {
		return XST_FAILURE;
	}

	/*
	 * Pointer to beginning of file .
	 */
	Res = f_lseek(&fil, 0);
	if (Res) {
		return XST_FAILURE;
	}

	/*
	 * Write data to file.
	 */
	Res = f_read(&fil, (const void*)DestinationAddress, FileSize,
			&NumBytesRead);
	if (Res) {
		return XST_FAILURE;
	}


	/*
	 * Close file.
	 */
	Res = f_close(&fil);
	if (Res) {
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}
