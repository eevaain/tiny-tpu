// TODO: FIX TIMING ISSUE WITH FULL FLAGS

module accumulator (
  input clk,
  input reset,
  input valid,
  input [31:0] acc_in,

  output reg [31:0] acc_mem_0, // Output for the first memory location
  output reg [31:0] acc_mem_1, // Output for the second memory location
  output reg full // Flag to indicate when the accumulator is full
);

  // Define a register array to store multiple accumulated values
  reg [31:0] acc_mem [0:1]; // Changed to 2 entries
  reg [1:0] index; // Index to manage storage locations
  integer i; // Declare integer outside of the always block


  always @(posedge clk or posedge reset) begin
    if (reset) begin
      // Initialize all accumulated values to 0 on reset
      for (i = 0; i < 2; i = i + 1) begin
        acc_mem[i] <= 0;
      end
      index <= 0; // Reset index
      full <= 0; // Reset full flag
      acc_mem_0 <= 0;
      acc_mem_1 <= 0; 
    end 

    else if (valid && acc_in != 0) begin // This might be a cheap fix...
      // Store input value at the current index
      acc_mem[index] = acc_in;
      // Increment index to store the next value (INCREMENT ONLY HAPPENS WHEN acc_in ISN'T zero!!)
      if (index < 1) begin 
        index = index + 1;
      end else begin 
        full = 1; // Set full flag when all memory locations are filled
      end
      if (full) begin 
        acc_mem_0 = acc_mem[0]; // I feel like i should be using non-blocking assignments here???
        acc_mem_1 = acc_mem[1];
      end
    end

    
  end

  // Task to print the contents of the accumulator
  // task print_contents;
  //   begin
  //     for (i = 0; i < 2; i = i + 1) begin
  //       $display("Accumulator[%0d] = %0d", i, acc_mem[i]);
  //     end
  //   end
  // endtask

  // // Print the accumulator state every clock cycle
  always @(posedge clk) begin
    $display("At time %t:", $time);
    $display("Accumulator inputs: acc_in = %0d, valid = %0d", acc_in, valid);
    $display("Accumulator memory contents: [%0d, %0d]", acc_mem[0], acc_mem[1]);
    $display("Accumulator index: %0d, full flag: %0d", index, full);
  end

endmodule
