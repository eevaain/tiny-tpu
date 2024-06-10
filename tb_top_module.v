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
  wire [31:0] acc1_mem_0;
  wire [31:0] acc1_mem_1;
  wire [31:0] acc2_mem_0;
  wire [31:0] acc2_mem_1;
  wire [31:0] unified_mem_0;
  wire [31:0] unified_mem_1;
  wire [31:0] unified_mem_2;
  wire [31:0] unified_mem_3;

  // Internal wires to connect to the processing elements
  wire [31:0] pe_acc_out1;
  wire [31:0] pe_acc_out2;
  wire [15:0] pe_a_out1;
  wire [15:0] pe_a_out2;

  // Instantiate the top level module
  top_level_module uut (
    .clk(clk),
    .reset(reset),
    .instruction(instruction),
    .valid(valid),
    .a_in1(a_in1),
    .a_in2(a_in2),
    .acc1_mem_0(acc1_mem_0),
    .acc1_mem_1(acc1_mem_1),
    .acc2_mem_0(acc2_mem_0),
    .acc2_mem_1(acc2_mem_1),
    .unified_mem_0(unified_mem_0),
    .unified_mem_1(unified_mem_1),
    .unified_mem_2(unified_mem_2),
    .unified_mem_3(unified_mem_3)
  );

  // Instantiate processing elements to monitor their acc_out
  processing_element pe1 (
    .clk(clk),
    .reset(reset),
    .load_weight(1'b0),
    .valid(valid),
    .a_in(a_in1),
    .weight(16'd3),
    .acc_in(32'd0),
    .a_out(pe_a_out1),
    .w_out(),
    .acc_out(pe_acc_out1)
  );

  processing_element pe2 (
    .clk(clk),
    .reset(reset),
    .load_weight(1'b0),
    .valid(valid),
    .a_in(a_in2),
    .weight(16'd4),
    .acc_in(pe_acc_out1),
    .a_out(pe_a_out2),
    .w_out(),
    .acc_out(pe_acc_out2)
  );

  // Clock generation
  always #5 clk = ~clk;

  // Initial block to initialize inputs and apply test vectors
  initial begin
    // Initialize inputs
    clk = 0;
    reset = 0;
    valid = 0;
    a_in1 = 0;
    a_in2 = 0;
    instruction = 0;

    // Apply reset
    reset = 1;
    #10;
    reset = 0;
    #10;

    // Load base address for weights
    instruction = 16'b000_0000000000000;  // LOAD_ADDR 0x0000
    #10;

    // Load weights into systolic array
    instruction = 16'b001_0000000000000;  // LOAD_WEIGHT
    #10;

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

    a_in1 = 0;   // No new input for the top-left PE
    a_in2 = 0;   // No new input for the bottom-left PE
    #10;

    a_in1 = 0;   // No new input for the top-left PE
    a_in2 = 0;   // No new input for the bottom-left PE
    #10;

    // Monitor unified buffer
    $display("Unified Buffer at time %t:", $time);
    $display("unified_mem_0 = %0d", unified_mem_0);
    $display("unified_mem_1 = %0d", unified_mem_1);
    $display("unified_mem_2 = %0d", unified_mem_2);
    $display("unified_mem_3 = %0d", unified_mem_3);

    // Finish the simulation
    $finish;
  end

  // // Monitor accumulators and inputs per clock cycle
  // always @(posedge clk) begin
  //   if (!reset) begin
  //     $display("At time %t:", $time);
  //     $display("Accumulator 1 memory contents: [%0d, %0d]", acc1_mem_0, acc1_mem_1);
  //     $display("Accumulator 2 memory contents: [%0d, %0d]", acc2_mem_0, acc2_mem_1);
  //     $display("Inputs: a_in1 = %0d, a_in2 = %0d", a_in1, a_in2);
  //     $display("Processing Element 1 acc_out: %0d", pe_acc_out1);
  //     $display("Processing Element 2 acc_out: %0d", pe_acc_out2);
  //   end
  // end

endmodule
