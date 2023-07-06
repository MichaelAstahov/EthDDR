`timescale 1ns / 1ps

module top 
(
    // Clock
    input  wire       clk_pin,    // 100MHz Clock
    // GPIO
    input  wire [3:0] sw_pin,     // Toggle Switches
    input  wire [3:0] btn_pin,    // Push Buttons 
    output wire       led0_r_pin,
    output wire       led0_g_pin,
    output wire       led0_b_pin,
    output wire       led1_r_pin,
    output wire       led1_g_pin,
    output wire       led1_b_pin,
    output wire       led2_r_pin,
    output wire       led2_g_pin,
    output wire       led2_b_pin,
    output wire       led3_r_pin,
    output wire       led3_g_pin,
    output wire       led3_b_pin,
    output wire       led4_pin,
    output wire       led5_pin,
    output wire       led6_pin,
    output wire       led7_pin,   
    // Ethernet: 100BASE-T MII
    output wire       phy_ref_clk,
    input  wire       phy_rx_clk,
    input  wire [3:0] phy_rxd,
    input  wire       phy_rx_dv,
    input  wire       phy_rx_er,
    input  wire       phy_tx_clk,
    output wire [3:0] phy_txd,
    output wire       phy_tx_en,
    input  wire       phy_col,
    input  wire       phy_crs,
    output wire       phy_reset_n,
    // UART: 500000 bps, 8N1
    input  wire       uart_rx_pin,
    output wire       uart_tx_pin
);

// Input Buffers
wire        clk_200mhz_int;
wire        clk_125mhz_int;
wire        clk_100mhz_int;
wire        clk_40mhz_int;
wire        clk_25mhz_int;
wire        hardware_rst40;
wire        hardware_rst100;
wire [2:0]  btn_int;
wire [3:0]  sw_int;
wire        uart_rx_int;
// UART Commands
wire        software_rst;
wire        software_ledson;
// Reset
wire        internal_rst100;

input_buffers input_buffers_inst (
    .clk_in      (clk_pin),
    .btn_in      (btn_pin),
    .sw_in       (sw_pin),
    .uart_rx_in  (uart_rx_pin),
    .clk_out0    (clk_200mhz_int),  // 200MHz referance clock
    .clk_out1    (clk_125mhz_int),  // 125MHz ethernet internal clock
    .clk_out2    (clk_100mhz_int),  // 100MHz system clock
    .clk_out3    (clk_40mhz_int),   // 40MHz  dsp clock
    .clk_out4    (clk_25mhz_int),   // 25MHz  ethernet external clock
    .rst_out40   (hardware_rst40),  // reset synced to 40MHz and pll_locked
    .rst_out100  (hardware_rst100), // reset synced to 100MHz and pll_locked
    .btn_out     (btn_int),         // 3 Push Buttons synced to 100MHz
    .sw_out      (sw_int),          // 4 Switches synced to 100MHz
    .uart_rx_out (uart_rx_int)
);

// UART Controller
uart_ctrl uart_ctrl_inst (
    .clk                (clk_100mhz_int),
    .rst                (internal_rst100),
    .btn                (btn_int[0]),
    .uart_rx            (uart_rx_int),
    .uart_tx            (uart_tx_pin),
    .software_rst       (software_rst),
    .software_ledson    (software_ledson)
);

// Ethernet MII
eth_mii_wrapper eth_wrapper_inst (
    // System
    .clk         (clk_int),
    .rst         (rst_int),
    // Ethernet: 100BASE-T MII
    .phy_rx_clk  (phy_rx_clk),
    .phy_rxd     (phy_rxd),
    .phy_rx_dv   (phy_rx_dv),
    .phy_rx_er   (phy_rx_er),
    .phy_tx_clk  (phy_tx_clk),
    .phy_txd     (phy_txd),
    .phy_tx_en   (phy_tx_en),
    .phy_col     (phy_col),
    .phy_crs     (phy_crs),
    .phy_reset_n (phy_reset_n)
);

reset reset_inst (
    .clk            (clk_100mhz_int),
    .hardware_rst   (hardware_rst100),
    .software_rst   (software_rst),
    .internal_rst   (internal_rst100)
);

// Leds
leds leds_inst (
    .clk                (clk_100mhz_int),
    .rst                (internal_rst100),
    .sw                 (sw_int),
    .software_ledson    (software_ledson),
    .led0_r             (led0_r_pin),
    .led0_g             (led0_g_pin),
    .led0_b             (led0_b_pin),
    .led1_r             (led1_r_pin),
    .led1_g             (led1_g_pin),
    .led1_b             (led1_b_pin),
    .led2_r             (led2_r_pin),
    .led2_g             (led2_g_pin),
    .led2_b             (led2_b_pin),
    .led3_r             (led3_r_pin),
    .led3_g             (led3_g_pin),
    .led3_b             (led3_b_pin),
    .led4               (led4_pin),
    .led5               (led5_pin),
    .led6               (led6_pin),
    .led7               (led7_pin)
);

endmodule