module test_logic
(
    input  wire         clk,
    input  wire         rst,
    input  wire [3:0]   sw,
    output wire         o_lgc0,
    output wire         o_lgc1,
    output wire         o_lgc2
);

reg reg0;
reg reg1;
reg reg2; 

initial begin
    reg0        = 1'b0;
    reg1        = 1'b0;
    reg2        = 1'b0;
end

always @(posedge clk) begin
    if (rst) begin
        reg0   <= 1'b0;
        reg1   <= 1'b0;
        reg2   <= 1'b0;
    end else begin
        if (sw[3]) begin
            reg0   <= 1'b0;
            reg1   <= 1'b0;  
            reg2   <= 1'b0; 
        end
        if (sw[2]) begin
            reg2   <= 1'b1;    
        end
        if (sw[1]) begin
            reg1   <= 1'b1;    
        end
        if (sw[0]) begin
            reg0   <= 1'b1;    
        end
    end
end

assign o_lgc0 = reg0;
assign o_lgc1 = reg1;
assign o_lgc2 = reg2;

endmodule