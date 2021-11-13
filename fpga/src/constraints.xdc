# General configuration

# 100 MHz clock
set_property -dict {LOC E3 IOSTANDARD LVCMOS33} [get_ports clk_pin]
create_clock -period 10.000 -name clk_pin [get_ports clk_pin]

set_property -dict {LOC G6 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12}  [get_ports led0_r_pin]
set_property -dict {LOC F6 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12}  [get_ports led0_g_pin]
set_property -dict {LOC E1 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12}  [get_ports led0_b_pin]
set_property -dict {LOC G3 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12}  [get_ports led1_r_pin]
set_property -dict {LOC J4 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12}  [get_ports led1_g_pin]
set_property -dict {LOC G4 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12}  [get_ports led1_b_pin]
set_property -dict {LOC J3 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12}  [get_ports led2_r_pin]
set_property -dict {LOC J2 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12}  [get_ports led2_g_pin]
set_property -dict {LOC H4 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12}  [get_ports led2_b_pin]
set_property -dict {LOC K1 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12}  [get_ports led3_r_pin]
set_property -dict {LOC H6 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12}  [get_ports led3_g_pin]
set_property -dict {LOC K2 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12}  [get_ports led3_b_pin]
set_property -dict {LOC H5 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12}  [get_ports led4_pin]
set_property -dict {LOC J5 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12}  [get_ports led5_pin]
set_property -dict {LOC T9 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12}  [get_ports led6_pin]
set_property -dict {LOC T10 IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports led7_pin]

# Push buttons
set_property -dict {LOC D9 IOSTANDARD LVCMOS33} [get_ports {btn_pin[0]}]
set_property -dict {LOC C9 IOSTANDARD LVCMOS33} [get_ports {btn_pin[1]}]
set_property -dict {LOC B9 IOSTANDARD LVCMOS33} [get_ports {btn_pin[2]}]
set_property -dict {LOC B8 IOSTANDARD LVCMOS33} [get_ports {btn_pin[3]}]

# Toggle switches
set_property -dict {LOC A8 IOSTANDARD LVCMOS33}  [get_ports {sw_pin[0]}]
set_property -dict {LOC C11 IOSTANDARD LVCMOS33} [get_ports {sw_pin[1]}]
set_property -dict {LOC C10 IOSTANDARD LVCMOS33} [get_ports {sw_pin[2]}]
set_property -dict {LOC A10 IOSTANDARD LVCMOS33} [get_ports {sw_pin[3]}]

# UART
set_property -dict {LOC D10  IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports uart_tx_pin]
set_property -dict {LOC A9   IOSTANDARD LVCMOS33} [get_ports uart_rx_pin]

#----------------#
# ILA


