
CXX=arm-none-eabi-g++
CFLAGS=-mcpu=cortex-m3 -mthumb --specs=nano.specs main.cpp 
LFLAGS=-Xlinker 
LIBS=-lc -lgcc -lnosys -lc -lgcc -lnosys

SIZE=arm-none-eabi-size

all: build-efm build-stm

build-efm:
	@$(CXX) $(CFLAGS) -o efm32.a $(LFLAGS) -Map=efm32.map -Tefm/efm32.ld efm/libdevice.a $(LIBS)
    
build-stm:
	@$(CXX) $(CFLAGS) -o stm32.a $(LFLAGS) -Map=stm32.map -Tstm/stm32.ld stm/libdevice.a $(LIBS)

compare: build-stm build-efm
	@echo "EFM"
	@cat efm32.map | grep -B 1 __libc_init_array
	@echo "STM"
	@cat stm32.map | grep -B 1 __libc_init_array



