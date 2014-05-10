################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CU_SRCS += \
../src/TestDemo.cu 

CU_DEPS += \
./src/TestDemo.d 

OBJS += \
./src/TestDemo.o 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.cu
	@echo 'Building file: $<'
	@echo 'Invoking: NVCC Compiler'
	/usr/local/cuda-5.5/bin/nvcc -G -g -O0 -gencode arch=compute_12,code=sm_12 -odir "src" -M -o "$(@:%.o=%.d)" "$<"
	/usr/local/cuda-5.5/bin/nvcc --compile -G -O0 -g -gencode arch=compute_12,code=compute_12 -gencode arch=compute_12,code=sm_12  -x cu -o  "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


