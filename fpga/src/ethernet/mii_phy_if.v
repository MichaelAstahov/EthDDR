`resetall
`timescale 1ns / 1ps
`default_nettype none

// MII PHY interface
module mii_phy_if (
    input  wire        rst,
    // MII interface to MAC
    output wire        mac_mii_rx_clk,
    output wire        mac_mii_rx_rst,
    output wire [3:0]  mac_mii_rxd,
    output wire        mac_mii_rx_dv,
    output wire        mac_mii_rx_er,
    output wire        mac_mii_tx_clk,
    output wire        mac_mii_tx_rst,
    input  wire [3:0]  mac_mii_txd,
    input  wire        mac_mii_tx_en,
    input  wire        mac_mii_tx_er,
    // MII interface to PHY
    input  wire        phy_mii_rx_clk,
    input  wire [3:0]  phy_mii_rxd,
    input  wire        phy_mii_rx_dv,
    input  wire        phy_mii_rx_er,
    input  wire        phy_mii_tx_clk,
    output wire [3:0]  phy_mii_txd,
    output wire        phy_mii_tx_en,
    output wire        phy_mii_tx_er
);

ssio_sdr_in #(
    .WIDTH (6)
)
rx_ssio_sdr_inst (
    .input_clk  (phy_mii_rx_clk),
    .input_d    ({phy_mii_rxd, phy_mii_rx_dv, phy_mii_rx_er}),
    .output_clk (mac_mii_rx_clk),
    .output_q   ({mac_mii_rxd, mac_mii_rx_dv, mac_mii_rx_er})
);

(* IOB = "TRUE" *)
reg [3:0] phy_mii_txd_reg = 4'd0;
(* IOB = "TRUE" *)
reg phy_mii_tx_en_reg = 1'b0, phy_mii_tx_er_reg = 1'b0;

assign phy_mii_txd = phy_mii_txd_reg;
assign phy_mii_tx_en = phy_mii_tx_en_reg;
assign phy_mii_tx_er = phy_mii_tx_er_reg;

always @(posedge mac_mii_tx_clk) begin
    phy_mii_txd_reg <= mac_mii_txd;
    phy_mii_tx_en_reg <= mac_mii_tx_en;
    phy_mii_tx_er_reg <= mac_mii_tx_er;
end

BUFG mii_bufg_inst (
    .I(phy_mii_tx_clk),
    .O(mac_mii_tx_clk)
);

// reset sync
reg [3:0] tx_rst_reg = 4'hf;
assign mac_mii_tx_rst = tx_rst_reg[0];

always @(posedge mac_mii_tx_clk or posedge rst) begin
    if (rst) begin
        tx_rst_reg <= 4'hf;
    end else begin
        tx_rst_reg <= {1'b0, tx_rst_reg[3:1]};
    end
end

reg [3:0] rx_rst_reg = 4'hf;
assign mac_mii_rx_rst = rx_rst_reg[0];

always @(posedge mac_mii_rx_clk or posedge rst) begin
    if (rst) begin
        rx_rst_reg <= 4'hf;
    end else begin
        rx_rst_reg <= {1'b0, rx_rst_reg[3:1]};
    end
end

endmodule

`resetall
