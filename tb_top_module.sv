`timescale 1ns / 1ns

module tb_top_level_module;
  // Inputs
  reg clk;
  reg reset;
  reg [15:0] instruction;
  reg valid;
  reg [15:0] a_in1;
  reg [15:0] a_in2;

  // Outputs
  wire [31:0] unified_mem [0:63];

  // Internal wires to connect to the processing elements

  // Instantiate the top level module
  top_level_module uut (
    .clk(clk),
    .reset(reset),
    .instruction(instruction),
    .valid(valid),
    .a_in1(a_in1),
    .a_in2(a_in2),
    .unified_mem(unified_mem)
  );

  // Clock generation
  always #5 clk = ~clk;

  // Initial block to initialize inputs and apply test vectors
  initial begin
    // Initialize inputs (registers outside the module)
    clk = 0;
    reset = 0;
    valid = 0;
    a_in1 = 0;
    a_in2 = 0;
    instruction = 0;
    // perhaps create an assembly instruction that when on reset for each module that uses these bits, set them to zero within the module

    // Apply reset (these are also registers outside the module)
    reset = 1;
    #10;
    reset = 0;
    #10;

    // Load base address for weights
    instruction = 16'b001_0000000001111;  // LOAD_ADDR 0x000F
    #10;

    // Load weights into systolic array
    instruction = 16'b010_0000000000000;  // LOAD_WEIGHT
    #10;

    // need an instruction here to take inputs from unified buffer into another memory partition which sets up the systolic array data. instead of doing the zero padding thing, load a new row after each clock cycle? might be less "hacky"....
    // need an instruction here to do the computation once the input array is fully loaded

    // Apply the 2x2 matrix inputs
    valid = 1;

    a_in1 = 11;  // a11
    a_in2 = 0;   // Zero input for the first cycle in the bottom-left PE
    #10;

    a_in1 = 12;  // a12
    a_in2 = 21;  // a21
    #10;

    a_in1 = 0;   // No new input for the top-left PE
    a_in2 = 22;  // a22
    #10;

    a_in1 = 0;   // No new input for the top-left PE
    a_in2 = 0;   // No new input for the bottom-left PE
    #10;

    a_in1 = 0;   // No new input for the top-left PE
    a_in2 = 0;   // No new input for the bottom-left PE
    #10;

////////////// SHOWS THREE OUTPUT ELEMENTS HERE ^^^^

    // a_in1 = 0;   // No new input for the top-left PE
    // a_in2 = 0;   // No new input for the bottom-left PE
    // #10;

//////////////  SHOWS ALL OUTPUT ELEMENTS HERE ^^^^





    // Monitor unified buffer
    $display("Unified Buffer at time %t:", $time);
    for (integer i = 0; i < 64; i = i + 1) begin
      $display("unified_mem[%0d] = %0d", i, unified_mem[i]);
    end

    // Finish the simulation
    $finish;
  end

endmodule
