// ---------------------------------------------------------------------------
// This block take care of all input pins and generate internal sync signals
// - Input Clock -> Buffer -> PLL -> Internal Clocks
// - SWs/BTNs -> Sync with Clocks -> Internal Sync SWs/BTNs
// ---------------------------------------------------------------------------

`timescale 1 ps / 1 ps

module input_buffers (
    input wire         clk_in,
    input wire [3:0]   btn_in,
    input wire [3:0]   sw_in,
    input wire         uart_rx_in,
    output wire        clk_out0,
    output wire        clk_out1,
    output wire        clk_out2,
    output wire        clk_out3,
    output wire        clk_out4,
    output wire        rst_out40,
    output wire        rst_out100,
    output wire [2:0]  btn_out,
    output wire [3:0]  sw_out,
    output wire        uart_rx_out
);

//! Clocks Managment
wire clk_ibuf;
wire clk_bufg;  //internal global 100MHz Clock
IBUF clk_ibuf_inst(
    .I  (clk_in),
    .O  (clk_ibuf)
);
BUFG clk_bufg_inst (
    .I  (clk_ibuf),  
    .O  (clk_bufg) 
);

wire pll_clko_200;
wire pll_clko_100;
wire pll_clko_125;
wire pll_clko_40;
wire pll_clko_25;
wire pll_locked;

clk_wiz_0 pll_core
(
    // Clock out ports
    .clko_200   (pll_clko_200),   // 200MHz - ref clk
    .clko_125   (pll_clko_125),   // 125MHz - internal ethernet clk
    .clko_100   (pll_clko_100),   // 100MHz - system clk
    .clko_40    (pll_clko_40),    // 40MHz  - dsp clk
    .clko_25    (pll_clko_25),    // 25MHz  - ethernet clk
    // Status and control signals
    .locked     (pll_locked),       
    // Clock in ports
    .clk_in     (clk_bufg)
);    


//! Sync Push Buttons, Switches and Reset
wire [3:0] btn_ibuf;
wire [3:0] sw_ibuf;
wire [3:0] btn_sync;
wire [3:0] sw_sync;
wire       pll_locked_sync100;
wire       pll_locked_sync40;
wire [3:0] btn_sync100;
wire [3:0] sw_sync100;

IBUF ibuf_sw0 (
    .O  (sw_ibuf[0]), 
    .I  (sw_in[0])  
);
IBUF ibuf_sw1 (
    .O  (sw_ibuf[1]), 
    .I  (sw_in[1])  
);
IBUF ibuf_sw2 (
    .O  (sw_ibuf[2]), 
    .I  (sw_in[2])  
);
IBUF ibuf_sw3 (
    .O  (sw_ibuf[3]), 
    .I  (sw_in[3])  
);

IBUF ibuf_btn0 (
    .O  (btn_ibuf[0]), 
    .I  (btn_in[0])  
);
IBUF ibuf_btn1 (
    .O  (btn_ibuf[1]), 
    .I  (btn_in[1])  
);
IBUF ibuf_btn2 (
    .O  (btn_ibuf[2]), 
    .I  (btn_in[2])  
);
IBUF ibuf_btn3 (
    .O  (btn_ibuf[3]), 
    .I  (btn_in[3])  
);

debounce_switch #(
    .WIDTH  (8),
    .N      (4),
    .RATE   (100000)
)
debounce_switch_inst (
    .clk    (pll_clko_100),
    .rst    (1'b0),
    .in     ({btn_ibuf, sw_ibuf}),
    .out    ({btn_sync, sw_sync})
);

sync_signal #(
    .WIDTH  (1),
    .N      (2)   
)
pll_locked_synchronizer_40mhz (
    .clk    (pll_clko_40),
    .in     (pll_locked),
    .out    (pll_locked_sync40)   
);

sync_signal #(
    .WIDTH  (1),
    .N      (2)   
)
pll_locked_synchronizer_100mhz (
    .clk    (pll_clko_100),
    .in     (pll_locked),
    .out    (pll_locked_sync100)   
);

sync_signal #(
    .WIDTH  (4),
    .N      (2)   
)
btn_synchronizer_100mhz (
    .clk    (pll_clko_100),
    .in     (btn_sync),
    .out    (btn_sync100)   
);

sync_signal #(
    .WIDTH  (4),
    .N      (2)   
)
sw_synchronizer_100mhz (
    .clk    (pll_clko_100),
    .in     (sw_sync),
    .out    (sw_sync100)   
);

wire rst_40;
sync_reset #(
    .N(4)
)
sync_reset_40_inst (
    .clk    (pll_clko_40),
    .rst    (btn_sync100[3] || ~pll_locked_sync40),
    .out    (rst_40)
);

wire rst_100;
sync_reset #(
    .N(4)
)
sync_reset_100_inst (
    .clk    (pll_clko_100),
    .rst    (btn_sync100[3] || ~pll_locked_sync100),
    .out    (rst_100)
);


//! Sync UART
wire uart_rx_ibuf;
wire uart_rx_sync100;
IBUF ibuf_uart_rx (
    .O  (uart_rx_ibuf), 
    .I  (uart_rx_in)  
);
sync_signal #(
    .WIDTH(1),
    .N(2)
)
sync_signal_inst (
    .clk(pll_clko_100),
    .in(uart_rx_ibuf),
    .out(uart_rx_sync100)
);


//! Output Assignments:
assign clk_out0     = pll_clko_200;
assign clk_out1     = pll_clko_125;
assign clk_out2     = pll_clko_100;
assign clk_out3     = pll_clko_40;
assign clk_out4     = pll_clko_25;
assign rst_out40    = rst_40;
assign rst_out100   = rst_100;
assign btn_out      = btn_sync100[2:0];
assign sw_out       = sw_sync100;
assign uart_rx_out  = uart_rx_sync100;

// ila_1 ila_1_top (
//  .clk    (pll_clko_100),      // input wire clk
//  .probe0 (uart_rx_ibuf),      // input wire [0:0]  probe0  
//  .probe1 (uart_rx_sync100)       // input wire [0:0]  probe1
// );

endmodule