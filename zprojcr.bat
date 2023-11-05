@echo off
setlocal enabledelayedexpansion

echo [[92mINFO[0m] RUNNING THE ZPROJECT SETUP BATCH BY IN_LOUIZ

set argCount=0
for %%x in (%*) do (
   set /A argCount+=1
   set "argVec[!argCount!]=%%~x"
)

if !argVec[1]!==--help (
    echo [[92mUSAGE[0m] Usage: 
    echo [[92mUSAGE[0m] ./[33mzprojcr[0m [[36mvscode[0m] ^<[36mfilepath[0m^> ^<[36mproject_name[0m^> [^<[36mname_of_additional_files[0m^>]
    echo [[92mUSAGE[0m]    - [36mvscode flag[0m  = Used to specify whenever the project will be opened in vscode automatically or not.
    echo [[92mUSAGE[0m]    - [36mfilepath[0m = The path where the project will be created.
    echo [[92mUSAGE[0m]    - [36mproject_name[0m = The name of the project.
    echo [[92mUSAGE[0m]    - [36mname_of_additional_files[0m = The name of other .c and .h modules that will be added to the project in the src folder.
    EXIT /B
) 

if !argVec[1]!==--h (
    echo [[92mUSAGE[0m] Usage: 
    echo [[92mUSAGE[0m] ./[33mzprojcr[0m [[36mvscode[0m] ^<[36mfilepath[0m^> ^<[36mproject_name[0m^> [^<[36mname_of_additional_files[0m^>]
    echo [[92mUSAGE[0m]    - [36mvscode flag[0m  = Used to specify whenever the project will be opened in vscode automatically or not.
    echo [[92mUSAGE[0m]    - [36mfilepath[0m = The path where the project will be created.
    echo [[92mUSAGE[0m]    - [36mproject_name[0m = The name of the project.
    echo [[92mUSAGE[0m]    - [36mname_of_additional_files[0m = The name of other .c and .h modules that will be added to the project in the src folder.
    EXIT /B
) 

if %argCount% lss 2 (
    echo [101mERROR[0m: [31mNot enough arguments![0m
    echo [[92mUSAGE[0m] Usage: 
    echo [[92mUSAGE[0m] ./[33mzprojcr[0m [[36mvscode[0m] ^<[36mfilepath[0m^> ^<[36mproject_name[0m^> [^<[36mname_of_additional_files[0m^>]
    echo [[92mUSAGE[0m]    - [36mvscode flag[0m  = Used to specify whenever the project will be opened in vscode automatically or not.
    echo [[92mUSAGE[0m]    - [36mfilepath[0m = The path where the project will be created.
    echo [[92mUSAGE[0m]    - [36mproject_name[0m = The name of the project.
    echo [[92mUSAGE[0m]    - [36mname_of_additional_files[0m = The name of other .c and .h modules that will be added to the project in the src folder.
    EXIT /B
)

if !argVec[1]!==vscode (
    set "proj_location=!argVec[2]!"
    set "proj_name=!argVec[3]!"
) else (
    set "proj_location=!argVec[1]!"
    set "proj_name=!argVec[2]!"
)

cls
mkdir %proj_location%
chdir %proj_location%

mkdir src

if %argCount% gtr 2 (
    cd src 
    for /l %%i in (4, 1, %argCount%) do (
            echo #include ^<stdio.h^> > \%proj_location%\src\!argVec[%%i]!.c 
            echo #include "!argVec[%%i]!.h" >>\%proj_location%\src\!argVec[%%i]!.c 
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

> \%proj_location%\build.bat (
for %%I in (
        "@echo off"
        "cls"
        "cd bin"
        "echo [INFO] Building the program: "
        "make"
        "cd .."
    ) do echo %%~I
)

> \%proj_location%\run.bat (
for %%I in (
        "@echo off"
        "cls"
        "cd bin"
        "echo [INFO] Executing the program: "
        "call %proj_name%.exe"
        "cd .."
    ) do echo %%~I
)

> \%proj_location%\bar.bat (
for %%I in (
        "@echo off"
        "cls"
        "call build.bat"
        "call run.bat"
    ) do echo %%~I
)

cd bin
call cmake .. -G "MinGW Makefiles"
cd ..
call bar.bat

if !argVec[1]!==vscode (
    code .
)

cd ..