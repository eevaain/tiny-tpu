`timescale 1ns/1ps

module tb_processing_element;

  // Testbench signals
  reg clk;
  reg reset;
  reg [15:0] a_in;
  reg [15:0] b_in;
  reg [31:0] c_in;
  wire [15:0] a_out;
  wire [15:0] b_out;
  wire [31:0] c_out;

  // Instantiate the processing_element module
  processing_element uut (
    .clk(clk),
    .reset(reset),
    .a_in(a_in),
    .b_in(b_in),
    .c_in(c_in),
    .a_out(a_out),
    .b_out(b_out),
    .c_out(c_out)
  );

  // Clock generation
  always begin
    #5 clk = ~clk; // Toggle clock every 5 time units (100 MHz clock)
  end

  initial begin
    // Initialize signals
    clk = 0;
    reset = 1;
    a_in = 16'd0;
    b_in = 16'd0;
    c_in = 32'd0;

    // Apply reset
    #10 reset = 0;

    // Test case 1: a_in = 3, b_in = 4, c_in = 10
    #10 a_in = 16'd3; b_in = 16'd4; c_in = 32'd10;
    #10;

    // Test case 2: a_in = 5, b_in = 6, c_in = c_out from previous cycle
    #10 a_in = 16'd5; b_in = 16'd6; c_in = c_out;
    #10;

    // Test case 3: a_in = 7, b_in = 8, c_in = c_out from previous cycle
    #10 a_in = 16'd7; b_in = 16'd8; c_in = c_out;
    #10;

    // End simulation
    #10 $stop;
  end

  initial begin
    $monitor("Time=%0d clk=%b reset=%b a_in=%d b_in=%d c_in=%d a_out=%d b_out=%d c_out=%d", 
             $time, clk, reset, a_in, b_in, c_in, a_out, b_out, c_out);
  end

endmodule
