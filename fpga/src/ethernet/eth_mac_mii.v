`resetall
`timescale 1ns / 1ps
`default_nettype none

// 10M/100M Ethernet MAC with MII interface
module eth_mac_mii #
(
    parameter ENABLE_PADDING = 1,
    parameter MIN_FRAME_LENGTH = 64
)
(
    input  wire        rst,
    output wire        rx_clk,
    output wire        rx_rst,
    output wire        tx_clk,
    output wire        tx_rst,
    // AXI input
    input  wire [7:0]  tx_axis_tdata,
    input  wire        tx_axis_tvalid,
    output wire        tx_axis_tready,
    input  wire        tx_axis_tlast,
    input  wire        tx_axis_tuser,
    // AXI output
    output wire [7:0]  rx_axis_tdata,
    output wire        rx_axis_tvalid,
    output wire        rx_axis_tlast,
    output wire        rx_axis_tuser,
    // MII interface
    input  wire        mii_rx_clk,
    input  wire [3:0]  mii_rxd,
    input  wire        mii_rx_dv,
    input  wire        mii_rx_er,
    input  wire        mii_tx_clk,
    output wire [3:0]  mii_txd,
    output wire        mii_tx_en,
    output wire        mii_tx_er,
    // Status
    output wire        tx_start_packet,
    output wire        tx_error_underflow,
    output wire        rx_start_packet,
    output wire        rx_error_bad_frame,
    output wire        rx_error_bad_fcs,
    // Configuration
    input  wire [7:0]  ifg_delay
);

wire [3:0]  mac_mii_rxd;
wire        mac_mii_rx_dv;
wire        mac_mii_rx_er;
wire [3:0]  mac_mii_txd;
wire        mac_mii_tx_en;
wire        mac_mii_tx_er;

mii_phy_if mii_phy_if_inst (
    .rst                (rst),
    .mac_mii_rx_clk     (rx_clk),
    .mac_mii_rx_rst     (rx_rst),
    .mac_mii_rxd        (mac_mii_rxd),
    .mac_mii_rx_dv      (mac_mii_rx_dv),
    .mac_mii_rx_er      (mac_mii_rx_er),
    .mac_mii_tx_clk     (tx_clk),
    .mac_mii_tx_rst     (tx_rst),
    .mac_mii_txd        (mac_mii_txd),
    .mac_mii_tx_en      (mac_mii_tx_en),
    .mac_mii_tx_er      (mac_mii_tx_er),

    .phy_mii_rx_clk     (mii_rx_clk),
    .phy_mii_rxd        (mii_rxd),
    .phy_mii_rx_dv      (mii_rx_dv),
    .phy_mii_rx_er      (mii_rx_er),
    .phy_mii_tx_clk     (mii_tx_clk),
    .phy_mii_txd        (mii_txd),
    .phy_mii_tx_en      (mii_tx_en),
    .phy_mii_tx_er      (mii_tx_er)
);

eth_mac_1g #(
    .ENABLE_PADDING     (ENABLE_PADDING),
    .MIN_FRAME_LENGTH   (MIN_FRAME_LENGTH)
)
eth_mac_1g_inst (
    .tx_clk             (tx_clk),
    .tx_rst             (tx_rst),
    .rx_clk             (rx_clk),
    .rx_rst             (rx_rst),
    .tx_axis_tdata      (tx_axis_tdata),
    .tx_axis_tvalid     (tx_axis_tvalid),
    .tx_axis_tready     (tx_axis_tready),
    .tx_axis_tlast      (tx_axis_tlast),
    .tx_axis_tuser      (tx_axis_tuser),
    .rx_axis_tdata      (rx_axis_tdata),
    .rx_axis_tvalid     (rx_axis_tvalid),
    .rx_axis_tlast      (rx_axis_tlast),
    .rx_axis_tuser      (rx_axis_tuser),
    .gmii_rxd           (mac_mii_rxd),
    .gmii_rx_dv         (mac_mii_rx_dv),
    .gmii_rx_er         (mac_mii_rx_er),
    .gmii_txd           (mac_mii_txd),
    .gmii_tx_en         (mac_mii_tx_en),
    .gmii_tx_er         (mac_mii_tx_er),
    .rx_clk_enable      (1'b1),
    .tx_clk_enable      (1'b1),
    .rx_mii_select      (1'b1),
    .tx_mii_select      (1'b1),
    .tx_start_packet    (tx_start_packet),
    .tx_error_underflow (tx_error_underflow),
    .rx_start_packet    (rx_start_packet),
    .rx_error_bad_frame (rx_error_bad_frame),
    .rx_error_bad_fcs   (rx_error_bad_fcs),
    .ifg_delay          (ifg_delay)
);

endmodule

`resetall
