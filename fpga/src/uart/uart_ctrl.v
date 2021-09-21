`timescale 1ns / 1ps

module uart_ctrl (
    input  wire clk,      // 100MHz clock
    input  wire rst,      // sync reset
    input  wire btn,      // button
    input  wire uart_rx,  // uart receive
    output wire uart_tx   // uart transmit
);

reg [7:0]   uart_tx_axis_tdata;
reg         uart_tx_axis_tvalid;
wire        uart_tx_axis_tready;

wire [7:0]  uart_rx_axis_tdata;
wire        uart_rx_axis_tvalid;
reg         uart_rx_axis_tready;

uart uart_inst (
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

always @(posedge clk or posedge rst) begin
    if (rst) begin
        uart_tx_axis_tdata  <= 0;
        uart_tx_axis_tvalid <= 0;
        uart_rx_axis_tready <= 0;
    end else begin
        if (uart_tx_axis_tvalid) begin
            // attempting to transmit a byte
            // so can't receive one at the moment
            uart_rx_axis_tready <= 0;
            // if it has been received, then clear the valid flag
            if (uart_tx_axis_tready) begin
                uart_tx_axis_tvalid <= 0;
            end
        end else begin
            // ready to receive byte
            uart_rx_axis_tready <= 1;
            if (uart_rx_axis_tvalid) begin
                // got one, so make sure it gets the correct ready signal
                // (either clear it if it was set or set it if we just got a
                // byte out of waiting for the transmitter to send one)
                uart_rx_axis_tready <= ~uart_rx_axis_tready;
                // send byte back out
                uart_tx_axis_tdata  <= uart_rx_axis_tdata;
                uart_tx_axis_tvalid <= 1;
            end
        end
    end
end

ila_0 ila_0_uart (
	.clk    (clk),   // input wire clk
	.probe0 (rst), // input wire [0:0]  probe0  
	.probe1 (btn), // input wire [0:0]  probe1 
	.probe2 (uart_rx), // input wire [0:0]  probe2 
	.probe3 (uart_tx), // input wire [0:0]  probe3 
	.probe4 (uart_tx_axis_tdata), // input wire [7:0]  probe4 
	.probe5 (uart_rx_axis_tdata), // input wire [7:0]  probe5 
	.probe6 (uart_tx_axis_tvalid), // input wire [0:0]  probe6 
	.probe7 (uart_tx_axis_tready), // input wire [0:0]  probe7 
	.probe8 (uart_rx_axis_tvalid), // input wire [0:0]  probe8 
	.probe9 (uart_rx_axis_tready) // input wire [0:0]  probe9
);

endmodule