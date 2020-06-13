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
    //input BTNL,
    output wire [31:0] result
    );
    
    //Debounce module for activate button
    //wire activate;
    //Debounce change_state (CLK100MHZ, BTNL, activate);
    
  
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
    assign result = m_axis_result_tdata;
    
    always @(posedge CLK100MHZ) begin
        s_axis_a_tdata <= 32'b01000000000100110011001100110011;
        s_axis_a_tvalid <= 1;
        s_axis_b_tdata <= 32'b01000000000100110011001100110011;
        s_axis_b_tvalid <= 1;
        s_axis_c_tdata <= 32'b01000000000100110011001100110011;
        s_axis_c_tvalid <= 1;
    end

endmodule
