#
# Toolchain
#
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR ARM)

set(WITH_SOFTDEVICE FALSE)
set(SOFTDEVICE "s140")
set(NRF_SD_BLE_API_VERSION "52_7.2.0")

# Find the nrf sdk root
if(EXISTS "$ENV{NRF_SDK_ROOT}")
    file(TO_CMAKE_PATH "$ENV{NRF_SDK_ROOT}" NRF_SDK_ROOT)
else()
    message(FATAL_ERROR "nRF-sdk not found! Please set the environment variable NRF_SDK_ROOT")
endif()


set(TOOLCHAIN_PREFIX "arm-none-eabi-")
set(CMAKE_C_COMPILER ${TOOLCHAIN_PREFIX}gcc)
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_PREFIX}g++)
set(CMAKE_ASM_COMPILER ${CMAKE_C_COMPILER})

# Find the toolchain bin directory
execute_process(COMMAND which ${CMAKE_C_COMPILER} OUTPUT_VARIABLE ARM_TOOLCHAIN_DIR OUTPUT_STRIP_TRAILING_WHITESPACE)
if("${ARM_TOOLCHAIN_DIR}" STREQUAL "")
    message(FATAL_ERROR "C compiler not found (${CMAKE_C_COMPILER})")
endif()

execute_process(COMMAND dirname ${ARM_TOOLCHAIN_DIR} OUTPUT_VARIABLE ARM_TOOLCHAIN_DIR OUTPUT_STRIP_TRAILING_WHITESPACE)
message(STATUS "Toolchain path: ${ARM_TOOLCHAIN_DIR}")

# Set root path for include and libs search
set(CMAKE_SYSROOT "${ARM_TOOLCHAIN_DIR}/../arm-none-eabi")
message(STATUS "CMake sysroot: ${CMAKE_SYSROOT}")


include_directories(SYSTEM 
    ${NRF_SDK_ROOT}/components
    ${NRF_SDK_ROOT}/modules/nrfx/mdk
    ${NRF_SDK_ROOT}/components/softdevice/mbr/headers
    ${NRF_SDK_ROOT}/components/libraries/strerror
    ${NRF_SDK_ROOT}/components/toolchain/cmsis/include
    ${NRF_SDK_ROOT}/components/libraries/util
    ${CMAKE_SOURCE_DIR}/config
    ${NRF_SDK_ROOT}/components/libraries/balloc
    ${NRF_SDK_ROOT}/components/libraries/ringbuf
    ${NRF_SDK_ROOT}/modules/nrfx/hal
    ${NRF_SDK_ROOT}/components/libraries/bsp
    ${NRF_SDK_ROOT}/components/libraries/log
    ${NRF_SDK_ROOT}/modules/nrfx
    ${NRF_SDK_ROOT}/components/libraries/experimental_section_vars
    ${NRF_SDK_ROOT}/components/libraries/delay
    ${NRF_SDK_ROOT}/integration/nrfx
    ${NRF_SDK_ROOT}/components/drivers_nrf/nrf_soc_nosd
    ${NRF_SDK_ROOT}/components/libraries/atomic
    ${NRF_SDK_ROOT}/components/boards
    ${NRF_SDK_ROOT}/components/libraries/memobj
    ${NRF_SDK_ROOT}/external/fprintf
    ${NRF_SDK_ROOT}/components/libraries/log/src)

    
#
# C flags common
#
set(CFLAGS "-DBOARD_CUSTOM")
# set(CFLAGS "${CFLAGS} -DCONFIG_GPIO_AS_PINRESET")
set(CFLAGS "${CFLAGS} -DFLOAT_ABI_HARD")
set(CFLAGS "${CFLAGS} -DMBR_PRESENT")
set(CFLAGS "${CFLAGS} -DNRF52840_XXAA")
set(CFLAGS "${CFLAGS} -mcpu=cortex-m4")
set(CFLAGS "${CFLAGS} -march=armv7e-m")
set(CFLAGS "${CFLAGS} -mthumb")
set(CFLAGS "${CFLAGS} -mabi=aapcs")
#set(CFLAGS "${CFLAGS} -mfloat-abi=hard") 
set(CFLAGS "${CFLAGS} -mfpu=fpv4-sp-d16")
set(CFLAGS "${CFLAGS} -Wall -Werror -Wno-expansion-to-defined")
# Keep every function in a separate section, this allows linker to discard unused ones
set(CFLAGS "${CFLAGS} -ffunction-sections -fdata-sections -fno-strict-aliasing")
set(CFLAGS "${CFLAGS} -fno-builtin -fshort-enums")
if(${WITH_SOFTDEVICE})
    set(CFLAGS "${CFLAGS} -DNRF_SD_BLE_API_VERSION=${NRF_SD_BLE_API_VERSION}")
    set(CFLAGS "${CFLAGS} -D${SOFTDEVICE}")
    set(CFLAGS "${CFLAGS} -DSOFTDEVICE_PRESENT")
    set(CFLAGS "${CFLAGS} -DSWI_DISABLE0")
else()
    set(CFLAGS "${CFLAGS} -DBSP_DEFINES_ONLY")
endif()
set(CFLAGS "${CFLAGS} -D__HEAP_SIZE=8192")
set(CFLAGS "${CFLAGS} -D__STACK_SIZE=8192")

#
# C++ flags common
#
set(CXXFLAGS ${CFLAGS})

