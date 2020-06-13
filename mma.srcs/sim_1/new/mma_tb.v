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
reg CLK100MHZ;
wire [31:0] res;
multiplier m(clk, res); // Fibonacci module instantiation

initial begin
    $display("clk   res");
    $monitor("%b   result=%b", clk, res);
    
    clk <= 0;
    
    repeat(40)  // <<< NB: may need to depending on n
        begin
            #5 clk = ~clk;
        end

end
endmodule
