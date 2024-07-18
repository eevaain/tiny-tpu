`default_nettype none
`timescale 1ns/1ns

module processing_element (
  input wire clk,
  input wire reset,
  input wire load_weight,       // Signal to load weight
  input wire valid,             // Valid signal indicating new data is available

  input wire [7:0] a_in,       // Input A from left neighbor
  input wire [7:0] weight,     // Weight input
  input wire [7:0] acc_in,     // Accumulated value from the PE above

  output reg [7:0] a_out,    // Output A to right neighbor
  output reg [7:0] acc_out   // Accumulated value to the PE below
);

  reg [7:0] weight_reg; // Register to hold the stationary weight

  always @(posedge clk or posedge reset) begin
      // perhaps create a state machine for load weight and valid (aka compute).... 
      // could help avoid race conditioning? 
    if (reset) begin
      
      a_out <= 8'b0;
      acc_out <= 8'b0;
      weight_reg <= 8'b0;

    end else begin

      if (load_weight) begin
        weight_reg <= weight;
      end 

      if (valid) begin // means compute!
        acc_out <= acc_in + (a_in * weight_reg);
        a_out <= a_in;
      end

    end
  end
endmodule
