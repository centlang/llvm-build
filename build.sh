#!/bin/sh

set -e

if [ "$#" -ne 2 ]; then
    echo "USAGE: ./build.sh <llvm version> <arch>"
    exit 1
fi

LLVM_VERSION="$1"
LLVM_TARGET="$2-linux-gnu"

rm -rf llvm-project install build

git clone https://github.com/llvm/llvm-project --depth 1 \
    -b "llvmorg-$LLVM_VERSION" llvm-project

mkdir install build && cd build

cat - <<EOF > $LLVM_TARGET.cmake
    set(CMAKE_SYSTEM_NAME Linux)

    set(CMAKE_C_COMPILER_TARGET $LLVM_TARGET)
    set(CMAKE_CXX_COMPILER_TARGET $LLVM_TARGET)

    set(CMAKE_LINKER_TYPE LLD)
    set(CMAKE_C_COMPILER clang)
    set(CMAKE_CXX_COMPILER clang++)

    set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
    set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
    set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
    set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
EOF

cmake -G Ninja ../llvm-project/llvm \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_TOOLCHAIN_FILE=$LLVM_TARGET.cmake \
    -DLLVM_HOST_TRIPLE=$LLVM_TARGET \
    -DLLVM_ENABLE_ZLIB=OFF \
    -DLLVM_ENABLE_ZSTD=OFF \
    -DCMAKE_INSTALL_PREFIX=../install/$LLVM_TARGET

cmake --build . --target install
