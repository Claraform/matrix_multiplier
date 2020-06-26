`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.06.2020 17:30:39
// Design Name: 
// Module Name: memory_tb
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


module memory_tb();


       reg CLK100MHZ; 
       reg [7:0] SW;
       
       wire [2:0] LED;
       
       memory memory_tb( CLK100MHZ,SW, LED);
       
       initial
       
       begin
       memory.state<='h30;
       $monitor("C_in is %b",memory.C_din);
       CLK100MHZ <= 1;
       end
       
       always begin
            #20 CLK100MHZ <= ~CLK100MHZ;
       end
endmodule
