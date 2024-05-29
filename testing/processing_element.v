module processing_element (
  input clk,
  input reset,
  input [15:0] a_in,  // Input A from left neighbor
  input [15:0] b_in,  // Input B from top neighbor

  input [31:0] c_in,  // Accumulated sum from top neighbor
  output reg [15:0] a_out, // Output A to right neighbor
  output reg [15:0] b_out, // Output B to bottom neighbor
  output reg [31:0] c_out  // Output C to bottom neighbor
);
  reg [31:0] product;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      a_out <= 16'b0;
      b_out <= 16'b0;
      c_out <= 32'b0;
      product <= 32'b0;
    end else begin
      // the cells stores the product of the two inputs, and adds it to the previous product
      product <= a_in * b_in;
      c_out <= c_in + product;
      // the same inputs into the element immediately become the outputs
      a_out <= a_in; 
      b_out <= b_in;
    end
  end
endmodule
