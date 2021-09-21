`timescale 1ns / 1ps

/*
 * Synchronizes an active-high asynchronous reset signal to a given clock by
 * using a pipeline of N registers.
 */

module sync_reset #
(
    parameter N = 2    // depth of synchronizer
)
(
    input  wire clk,
    input  wire rst,
    output wire out
);

(* srl_style = "register" *)
reg [N-1:0] sync_reg = {N{1'b1}};

assign out = sync_reg[N-1];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        sync_reg <= {N{1'b1}};
    end else begin
        sync_reg <= {sync_reg[N-2:0], 1'b0};
    end
end

endmodule