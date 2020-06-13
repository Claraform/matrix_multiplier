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
    output wire tvalid,
    output wire [31:0] result
    );
    
    //Debounce module for activate button
    //wire activate;
    //Debounce change_state (CLK100MHZ, BTNL, activate);
    
    //BRAM I/O
    reg ena;
    reg wea;
    reg enb;
    reg [6:0] addra=0;
    reg [31:0] dina; 
    reg [6:0] addrb=0;
    wire [31:0] doutb;
    
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
    
    assign result = doutb;
    assign tvalid = m_axis_result_tvalid;
    
    always @(posedge CLK100MHZ) begin
        s_axis_a_tdata <= doutb;
        s_axis_a_tvalid <= 1;
        addrb <= addrb + 1;
        s_axis_b_tdata <= doutb;
        s_axis_b_tvalid <= 1;
        s_axis_c_tdata <= doutb;
        s_axis_c_tvalid <= 1;
        
        if (m_axis_result_tvalid) begin
            wea <= 1;
            dina <= m_axis_result_tdata;
            wea <= 0;
            addra <= addra + 1;
        end
        
//        s_axis_c_tdata <= m_axis_result_tdata;
//        s_axis_a_tdata <= 0;
//        s_axis_a_tvalid <= 1;
//        s_axis_b_tdata <= 0;
//        s_axis_b_tvalid <= 1;
//        s_axis_c_tvalid <= 1;
        
          
//        wea <= 1;
//        dina <= m_axis_result_tdata;
//        wea <= 0;
//        addra <= addra + 1;
    end

endmodule