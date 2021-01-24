#!/bin/sh
mkdir build
cd build
rm -rf *
cmake -v -G"Unix Makefiles" -DCMAKE_BUILD_TYPE=Debug -DCMAKE_TOOLCHAIN_FILE:PATH="../config/nrf52840-arm-gcc-toolchain.cmake" ..
make
