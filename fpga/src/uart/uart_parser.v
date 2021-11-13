`timescale 1ns / 1ps

module uart_parser (
    // system
    input  wire         clk,      // 100MHz clock
    input  wire         rst,      // sync reset
    // uart rx
    input  wire [7:0]   uart_rx_axis_tdata,  
    input  wire         uart_rx_axis_tvalid,  
    output wire         uart_rx_axis_tready,
    // uart tx
    output wire [7:0]   uart_tx_axis_tdata,  
    output wire         uart_tx_axis_tvalid,  
    input  wire         uart_tx_axis_tready,
    // commands
    output wire         software_rst,
    output wire         software_ledson
);

// uart communication & protocol
// start & END_RX of message
localparam START_OF_MSG     = 8'haa;
localparam END_OF_MSG       = 8'hff;
// destination
localparam PC_TO_FPGA       = 8'h01;
localparam FPGA_TO_PC       = 8'h10;
// commands
localparam FPGA_RST         = 8'h00;
localparam RST_RX           = 8'h01;
localparam FPGA_LEDS_ON     = 8'h10;
localparam LEDS_ON_RX       = 8'h11;
localparam FPGA_LEDS_OFF    = 8'h20;
localparam LEDS_OFF_RX      = 8'h21;
// command registers
reg [3:0]   index_rx;
reg [3:0]   index_tx;
reg [7:0]   dest;
reg [7:0]   cmnd;
reg [7:0]   cksm_rx;
reg [7:0]   cksm_calc_rx;
reg [7:0]   cksm_calc_tx;
reg         sw_rst;
reg         sw_ledson;
reg         error;
reg         uart_rx_dnv; //uart rx process done and valid
reg         uart_tx_dnv; //uart tx process done and valid

// state machine
// fsm register & parameters
reg [4:0] fsm_rx;
localparam IDLE_RX	 = 5'b00001;
localparam GET_RX	 = 5'b00010;
localparam CHECK_RX  = 5'b00100;
localparam PARSE_RX  = 5'b01000;
localparam END_RX	 = 5'b10000;

reg [6:0] fsm_tx;
localparam IDLE_TX	 = 7'b0000001;
localparam HEAD_TX	 = 7'b0000010;
localparam DEST_TX	 = 7'b0000100;
localparam CMD_TX	 = 7'b0001000;
localparam CKSM_TX	 = 7'b0010000;
localparam TAIL_TX	 = 7'b0100000;
localparam END_TX	 = 7'b1000000;

// uart tx registers
reg [7:0]   uart_tx_axis_tdata_reg;
reg         uart_tx_axis_tvalid_reg;
reg         uart_rx_axis_tready_reg;

initial begin
    index_rx		        = 4'b0;
    index_tx		        = 4'b0;
    cksm_calc_rx	        = 8'b0;
    cksm_rx	                = 8'b0;
    cmnd	                = 8'b0;
    dest	                = 8'b0;
    sw_rst		            = 1'b0;
    sw_ledson	            = 1'b0;
    error                   = 1'b0;
    uart_rx_dnv             = 1'b0;
    fsm_rx		            = IDLE_RX;
    fsm_tx		            = IDLE_TX;
    uart_rx_axis_tready_reg	= 1'b0;
end

always @(posedge clk or posedge rst) begin
    if(rst) begin
        index_rx		        <= 4'b0;
        cksm_calc_rx	        <= 8'b0;
        cksm_rx	                <= 8'b0;
        cmnd	                <= 8'b0;
        dest	                <= 8'b0;
        sw_rst		            <= 1'b0;
        sw_ledson	            <= 1'b0;
        error                   <= 1'b0;
        uart_rx_dnv             <= 1'b0;
        fsm_rx		            <= IDLE_RX;
        uart_rx_axis_tready_reg <= 1'b0;
    end else begin
        case (fsm_rx)
            IDLE_RX: begin
                // ready to receive byte
                uart_rx_axis_tready_reg <= 1'b1;
                error                   <= 1'b0; 
                uart_rx_dnv             <= 1'b0;

                if (uart_rx_axis_tvalid && uart_rx_axis_tdata == START_OF_MSG) begin
                    fsm_rx      <= GET_RX;
                    index_rx    <= index_rx + 1'b1;
                end else begin
                    fsm_rx <= IDLE_RX;
                end
            end
            GET_RX: begin
                if (uart_rx_axis_tvalid) begin
                    case (index_rx)
                        3'd1: begin
                            index_rx	    <= index_rx + 1'b1;
                            dest            <= uart_rx_axis_tdata;
                            cksm_calc_rx    <= cksm_calc_rx  + uart_rx_axis_tdata;
                        end
                        3'd2: begin
                            index_rx	    <= index_rx + 1'b1;
                            cmnd            <= uart_rx_axis_tdata;
                            cksm_calc_rx    <= cksm_calc_rx  + uart_rx_axis_tdata;
                        end
                        3'd3: begin
                            index_rx	<= index_rx + 1'b1;
                            cksm_rx     <= uart_rx_axis_tdata;
                        end
                        3'd4: begin
                            if (uart_rx_axis_tdata == END_OF_MSG) begin
                                index_rx	<= 4'b0;
                                fsm_rx 	    <= CHECK_RX;
                            end else begin
                                cksm_rx     <= 8'b0;
                                cmnd        <= 8'b0;
                                dest        <= 8'b0;
                                index_rx    <= 4'b0;
                                error       <= 1'b1;
                                fsm_rx 	    <= IDLE_RX;
                            end
                        end
                        default: begin 
                            cksm_rx         <= 8'b0;
                            cksm_calc_rx    <= 8'b0;
                            cmnd            <= 8'b0;
                            dest            <= 8'b0;
                            index_rx	    <= 4'b0;
                            error           <= 1'b1;
                            fsm_rx 	        <= IDLE_RX;
                        end
                    endcase
                end
            end
            CHECK_RX: begin
                if (cksm_calc_rx == cksm_rx) begin
                    fsm_rx		            <= PARSE_RX;
                    uart_rx_dnv             <= 1'b1;
                    uart_rx_axis_tready_reg <= 1'b0;
                end else begin 
                    cksm_rx                 <= 8'b0;
                    cksm_calc_rx            <= 8'b0;
                    cmnd                    <= 8'b0;
                    dest                    <= 8'b0;
                    error                   <= 1'b1;
                    uart_rx_axis_tready_reg <= 1'b0;
                    fsm_rx 	                <= IDLE_RX;
                end
            end	
            PARSE_RX: begin
                if (dest == PC_TO_FPGA) begin
                    case (cmnd)
                        FPGA_RST        : sw_rst    <= 1'b1;
                        FPGA_LEDS_ON    : sw_ledson <= 1'b1;
                        FPGA_LEDS_OFF   : sw_ledson <= 1'b0;
                        default: begin
                            sw_rst	    <= 1'b0;
                            sw_ledson   <= 1'b0;
                        end
                    endcase
                end else begin
                    cksm_rx         <= 8'b0;
                    cksm_calc_rx    <= 8'b0;
                    cmnd            <= 8'b0;
                    dest            <= 8'b0;
                    fsm_rx	        <= END_RX;
                end

                fsm_rx   <= END_RX;
            end	
            END_RX: begin
                sw_rst	        <= 1'b0;
                if (uart_tx_dnv) begin
                    uart_rx_dnv     <= 1'b0;
                    cksm_rx         <= 8'b0;
                    cksm_calc_rx    <= 8'b0;
                    cmnd            <= 8'b0;
                    dest            <= 8'b0;
                    fsm_rx		    <= IDLE_RX;
                end else begin
                    fsm_rx		    <= END_RX;
                end
            end	
            default: begin
                index_rx		        <= 4'b0;
                cksm_calc_rx	        <= 8'b0;
                cksm_rx	                <= 8'b0;
                cmnd	                <= 8'b0;
                dest	                <= 8'b0;
                sw_rst		            <= 1'b0;
                sw_ledson	            <= 1'b0;
                fsm_rx		            <= IDLE_RX;
                uart_rx_axis_tready_reg <= 1'b0;
            end
        endcase
    end
end

always @(posedge clk or posedge rst) begin
    if(rst) begin
        fsm_tx		            <= IDLE_TX;
        uart_tx_axis_tdata_reg  <= 8'b0;
        uart_tx_axis_tvalid_reg <= 1'b0;
        cksm_calc_tx            <= 8'b0;
        uart_tx_dnv             <= 1'b0;
    end else begin
        case (fsm_tx)
            IDLE_TX: begin
                uart_tx_axis_tvalid_reg <= 1'b0;
                uart_tx_axis_tdata_reg  <= 8'b0;
                cksm_calc_tx            <= 8'b0;
                uart_tx_dnv             <= 1'b0;
                if (uart_rx_dnv) begin
                    fsm_tx <= HEAD_TX;
                end else begin
                    fsm_tx <= IDLE_TX;
                end
            end
            HEAD_TX: begin
                if (uart_tx_axis_tvalid_reg) begin
                    if (uart_tx_axis_tready) begin
                        uart_tx_axis_tvalid_reg <= 1'b0;
                        fsm_tx                  <= DEST_TX;
                    end
                end else begin
                    uart_tx_axis_tvalid_reg <= 1'b1;
                    uart_tx_axis_tdata_reg  <= START_OF_MSG;
                end
            end
            DEST_TX: begin
                if (uart_tx_axis_tvalid_reg) begin
                    if (uart_tx_axis_tready) begin
                        uart_tx_axis_tvalid_reg <= 1'b0;
                        fsm_tx                  <= CMD_TX;
                    end
                end else begin
                    uart_tx_axis_tvalid_reg <= 1'b1;
                    uart_tx_axis_tdata_reg  <= FPGA_TO_PC;
                    cksm_calc_tx            <= FPGA_TO_PC;
                end
            end	
            CMD_TX: begin
                if (uart_tx_axis_tvalid_reg) begin
                    if (uart_tx_axis_tready) begin
                        uart_tx_axis_tvalid_reg <= 1'b0;
                        fsm_tx                  <= CKSM_TX;
                    end
                end else begin
                    uart_tx_axis_tvalid_reg <= 1'b1;
                    uart_tx_axis_tdata_reg  <= {cmnd[7:1], 1'b1};
                    cksm_calc_tx            <= cksm_calc_tx + {cmnd[7:1], 1'b1};
                end
            end
            CKSM_TX: begin
                if (uart_tx_axis_tvalid_reg) begin
                    if (uart_tx_axis_tready) begin
                        uart_tx_axis_tvalid_reg <= 1'b0;
                        fsm_tx                  <= TAIL_TX;
                    end
                end else begin
                    uart_tx_axis_tvalid_reg <= 1'b1;
                    uart_tx_axis_tdata_reg  <= cksm_calc_tx;
                end
            end
            TAIL_TX: begin
                if (uart_tx_axis_tvalid_reg) begin
                    if (uart_tx_axis_tready) begin
                        uart_tx_axis_tvalid_reg <= 1'b0;
                        uart_tx_dnv             <= 1'b1;
                        fsm_tx                  <= END_TX;
                    end
                end else begin
                    uart_tx_axis_tvalid_reg <= 1'b1;
                    uart_tx_axis_tdata_reg  <= END_OF_MSG;
                end
            end
            END_TX: begin
                uart_tx_dnv <= 1'b0;
                fsm_tx		<= IDLE_TX;
            end
            default: begin
                fsm_tx		            <= IDLE_TX;
                uart_tx_axis_tdata_reg  <= 8'b0;
                uart_tx_axis_tvalid_reg <= 1'b0;
            end
        endcase
    end
end


assign uart_rx_axis_tready = uart_rx_axis_tready_reg;
assign uart_tx_axis_tdata  = uart_tx_axis_tdata_reg;
assign uart_tx_axis_tvalid = uart_tx_axis_tvalid_reg;

assign software_rst     = sw_rst;
assign software_ledson  = sw_ledson;

endmodule