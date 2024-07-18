`default_nettype none
`timescale 1ns/1ns

module tpu (
  input wire clk,
  input wire reset,
  input wire start  // New input to start the program
);

  wire [7:0] a_in1;
  wire [7:0] a_in2;

  // Internal signals for control unit
  wire [12:0] base_address;

  wire load_weight;
  wire load_input;
  wire valid;
  wire store;

  // Internal signals for accumulated values from the systolic array
  wire [7:0] systolic_acc_out1;
  wire [7:0] systolic_acc_out2;

  wire acc1_full;
  wire acc2_full;

  // Internal signals for weights from memory
  wire [7:0] weight1;
  wire [7:0] weight2;
  wire [7:0] weight3;
  wire [7:0] weight4;

  // Internal signals for output matrix individual row vectors to unified buffer
  wire [7:0] acc1_mem_0_to_ub;
  wire [7:0] acc1_mem_1_to_ub;
  wire [7:0] acc2_mem_0_to_ub;
  wire [7:0] acc2_mem_1_to_ub;

  // Internal signals for activation inputs from unified buffer
  wire [7:0] out_ub_to_input_setup_00;
  wire [7:0] out_ub_to_input_setup_01;
  wire [7:0] out_ub_to_input_setup_10;
  wire [7:0] out_ub_to_input_setup_11;

  // Instantiate the control unit
  control_unit cu (
    .start(start),
    .clk(clk),
    .reset(reset),
    .load_weight(load_weight),
    .base_address(base_address),
    .load_input(load_input),
    .valid(valid),
    .store(store)
  );

  // Instantiate the weight memory
  weight_memory wm (
    .clk(clk),
    .reset(reset),
    .load_weight(load_weight),
    .addr(base_address),
    .weight1(weight1),
    .weight2(weight2),
    .weight3(weight3),
    .weight4(weight4)
  );

  input_setup is (
    .clk(clk),
    .reset(reset),
    .valid(valid),

    .a11(out_ub_to_input_setup_00),
    .a12(out_ub_to_input_setup_01),
    .a21(out_ub_to_input_setup_10),
    .a22(out_ub_to_input_setup_11),

    .a_in1(a_in1),
    .a_in2(a_in2)
  );

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
    .acc_mem_0(acc1_mem_0_to_ub),
    .acc_mem_1(acc1_mem_1_to_ub),
    .full(acc1_full)
  );

  // Instantiate the second accumulator
  accumulator acc2 (
    .clk(clk),
    .reset(reset),
    .valid(valid),
    .acc_in(systolic_acc_out2),
    .acc_mem_0(acc2_mem_0_to_ub),
    .acc_mem_1(acc2_mem_1_to_ub),
    .full(acc2_full)
  );

  // Instantiate the unified buffer
  unified_buffer ub (
    // inputs 
    .clk(clk),
    .reset(reset),
    .load_input(load_input),
    .store_acc1(acc1_full), // Only store when accumulator is full
    .store_acc2(acc2_full), // Only store when accumulator is full
    .acc1_mem_0(acc1_mem_0_to_ub),
    .acc1_mem_1(acc1_mem_1_to_ub),
    .acc2_mem_0(acc2_mem_0_to_ub),
    .acc2_mem_1(acc2_mem_1_to_ub),
    .addr(base_address),
    // outputs
    .out_ub_00(out_ub_to_input_setup_00),
    .out_ub_01(out_ub_to_input_setup_01),
    .out_ub_10(out_ub_to_input_setup_10),
    .out_ub_11(out_ub_to_input_setup_11),
    // have a store or retrieve flag? (r/w)
    .store(store)
  );

endmodule
