module leds
(
    input  wire         clk,
    input  wire         rst,
    input  wire [3:0]   sw,
    input wire          software_ledson,
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

localparam CNT_50M = 28'd50_000_000;

reg         rst_led_reg;
reg [27:0]  clk_cnt_reg;
reg         clk_led_reg;
reg [3:0]   led_shift_reg;
reg         led_shift_reg_dir;
reg [27:0]  led_cnt_logic_reg;

initial begin
    rst_led_reg                 = 1'b0;
    clk_cnt_reg                 = 28'b0;
    clk_led_reg                 = 1'b0;
    led_shift_reg               = 4'b0;
    led_shift_reg_dir           = 1'b0;
end

always @(posedge clk) begin
    if (rst) begin
        led_cnt_logic_reg           <= 28'b0;
        led_shift_reg               <= 4'b0;
        led_shift_reg_dir           <= 1'b0;
    end else begin
        if (software_ledson) begin
            if (led_shift_reg == 4'b1111) begin
                led_shift_reg_dir <= 1'b1;
            end else if (led_shift_reg == 4'b0) begin
                led_shift_reg_dir <= 1'b0;
            end

            if (led_cnt_logic_reg == CNT_50M - 1) begin
                led_cnt_logic_reg   <= 28'b0;
                if (~led_shift_reg_dir) begin
                    led_shift_reg <= {led_shift_reg[2:0], 1'b1};
                end else begin
                    led_shift_reg <= {led_shift_reg[2:0], 1'b0};
                    // led_shift_reg <= {1'b0, led_shift_reg[3:1]};
                end
            end else begin
                led_cnt_logic_reg   <= led_cnt_logic_reg + 1'b1;
            end
        end else begin
            led_cnt_logic_reg   <= 28'b0;
            led_shift_reg        <= 4'b0;
            led_shift_reg_dir    <= 1'b0;
        end
    end
end

always @(posedge clk) begin
    if (rst) begin
        rst_led_reg   <= 1'b1;
    end else begin
        rst_led_reg   <= 1'b0;
    end
end

always @(posedge clk) begin
    if (rst) begin
        clk_cnt_reg   <= 28'b0;
    end else begin
        if (clk_cnt_reg == CNT_50M - 1) begin
            clk_led_reg   <= ~clk_led_reg;
            clk_cnt_reg   <= 28'b0;
        end else begin
            clk_cnt_reg   <= clk_cnt_reg + 1'b1;
        end
    end
end

pwm rst_pwm_inst (
    .clk        (clk),
    .rst        (1'b0),
    .en         (rst_led_reg),
    .dutycycle  (11'b11010100100),
    .out        (led3_r)
);

pwm clk_pwm_inst (
    .clk        (clk),
    .rst        (rst),
    .en         (clk_led_reg),
    .dutycycle  (11'b11110011110),
    .out        (led0_g)
);


assign {led4, led5, led6, led7} = led_shift_reg;


endmodule