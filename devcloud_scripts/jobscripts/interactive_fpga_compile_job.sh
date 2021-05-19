#!/bin/bash
# Request an interactive job for compilation testing on DevCloud
qsub -l nodes=1:fpga_compile:ppn=2 -I
