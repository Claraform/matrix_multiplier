`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.06.2020 13:24:59
// Design Name: 
// Module Name: mma_tb
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


module mma_tb(

    );

// Fibonacci module inputs/outputs
reg clk;
reg start;
reg [7:0] cycle = 0;
reg [31:0] A = 32'b01000000000100110011001100110011;
reg [31:0] B = 32'b01000000000100110011001100110011;
reg [31:0] C = 32'b01000000000100110011001100110011;
wire [31:0] res;
wire tvalid;
//multiplier m(clk, A, B, C, res); 
multiplier m(clk, start, tvalid, res);

initial begin
//    $display("clk cycle   A   B   C   res");
//    $monitor("cycle=%2d   A=%h, B=%h, C=%h, result=%h", cycle, A, B, C, res);
    $display("clk cycle  start tvalid    res");
    $monitor("cycle=%2d  start=%b valid=%b result=%h", cycle, start, tvalid, res);
    
    start <= 0;
    clk <= 0;
    #5
    clk <= 1;
    #5
    start <= 1;
    cycle <= 1;
    #5
    clk <= 0;
    #5
    clk <= 1;
    #5
    cycle <= 2;
    start <= 0;
    
    repeat(120)  // <<< NB: may need to depending on n
        begin
            #5 clk = ~clk;
            if (clk == 1) begin
                cycle <= cycle + 1;
            end
        end

end
endmodule
