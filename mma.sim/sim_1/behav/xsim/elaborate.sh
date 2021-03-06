#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2019.2.1 (64-bit)
#
# Filename    : elaborate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for elaborating the compiled design
#
# Generated by Vivado on Fri Jun 26 16:31:23 SAST 2020
# SW Build 2729669 on Thu Dec  5 04:48:12 MST 2019
#
# Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
#
# usage: elaborate.sh
#
# ****************************************************************************
set -Eeuo pipefail
echo "xelab -wto 6fdd173d26ad4fa2837ad6631f187a27 --incr --debug typical --relax --mt 8 -L blk_mem_gen_v8_4_4 -L xil_defaultlib -L xbip_utils_v3_0_10 -L axi_utils_v2_0_6 -L xbip_pipe_v3_0_6 -L xbip_dsp48_wrapper_v3_0_4 -L xbip_dsp48_addsub_v3_0_6 -L xbip_dsp48_multadd_v3_0_6 -L xbip_bram18k_v3_0_6 -L mult_gen_v12_0_16 -L floating_point_v7_1_9 -L unisims_ver -L unimacro_ver -L secureip -L xpm --snapshot mma_tb_behav xil_defaultlib.mma_tb xil_defaultlib.glbl -log elaborate.log"
xelab -wto 6fdd173d26ad4fa2837ad6631f187a27 --incr --debug typical --relax --mt 8 -L blk_mem_gen_v8_4_4 -L xil_defaultlib -L xbip_utils_v3_0_10 -L axi_utils_v2_0_6 -L xbip_pipe_v3_0_6 -L xbip_dsp48_wrapper_v3_0_4 -L xbip_dsp48_addsub_v3_0_6 -L xbip_dsp48_multadd_v3_0_6 -L xbip_bram18k_v3_0_6 -L mult_gen_v12_0_16 -L floating_point_v7_1_9 -L unisims_ver -L unimacro_ver -L secureip -L xpm --snapshot mma_tb_behav xil_defaultlib.mma_tb xil_defaultlib.glbl -log elaborate.log

