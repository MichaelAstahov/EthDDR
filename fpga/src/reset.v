`timescale 1 ps / 1 ps

module reset(
	input  wire	clk,
	input  wire	hardware_rst,
	input  wire	software_rst,
	output wire	internal_rst
);

reg	internal_rst_reg;
reg	internal_rst_reg_sync0;
reg	internal_rst_reg_sync1;

always @(posedge clk) begin
    if (hardware_rst || software_rst)
        internal_rst_reg <= 1'b1;
    else
        internal_rst_reg <= 1'b0;
end

always @(posedge clk) begin
    internal_rst_reg_sync0 <= internal_rst_reg;
    internal_rst_reg_sync1 <= internal_rst_reg_sync0;
end

assign internal_rst = internal_rst_reg_sync1;


endmodule