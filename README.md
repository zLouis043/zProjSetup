# zProjSetup

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![GitHub last commit (branch)](https://img.shields.io/github/last-commit/zLouis043/zProjSetup/main)
![GitHub top language](https://img.shields.io/github/languages/top/zLouis043/zProjSetup)

A simple batch file useful to setup C projects 

## How-To

### To use this batch file you will need cmake to generate the build for the project

To run the program:

```console

$ ./zprojcr <filepath> <project_name> [<name_of_additional_files>]

```

This will create:
- the folder for the project
- the main file .c
- the source folder that contains the additional .c and .h files added when creating the project 
- the bin folder

And will generate the cmake files and than it will build the project for the first time.
