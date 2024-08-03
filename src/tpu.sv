`default_nettype none
`timescale 1ns/1ns

module tpu (
  // INPUTS
  input wire clk,
  input wire reset,
  input wire [7:0] ui_in,  
  input wire [7:0] uio_in, 
   // OUTPUTS 
  output wire [7:0] uo_out // this is uo_out (should rename to uo_out)
);

  // TODO: perhaps create an assign statement to COMBINE both ui_in and uio_in so i can have a 16 bit bus??? 

  // Internal signals which connect dma controller flags to memory devices (data select flags)
  wire start; 
  wire fetch_w;
  wire fetch_inp; 
  wire fetch_ins; 
  wire dma_address; // TODO: connect this to each memory device?? perhaps merge this with base address wire? 

  // "zero-buffered" staggered "x" value matrix data transfer from input setup into mmu
  wire [7:0] a_in1;
  wire [7:0] a_in2;

  // Internal signals for control unit
  wire [4:0] base_address; // this is the address decoded from the ISA (ran from program mem)
  wire load_weight;
  wire load_input;
  wire valid;
  wire store;
  wire ext;

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

  // Instantiate direct memory controller 
  dma dma ( 
    // INPUTS
    .clk(clk),
    .reset(reset),
    .uio_in(uio_in),
    // OUTPUTS
    .fetch_w(fetch_w),
    .fetch_inp(fetch_inp),
    .fetch_ins(fetch_ins),
    .start(start), 
    .dma_address(dma_address)
  );


  // Instantiate the control unit
  control_unit cu (
    .fetch_ins(fetch_ins),
    .ui_in(ui_in),

    .start(start),
    .clk(clk),
    .reset(reset),
    .load_weight(load_weight),
    .base_address(base_address),
    .load_input(load_input),
    .valid(valid),
    .store(store),
    .ext(ext)
  );

  // Instantiate the weight memory
  weight_memory wm (
    .fetch_w(fetch_w),
    .ui_in(ui_in),


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
      .fetch_inp(fetch_inp),
      .ui_in(ui_in), 


    // inputs 
    .clk(clk),
    .reset(reset),
    .load_input(load_input),
    .full_acc1(acc1_full), // Only store when accumulator is full
    .full_acc2(acc2_full), // Only store when accumulator is full
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

    .store(store),
    .ext(ext), // flag for dispatching data out of chip
    .final_out(uo_out) // bus of output data wires
  );

endmodule
