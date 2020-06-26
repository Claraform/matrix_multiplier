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


module memory( 
    // These signal names are for the nexys A7. 
    // Check your constraint file to get the right names
    input  CLK100MHZ,
    input [7:0] SW,  
    output  [2:0] LED
    );
    
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
    reg C_we=1;
    reg [9:0] C_addr =0;
    reg [31:0] C_din =0;
    wire [31:0] C_dout;
    
    //fp variables
    reg [31:0] a_input = 0;                    
    reg [31:0] b_input = 0;                    
    reg [31:0] c_input = 0;                    
    reg a_vbit = 1;                       
    reg b_vbit = 1;                       
    reg c_vbit = 1;                        
    wire [31:0] result;                         
    wire result_vbit; 
    
    localparam[7:0]                            // MMA States
        ST_RESET = 8'h00,                       // Reset
        ST_IDLE = 8'h01,                        // Idle
        ST_WAIT = 8'h02,                        // Wait
        ST_ERROR = 8'h0F,                       // Error
        ST_RXA = 8'h10,                         // Receive matrix A - initialisation
        ST_RXA_DIM1 = 8'h11,                    // Receive matrix A - dimension 1
        ST_RXA_DIM2 = 8'h12,                    // Receive matrix A - dimension 2
        ST_RXA_DATA = 8'h13,                    // Receive matrix A - data (values)
        ST_RXA_COMPLETE = 8'h14,                // Receive matrix A - complete
        ST_RXB = 8'h20,                         // Receive matrix B - initialisation
        ST_RXB_DIM1 = 8'h21,                    // Receive matrix B - dimension 1
        ST_RXB_DIM2 = 8'h22,                    // Receive matrix B - dimension 1
        ST_RXB_DATA = 8'h23,                    // Receive matrix B - dimension 1
        ST_RXB_COMPLETE = 8'h24,                // Receive matrix B - complete
        ST_MUL = 8'h30,                         // Multiply matrices - initialisation
        ST_MUL_LOADDIMS = 8'h31,                // Multiply matrices - load dimensions
        ST_MUL_VERIFYDIMS = 8'h32,              // Multiply matrices - verify dimensions
        ST_MUL_EL_START = 8'h33,                // Multiply element - initialisation
        ST_MUL_EL_FETCH = 8'h34,                // Multiply element - fetch values
        ST_MUL_EL_FPSET = 8'h35,                // Multiply element - load into FPU
        ST_MUL_EL_FPWAIT = 8'h36,               // Multiply element - wait for FPU
        ST_MUL_EL_FPGET = 8'h37,                // Multiply element - get FPU result
        ST_MUL_EL_WRITE = 8'h38,                // Multiply element - write back result
        ST_MUL_TXCOMPLETE = 8'h39,              // Multiply matrices - transmit completion message
        ST_MUL_COMPLETE = 8'h3A,                // Multiply matrices - complete
        ST_TXR = 8'h40,                         // Transmit result - initialisation
        ST_TXR_DIM1 = 8'h41,                    // Transmit result - dimension 1
        ST_TXR_DIM2 = 8'h42,                    // Transmit result - dimension 2
        ST_TXR_DATA = 8'h43,                    // Transmit result - data (values)
        ST_TXR_COMPLETE = 8'h44,                // Transmit result - complete
        ST_UART_GET4 = 8'h50,                   // UART receive 4 bytes - initialisation
        ST_UART_GET4_RX = 8'h51,                // UART receive 4 bytes - receive data
        ST_UART_PUT4 = 8'h52,                   // UART transmit 4 bytes - initialisation
        ST_UART_PUT4_TX = 8'h53,                // UART transmit 4 bytes - transmit data
        ST_UART_RX_WAIT = 8'h5A,                // UART wait for receive
        ST_UART_RX_TIMEOUT = 8'h5B,             // UART timed-out while waiting
        ST_UART_TX_WAIT = 8'h5C,                // UART wait for transmit
        ST_BRAM_A_WEA = 8'h60,                  // BRAM A assert wea for a cycle
        ST_BRAM_A_WEA_LOW = 8'h61,              // BRAM A deassert wea
        ST_BRAM_B_WEA = 8'h62,                  // BRAM B assert wea for a cycle
        ST_BRAM_B_WEA_LOW = 8'h63,              // BRAM B deassert wea
        ST_BRAM_R_WEA = 8'h64,                  // BRAM R assert wea for a cycle
        ST_BRAM_R_WEA_LOW = 8'h65;              // BRAM R deassert wea
    
    reg [7:0] state = ST_RESET;                 // Current state
    reg [7:0] return_state = ST_RESET; 
    
    reg [31:0] scratch[5:0];
    
    reg [15:0] a_m = 3;                         // Matrix A dimension 1
    reg [15:0] a_n = 3;                         // Matrix A dimension 2
    reg [15:0] a_i = 0;                         // Matrix A dimension 1 position
    reg [15:0] a_j = 0;                         // Matrix A dimension 2 position
    reg [31:0] a_v = 0;                         // Matrix A element value
    reg [15:0] b_m = 3;                         // Matrix B dimension 1
    reg [15:0] b_n = 3;                         // Matrix B dimension 2
    reg [15:0] b_i = 0;                         // Matrix B dimension 1 position
    reg [15:0] b_j = 0;                         // Matrix B dimension 2 position
    reg [31:0] b_v = 0;                         // Matrix B element value
    reg [15:0] r_m = 0;                         // Matrix R dimension 1
    reg [15:0] r_n = 0;                         // Matrix R dimension 2
    reg [15:0] r_i = 0;                         // Matrix R dimension 1 position
    reg [15:0] r_j = 0;                         // Matrix R dimension 2 position
    reg [31:0] r_v = 0;                         // Matrix R element value
    
    reg counter_en = 0;                         // Counter enable
    reg counter_reset = 0;                      // Counter reset
    wire [31:0] counter_value;                  // Counter value (clock cycles)
        