#
# Default C compiler flags
#
set(CMAKE_C_FLAGS_DEBUG_INIT "-g3 -Og -Wall -pedantic -DDEBUG ${CFLAGS}")
set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG_INIT}" CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS_RELEASE_INIT "-O3 -Wall ${CFLAGS}")
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE_INIT}" CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS_MINSIZEREL_INIT "-Os -Wall ${CFLAGS}")
set(CMAKE_C_FLAGS_MINSIZEREL "${CMAKE_C_FLAGS_MINSIZEREL_INIT}" CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS_RELWITHDEBINFO_INIT  "-O2 -g -Wall ${CFLAGS}")
set(CMAKE_C_FLAGS_RELWITHDEBINFO "${CMAKE_ASM_FLAGS_RELWITHDEBINFO_INIT}" CACHE STRING "" FORCE)

#
# Default C++ compiler flags
#
set(CMAKE_CXX_FLAGS_DEBUG_INIT "-g3 -Og -Wall -pedantic -DDEBUG ${CXXFLAGS}")
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG_INIT}" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS_RELEASE_INIT "-O3 -Wall ${CXXFLAGS}")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE_INIT}" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS_MINSIZEREL_INIT "-Os -Wall ${CXXFLAGS}")
set(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_C_FLAGS_MINSIZEREL_INIT}" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO_INIT  "-O2 -g -Wall ${CXXFLAGS}")
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_ASM_FLAGS_RELWITHDEBINFO_INIT}" CACHE STRING "" FORCE)

#
# Linker flags
#
set(LDFLAGS "-mcpu=cortex-m4")
set(LDFLAGS "-march=armv7e-m")
set(LDFLAGS "${LDFLAGS} -mthumb")
set(LDFLAGS "${LDFLAGS} -mabi=aapcs")
#set(LDFLAGS "${LDFLAGS} -mfloat-abi=hard")
set(LDFLAGS "${LDFLAGS} -mfpu=fpv4-sp-d16")
# Let linker dump unused sections
set(LDFLAGS "${LDFLAGS} -Wl,--gc-sections")
# Use newlib in nano version
set(LDFLAGS "${LDFLAGS} --specs=nano.specs")
set(LDFLAGS "${LDFLAGS} -L${NRF_SDK_ROOT}/modules/nrfx/mdk")
set(LDFLAGS "${LDFLAGS} -T${CMAKE_SOURCE_DIR}/config/nrf52840.ld")

set(CMAKE_EXE_LINKER_FLAGS_INIT ${LDFLAGS})

# Add common libraries
link_libraries(-lc -lnosys -lm)

#
# Adjust the default behaviour of the FIND_XXX() commands:
# - Search headers and libraries in the target environment
# - Search programs in the host environment
#
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)


#
# Utils
#


#
# Add elf to bin, hex and uf2 conversion
#
function(add_nrf52840_executable)
    cmake_parse_arguments(
            PARSED_ARGS
            ""
            "TARGET"
            ""
            ${ARGN}
        )
    
    if(NOT PARSED_ARGS_TARGET)
        message(FATAL_ERROR "You must provide a TARGET to add_nrf52840_executable")
    endif()
    
    if(NOT TARGET ${PARSED_ARGS_TARGET})
        message(FATAL_ERROR "Target ${PARSED_ARGS_TARGET} not defined")
    endif()
    
    if(_${PARSED_ARGS_TARGET}_ADD_UF2_EXECUTABLE)
        message(FATAL_ERROR "Duplicated call to add_nrf52840_executable for ${PARSED_ARGS_TARGET} target")
    endif()
    
    # Add startup sources
    set_property(SOURCE ${NRF_SDK_ROOT}/modules/nrfx/mdk/gcc_startup_nrf52840.S PROPERTY LANGUAGE C)    
    target_sources(${PARSED_ARGS_TARGET} PRIVATE 
        ${NRF_SDK_ROOT}/modules/nrfx/mdk/gcc_startup_nrf52840.S
        ${NRF_SDK_ROOT}/modules/nrfx/mdk/system_nrf52840.c)

    # Generate bin, hex and uf2 files
    find_program(CMAKE_OBJCOPY ${TOOLCHAIN_PREFIX}objcopy REQUIRED)
    add_custom_command(TARGET ${PARSED_ARGS_TARGET} POST_BUILD
                   COMMAND ${CMAKE_OBJCOPY} -O binary $<TARGET_FILE:${PARSED_ARGS_TARGET}> ${CMAKE_CURRENT_BINARY_DIR}/${PARSED_ARGS_TARGET}.bin
                   COMMAND ${CMAKE_OBJCOPY} -O ihex $<TARGET_FILE:${PARSED_ARGS_TARGET}> ${CMAKE_CURRENT_BINARY_DIR}/${PARSED_ARGS_TARGET}.hex
                   COMMAND python3 ${CMAKE_SOURCE_DIR}/tools/uf2conv.py -c -f 0xADA52840 -o ${CMAKE_CURRENT_BINARY_DIR}/${PARSED_ARGS_TARGET}.uf2 ${CMAKE_CURRENT_BINARY_DIR}/${PARSED_ARGS_TARGET}.hex
                   DEPENDS ${PARSED_ARGS_TARGET})
    set(_${PARSED_ARGS_TARGET}_ADD_UF2_EXECUTABLE TRUE PARENT_SCOPE)
endfunction()

