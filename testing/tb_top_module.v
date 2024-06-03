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
  wire [31:0] acc_out1;
  wire [31:0] acc_out2;

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
    .acc_out1(acc_out1),
    .acc_out2(acc_out2)
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
    // valid = 0;


    // Second clock cycle - inputs for the top-left and bottom-left PEs
    valid = 1;
    a_in1 = 12;  // a12
    a_in2 = 21;  // a21
    #10;
    // valid = 0;


    // Third clock cycle - input for the bottom-left PE
    valid = 1;
    a_in1 = 0;   // No new input for the top-left PE
    a_in2 = 22;  // a22
    #10;
    // valid = 0;


    // Fourth clock cycle - input for the bottom-left PE
    valid = 1;
    a_in1 = 0;   // No new input for the top-left PE
    a_in2 = 0;  // No new input for the bottom-left PE
    #10;
    // valid = 0;


    // Fifth clock cycle - input for the bottom-left PE
    valid = 1;
    a_in1 = 0;   // No new input for the top-left PE
    a_in2 = 0;  // No new input for the bottom-left PE
    #10;
    // valid = 0;
    #10;
    #10;



    // Finish the simulation
    $finish;
  end


  // Monitor accumulators per clock cycle
  always @(posedge clk) begin
    if (!reset) begin
      $display("At time %t:", $time);
      uut.acc1.print_contents();
      uut.acc2.print_contents();
    end
  end

endmodule
