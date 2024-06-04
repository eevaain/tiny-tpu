`timescale 1ns / 1ns

module tb_top_level_module;
  // Inputs
  reg clk;
  reg reset;
  reg load_weight;
  reg valid;
  reg [15:0] a_in1;
  reg [15:0] a_in2;
  reg [15:0] weight1;
  reg [15:0] weight2;
  reg [15:0] weight3;
  reg [15:0] weight4;

  // Outputs
  wire [31:0] acc1_mem_0;
  wire [31:0] acc1_mem_1;
  wire [31:0] acc2_mem_0;
  wire [31:0] acc2_mem_1;
  wire [31:0] unified_mem_0;
  wire [31:0] unified_mem_1;
  wire [31:0] unified_mem_2;
  wire [31:0] unified_mem_3;

  // Instantiate the top_level_module
  top_level_module uut (
    .clk(clk),
    .reset(reset),
    .load_weight(load_weight),
    .valid(valid),
    .a_in1(a_in1),
    .a_in2(a_in2),
    .weight1(weight1),
    .weight2(weight2),
    .weight3(weight3),
    .weight4(weight4),
    .acc1_mem_0(acc1_mem_0),
    .acc1_mem_1(acc1_mem_1),
    .acc2_mem_0(acc2_mem_0),
    .acc2_mem_1(acc2_mem_1),
    .unified_mem_0(unified_mem_0),
    .unified_mem_1(unified_mem_1),
    .unified_mem_2(unified_mem_2),
    .unified_mem_3(unified_mem_3)
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
    a_in1 = 0;
    a_in2 = 0;
    weight1 = 0;
    weight2 = 0;
    weight3 = 0;
    weight4 = 0;

    // Apply reset
    reset = 1;
    #10;
    reset = 0;
    #10;

    // Load all weights into the PEs in one clock cycle.
    load_weight = 1;
    weight1 = 3;  // Weight for PE(0,0)
    weight2 = 5;  // Weight for PE(0,1)
    weight3 = 4;  // Weight for PE(1,0)
    weight4 = 6;  // Weight for PE(1,1)
    #10;
    load_weight = 0;

    // Apply the 2x2 matrix inputs
    valid = 1;
    // First clock cycle - inputs for the top-left and bottom-left PEs
    a_in1 = 11;  // a11
    a_in2 = 0;   // Zero input for the first cycle in the bottom-left PE
    #10;

    // Second clock cycle - inputs for the top-left and bottom-left PEs
    a_in1 = 12;  // a12
    a_in2 = 21;  // a21
    #10;

    // Third clock cycle - input for the bottom-left PE
    a_in1 = 0;   // No new input for the top-left PE
    a_in2 = 22;  // a22
    #10;

    // Fourth clock cycle - no new inputs
    a_in1 = 0;   // No new input for the top-left PE
    a_in2 = 0;   // No new input for the bottom-left PE
    #10;

    // Fifth clock cycle - no new inputs
    a_in1 = 0;   // No new input for the top-left PE
    a_in2 = 0;   // No new input for the bottom-left PE
    #10;

   // Sixth clock cycle - no new inputs
    a_in1 = 0;   // No new input for the top-left PE
    a_in2 = 0;   // No new input for the bottom-left PE
    #10;

   // Seventh clock cycle - no new inputs
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

  // Monitor accumulators per clock cycle
  always @(posedge clk) begin
    if (!reset) begin
      $display("At time %t:", $time);
      // $display("Accumulator 1 memory contents: [%0d, %0d]", uut.acc1_mem_0, uut.acc1_mem_1);
      // $display("Accumulator 2 memory contents: [%0d, %0d]", uut.acc2_mem_0, uut.acc2_mem_1);
      uut.acc1.print_contents();
      uut.acc2.print_contents();
    end
  end

endmodule
