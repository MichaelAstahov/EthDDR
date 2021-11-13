module pwm (
    input  wire         clk,
    input  wire         rst,
    input  wire         en,
    input  wire [10:0]  dutycycle,
    output wire         out
);
				
reg [10:0] counter;
	
always @(posedge clk) begin
    if (rst) begin
        counter <= 10'b0;
    end else begin
        if (en) begin
            counter <= counter + 1'b1;
        end else begin
            counter <= 10'b0;
        end
    end
end
	
assign out = (counter >= dutycycle);
	
endmodule