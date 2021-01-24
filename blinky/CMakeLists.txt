cmake_minimum_required(VERSION 3.6)
project(blinky)

set(CMAKE_CXX_STANDARD 14)

add_executable(blinky
        ${NRF_SDK_ROOT}/components/libraries/log/src/nrf_log_frontend.c
        ${NRF_SDK_ROOT}/components/libraries/log/src/nrf_log_str_formatter.c
        ${NRF_SDK_ROOT}/components/libraries/util/app_error.c
        ${NRF_SDK_ROOT}/components/libraries/util/app_error_handler_gcc.c
        ${NRF_SDK_ROOT}/components/libraries/util/app_error_weak.c
        ${NRF_SDK_ROOT}/components/libraries/util/app_util_platform.c
        ${NRF_SDK_ROOT}/components/boards/boards.c
        ${NRF_SDK_ROOT}/components/libraries/util/nrf_assert.c
        ${NRF_SDK_ROOT}/components/libraries/atomic/nrf_atomic.c
        ${NRF_SDK_ROOT}/components/libraries/balloc/nrf_balloc.c
        ${NRF_SDK_ROOT}/external/fprintf/nrf_fprintf.c
        ${NRF_SDK_ROOT}/external/fprintf/nrf_fprintf_format.c
        ${NRF_SDK_ROOT}/components/libraries/memobj/nrf_memobj.c
        ${NRF_SDK_ROOT}/components/libraries/ringbuf/nrf_ringbuf.c
        ${NRF_SDK_ROOT}/components/libraries/strerror/nrf_strerror.c
        ${NRF_SDK_ROOT}/modules/nrfx/soc/nrfx_atomic.c
        main.c
)
add_nrf52840_executable(TARGET blinky)
