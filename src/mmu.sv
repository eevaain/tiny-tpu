module mmu(
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

  // i do not need these two but keep these wires exposed. they are not defined in the top level module so dont touch that. 
  output [15:0] a_out1, // Output A from PE(0,1)
  output [15:0] a_out2, // Output A from PE(1,1)

  // these values need to be stored in a register in matrix format
  output [31:0] acc_out1, // Accumulated value from PE(1,0)
  output [31:0] acc_out2  // Accumulated value from PE(1,1)
);
  // Internal signals for connections between PEs
  wire [15:0] a_inter_01, a_inter_11;
  wire [31:0] acc_inter_00, acc_inter_01;
  wire [15:0] w_inter_00, w_inter_01;

  // Instantiate PE(0,0)
  processing_element PE00 (
    .clk(clk),
    .reset(reset),
    .load_weight(load_weight),
    .valid(valid),
    .a_in(a_in1),
    .weight(weight1),
    .acc_in(32'b0),   // Top-left corner has no accumulated input
    .a_out(a_inter_01),
    .w_out(w_inter_00),
    .acc_out(acc_inter_00)
  );

  // Instantiate PE(0,1)
  processing_element PE01 (
    .clk(clk),
    .reset(reset),
    .load_weight(load_weight),
    .valid(valid),
    .a_in(a_inter_01),
    .weight(weight2),
    .acc_in(32'b0),   // Top-right corner has no accumulated input
    .a_out(a_out1),
    .w_out(w_inter_01),
    .acc_out(acc_inter_01)
  );

  // Instantiate PE(1,0)
  processing_element PE10 (
    .clk(clk),
    .reset(reset),
    .load_weight(load_weight),
    .valid(valid),
    .a_in(a_in2),
    .weight(weight3),
    .acc_in(acc_inter_00), // Bottom-left corner gets accumulated input from PE(0,0)
    .a_out(a_inter_11),
    .w_out(),
    .acc_out(acc_out1)
  );

  // Instantiate PE(1,1)
  processing_element PE11 (
    .clk(clk),
    .reset(reset),
    .load_weight(load_weight),
    .valid(valid),
    .a_in(a_inter_11),
    .weight(weight4),
    .acc_in(acc_inter_01), // Bottom-right corner gets accumulated input from PE(0,1)
    .a_out(a_out2),
    .w_out(),
    .acc_out(acc_out2)
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
