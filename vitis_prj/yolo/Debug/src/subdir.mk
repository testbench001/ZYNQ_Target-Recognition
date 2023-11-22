################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
LD_SRCS += \
../src/lscript.ld 

C_SRCS += \
../src/dma_ctrl.c \
../src/main.c \
../src/platform.c \
../src/yolo_accel_ctrl.c \
../src/yolo_load_param.c 

OBJS += \
./src/dma_ctrl.o \
./src/main.o \
./src/platform.o \
./src/yolo_accel_ctrl.o \
./src/yolo_load_param.o 

C_DEPS += \
./src/dma_ctrl.d \
./src/main.d \
./src/platform.d \
./src/yolo_accel_ctrl.d \
./src/yolo_load_param.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v7 gcc compiler'
	arm-none-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -MT"$@" -mcpu=cortex-a9 -mfpu=vfpv3 -mfloat-abi=hard -ID:/28_YOLOv3-Tiny/ZYNQ_Prj/ch44/vitis_prj/design_1_wrapper/export/design_1_wrapper/sw/design_1_wrapper/standalone_domain/bspinclude/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


