module main (
  input clk,
  input reset,
  input [15:0] instruction,  // Instruction input
  
  output [31:0] unified_mem [0:63]  // Output for unified buffer memory

);

  wire [15:0] a_in1;
  wire [15:0] a_in2;

  // Internal signals for control unit
  wire load_weight;
  wire load_input;
  wire valid;
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

  // Internal signals for output matrix individual row vectors to unified buffer
  wire [31:0] acc1_mem_0_to_ub;
  wire [31:0] acc1_mem_1_to_ub;
  wire [31:0] acc2_mem_0_to_ub;
  wire [31:0] acc2_mem_1_to_ub;

  // Internal signals for activation inputs from unified buffer
  wire [31:0] out_ub_to_input_setup_00;
  wire [31:0] out_ub_to_input_setup_01;
  wire [31:0] out_ub_to_input_setup_10;
  wire [31:0] out_ub_to_input_setup_11;

  // Instantiate the control unit
  control_unit cu (
    .clk(clk),
    .reset(reset),
    .instruction(instruction),
    .load_weight(load_weight),
    .base_address(base_address),
    .load_input(load_input),
    .valid(valid)
  );

  // Instantiate the weight memory
  weight_memory wm (
    .addr(base_address),
    .weight1(weight1),
    .weight2(weight2),
    .weight3(weight3),
    .weight4(weight4)
  );

  /*
    // TODO

    .a11(out_ub_to_input_setup_00),
    .a12(out_ub_to_input_setup_01),
    .a21(out_ub_to_input_setup_10),
    .a22(out_ub_to_input_setup_11)

  */


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
    // TODO: Create a flag on whether to take address of the unified buffer or of the weight memory within the ISA instruction 
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
    .unified_mem(unified_mem),
    .out_ub_00(out_ub_to_input_setup_00),
    .out_ub_01(out_ub_to_input_setup_01),
    .out_ub_10(out_ub_to_input_setup_10),
    .out_ub_11(out_ub_to_input_setup_11)
    // have a store or retrieve flag? 
  );

  // Track and display a_in1 and a_in2 values per clock cycle
  // always @(posedge clk or posedge reset) begin
  //   if (reset) begin
  //     // Do nothing on reset
  //   end else begin
  //     $display("Time: %0t, a_in1: %0d, a_in2: %0d", $time, a_in1, a_in2);
  //   end
  // end

endmodule
