#
# This file was created by Xilinx Vitis tool.
#


#
# tools
#

RM = rm -f
RMDIR = rm -rf

#
# variables
#

SDCARD_GEN = sdcard_gen
GENERATE_BIF = ::scw::generate_bif

XPFM_PATH = D:/28_YOLOv3-Tiny/ZYNQ_Prj/ch44/vitis_prj/design_1_wrapper/export/design_1_wrapper/design_1_wrapper.xpfm
SYS_CONFIG = design_1_wrapper
DOMAINS = standalone_domain
BIF_PATH = D:/28_YOLOv3-Tiny/ZYNQ_Prj/ch44/vitis_prj/yolo_system/Debug/system.bif

BITSTREAM_PATH = D:/28_YOLOv3-Tiny/ZYNQ_Prj/ch44/vitis_prj/yolo/_ide/bitstream/design_1_wrapper.bit
SD_FILES = --elf D:/28_YOLOv3-Tiny/ZYNQ_Prj/ch44/vitis_prj/yolo/Debug/yolo.elf,ps7_cortexa9_0

#
# primary build targets
#

all: sd_card

sd_card:
	-@echo Generating bif file for the system project
	generate_system_bif.bat 58084 ${XPFM_PATH} ${DOMAINS} ${BIF_PATH}
	${SDCARD_GEN} --xpfm ${XPFM_PATH} --sys_config ${SYS_CONFIG} --bif ${BIF_PATH} --bitstream ${BITSTREAM_PATH} ${SD_FILES}

clean:
	$(RMDIR) ./_sds
	${RMDIR} sd_card
	${RM} system.bif

.PHONY: all sd_card clean


