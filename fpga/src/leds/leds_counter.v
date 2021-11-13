module leds_counter #(
    parameter N = 28'd40_000_000
)
(
    input  wire clk,
    input  wire rst,
    output wire out
);

reg [27:0] leds_cnt;    //40M counter
reg        blink_led_reg;
initial begin
    leds_cnt        = 28'b0;
    blink_led_reg   = 1'b0;
end

always @(posedge clk) begin
    if (rst) begin
        leds_cnt        <= 28'b0;
        blink_led_reg   <= 1'b0;
    end else begin
        if (leds_cnt == N) begin
            leds_cnt        <= 28'b0;
            blink_led_reg   <= ~blink_led_reg;
        end else begin
            leds_cnt <= leds_cnt + 1'b1;
        end
    end
end

// ila_0 led_ila (
// 	.clk    (clk),              // input wire clk
// 	.probe0 (rst),              // input wire [0:0]  probe0  
// 	.probe1 (blink_led_reg),    // input wire [0:0]  probe1 
// 	.probe2 (leds_cnt)          // input wire [27:0]  probe2
// );

assign out = blink_led_reg;

endmodule