//////////////////////////////////////////////////////////////////////////////////
// Initialization of IP
//////////////////////////////////////////////////////////////////////////////////
    //Matrix A intiilisation
    memory_a matrix_a(
          .clka(CLK100MHZ),    // input wire clka
          .ena(A_en),      // input wire ena
          .wea(A_we),      // input wire [0 : 0] wea
          .addra(A_addr),  // input wire [4 : 0] addra
          .dina(A_din),    // input wire [31 : 0] dina
          .douta(A_dout)  // output wire [31 : 0] douta
    );
    
    
      memory_b matrix_b(
          .clka(CLK100MHZ),    // input wire clka
          .ena(A_en),      // input wire ena
          .wea(A_we),      // input wire [0 : 0] wea
          .addra(A_addr),  // input wire [4 : 0] addra
          .dina(A_din),    // input wire [31 : 0] dina
          .douta(A_dout)  // output wire [31 : 0] douta
    );
    
       memory_c matrix_c(
          .clka(CLK100MHZ),    // input wire clka
          .ena(C_en),      // input wire ena
          .wea(C_we),      // input wire [0 : 0] wea
          .addra(C_addr),  // input wire [4 : 0] addra
          .dina(C_din),    // input wire [31 : 0] dina
          .douta(C_dout)  // output wire [31 : 0] douta
    );
    
    floatmulti floatmulti (
          .aclk(CLK100MHz),                                  // input wire aclk
          .s_axis_a_tvalid(a_vbit),            // input wire s_axis_a_tvalid
          .s_axis_a_tready(s_axis_a_tready),            // output wire s_axis_a_tready
          .s_axis_a_tdata(a_input),              // input wire [31 : 0] s_axis_a_tdata
          .s_axis_b_tvalid(b_vbit),            // input wire s_axis_b_tvalid
          .s_axis_b_tready(s_axis_b_tready),            // output wire s_axis_b_tready
          .s_axis_b_tdata(b_input),              // input wire [31 : 0] s_axis_b_tdata
          .s_axis_c_tvalid(c_vbit),            // input wire s_axis_c_tvalid
          .s_axis_c_tready(s_axis_c_tready),            // output wire s_axis_c_tready
          .s_axis_c_tdata(c_input),              // input wire [31 : 0] s_axis_c_tdata
          .m_axis_result_tvalid(result_vbit),  // output wire m_axis_result_tvalid
          .m_axis_result_tready(result),  // input wire m_axis_result_tready
          .m_axis_result_tdata(m_axis_result_tdata)    // output wire [31 : 0] m_axis_result_tdata
    );
