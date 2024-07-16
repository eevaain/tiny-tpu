`default_nettype none
`timescale 1ns/1ns

module mmu(
  input wire clk,
  input wire reset,
  input wire load_weight,    // Signal to load weight
  input wire valid,          // Valid signal indicating new data is available

  input wire [7:0] a_in1,   // Input A for PE(0,0)
  input wire [7:0] a_in2,   // Input A for PE(1,0)

  input wire [7:0] weight1, // Weight for PE(0,0)
  input wire [7:0] weight2, // Weight for PE(0,1)
  input wire [7:0] weight3, // Weight for PE(1,0)
  input wire [7:0] weight4, // Weight for PE(1,1)

  // these values need to be stored in a register in matrix format
  output wire [7:0] acc_out1, // Accumulated value from PE(1,0)
  output wire [7:0] acc_out2  // Accumulated value from PE(1,1)
);
  // Internal signals for connections between PEs
  wire [7:0] a_inter_01, a_inter_11;
  wire [7:0] acc_inter_00, acc_inter_01;

  wire [7:0] a_out1 = 8'b0;
  wire [7:0] a_out2 = 8'b0;


  // Instantiate PE(0,0)
  processing_element PE00 (
    .clk(clk),
    .reset(reset),
    .load_weight(load_weight),
    .valid(valid),
    .a_in(a_in1),
    .weight(weight1),
    .acc_in(8'b0),   // Top-left corner has no accumulated input
    .a_out(a_inter_01),
    .acc_out(acc_inter_00)
  );

  // Instantiate PE(0,1)
  processing_element PE01 (
    .clk(clk),
    .reset(reset),
    .load_weight(load_weight),
    .valid(valid),
    .a_in(a_inter_01),
    .weight(weight3),
    .acc_in(8'b0),   // Top-right corner has no accumulated input
    .a_out(a_out1),
    .acc_out(acc_inter_01)
  );

  // Instantiate PE(1,0)
  processing_element PE10 (
    .clk(clk),
    .reset(reset),
    .load_weight(load_weight),
    .valid(valid),
    .a_in(a_in2),
    .weight(weight2),
    .acc_in(acc_inter_00), // Bottom-left corner gets accumulated input from PE(0,0)
    .a_out(a_inter_11),
    .acc_out(acc_out1)
  );

  // Instantiate PE(1,1)
  processing_element PE11 (
    .clk(clk),
    .reset(reset),
    .load_weight(load_weight),
    .valid(valid),
    .a_in(a_inter_11),
    .weight(weight4),
    .acc_in(acc_inter_01), // Bottom-right corner gets accumulated input from PE(0,1)
    .a_out(a_out2),
    .acc_out(acc_out2)
  );

endmodule
