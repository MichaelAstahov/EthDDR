vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xpm
vlib modelsim_lib/msim/xil_defaultlib

vmap xpm modelsim_lib/msim/xpm
vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xpm  -incr -sv "+incdir+../../../../EthDDR.srcs/sources_1/ip/ila_1/hdl/verilog" \
"D:/Apps/Vivado/Vivado/2020.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"D:/Apps/Vivado/Vivado/2020.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm  -93 \
"D:/Apps/Vivado/Vivado/2020.1/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -incr "+incdir+../../../../EthDDR.srcs/sources_1/ip/ila_1/hdl/verilog" \
"../../../../EthDDR.srcs/sources_1/ip/ila_1/sim/ila_1.v" \

vlog -work xil_defaultlib \
"glbl.v"
