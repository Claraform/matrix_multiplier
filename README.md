### UCT EEE4120F- High Performance Digital Embedded Systems
# YODA Project Code repository

Authors:    Clara Stassen       STSCLA001 
            Michael Granelli    GRNMIC028
           
-------------------------------------------------------

This repo contains the code from our final deliverable MS6 of the YODA project

For convenience The Vivado Project and Golden Measure have been combined into the same repo.

When running either, they do not have to be in the same folder. There are no dependencies.

-------------------------------------------------------

The FPGA code is in the form of a Vivado Project.

The team used Vivado 2019.2 - it is unknown whether it is compatible with past versions.

There were sometimes issues with the project not inporting the correct BRAM structures. 

If this is the case the BRAM must be manually added.

The settings were: Read/Write width = 32; Read/Write depth = 1024; Single Port; load data from the .coe file

-------------------------------------------------------

The Golden Measure code require gcc to compile

There is a makefile with the following rules:


default: compile into an executable

run: run the executable

clean: remove binary and project files

