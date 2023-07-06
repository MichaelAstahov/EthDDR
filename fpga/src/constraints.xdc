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

# Ethernet MII PHY
set_property -dict {LOC F15  IOSTANDARD LVCMOS33} [get_ports phy_rx_clk]
set_property -dict {LOC D18  IOSTANDARD LVCMOS33} [get_ports {phy_rxd[0]}]
set_property -dict {LOC E17  IOSTANDARD LVCMOS33} [get_ports {phy_rxd[1]}]
set_property -dict {LOC E18  IOSTANDARD LVCMOS33} [get_ports {phy_rxd[2]}]
set_property -dict {LOC G17  IOSTANDARD LVCMOS33} [get_ports {phy_rxd[3]}]
set_property -dict {LOC G16  IOSTANDARD LVCMOS33} [get_ports phy_rx_dv]
set_property -dict {LOC C17  IOSTANDARD LVCMOS33} [get_ports phy_rx_er]
set_property -dict {LOC H16  IOSTANDARD LVCMOS33} [get_ports phy_tx_clk]
set_property -dict {LOC H14  IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {phy_txd[0]}]
set_property -dict {LOC J14  IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {phy_txd[1]}]
set_property -dict {LOC J13  IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {phy_txd[2]}]
set_property -dict {LOC H17  IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports {phy_txd[3]}]
set_property -dict {LOC H15  IOSTANDARD LVCMOS33 SLEW FAST DRIVE 12} [get_ports phy_tx_en]
set_property -dict {LOC D17  IOSTANDARD LVCMOS33} [get_ports phy_col]
set_property -dict {LOC G14  IOSTANDARD LVCMOS33} [get_ports phy_crs]
set_property -dict {LOC G18  IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports phy_ref_clk]
set_property -dict {LOC C16  IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports phy_reset_n]
#set_property -dict {LOC K13  IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports phy_mdio]
#set_property -dict {LOC F16  IOSTANDARD LVCMOS33 SLEW SLOW DRIVE 12} [get_ports phy_mdc]

create_clock -period 40.000 -name phy_rx_clk [get_ports phy_rx_clk]
create_clock -period 40.000 -name phy_tx_clk [get_ports phy_tx_clk]

set_false_path -to [get_ports {phy_ref_clk phy_reset_n}]
set_output_delay 0 [get_ports {phy_ref_clk phy_reset_n}]

#set_false_path -to [get_ports {phy_mdio phy_mdc}]
#set_output_delay 0 [get_ports {phy_mdio phy_mdc}]
#set_false_path -from [get_ports {phy_mdio}]
#set_input_delay 0 [get_ports {phy_mdio}]

#----------------#
# ILA


