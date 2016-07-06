# Base STM32F4 CMake file
#
# This can be used as is as a project base, or by adding the stm32f4-base
# repository as a submodule to another project, copying this CMakeLists file
# to the top level directory, and updating the BASE_LOCATION variable to reflect this
# change

###### Project Environment #####

# Set minimum CMake version
cmake_minimum_required(VERSION 2.8.4)

# Set stm32-base project location
set(BASE_LOCATION ../modules/stm32f4-base)

# Set the compiler (must be prior to project setup)
include(${BASE_LOCATION}/toolchain/arm-gcc.cmake)

##### Project Setup #####

# Set our output target
set(TARGET stm32)

# Configure project and languages
project(${TARGET} C CXX ASM)

# Set device
if(NOT DEVICE)
set(DEVICE STM32F429zit6)
endif()

# Set build
if(NOT CMAKE_BUILD_TYPE)
set(CMAKE_BUILD_TYPE DEBUG)
endif()

##### Modules #####

# Libraries can be added to the LIBS variable
# or manually included here.

# Add base libs (emlib, CMSIS, device files)
include(${BASE_LOCATION}/toolchain/stm32-base.cmake)

##### Files #####

# Add project headers
include_directories(${BASE_LOCATION}/include)

# Add project sources
set(SOURCES
    ../main.cpp
)

##### Outputs #####

# Generate executable and link
add_executable(${TARGET} ${SOURCES})
target_link_libraries(${TARGET} device c gcc nosys)

##### Post build (require target to be defined) #####

# Add post build commands
include(${BASE_LOCATION}/toolchain/post-build.cmake)

# Add STLink commands
include(${BASE_LOCATION}/toolchain/stlink.cmake)

