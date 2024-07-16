`default_nettype none
`timescale 1ns/1ns

module unified_buffer (
  input wire clk,
  input wire reset,

  input wire store_acc1, // full flag from accumulator 1
  input wire store_acc2, // full flag from accumulator 2

  input wire [12:0] addr, // address to input to
  input wire load_input, // flag for loading input from own memory to input_setup buffer

  input wire store, // flag for storing data from accumulators to unified buffer

  input wire [7:0] acc1_mem_0,
  input wire [7:0] acc1_mem_1,
  input wire [7:0] acc2_mem_0,
  input wire [7:0] acc2_mem_1,

  // triggered on write operation 
  output reg [7:0] out_ub_00,
  output reg [7:0] out_ub_01,
  output reg [7:0] out_ub_10,
  output reg [7:0] out_ub_11
);

  parameter MEM_SIZE = 64;
  parameter ADDR_WIDTH = 6;

  reg [7:0] unified_mem [0:MEM_SIZE-1];
  reg [ADDR_WIDTH-1:0] write_pointer; // next free memory location
  integer i;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      for (i = 0; i < MEM_SIZE; i = i + 1) begin
        unified_mem[i] <= 8'b0;
      end
      write_pointer <= 0;
      out_ub_00 <= 8'b0;
      out_ub_01 <= 8'b0;
      out_ub_10 <= 8'b0;
      out_ub_11 <= 8'b0;
    end else begin
      /* READ FROM MEMORY */  
      if (load_input) begin
        out_ub_00 <= unified_mem[addr]; 
        out_ub_01 <= unified_mem[addr + 1]; 
        out_ub_10 <= unified_mem[addr + 2]; 
        out_ub_11 <= unified_mem[addr + 3]; 
      end

      /* STORE TO MEMORY */
      if (store && store_acc1 && store_acc2) begin
        unified_mem[addr] <= acc1_mem_0;
        unified_mem[addr + 1] <= acc1_mem_1;
        unified_mem[addr + 2] <= acc2_mem_0;
        unified_mem[addr + 3] <= acc2_mem_1;
        write_pointer <= addr + 4;
      end
    end
  end
endmodule
