::@echo off
:: .
:: Compile your examples using:  raylib_compile_execute.bat core/core_basic_window.c
:: .
:: > Setup required Environment
:: -------------------------------------
set RAYLIB_SRC="raylib\src"
set RAYLIB_RES_FILE="raylib\src\raylib.rc.data"
set COMPILER="mingw\bin\g++.exe"

:: Get full filename path for input file %1
set FILENAME=%~f1
set NAMEPART=%FILENAME:~0,-4%
cd %~dp0

:: .
:: > Cleaning latest build
:: ---------------------------
cmd /c if exist %NAMEPART%.exe del /F %NAMEPART%.exe

:: .
:: > Compiling program
:: --------------------------
:: -s        : Remove all symbol table and relocation information from the executable
:: -O2       : Optimization Level 2, this option increases both compilation time and the performance of the generated code
:: -std=c99  : Use C99 language standard
:: -Wall     : Enable all compilation Warnings
:: -mwindows : Compile a Windows executable, no cmd window
%COMPILER% %FILENAME% %RAYLIB_RES_FILE% -o %NAMEPART%.x86.exe -s -Os -I%RAYLIB_SRC% -L%RAYLIB_SRC% -lraylib -lopengl32 -lgdi32 -lwinmm -std=c++17 -Wall -mwindows -m32 -static
::%COMPILER% %FILENAME% %RAYLIB_RES_FILE% -o %NAMEPART%.x64.exe -s -Os -I%RAYLIB_SRC% -L%RAYLIB_SRC% -lraylib -lopengl32 -lgdi32 -lwinmm -std=c++17 -Wall -mwindows -m64 -static

:: Max optimize with upx
upx\upx.exe --ultra-brute -9 --best -v -f --compress-icons=1 --compress-resources=1 --strip-relocs=1 --compress-exports=1 %NAMEPART%.x86.exe
::upx\upx.exe --ultra-brute -9 --best -v -f --compress-icons=1 --compress-resources=1 --strip-relocs=1 --compress-exports=1 %NAMEPART%.x64.exe

:: Ensure dirs for built exes
mkdir bin\x86
::mkdir bin\x64

:: Move builds to respective binary directories
move %NAMEPART%.x86.exe bin\x86
::move %NAMEPART%.x64.exe bin\x64