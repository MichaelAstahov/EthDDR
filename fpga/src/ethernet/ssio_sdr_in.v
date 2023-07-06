`resetall
`timescale 1ns / 1ps
`default_nettype none

// Generic source synchronous SDR input
module ssio_sdr_in #
(
    // Width of register in bits
    parameter WIDTH = 1
)
(
    input  wire             input_clk,
    input  wire [WIDTH-1:0] input_d,
    output wire             output_clk,
    output wire [WIDTH-1:0] output_q
);

wire clk_int;
wire clk_io;

assign clk_int = input_clk;

// pass through RX clock to input buffers
BUFIO clk_bufio (
    .I  (clk_int),
    .O  (clk_io)
);

// pass through RX clock to logic
BUFR #(
    .BUFR_DIVIDE ("BYPASS")
)
clk_bufr (
    .I      (clk_int),
    .O      (output_clk),
    .CE     (1'b1),
    .CLR    (1'b0)
);


(* IOB = "TRUE" *)
reg [WIDTH-1:0] output_q_reg = {WIDTH{1'b0}};

assign output_q = output_q_reg;

always @(posedge clk_io) begin
    output_q_reg <= input_d;
end

endmodule

`resetall
