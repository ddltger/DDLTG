#!/bin/sh
if [ ! -d "build" ];then
    mkdir build
else
    rm -rf build/CMakeCache.txt
fi

cd build
cmake -DCMAKE_TOOLCHAIN_FILE=CMake/toolchain/ios.toolchain.cmake -G Xcode ..
cd -