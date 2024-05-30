`timescale 1ns/1ps

module tb_systolic_array_2x2;

  reg clk;
  reg reset;
  reg valid;
  reg [15:0] a_in_0, a_in_1;
  reg [15:0] b_in_0, b_in_1;
  wire [31:0] product_00, product_01, product_10, product_11;

  systolic_array uut (
    .clk(clk),
    .reset(reset),
    .a_in_0(a_in_0),
    .a_in_1(a_in_1),
  )