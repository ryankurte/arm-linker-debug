# ARM Linker Debugging

Some issue with the stm32f4-base project causes newlib nano not to be used when compiling for STM32. This was discovered in compiling for the STM32L1 platform (which causes hardfaults at __libc_init_array).  
Makefile.simple demonstrates the correct behaviour, where newlib nano is linked for both projects.  
Makefile demonstrates the difference between applications linked with the EFM32-Base and STM32F4 base projects, including the differing reference to newlib & newlib nano.  

The following are command outputs to be compared from the project.  

## Compile

### EFM

#### Assembly

arm-none-eabi-g++   -I./modules/efm32-base/device/EFM32GG/Include -I./modules/efm32-base/cmsis/Include -I./modules/efm32-base/emlib/inc -I../modules/efm32-base/include  -Wextra -Wall -Wno-unused-parameter **-mcpu=cortex-m3 -mthumb** -fno-builtin -ffunction-sections -fdata-sections -fomit-frame-pointer -DEFM32GG990F1024  -x assembler-with-cpp -DLOOP_ADDR=0x8000 -O0 -g -gdwarf-2   -o CMakeFiles/device.dir./modules/efm32-base/device/EFM32GG/Source/GCC/startup_efm32gg.S.obj -c ./modules/efm32-base/device/EFM32GG/Source/GCC/startup_efm32gg.S

#### C

arm-none-eabi-gcc   -I./modules/efm32-base/device/EFM32GG/Include -I./modules/efm32-base/cmsis/Include -I./modules/efm32-base/emlib/inc -I../modules/efm32-base/include  -std=gnu99 -Wextra -Wall -Wno-unused-parameter **-mcpu=cortex-m3 -mthumb** -fno-builtin -ffunction-sections -fdata-sections -fomit-frame-pointer -DEFM32GG990F1024  -mfix-cortex-m3-ldrd **--specs=nano.specs** -MMD -MP -O0 -g -gdwarf-2   -o CMakeFiles/device.dir./modules/efm32-base/device/EFM32GG/Source/system_efm32gg.c.obj   -c ./modules/efm32-base/device/EFM32GG/Source/system_efm32gg.c

### STM

#### Assembly

arm-none-eabi-g++   -I./modules/stm32f4-base/drivers/CMSIS/Include -I./modules/stm32f4-base/drivers/CMSIS/Device/ST/STM32F4xx/Include -I../modules/stm32f4-base/include  **-mcpu=cortex-m4 -mthumb** -x assembler-with-cpp -DLOOP_ADDR=0x8000 -O0 -g -gdwarf-2   -Wextra -Wall -Wno-unused-parameter -fno-builtin -ffunction-sections -fdata-sections -fomit-frame-pointer -DSTM32F429zit6 -DSTM32F429xx -DSTM32F4  -o CMakeFiles/device.dir./modules/stm32f4-base/drivers/CMSIS/Device/ST/STM32F4xx/Source/Templates/gcc/startup_stm32f429xx.s.obj -c ./modules/stm32f4-base/drivers/CMSIS/Device/ST/STM32F4xx/Source/Templates/gcc/startup_stm32f429xx.s

#### C

arm-none-eabi-gcc   -I./modules/stm32f4-base/drivers/CMSIS/Include -I./modules/stm32f4-base/drivers/CMSIS/Device/ST/STM32F4xx/Include -I../modules/stm32f4-base/include  -std=gnu99 **-mcpu=cortex-m4 -mthumb**  **--specs=nano.specs** -MMD -MP -O0 -g -gdwarf-2   -Wextra -Wall -Wno-unused-parameter -fno-builtin -ffunction-sections -fdata-sections -fomit-frame-pointer -DSTM32F429zit6 -DSTM32F429xx -DSTM32F4  -o CMakeFiles/device.dir./modules/stm32f4-base/drivers/CMSIS/Device/ST/STM32F4xx/Source/Templates/system_stm32f4xx.c.obj   -c ./modules/stm32f4-base/drivers/CMSIS/Device/ST/STM32F4xx/Source/Templates/system_stm32f4xx.c

## Archive

### EFM
arm-none-eabi-ar qc libdevice.a  CMakeFiles/device.dir./modules/efm32-base/device/EFM32GG/Source/GCC/startup_efm32gg.S.obj CMakeFiles/device.dir./modules/efm32-base/device/EFM32GG/Source/system_efm32gg.c.obj
arm-none-eabi-ranlib libdevice.a

### STM
arm-none-eabi-ar qc libdevice.a  CMakeFiles/device.dir./modules/stm32f4-base/drivers/CMSIS/Device/ST/STM32F4xx/Source/Templates/gcc/startup_stm32f429xx.s.obj CMakeFiles/device.dir./modules/stm32f4-base/drivers/CMSIS/Device/ST/STM32F4xx/Source/Templates/system_stm32f4xx.c.obj
arm-none-eabi-ranlib libdevice.a

## Link

### EFM

arm-none-eabi-g++   -Wextra -Wall -Wno-unused-parameter **-mcpu=cortex-m3 -mthumb** -fno-builtin -ffunction-sections -fdata-sections -fomit-frame-pointer -DEFM32GG990F1024  -mfix-cortex-m3-ldrd **--specs=nano.specs** -MMD -MP -O0 -g -gdwarf-2  -Wextra -Wall -Wno-unused-parameter **-mcpu=cortex-m3 -mthumb** -fno-builtin -ffunction-sections -fdata-sections -fomit-frame-pointer -DEFM32GG990F1024  -Xlinker -T./efm/build/efm32gg.ld -Wl,-Map=efm32.map -Wl,--gc-sections CMakeFiles/efm32.dir./main.cpp.obj  -o efm32 libdevice.a libemlib.a -lgcc -lc -lnosys -lgcc -lc -lnosys

### STM

arm-none-eabi-g++   **-mcpu=cortex-m4 -mthumb**  **--specs=nano.specs** -MMD -MP -O0 -g -gdwarf-2  **-mcpu=cortex-m4 -mthumb** -Xlinker -Tstm32.ld -Wl,-Map=stm32.map -Wl,--gc-sections CMakeFiles/stm32.dir./main.cpp.obj  -o stm32 libdevice.a -lgcc -lc -lnosys

