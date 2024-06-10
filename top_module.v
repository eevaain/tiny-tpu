module top_level_module (
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

  output [31:0] acc1_mem_0, // Output for first memory location of acc1
  output [31:0] acc1_mem_1, // Output for second memory location of acc1
  output [31:0] acc2_mem_0, // Output for first memory location of acc2
  output [31:0] acc2_mem_1, // Output for second memory location of acc2
  
  output [31:0] unified_mem_0,
  output [31:0] unified_mem_1,
  output [31:0] unified_mem_2,
  output [31:0] unified_mem_3
);

  // Internal signals for accumulated values from the systolic array
  wire [31:0] systolic_acc_out1;
  wire [31:0] systolic_acc_out2;
  wire acc1_full;
  wire acc2_full;

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
    // .acc_out(acc_out1),x
    .acc_mem_0(acc1_mem_0),
    .acc_mem_1(acc1_mem_1),
    .full(acc1_full)
  );

  // Instantiate the second accumulator
  accumulator acc2 (
    .clk(clk),
    .reset(reset),
    .valid(valid),
    .acc_in(systolic_acc_out2),
    // .acc_out(acc_out2),
    .acc_mem_0(acc2_mem_0),
    .acc_mem_1(acc2_mem_1),
    .full(acc2_full)
  );

  // Instantiate the unified buffer
  unified_buffer ub (
    .clk(clk),
    .reset(reset),
    .store_acc1(acc1_full), // Only store when accumulator is full
    .store_acc2(acc2_full), // Only store when accumulator is full
    .acc1_mem_0(acc1_mem_0),
    .acc1_mem_1(acc1_mem_1),
    .acc2_mem_0(acc2_mem_0),
    .acc2_mem_1(acc2_mem_1),
    .unified_mem_0(unified_mem_0),
    .unified_mem_1(unified_mem_1),
    .unified_mem_2(unified_mem_2),
    .unified_mem_3(unified_mem_3)
  );

endmodule