//////////////////////////////////////////////////////////////////////////////////    

always @(posedge CLK100MHZ) begin

    // === STATE MACHINE ===
    case (state)
        
         ST_WAIT: begin // Wait
            if (scratch[0]) begin
                scratch[0] <= scratch[0] - 1; // Decrement scratch[0] until zero
            end else begin
                state <= return_state; // Return to previous state
            end 
        end       
        
        ST_MUL: begin // Multiply matrices - initialisation
            scratch[2] <= 0; // Clear scratch[2]
            scratch[3] <= 0; // Clear scratch[3]
            scratch[4] <= 0; // Clear scratch[4]
            scratch[5] <= 0; // Clear scratch[5]
            a_i <= 0; // Clear a_i
            a_j <= 0; // Clear a_j
            b_i <= 0; // Clear b_i
            b_j <= 0; // Clear b_j
            r_i <= 0; // Clear r_i
            r_j <= 0; // Clear r_j
            counter_reset <= 1'b1; // Reset counter
            state <= ST_MUL_VERIFYDIMS; // Change state to MUL_VERIFYDIMS
        end

        ST_MUL_VERIFYDIMS: begin // Multiply matrices - verify dimensions
            counter_reset <= 1'b0; // Deassert counter_reset
            if (a_n == b_m) begin // Check if dimensions are compatible
                counter_en <= 1'b1; // Enable counter
                r_m <= a_m; // Set matrix R M dimension to matrix A N dimension
                r_n <= b_n; // Set matrix R N dimension to matrix B M dimension
                if (!scratch[3][0]) begin
                    C_addr <= 0; // Set BRAM R address to 0
                    C_din <= a_m; // Set BRAM R data in to m dimension
                    scratch[3][0] <= 1'b1; // Assert scratch[3][0]
                    return_state <= ST_MUL_VERIFYDIMS; // Set return state to MUL_VERIFYDIMS
                    state <= ST_BRAM_R_WEA; // Change state to BRAM_R_WEA (write to BRAM R)
                end else begin
                    C_addr <= 1; // Set BRAM R address to 1
                    C_din <= b_n; // Set BRAM R data in to n dimension
                    scratch[3][0] <= 1'b0; // Deassert scratch[3][0]
                    return_state <= ST_MUL_EL_START; // Set return state to MUL_EL_START
                    state <= ST_BRAM_R_WEA; // Change state to BRAM_R_WEA (write to BRAM R)
                end
            end else begin // Dimensions not compatible
                scratch[0] <= 1; // Set argument to 1 (error 1)
                state <= ST_ERROR; // Set state to error
            end
        end

        ST_MUL_EL_START: begin // Multiply element - initialisation
            if (r_i < r_m) begin // Iterate through rows
                a_i <= r_i; // set A row to R row
                if (r_j < r_n) begin // Iterate through columns
                    if (a_j < a_n) begin // Iterate through elements
                        A_addr <= a_i*a_n + a_j + 2; // Set BRAM A address
                        B_addr <= b_i*b_n + b_j + 2; // Set BRAM B address
                        return_state <= ST_MUL_EL_FETCH; // Set return state to MUL_EL_FETCH (fetch, MAC)
                        scratch[0] <= 1; // Set scratch[0] (delay duration) to 1
                        state <= ST_WAIT; // Change state to WAIT
                        a_j <= a_j + 1; // Increment a_j
                        b_i <= b_i + 1; // Increment b_i
                    end else begin
                        state <= ST_MUL_EL_WRITE; // Change state to MUL_EL_WRITE (write result element to BRAM)
                        a_j <= 0; // Reset a_j
                        b_i <= 0; // Reset b_i
                        b_j <= b_j + 1; // Increment b_j
                    end
                end else begin
                    r_j <= 0; // Reset r_j
                    b_j <= 0; // Reset b_j
                    r_i <= r_i + 1; // Increment r_i
                    a_i <= a_i + 1; // Increment a_i
                end
            end else begin
                state <= ST_MUL_COMPLETE; // Change state to MUL_TXCOMPLETE
                r_i <= 0; // Reset r_i
                a_i <= 0; // Reset a_i
            end
        end

        ST_MUL_EL_FETCH: begin // Multiply element - fetch values
            a_v <= A_dout; // Get a_v
            b_v <= B_dout; // Get b_v
            state <= ST_MUL_EL_FPSET; // Change state to MUL_EL_FPSET
        end

        ST_MUL_EL_FPSET: begin // Multiply element - load into FPU
            a_input <= a_v; // Set FPU input A to a_v
            b_input <= b_v; // Set FPU input B to b_v
            c_input <= r_v; // Set FPU input C to r_v
            a_vbit <= 1'b1; // Assert FPU input A valid
            b_vbit <= 1'b1; // Assert FPU input B valid
            c_vbit <= 1'b1; // Assert FPU input C valid
            state <= ST_MUL_EL_FPWAIT; // Change state to MUL_EL_FPWAIT
        end

        ST_MUL_EL_FPWAIT: begin // Multiply element - wait for FPU
            scratch[0] <= 19; // Set argument to 19
            return_state <= ST_MUL_EL_FPGET; // Set return state to MUL_EL_FPGET
            state <= ST_WAIT; // Change state to WAIT (wait for 19 cycles for FPU)
        end

        ST_MUL_EL_FPGET: begin // Multiply element - get FPU result
            r_v <= result; // Save fpu_r into r_v
            state <= ST_MUL_EL_START; // Change state to MUL_EL_START
        end

        ST_MUL_EL_WRITE: begin // Multiply element - write back result
            C_addr <= r_i*r_n + r_j + 2; // Set BRAM R address
            r_j <= r_j + 1; // Increment r_j
            C_din <= r_v; // Set BRAM R data in to r_v
            r_v <= 0; // Reset r_v
            return_state <= ST_MUL_EL_START; // Set return state to MUL_EL_START
            state <= ST_BRAM_R_WEA; // Change state to BRAM_R_WEA (write to BRAM)
        end   
        
         ST_MUL_COMPLETE: begin // Multiply matrices - complete
