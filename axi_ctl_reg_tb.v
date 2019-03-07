// Author: Erwin Ouyang
// Date  : 31 Jan 2019

`timescale 1ns / 1ps

module axi_ctl_reg_tb();
    localparam T = 10;

    reg aclk;
    reg aresetn;
    wire s_axi_arready;
    reg [31:0] s_axi_araddr;
    reg s_axi_arvalid; 
    wire s_axi_awready;
    reg [31:0] s_axi_awaddr;
    reg s_axi_awvalid;  
    reg s_axi_bready;
    wire [1:0] s_axi_bresp;
    wire s_axi_bvalid;
    reg s_axi_rready;
    wire [31:0] s_axi_rdata;
    wire [1:0] s_axi_rresp;
    wire s_axi_rvalid;
    wire s_axi_wready;
    reg [31:0] s_axi_wdata;
    reg [3:0] s_axi_wstrb;
    reg s_axi_wvalid;
    wire start;
    wire mode_test;
    reg ready;
    reg done;
    reg [31:0] out_cosf;

    axi_ctl_reg dut
    (
        .aclk(aclk),
        .aresetn(aresetn),
        .s_axi_araddr(s_axi_araddr),
        .s_axi_arready(s_axi_arready),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_awaddr(s_axi_awaddr),
        .s_axi_awready(s_axi_awready),
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_bready(s_axi_bready),
        .s_axi_bresp(s_axi_bresp),
        .s_axi_bvalid(s_axi_bvalid),
        .s_axi_rdata(s_axi_rdata),
        .s_axi_rready(s_axi_rready),
        .s_axi_rresp(s_axi_rresp),
        .s_axi_rvalid(s_axi_rvalid),
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wready(s_axi_wready),
        .s_axi_wstrb(s_axi_wstrb),
        .s_axi_wvalid(s_axi_wvalid),
        .start(start),
        .mode_test(mode_test),
        .ready(ready),
        .done(done),
        .out_cosf(out_cosf)
    );

    always
    begin
        aclk = 0;
        #(T/2);
        aclk = 1;
        #(T/2);
    end

    initial
    begin
        s_axi_awaddr = 0;
        s_axi_awvalid = 0;
        s_axi_wstrb = 0;
        s_axi_wdata = 0;
        s_axi_wvalid = 0;
        s_axi_bready = 1;
        s_axi_araddr = 0;
        s_axi_arvalid = 0;
        s_axi_rready = 1;
        ready = 0;
        done = 0;
        out_cosf = 0;
        
        // *** Reset ***
        aresetn = 0;
        #(T*5);
        aresetn = 1;
        #(T*5);
    
        // Mode test = 0
        axi_write(8'h04, 32'h0);
        // Start
        axi_write(8'h00, 32'h1);
        // Wait for done = 1
        #(T*100);       // Dummy
        done = 1;       // Dummy
        out_cosf = 168;  // Dummy
        // Read done
        axi_read(8'h0c);
        done = 0;
        // Read cosf
        axi_read(8'h10);
        
        // Wait for ready = 1
        #(T*100);       // Dummy
        ready = 1;      // Dummy
        // Read ready
        axi_read(8'h08);
        ready = 0;
        
        // Mode test = 1
        axi_write(8'h04, 32'h1);
        // Start
        axi_write(8'h00, 32'h1);

        // Wait for done = 1
        #(T*100);       // Dummy
        done = 1;       // Dummy
        // Read done
        axi_read(8'h0c);
        done = 0;                  
    end

    task axi_write;
        input [31:0] awaddr;
        input [31:0] wdata; 
        begin
            // *** Write address ***
            s_axi_awaddr = awaddr;
            s_axi_awvalid = 1;
            #T;
            s_axi_awvalid = 0;
            // *** Write data ***
            s_axi_wdata = wdata;
            s_axi_wstrb = 4'hf;
            s_axi_wvalid = 1; 
            #T;
            s_axi_wvalid = 0;
            #T;
        end
    endtask
    
    task axi_read;
        input [31:0] araddr;
        begin
            // *** Read address ***
            s_axi_araddr = araddr;
            s_axi_arvalid = 1;
            #T;
            s_axi_arvalid = 0;
            #T;
        end
    endtask

endmodule
