# ARM Linker Debugging

Some issue with the stm32f4-base project causes newlib nano not to be used when compiling for STM32. This was discovered in compiling for the STM32L1 platform (which causes hardfaults at __libc_init_array).  
Makefile.simple demonstrates the correct behaviour, where newlib nano is linked for both projects.  
Makefile demonstrates the difference between applications linked with the EFM32-Base and STM32F4 base projects, including the differing reference to newlib & newlib nano.  

The following are command outputs to be compared from the project.  

## Compile ASM

### EFM
arm-none-eabi-g++  -DEFM32GG990F1024 -I./armdbg/modules/efm32-base/device/EFM32GG/Include -I./armdbg/modules/efm32-base/cmsis/Include -I./armdbg/modules/efm32-base/emlib/inc -I./modules/efm32-base/include  -Wextra -Wall -Wno-unused-parameter **-mcpu=cortex-m3 -mthumb** -fno-builtin -ffunction-sections -fdata-sections -fomit-frame-pointer  -x assembler-with-cpp -DLOOP_ADDR=0x8000 -O0 -g -gdwarf-2   -o CMakeFiles/device.dir./armdbg/modules/efm32-base/device/EFM32GG/Source/GCC/startup_efm32gg.S.obj -c ./armdbg/modules/efm32-base/device/EFM32GG/Source/GCC/startup_efm32gg.S

### STM
arm-none-eabi-g++   -I./armdbg/modules/stm32f4-base/drivers/CMSIS/Include -I./armdbg/modules/stm32f4-base/drivers/CMSIS/Device/ST/STM32F4xx/Include -I./modules/stm32f4-base/include  -Wextra -Wall -Wno-unused-parameter **-mcpu=cortex-m4 -mthumb** -fno-builtin -ffunction-sections -fdata-sections -fomit-frame-pointer  -x assembler-with-cpp -DLOOP_ADDR=0x8000 -O0 -g -gdwarf-2   -DSTM32F429zit6 -DSTM32F429xx -DSTM32F4  -o CMakeFiles/device.dir./armdbg/modules/stm32f4-base/drivers/CMSIS/Device/ST/STM32F4xx/Source/Templates/gcc/startup_stm32f429xx.s.obj -c ./armdbg/modules/stm32f4-base/drivers/CMSIS/Device/ST/STM32F4xx/Source/Templates/gcc/startup_stm32f429xx.s

## Compile C

### EFM
arm-none-eabi-g++   -DEFM32GG990F1024 -I./armdbg/modules/efm32-base/device/EFM32GG/Include -I./armdbg/modules/efm32-base/cmsis/Include -I./armdbg/modules/efm32-base/emlib/inc -I./modules/efm32-base/include  -Wextra -Wall -Wno-unused-parameter **-mcpu=cortex-m3 -mthumb** -fno-builtin -ffunction-sections -fdata-sections -fomit-frame-pointer  -mfix-cortex-m3-ldrd **--specs=nano.specs** -MMD -MP -O0 -g -gdwarf-2   -o CMakeFiles/efm32.dir./armdbg/main.cpp.obj -c ./armdbg/main.cpp

### STM
arm-none-eabi-g++    -I./armdbg/modules/stm32f4-base/drivers/CMSIS/Include -I./armdbg/modules/stm32f4-base/drivers/CMSIS/Device/ST/STM32F4xx/Include -I./modules/stm32f4-base/include  -Wextra -Wall -Wno-unused-parameter **-mcpu=cortex-m4 -mthumb** -fno-builtin -ffunction-sections -fdata-sections -fomit-frame-pointer   **--specs=nano.specs** -MMD -MP -O0 -g -gdwarf-2   -DSTM32F429zit6 -DSTM32F429xx -DSTM32F4  -o CMakeFiles/stm32.dir./armdbg/main.cpp.obj -c ./armdbg/main.cpp

## Archive

### EFM
arm-none-eabi-ar qc libdevice.a  CMakeFiles/device.dir./armdbg/modules/efm32-base/device/EFM32GG/Source/GCC/startup_efm32gg.S.obj CMakeFiles/device.dir./armdbg/modules/efm32-base/device/EFM32GG/Source/system_efm32gg.c.obj
arm-none-eabi-ranlib libdevice.a

### STM
arm-none-eabi-ar qc libdevice.a  CMakeFiles/device.dir./armdbg/modules/stm32f4-base/drivers/CMSIS/Device/ST/STM32F4xx/Source/Templates/gcc/startup_stm32f429xx.s.obj CMakeFiles/device.dir./armdbg/modules/stm32f4-base/drivers/CMSIS/Device/ST/STM32F4xx/Source/Templates/system_stm32f4xx.c.obj
arm-none-eabi-ranlib libdevice.a

## Link

### EFM
/usr/local/Cellar/cmake/3.5.2/bin/cmake -E cmake_link_script CMakeFiles/efm32.dir/link.txt --verbose=1
arm-none-eabi-g++   -Wextra -Wall -Wno-unused-parameter **-mcpu=cortex-m3 -mthumb** -fno-builtin -ffunction-sections -fdata-sections -fomit-frame-pointer  -mfix-cortex-m3-ldrd **--specs=nano.specs** -MMD -MP -O0 -g -gdwarf-2  -Wextra -Wall -Wno-unused-parameter **-mcpu=cortex-m3 -mthumb** -fno-builtin -ffunction-sections -fdata-sections -fomit-frame-pointer  -Xlinker -T./armdbg/efm/build/efm32gg.ld -Wl,-Map=efm32.map -Wl,--gc-sections CMakeFiles/efm32.dir./armdbg/main.cpp.obj  -o efm32 libdevice.a -lc -lgcc -lnosys -lc -lgcc -lnosys

### STM
/usr/local/Cellar/cmake/3.5.2/bin/cmake -E cmake_link_script CMakeFiles/stm32.dir/link.txt --verbose=1
arm-none-eabi-g++   -Wextra -Wall -Wno-unused-parameter **-mcpu=cortex-m4 -mthumb** -fno-builtin -ffunction-sections -fdata-sections -fomit-frame-pointer   **--specs=nano.specs** -MMD -MP -O0 -g -gdwarf-2  -Wextra -Wall -Wno-unused-parameter **-mcpu=cortex-m4 -mthumb** -fno-builtin -ffunction-sections -fdata-sections -fomit-frame-pointer  -Xlinker -Tstm32.ld -Wl,-Map=stm32.map -Wl,--gc-sections CMakeFiles/stm32.dir./armdbg/main.cpp.obj  -o stm32 libdevice.a -lc -lgcc -lnosys

