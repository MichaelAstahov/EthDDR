// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Fri Oct  8 20:26:11 2021
// Host        : DESKTOP-221HEHL running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Projects/EthDDR/fpga/vivado/EthDDR.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_stub.v
// Design      : clk_wiz_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35ticsg324-1L
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_wiz_0(clko_200, clko_125, clko_100, clko_40, clko_25, 
  locked, clk_in)
/* synthesis syn_black_box black_box_pad_pin="clko_200,clko_125,clko_100,clko_40,clko_25,locked,clk_in" */;
  output clko_200;
  output clko_125;
  output clko_100;
  output clko_40;
  output clko_25;
  output locked;
  input clk_in;
endmodule
