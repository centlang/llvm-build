@echo off

setlocal enabledelayedexpansion

if "%~1"=="" (
    echo USAGE: .\build.bat ^<llvm version^>
    exit /b 1
)

set LLVM_VERSION=%1

set ERRORLEVEL=0

rmdir /s /q llvm-project build install 2>nul

git clone https://github.com/llvm/llvm-project --depth 1 ^
    -b llvmorg-%LLVM_VERSION% llvm-project

mkdir build install
cd build

cmake -G Ninja ../llvm-project/llvm ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DLLVM_ENABLE_ZLIB=OFF ^
    -DLLVM_ENABLE_DIA_SDK=OFF ^
    -DLLVM_ENABLE_ZSTD=OFF ^
    -DCMAKE_INSTALL_PREFIX=../install

cmake --build . --target install
