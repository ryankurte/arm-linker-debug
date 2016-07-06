
all: efm32 stm32

efm32:
	mkdir -p efm/build && cd efm/build && cmake .. && make

stm32:
	mkdir -p stm/build && cd stm/build && cmake .. && make

compare: efm32 stm32
	@echo "EFM32 __libc_init_array"
	cat efm/build/efm32.map | grep -B 1 __libc_init_array
	@echo "EFM32 __libc_init_array"
	cat stm/build/stm32.map | grep -B 1 __libc_init_array

