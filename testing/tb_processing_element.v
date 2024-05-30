`timescale 1ns / 1ns

module tb_processing_element;
  // Inputs
  reg clk;
  reg reset;
  reg load_weight;
  reg valid;
  reg [15:0] a_in;
  reg [15:0] weight;
  reg [31:0] acc_in; 

  // Outputs
  wire [15:0] a_out;
  wire [31:0] acc_out;
  wire [15:0] w_out;

  // Instantiate the processing_element module
  processing_element uut (
    .clk(clk),
    .reset(reset),
    .load_weight(load_weight),
    .valid(valid),
    .a_in(a_in),
    .weight(weight),
    .acc_in(acc_in),  // Accumulated value input
    .a_out(a_out),
    .acc_out(acc_out),
    .w_out(w_out)
  );

  // Clock generation
  always #5 clk = ~clk;

  // Initial block to initialize inputs and apply test vectors
  initial begin
    // Initialize inputs
    clk = 0;
    reset = 0;
    load_weight = 0;
    valid = 0;
    a_in = 0;
    weight = 0;
    acc_in = 0;

    // Apply reset
    reset = 1;
    #10;
    reset = 0;
    #10;

    // Load weight
    load_weight = 1;
    weight = 3;  // Example weight value
    #10;
    load_weight = 0;
    #10;

    // Apply first set of inputs
    valid = 1;
    a_in = 2;    // Example input A
    acc_in = 0;  // Ensure acc_in is always zero
    #10;
    valid = 0;
    #10;

    // Apply second set of inputs
    valid = 1;
    a_in = 5;    // Another example input A
    acc_in = 0;  // Ensure acc_in is always zero
    #10;
    valid = 0;
    #10;

    // Finish the simulation
    $finish;
  end

  // Monitor the outputs
  initial begin
    $monitor("At time %t: a_out = %d, acc_out = %d, w_out = %d", $time, a_out, acc_out, w_out);
  end
endmodule
