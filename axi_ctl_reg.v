// Author: Erwin Ouyang
// Date  : 31 Jan 2019

`timescale 1ns / 1ps

module axi_ctl_reg
	(
	    // ### Clock and reset signals #########################################
		input  wire        aclk,
		input  wire        aresetn,
		// ### AXI4-lite slave signals #########################################
		// *** Write address signals ***
        output wire        s_axi_awready,
		input  wire [31:0] s_axi_awaddr,
		input  wire        s_axi_awvalid,
		// *** Write data signals ***
        output wire        s_axi_wready,
		input  wire [31:0] s_axi_wdata,
		input  wire [3:0]  s_axi_wstrb,
		input  wire        s_axi_wvalid,
		// *** Write response signals ***
        input  wire        s_axi_bready,
		output wire [1:0]  s_axi_bresp,
		output wire        s_axi_bvalid,
		// *** Read address signals ***
        output wire        s_axi_arready,
		input  wire [31:0] s_axi_araddr,
		input  wire        s_axi_arvalid,
		// *** Read data signals ***	
        input  wire        s_axi_rready,
		output wire [31:0] s_axi_rdata,
		output wire [1:0]  s_axi_rresp,
		output wire        s_axi_rvalid,
		// ### User signals ####################################################	
		output wire        start,
		output wire        mode_test,
	    input wire         ready,
	    input wire         done,
		input wire [31:0]  out_cosf
	);

    // ### Register map ########################################################
    // 0x00: start (R/W)
    // 0x04: mode_test (R/W)
    // 0x08: ready (R)
    // 0x0C: done (R)
    // 0x10: out_const (R)
	localparam C_ADDR_BITS = 8;
	// *** Address ***
	localparam C_ADDR_START = 8'h00,
			   C_ADDR_MODE_TEST = 8'h04,
			   C_ADDR_READY = 8'h08,
			   C_ADDR_DONE = 8'h0c,
			   C_ADDR_OUT_CONST = 8'h10;
	// *** AXI write FSM ***
	localparam S_WRIDLE = 2'd0,
			   S_WRDATA = 2'd1,
			   S_WRRESP = 2'd2;
	// *** AXI read FSM ***
	localparam S_RDIDLE = 2'd0,
			   S_RDDATA = 2'd1;
	
	// *** AXI write ***
	reg [1:0] wstate_cs, wstate_ns;
	reg [C_ADDR_BITS-1:0] waddr;
	wire [31:0] wmask;
	wire aw_hs, w_hs;
	// *** AXI read ***
	reg [1:0] rstate_cs, rstate_ns;
	wire [C_ADDR_BITS-1:0] raddr;
	reg [31:0] rdata;
	wire ar_hs;
	// *** Control registers ***
	reg start_reg;
	reg startsig_reg;
	reg [3:0] cnt_start_reg;
	reg mode_test_reg;
	
	// ### AXI write ###########################################################
	assign s_axi_awready = (wstate_cs == S_WRIDLE);
	assign s_axi_wready = (wstate_cs == S_WRDATA);
	assign s_axi_bresp = 2'b00;    // OKAY
	assign s_axi_bvalid = (wstate_cs == S_WRRESP);
	assign wmask = {{8{s_axi_wstrb[3]}}, {8{s_axi_wstrb[2]}}, {8{s_axi_wstrb[1]}}, {8{s_axi_wstrb[0]}}};
	assign aw_hs = s_axi_awvalid & s_axi_awready;
	assign w_hs = s_axi_wvalid & s_axi_wready;

	// *** Write state register ***
	always @(posedge aclk)
	begin
		if (!aresetn)
			wstate_cs <= S_WRIDLE;
		else
			wstate_cs <= wstate_ns;
	end
	
	// *** Write state next ***
	always @(*)
	begin
		case (wstate_cs)
			S_WRIDLE:
				if (s_axi_awvalid)
					wstate_ns = S_WRDATA;
				else
					wstate_ns = S_WRIDLE;
			S_WRDATA:
				if (s_axi_wvalid)
					wstate_ns = S_WRRESP;
				else
					wstate_ns = S_WRDATA;
			S_WRRESP:
				if (s_axi_bready)
					wstate_ns = S_WRIDLE;
				else
					wstate_ns = S_WRRESP;
			default:
				wstate_ns = S_WRIDLE;
		endcase
	end
	
	// *** Write address register ***
	always @(posedge aclk)
	begin
		if (aw_hs)
			waddr <= s_axi_awaddr[C_ADDR_BITS-1:0];
	end
	
	// ### AXI read ############################################################
	assign s_axi_arready = (rstate_cs == S_RDIDLE);
	assign s_axi_rdata = rdata;
	assign s_axi_rresp = 2'b00;    // OKAY
	assign s_axi_rvalid = (rstate_cs == S_RDDATA);
	assign ar_hs = s_axi_arvalid & s_axi_arready;
	assign raddr = s_axi_araddr[C_ADDR_BITS-1:0];
	
	// *** Read state register ***
	always @(posedge aclk)
	begin
		if (!aresetn)
			rstate_cs <= S_RDIDLE;
		else
			rstate_cs <= rstate_ns;
	end

	// *** Read state next ***
	always @(*) 
	begin
		case (rstate_cs)
			S_RDIDLE:
				if (s_axi_arvalid)
					rstate_ns = S_RDDATA;
				else
					rstate_ns = S_RDIDLE;
			S_RDDATA:
				if (s_axi_rready)
					rstate_ns = S_RDIDLE;
				else
					rstate_ns = S_RDDATA;
			default:
				rstate_ns = S_RDIDLE;
		endcase
	end
	
	// *** Read data register ***
	always @(posedge aclk)
	begin
	    if (!aresetn)
	        rdata <= 0;
		else if (ar_hs)
			case (raddr)
				C_ADDR_START:
				    rdata <= {{31{1'b0}}, start_reg};
                C_ADDR_MODE_TEST:
                    rdata <= {{31{1'b0}}, mode_test_reg};
                C_ADDR_READY:
                    rdata <= {{31{1'b0}}, ready};
                C_ADDR_DONE:
                    rdata <= {{31{1'b0}}, done};
                C_ADDR_OUT_CONST:
                    rdata <= out_cosf;		
			endcase
	end
	
    // ### Control registers ###################################################
    assign start = start_reg;
    assign mode_test = mode_test_reg;
    
	always @(posedge aclk)
	begin
	    if (!aresetn)
	    begin
            start_reg <= 0;
            startsig_reg <= 0;
            cnt_start_reg <= 0;
            mode_test_reg <= 0;
        end
		else if (w_hs && waddr == C_ADDR_START)
		begin
			if (s_axi_wdata[0])
			begin
			    start_reg <= 1;
			    startsig_reg <= 1;
			end
	    end
		else if (w_hs && waddr == C_ADDR_MODE_TEST)
        begin
            mode_test_reg <= (s_axi_wdata[0] & wmask) | (mode_test_reg & ~wmask);
        end
	    else
	    begin
	        if (startsig_reg)
	        begin
	            cnt_start_reg <= cnt_start_reg + 1;
	            if (cnt_start_reg == 3-1)
	            begin
	                start_reg <= 0;
	                cnt_start_reg <= 0;
	            end
	        end
	    end
	end

endmodule