//            uart_tx_begin <= 1'b0; // Deassert uart_tx_begin
            counter_en <= 1'b0; // Disable counter
            // Reset registers
            scratch[2] <= 0;
            scratch[3] <= 0;
            a_i <= 0;
            a_j <= 0;
            a_v <= 0;
            b_i <= 0;
            b_j <= 0;
            b_v <= 0;
            r_i <= 0;
            r_j <= 0;
            r_v <= 0;
            state <= ST_IDLE; // Change state to IDLE
        end
        
        ST_BRAM_R_WEA: begin // BRAM R assert wea for a cycle
            C_we <= 1'b1; // Assert wea
            scratch[5][7:0] <= scratch[0][7:0]; // Save argument to scratch[5]
            scratch[5][15:8] <= return_state; // Save return state to scratch[5]
            scratch[0] <= 1; // Set argument to 1
            return_state <= ST_BRAM_R_WEA_LOW; // Set return state to BRAM_R_WEA_LOW
            state <= ST_WAIT; // Change state to WAIT
        end
        
        

        ST_BRAM_R_WEA_LOW: begin // BRAM R deassert wea
            C_we <= 1'b0; // Deassert wea
            scratch[5][15:0] <= 0; // Reset used parts of scratch[5]
            return_state <= scratch[5][7:0]; // Set return state
            state <= scratch[5][15:8]; // Return
        end

    endcase
    
end

endmodule

