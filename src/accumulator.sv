`default_nettype none
`timescale 1ns/1ns

module accumulator (
  input wire clk,
  input wire reset,
  input wire valid,
  input wire [7:0] acc_in,

  output reg [7:0] acc_mem_0, // Output for the first memory location
  output reg [7:0] acc_mem_1, // Output for the second memory location
  output reg full // Flag to indicate when the accumulator is full
);

  // Define a register array to store multiple accumulated values
  reg [7:0] acc_mem [0:1]; // Changed to 2 entries
  reg [1:0] index; // Index to manage storage locations
  integer i; // Declare integer outside of the always block

  // Implement a state machine for this maybe??
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      for (i = 0; i < 2; i = i + 1) begin
          acc_mem[i] <= 0;
      end

      index <= 0;
      full <= 0;
      acc_mem_0 <= 0;
      acc_mem_1 <= 0; 
    end else begin

      // Nothing starts until valid (compute) flag is set! 
      // Valid flag must be held high for compute to finish!
      if (valid && acc_in != 0 && !full) begin
        acc_mem[index] <= acc_in;
        if (index < 1) begin 
          index <= index + 1;
        end else begin 
          full <= 1; // Set full flag when all memory locations are filled
        end
      end

      // Output the accumulated values when the accumulator is full
      if (full) begin 
        acc_mem_0 <= acc_mem[0]; 
        acc_mem_1 <= acc_mem[1];
      end
    end
  end

endmodule
