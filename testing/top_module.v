module top_level_module(
  input clk,
  input reset,
  input load_weight,    // Signal to load weight
  input valid,          // Valid signal indicating new data is available

  input [15:0] a_in1,   // Input A for PE(0,0)
  input [15:0] a_in2,   // Input A for PE(1,0)

  input [15:0] weight1, // Weight for PE(0,0)
  input [15:0] weight2, // Weight for PE(0,1)
  input [15:0] weight3, // Weight for PE(1,0)
  input [15:0] weight4, // Weight for PE(1,1)

  output [31:0] acc_out1, // Final accumulated value for output 1
  output [31:0] acc_out2  // Final accumulated value for output 2
);

  // Internal signals for accumulated values from the systolic array
  wire [31:0] systolic_acc_out1;
  wire [31:0] systolic_acc_out2;

  // Index counter for storing the values in the accumulators
  reg [3:0] index1;
  reg [3:0] index2;

  // Instantiate the systolic array
  mmu systolic_array_inst (
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
    .acc_out1(systolic_acc_out1),
    .acc_out2(systolic_acc_out2)
  );

  // Instantiate the first accumulator
  accumulator acc1 (
    .clk(clk),
    .reset(reset),
    .valid(valid),
    .acc_in(systolic_acc_out1),
    .index(index1),   // Pass the index to the accumulator
    .acc_out(acc_out1)
  );

  // Instantiate the second accumulator
  accumulator acc2 (
    .clk(clk),
    .reset(reset),
    .valid(valid),
    .acc_in(systolic_acc_out2),
    .index(index2),   // Pass the index to the accumulator
    .acc_out(acc_out2)
  );

  // Control logic to manage the indices
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      index1 <= 0;
      index2 <= 0;
    end else if (valid) begin
      // Increment indices to store the next values
      if (index1 < 3) index1 <= index1 + 1;
      if (index2 < 3) index2 <= index2 + 1;
    // index1 <= index1 + 1;
    // index2 <= index2 + 1;
    end
  end

endmodule
