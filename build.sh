#!/bin/sh

set -e

if [ "$#" -ne 1 ]; then
    echo "USAGE: ./build.sh <llvm-version>"
    exit 1
fi

LLVM_VERSION="$1"

rm -rf llvm-project install build

git clone https://github.com/llvm/llvm-project --depth 1 \
    -b "llvmorg-$LLVM_VERSION" llvm-project

mkdir install build && cd build

cmake -G Ninja ../llvm-project/llvm -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=../install

cmake --build . --target install
