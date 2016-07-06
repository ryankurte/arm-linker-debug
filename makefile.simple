
CXX=arm-none-eabi-g++
CFLAGS=-mcpu=cortex-m3 -mthumb 
SPECS=--specs=nano.specs
LFLAGS=-Xlinker 
LIBS=-lc -lgcc -lnosys -lc -lgcc -lnosys

SIZE=arm-none-eabi-size

all: build-efm build-stm

build-efm:
	$(CXX) $(CFLAGS) main.cpp -o efm32.o -c
	$(CXX) $(CFLAGS) $(SPECS) -o efm32.elf $(LFLAGS) -Map=efm32.map -Tefm/efm32.ld efm32.o efm/libdevice.a $(LIBS)
    
build-stm:
	$(CXX) $(CFLAGS) main.cpp -o stm32.o -c
	$(CXX) $(CFLAGS) $(SPECS) -o stm32.elf $(LFLAGS) -Map=stm32.map -Tstm/stm32.ld stm32.o stm/libdevice.a $(LIBS)

compare: build-stm build-efm
	@echo "EFM"
	cat efm32.map | grep -B 1 __libc_init_array | grep armv7-m
	@echo "STM"
	cat stm32.map | grep -B 1 __libc_init_array | grep armv7-m

clean:
	@rm -f *.o *.map *.elf *.a

