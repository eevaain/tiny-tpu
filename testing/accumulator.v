module accumulator (
  input clk,
  input reset,
  input valid,
  input [31:0] acc_in,
  input [3:0] index, // New input to specify the index for storing/loading data
  output reg [31:0] acc_out
);

  // Define a register array to store multiple accumulated values
  reg [31:0] acc_mem [0:3]; // Example with 4 entries (could also do 2)

  integer i; // Declare integer outside of the always block

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      // Initialize all accumulated values to 0 on reset
      for (i = 0; i < 4; i = i + 1) begin
        acc_mem[i] <= 0; // OKAY IF I SET THIS TO ONE THEN I CAN SEE ITS CUS OF THE ZEROS 
      end
      acc_out <= 0;
    end else if (valid) begin
      // Accumulate input value at the specified index
    //   acc_mem[index] <= acc_mem[index] + acc_in;
        acc_mem[index] <= acc_in;
      // Update output with the new accumulated value
      acc_out <= acc_mem[index];
    end
  end

  // Task to print the contents of the accumulator
  task print_contents;
    begin
      for (i = 0; i < 4; i = i + 1) begin
        $display("Accumulator[%0d] = %0d", i, acc_mem[i]);
      end
    end
  endtask

endmodule
