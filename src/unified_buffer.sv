`default_nettype none
`timescale 1ns/1ns

module unified_buffer (
  input wire fetch_inp,
  input wire [7:0] ui_in, 
    // TODO: Implement logic to load data into unified_mem using these two inputs above. 


  input wire clk,
  input wire reset,

  input wire full_acc1, // full flag from accumulator 1
  input wire full_acc2, // full flag from accumulator 2

  input wire [12:0] addr, // address to input to
  input wire load_input, // flag for loading input from own memory to input_setup buffer

  input wire store, // flag for storing data from accumulators to unified buffer
  input wire ext, // flag for output to host computer

  input wire [7:0] acc1_mem_0,
  input wire [7:0] acc1_mem_1,
  input wire [7:0] acc2_mem_0,
  input wire [7:0] acc2_mem_1,

  // triggered on write operation 
  output reg [7:0] out_ub_00,
  output reg [7:0] out_ub_01,
  output reg [7:0] out_ub_10,
  output reg [7:0] out_ub_11,

  output reg [7:0] final_out
);

  // turn this all into an FSM for reading from memory, acc_to_ub, and ub to output pins
  parameter MEM_SIZE = 32;

  reg [7:0] unified_mem [0:MEM_SIZE-1];
  reg [1:0] incrementor; 
  integer i;

  typedef enum reg [1:0] {IDLE, WRITE_TO_HOST} state_t; // this is for taking product matrix out of chip
  state_t state = IDLE;


  reg [12:0] addr_pointer; 
  reg [12:0] end_addr; 

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      for (i = 0; i < MEM_SIZE; i = i + 1) begin
        unified_mem[i] <= 8'b0;
      end
      out_ub_00 <= 8'b0;
      out_ub_01 <= 8'b0;
      out_ub_10 <= 8'b0;
      out_ub_11 <= 8'b0;
      incrementor <= 2'b0;
      final_out <= 8'b0;
      end_addr <= 13'b0; 
      addr_pointer <= 13'b0;
    end else begin
      /* READ FROM MEMORY */  
      if (load_input) begin
        out_ub_00 <= unified_mem[addr]; 
        out_ub_01 <= unified_mem[addr + 1]; 
        out_ub_10 <= unified_mem[addr + 2]; 
        out_ub_11 <= unified_mem[addr + 3]; 
      end

      /* STORE TO MEMORY */
      if (store && full_acc1 && full_acc2) begin 
        unified_mem[addr] <= acc1_mem_0;
        unified_mem[addr + 1] <= acc1_mem_1;
        unified_mem[addr + 2] <= acc2_mem_0;
        unified_mem[addr + 3] <= acc2_mem_1;
      end

        case (state)
          IDLE: begin
            final_out <= 8'b0; 
            end_addr <= 13'b0; 
            addr_pointer <= 13'b0;
            if (ext) begin
              state <= WRITE_TO_HOST;
              addr_pointer <= addr; 
              end_addr <= addr + 4; 
            end
          end
          WRITE_TO_HOST: begin
            if (addr_pointer < end_addr) begin
              final_out <= unified_mem[addr_pointer];
              addr_pointer <= addr_pointer + 1; 
            end else begin
                state <= IDLE; 
            end
          end
        endcase
          
    end
  end
endmodule
