@echo off
setlocal enabledelayedexpansion

set argCount=0
for %%x in (%*) do (
   set /A argCount+=1
   set "argVec[!argCount!]=%%~x"
)

if !argVec[1]!==--help (
    echo [USAGE] ./crproj ^<filepath^> ^<project_name^> [^<name_of_additional_files^>]
    EXIT /B
) 

if !argVec[1]!==--h (
    echo [USAGE] ./crproj ^<filepath^> ^<project_name^> [^<name_of_additional_files^>]
    EXIT /B
) 

if %argCount% lss 2 (
    echo [ERROR] Not enough arguments!
    echo [USAGE] ./crproj ^<filepath^> ^<project_name^> [^<name_of_additional_files^>] 
    EXIT /B
)

set "proj_location=!argVec[1]!"
set "proj_name=!argVec[2]!"

cls
mkdir %proj_location%
chdir %proj_location%

mkdir src

if %argCount% gtr 2 (
    cd src 
    for /l %%i in (3, 1, %argCount%) do (
            echo #include "!argVec[%%i]!.h" > \%proj_location%\src\!argVec[%%i]!.c 
            echo #pragma once> \%proj_location%\src\!argVec[%%i]!.h
    )

    cd ..
) 

mkdir bin

set ""=""

> \%proj_location%\main.c (
for %%I in (
        "#include <stdio.h>"
        "int main(void){"
        "   printf(!"!COMPLETED!"!);"
        "   return 0; "
        "}"
    ) do echo %%~I
)

> \%proj_location%\CMakeLists.txt (
for %%I in (
        "cmake_minimum_required(VERSION 3.26.4)"
        "project(%proj_name%)"
        "# Add executable target with source files listed in SOURCE_FILES variable"
    ) do echo %%~I
)

if %argCount% GTR 1 (
    echo add_executable^(${PROJECT_NAME} main.c  >> \%proj_location%\CMakeLists.txt
    cd src 
    FOR %%y in (*) do (
        echo                                src/%%y  >> \%proj_location%\CMakeLists.txt
    )
    echo                                            ^) >> \%proj_location%\CMakeLists.txt
    cd ..
) else (
   echo add_executable(${PROJECT_NAME} main.c^) >> \%proj_location%\CMakeLists.txt
)

> \%proj_location%\bar.bat (
for %%I in (
        "cls"
        "cd bin"
        "echo [INFO] Building the program: "
        "make"
        "echo [INFO] Executing the program: "
        "call %proj_name%.exe"
        "cd .."
    ) do echo %%~I
)

cd bin
call cmake .. -G "MinGW Makefiles"
cd ..
call bar.bat
cd ..