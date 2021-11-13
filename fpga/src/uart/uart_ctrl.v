`timescale 1ns / 1ps

module uart_ctrl (
    input  wire clk,      // 100MHz clock
    input  wire rst,      // sync reset
    input  wire btn,      // button
    input  wire uart_rx,  // uart receive
    output wire uart_tx,  // uart transmit
    output wire software_rst,
    output wire software_ledson
);

wire [7:0]  uart_tx_axis_tdata;
wire        uart_tx_axis_tvalid;
wire        uart_tx_axis_tready;

wire [7:0]  uart_rx_axis_tdata;
wire        uart_rx_axis_tvalid;
wire        uart_rx_axis_tready;

uart uart_inst (
    // system
    .clk                (clk),
    .rst                (rst),
    // AXI input
    .s_axis_tdata       (uart_tx_axis_tdata),
    .s_axis_tvalid      (uart_tx_axis_tvalid),
    .s_axis_tready      (uart_tx_axis_tready),
    // AXI output
    .m_axis_tdata       (uart_rx_axis_tdata),
    .m_axis_tvalid      (uart_rx_axis_tvalid),
    .m_axis_tready      (uart_rx_axis_tready),
    // uart
    .rxd                (uart_rx),
    .txd                (uart_tx),
    // status
    .tx_busy            (),
    .rx_busy            (),
    .rx_overrun_error   (),
    .rx_frame_error     (),
    // configuration
    .prescale           (100000000/(9600*8))    // [Fclk/(baud*width)]
);

uart_parser uart_parser_inst (
    // system
    .clk                    (clk),
    .rst                    (rst),
    // uart rx
    .uart_rx_axis_tdata     (uart_rx_axis_tdata),
    .uart_rx_axis_tvalid    (uart_rx_axis_tvalid),
    .uart_rx_axis_tready    (uart_rx_axis_tready),
    // uart tx
    .uart_tx_axis_tdata     (uart_tx_axis_tdata),
    .uart_tx_axis_tvalid    (uart_tx_axis_tvalid),
    .uart_tx_axis_tready    (uart_tx_axis_tready),
    // commands
    .software_rst           (software_rst),
    .software_ledson        (software_ledson)
);

endmodule