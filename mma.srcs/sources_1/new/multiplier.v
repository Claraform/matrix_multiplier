`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.06.2020 12:47:58
// Design Name: 
// Module Name: multiplier
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module multiplier(
    input  CLK100MHZ,
    input start,
    output wire [31:0] a,
    output wire [31:0] b,
    output wire [31:0] c,
    output wire [31:0] result,
    output wire [5:0] cnt
    );
    
    //Debounce module for activate button
    //wire activate;
    //Debounce change_state (CLK100MHZ, BTNL, activate);
    
    //Matrix variables
    reg [6:0] A_row = 2;
    reg [6:0] A_col = 1;
    reg [6:0] B_row = 1;
    reg [6:0] B_col = 2;
    reg [6:0] size = 2;
    
    //BRAM I/O
    reg ena = 1;
    reg wea = 1;
    reg enb = 1;
    reg [6:0] addra=10;
    reg [31:0] dina; 
    reg [6:0] addrb=0;
    wire [31:0] doutb;
    
    //Temporary address hold
    reg [6:0] add_temp = 0;
    
    //BRAM Module
    blk_mem_gen_0 your_instance_name (
      .clka(CLK100MHZ),    // input wire clka
      .ena(ena),      // input wire ena
      .wea(wea),      // input wire [0 : 0] wea
      .addra(addra),  // input wire [6 : 0] addra
      .dina(dina),    // input wire [31 : 0] dina
      .clkb(CLK100MHZ),    // input wire clkb
      .enb(enb),      // input wire enb
      .addrb(addrb),  // input wire [6 : 0] addrb
      .doutb(doutb)  // output wire [31 : 0] doutb
    );
  
    //Floating Point Module I/O
    reg s_axis_a_tvalid;  
    reg [31:0] s_axis_a_tdata;   
    reg s_axis_b_tvalid;            
    reg [31:0] s_axis_b_tdata;             
    reg s_axis_c_tvalid;           
    reg [31:0] s_axis_c_tdata;             
    wire m_axis_result_tvalid;  
    wire [31:0] m_axis_result_tdata;  
    
    //Multiply module
    floating_point_0 float (
        .aclk(CLK100MHZ),                              // input wire aclk
        .s_axis_a_tvalid(s_axis_a_tvalid),            // input wire 
        .s_axis_a_tdata(s_axis_a_tdata),              // input wire 
        .s_axis_b_tvalid(s_axis_b_tvalid),            // input wire 
        .s_axis_b_tdata(s_axis_b_tdata),              // input wire 
        .s_axis_c_tvalid(s_axis_c_tvalid),            // input wire 
        .s_axis_c_tdata(s_axis_c_tdata),              // input wire 
        .m_axis_result_tvalid(m_axis_result_tvalid),  // output wire 
        .m_axis_result_tdata(m_axis_result_tdata)    // output wire 
    );
    
    reg [5:0] count = 0;
    reg [5:0] row_items = 0;
    reg [5:0] col_items = 0;
    reg fetch = 0;
    reg fetch_index = 0;
    reg [2:0] fetch_cycle = 0;
    reg calculate = 0;
    
    assign result = m_axis_result_tdata;
    assign a = s_axis_a_tdata;
    assign b = s_axis_b_tdata;
    assign c = s_axis_c_tdata;
    assign cnt = count;
    
    always @(posedge fetch, negedge fetch) begin
        if (fetch_index == 0) begin
            addrb <= add_temp; 
            s_axis_a_tdata = doutb;
            fetch_index <= 1;
        end
        if (fetch_index == 1) begin
            addrb <= addrb + size;
            s_axis_b_tdata = doutb;
            add_temp <= add_temp + 1;
            fetch_index <= 0;
        end
    end
    
    always @(posedge calculate, negedge calculate) begin
        if (fetch_cycle < 2) begin
            fetch <= ~fetch;
            fetch_cycle <= fetch_cycle + 1;
        end 
        else begin
            fetch_cycle <= 0;
            s_axis_a_tvalid = 1;
            s_axis_b_tvalid = 1;
            s_axis_c_tdata <= m_axis_result_tdata;
            s_axis_c_tvalid <= 1;
        end       
    end
    
    
    always @(posedge CLK100MHZ) begin
//        if (start) begin
//            s_axis_c_tdata <= 0;
//            count <= 0;
//        end
        if (count < 5) begin
            calculate <= ~calculate;
        end
//        if (count >= 5 && count < 25) begin
//            calculate <= 0;
//        end
        if (count >= 25) begin
            row_items <= row_items + 1;
            count <= 0;
            if (row_items == A_row) begin
                row_items <= 0;
                col_items <= col_items + 1;
                dina <= m_axis_result_tdata;
                addra = addra + 1;
                if (col_items == A_col) begin
                    // We are done
                end
            end  
        end
        count <= count + 1;             
    end
    
    endmodule
