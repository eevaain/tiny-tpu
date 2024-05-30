module systolic_array (
  input clk,
  input reset,
  input [15:0] a_in_0, // First row input A
  input [15:0] a_in_1, // Second row input A
  input [15:0] b_in_0, // First column input B
  input [15:0] b_in_1, // Second column input B
  input valid,         // Valid signal for input data

  output [31:0] product_00, // Output product for PE(0,0)
  output [31:0] product_01, // Output product for PE(0,1)
  output [31:0] product_10, // Output product for PE(1,0)
  output [31:0] product_11  // Output product for PE(1,1)
);

  // State to track the input phases for zero padding
  reg [2:0] state;
  reg [15:0] a_in_0_reg, a_in_1_reg, b_in_0_reg, b_in_1_reg;

  // Initialize the state
  initial begin
    state = 0;
  end

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= 0;
      a_in_0_reg <= 16'd0;
      a_in_1_reg <= 16'd0;
      b_in_0_reg <= 16'd0;
      b_in_1_reg <= 16'd0;
    end else if (valid) begin
      case (state)
        0: begin
          // Initial phase: feed first row and column
          a_in_0_reg <= 16'd1; // A[0,0]
          a_in_1_reg <= 16'd0; // Padding with zero for second row
          b_in_0_reg <= 16'd5; // B[0,0]
          b_in_1_reg <= 16'd0; // Padding with zero for second column
          state <= 1;
        end
        1: begin
          // Feed second row and first column
          a_in_0_reg <= 16'd2; // A[0,1]
          a_in_1_reg <= 16'd3; // A[1,0]
          b_in_0_reg <= 16'd7; // B[1,0]
          b_in_1_reg <= 16'd6; // B[0,1]
          state <= 2;
        end
        2: begin
          // Feed third row and second column
          a_in_0_reg <= 16'd0; // Padding with zero for third row
          a_in_1_reg <= 16'd4; // A[1,1]
          b_in_0_reg <= 16'd0; // Padding with zero for third column
          b_in_1_reg <= 16'd8; // B[1,1]
          state <= 3;
        end
        3: begin
          // Padding zeros to ensure proper propagation
          a_in_0_reg <= 16'd0;
          a_in_1_reg <= 16'd0;
          b_in_0_reg <= 16'd0;
          b_in_1_reg <= 16'd0;
          state <= 3; // Stay in this state for continuous padding if needed
        end
      endcase
    end
  end

  // Wires for connecting processing elements
  wire [15:0] a_out_00, a_out_10;
  wire [15:0] b_out_00, b_out_01;

  // Instantiate the processing elements
  processing_element pe00 (
    .clk(clk),
    .reset(reset),
    .a_in(a_in_0_reg),
    .b_in(b_in_0_reg),
    .valid(valid),
    .a_out(a_out_00),
    .b_out(b_out_00),
    .product(product_00)
  );

  processing_element pe01 (
    .clk(clk),
    .reset(reset),
    .a_in(a_out_00),
    .b_in(b_in_1_reg),
    .valid(valid),
    .a_out(),
    .b_out(b_out_01),
    .product(product_01)
  );

  processing_element pe10 (
    .clk(clk),
    .reset(reset),
    .a_in(a_in_1_reg),
    .b_in(b_out_00),
    .valid(valid),
    .a_out(a_out_10),
    .b_out(),
    .product(product_10)
  );

  processing_element pe11 (
    .clk(clk),
    .reset(reset),
    .a_in(a_out_10),
    .b_in(b_out_01),
    .valid(valid),
    .a_out(),
    .b_out(),
    .product(product_11)
  );

endmodule
