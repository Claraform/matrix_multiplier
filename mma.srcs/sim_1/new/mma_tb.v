`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////


module mma_tb(

    );

// Fibonacci module inputs/outputs
reg clk = 0;
reg start;
reg [7:0] cycle = 0;
wire [31:0] res;
wire [31:0] a;
wire [31:0] b;
wire [31:0] c;
wire [5:0] count;
wire tvalid;
//multiplier m(clk, A, B, C, res); 
multiplier m(clk, a, b, c, res);

initial begin
//    $display("clk cycle   A   B   C   res");
//    $monitor("cycle=%2d   A=%h, B=%h, C=%h, result=%h", cycle, A, B, C, res);
    $display("clk cycle  start tvalid    res");
    $monitor("cycle=%3d a=%h b=%h c=%h result=%h", cycle, a, b, c, res);
 
  
    clk<=1;
    end

     // <<< NB: may need to depending on n
    always begin
        # 20 clk = ~clk;
        if (clk == 1) begin
            cycle <= cycle + 1;
        end
    end


endmodule