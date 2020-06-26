`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.06.2020 15:43:10
// Design Name: 
// Module Name: memory
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
    // These signal names are for the nexys A7. 
    // Check your constraint file to get the right names
    input  CLK100MHZ,
    output wire [31:0] a,
    output wire [31:0] b,
    output wire [31:0] c,
    output wire [31:0] res
    //input [7:0] SW,  
    //output  [2:0] LED
    );
    //Matrix dimension
    localparam [5:0] row = 2;
    localparam [5:0] col = 4;
    
    //Matrix a variables
    reg A_en=1;
    reg A_we=0;
    reg [9:0] A_addr =0;
    reg [31:0] A_din =0;
    wire [31:0] A_dout;
    
    //Matrix b variables
    reg B_en=1;
    reg B_we=0;
    reg [9:0] B_addr =0;
    reg [31:0] B_din =0;
    wire [31:0] B_dout;
    
    //Matrix c variables
    reg C_en=1;
    reg C_we=0;
    reg [9:0] C_addr =0;
    reg [31:0] C_din =0;
    wire [31:0] C_dout;
    
    //fp variables
    reg [31:0] a_input;                    
    reg [31:0] b_input;                    
    reg [31:0] c_input;                    
    reg a_vbit;                       
    reg b_vbit;                       
    reg c_vbit;                        
    wire [31:0] result;                         
    wire result_vbit; 
    
     // MMA States
     localparam[7:0] WAIT = 8'b00000000;
     localparam[7:0] FETCH = 8'b00000001;
     localparam[7:0] STORE = 8'b00000010;
     localparam[7:0] START = 8'b00000011;
     localparam[7:0] RESET = 8'b00000100;
     localparam[7:0] IDLE = 8'b00000101;
     localparam[7:0] ASSERT = 8'b00000110;
     localparam[7:0] DEASSERT = 8'b00000111;
     localparam[7:0] CHECK = 8'b00001000;
    
    reg [7:0] state = RESET;                 // Current state
    
    reg [31:0] count = 0;                  // Counter value (clock cycles)
        
//////////////////////////////////////////////////////////////////////////////////
// Initialization of IP
//////////////////////////////////////////////////////////////////////////////////
    //BRAM intiilisation
    matrixA matrix_a(
          .clka(CLK100MHZ),    // input wire clka
          .ena(A_en),      // input wire ena
          .wea(A_we),      // input wire [0 : 0] wea
          .addra(A_addr),  // input wire [4 : 0] addra
          .dina(A_din),    // input wire [31 : 0] dina
          .douta(A_dout)  // output wire [31 : 0] douta
    );
    
    
      matrixB matrix_b(
          .clka(CLK100MHZ),    // input wire clka
          .ena(B_en),      // input wire ena
          .wea(B_we),      // input wire [0 : 0] wea
          .addra(B_addr),  // input wire [4 : 0] addra
          .dina(B_din),    // input wire [31 : 0] dina
          .douta(B_dout)  // output wire [31 : 0] douta
    );
    
       matrixC matrix_c(
          .clka(CLK100MHZ),    // input wire clka
          .ena(C_en),      // input wire ena
          .wea(C_we),      // input wire [0 : 0] wea
          .addra(C_addr),  // input wire [4 : 0] addra
          .dina(C_din),    // input wire [31 : 0] dina
          .douta(C_dout)  // output wire [31 : 0] douta
    );
    
    floating_point_0 floatmulti (
          .aclk(CLK100MHZ),                                  // input wire aclk
          .s_axis_a_tvalid(a_vbit),            // input wire s_axis_a_tvalid
          .s_axis_a_tdata(a_input),              // input wire [31 : 0] s_axis_a_tdata
          .s_axis_b_tvalid(b_vbit),            // input wire s_axis_b_tvalid
          .s_axis_b_tdata(b_input),              // input wire [31 : 0] s_axis_b_tdata
          .s_axis_c_tvalid(c_vbit),            // input wire s_axis_c_tvalid
          .s_axis_c_tdata(c_input),              // input wire [31 : 0] s_axis_c_tdata
          .m_axis_result_tvalid(result_vbit),  // output wire m_axis_result_tvalid
          .m_axis_result_tdata(result)    // output wire [31 : 0] m_axis_result_tdata
    );
//////////////////////////////////////////////////////////////////////////////////    
   
    assign res = result;
    assign a = a_input;
    assign b = b_input;
    assign c = c_input;
    
    reg [5:0] cnt_row = 0;
    reg [5:0] cnt_col = 0;
    
always @(posedge CLK100MHZ) begin

    // === STATE MACHINE ===
    case (state)
        RESET: begin
            A_addr <= 0;
            B_addr <= 0;
            C_addr <= 0;
            count <= 0;
            c_input <= 0;
            cnt_row <= 0;
            cnt_col <= 0;
            state <= START;
        end
        START: begin // Multiply element - initialisation
            state <= FETCH;
        end
        FETCH: begin
            a_input <= A_dout;
            A_addr <= A_addr + 1;
            b_input <= B_dout;
            B_addr <= B_addr + 1;
            state <= ASSERT;
        end
        ASSERT: begin
            a_vbit <= 1;
            b_vbit <= 1;
            c_vbit <= 1;
            state <= WAIT;
        end
        DEASSERT: begin
            a_vbit <= 0;
            b_vbit <= 0;
            c_vbit <= 0;
            C_we <= 0;
            C_din <= 0;
            state <= FETCH;
        end
        WAIT: begin
            if (count < 18) begin
                count <= count + 1;
            end
            else begin
                count <= 0;
                cnt_col <= cnt_col + 1;
                state <= CHECK;
            end
        end
        CHECK: begin
            //Check dimensions
            c_input <= result;
            if (cnt_col == col) begin
                state <= STORE;
            end
            else begin
                state <= DEASSERT;
            end
        end
        STORE: begin
            C_din <= result;
            C_addr <= C_addr + 1;
            C_we <= 1;
            cnt_row <= cnt_row + 1;
            c_input <= 0;
            if (cnt_row == row) begin
                state <= IDLE;
            end
            state <= DEASSERT;
        end
        IDLE: begin
        
        end

    endcase
    
end

endmodule