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

    // UART: 500000 bps, 8N1
    input  wire       uart_rx_pin,
    output wire       uart_tx_pin
);

//! Input Buffers
wire        clk_200mhz_int;
wire        clk_125mhz_int;
wire        clk_100mhz_int;
wire        clk_40mhz_int;
wire        clk_25mhz_int;
wire        rst40_int;
wire        rst100_int;
wire [2:0]  btn_int;
wire [3:0]  sw_int;
wire        uart_rx_int;

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
    .rst_out40   (rst40_int),       // reset synced to 40MHz and pll_locked
    .rst_out100  (rst100_int),      // reset synced to 100MHz and pll_locked
    .btn_out     (btn_int),         // 3 Push Buttons synced to 100MHz
    .sw_out      (sw_int),          // 4 Switches synced to 100MHz
    .uart_rx_out (uart_rx_int)
);

//! UART Controller
uart_ctrl uart_ctrl_inst (
    .clk     (clk_100mhz_int),
    .rst     (rst100_int),
    .btn     (btn_int[0]),
    .uart_rx (uart_rx_int),
    .uart_tx (uart_tx_pin)
);

//! Leds
leds leds_inst (
    .clk      (clk_100mhz_int),
    .rst      (rst100_int),
    .sw       (sw_int),
    .led0_r   (led0_r_pin),
    .led0_g   (led0_g_pin),
    .led0_b   (led0_b_pin),
    .led1_r   (led1_r_pin),
    .led1_g   (led1_g_pin),
    .led1_b   (led1_b_pin),
    .led2_r   (led2_r_pin),
    .led2_g   (led2_g_pin),
    .led2_b   (led2_b_pin),
    .led3_r   (led3_r_pin),
    .led3_g   (led3_g_pin),
    .led3_b   (led3_b_pin),
    .led4     (led4_pin),
    .led5     (led5_pin),
    .led6     (led6_pin),
    .led7     (led7_pin)
);

endmodule