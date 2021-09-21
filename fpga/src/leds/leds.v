module leds
(
    input  wire         clk,
    input  wire         rst,
    input  wire [3:0]   sw,
    output wire         led0_r,
    output wire         led0_g,
    output wire         led0_b,
    output wire         led1_r,
    output wire         led1_g,
    output wire         led1_b,
    output wire         led2_r,
    output wire         led2_g,
    output wire         led2_b,
    output wire         led3_r,
    output wire         led3_g,
    output wire         led3_b,
    output wire         led4,
    output wire         led5,
    output wire         led6,
    output wire         led7   
);

localparam CNT_40M = 28'd40_000_000 - 28'd1;

reg  rst_led_reg;
wire test_logic_wire0;
wire test_logic_wire1;
wire test_logic_wire2;
wire test_logic_wire3;

initial begin
    rst_led_reg = 1'b0;
end

//! Test Logic
test_logic test_logic_inst (
    .clk     (clk),
    .rst     (rst),
    .sw      (sw[3:0]),
    .o_lgc0  (test_logic_wire0),
    .o_lgc1  (test_logic_wire1),
    .o_lgc2  (test_logic_wire2)
);


always @(posedge clk) begin
    if (rst) begin
        rst_led_reg   <= 1'b1;
    end else begin
        rst_led_reg   <= 1'b0;
    end
end


assign led4 = test_logic_wire0;
assign led5 = test_logic_wire1;
assign led6 = test_logic_wire2;


assign led3_r = rst_led_reg;


endmodule