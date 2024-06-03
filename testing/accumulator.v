module accumulator (
  input clk,
  input reset,
  input valid,
  input [31:0] acc_in,
  output reg [31:0] acc_out
);

  // Define a register array to store multiple accumulated values
  reg [31:0] acc_mem [0:3]; // Example with 4 entries (could also do 2)
  reg [1:0] index; // Index to manage storage locations
  integer i; // Declare integer outside of the always block

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      // Initialize all accumulated values to 0 on reset
      for (i = 0; i < 2; i = i + 1) begin
        acc_mem[i] <= 0;
      end
      acc_out <= 0;
      index <= 0; // Reset index
    end else if (valid && acc_in != 0) begin // This might be a cheap fix...
      // Store input value at the current index
      acc_mem[index] <= acc_in;
      // Update output with the new accumulated value
      acc_out <= acc_mem[index];
      // Increment index to store the next value (INCREMENT ONLY HAPPENS WHEN acc_in ISNT zero!!)
      if (index < 3) index <= index + 1;
    end
  end

  // Task to print the contents of the accumulator
  task print_contents;
    begin
      for (i = 0; i < 2; i = i + 1) begin
        $display("Accumulator[%0d] = %0d", i, acc_mem[i]);
      end
    end
  endtask

endmodule
