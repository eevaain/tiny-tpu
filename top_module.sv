module top_level_module (
  input clk,
  input reset,
  input [15:0] instruction,  // Instruction input

  input valid,               // Valid signal indicating new data is available
  input [15:0] a_in1,        // Input A for PE(0,0)
  input [15:0] a_in2,        // Input A for PE(1,0)
  
  output [31:0] unified_mem [0:63]  // Output for unified buffer memory
);

  // Internal signals for control unit
  wire load_weight;
  wire [12:0] base_address;

  // Internal signals for accumulated values from the systolic array
  wire [31:0] systolic_acc_out1;
  wire [31:0] systolic_acc_out2;
  
  wire acc1_full;
  wire acc2_full;

  // Internal signals for weights from memory
  wire [15:0] weight1;
  wire [15:0] weight2;
  wire [15:0] weight3;
  wire [15:0] weight4;

  wire [31:0] acc1_mem_0_to_ub;
  wire [31:0] acc1_mem_1_to_ub;
  wire [31:0] acc2_mem_0_to_ub;
  wire [31:0] acc2_mem_1_to_ub;

  // Instantiate the control unit
  control_unit cu (
    .clk(clk),
    .reset(reset),
    .instruction(instruction),
    .load_weight(load_weight),
    .base_address(base_address)
  );

  // Instantiate the weight memory
  weight_memory wm (
    .addr(base_address),
    .weight1(weight1),
    .weight2(weight2),
    .weight3(weight3),
    .weight4(weight4)
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
    .clk(clk),
    .reset(reset),
    .store_acc1(acc1_full), // Only store when accumulator is full
    .store_acc2(acc2_full), // Only store when accumulator is full
    .acc1_mem_0(acc1_mem_0_to_ub),
    .acc1_mem_1(acc1_mem_1_to_ub),
    .acc2_mem_0(acc2_mem_0_to_ub),
    .acc2_mem_1(acc2_mem_1_to_ub),
    .unified_mem(unified_mem)
  );

  // Track and display accumulator values per clock cycle
  // OK SO I HAVE AN ISSUE THAT THE FULL FLAG IS BEING SET ONE CLOCK CYCLE TOO EARLY
  // but why is this happen? 
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      // Do nothing on reset
    end else begin
      $display("Time: %0t, acc1_mem_0: %0d, acc1_mem_1: %0d, acc2_mem_0: %0d, acc2_mem_1: %0d, acc1_full: %0d, acc2_full: %0d", 
               $time, acc1_mem_0_to_ub, acc1_mem_1_to_ub, acc2_mem_0_to_ub, acc2_mem_1_to_ub, acc1_full, acc2_full);
    end
  end

endmodule
