module processing_element (
  input clk,
  input reset,
  input load_weight,       // Signal to load weight
  input valid,             // Valid signal indicating new data is available

  input [15:0] a_in,       // Input A from left neighbor
  input [15:0] weight,     // Weight input
  input [31:0] acc_in,     // Accumulated value from the PE above

  output reg [15:0] a_out,    // Output A to right neighbor
  output reg [15:0] w_out,    // Weight output
  output reg [31:0] acc_out   // Accumulated value to the PE below
);
  reg [15:0] weight_reg; // Register to hold the stationary weight

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      a_out <= 16'b0;
      acc_out <= 32'b0;
      weight_reg <= 16'b0;
    end else begin
      if (load_weight) begin
        // Load the weight when the load_weight signal is high
        weight_reg <= weight;
      end
      if (valid) begin
        // Calculate the new accumulated value
        acc_out <= acc_in + (a_in * weight_reg);
        // Propagate input A to output A
        a_out <= a_in;
        // Propagate weight to output w_out
        w_out <= weight_reg; 
      end
    end
  end
endmodule
