module unified_buffer (
  input clk,
  input reset,

  input store_acc1, // full flag from accumulator 1
  input store_acc2, // full flag from accumulator 2

  // should have another parameter to accept an address for write_pointer
  input [31:0] acc1_mem_0,
  input [31:0] acc1_mem_1,
  input [31:0] acc2_mem_0,
  input [31:0] acc2_mem_1,
  output reg [31:0] unified_mem [0:63] 
  // make another output to output just the input activations to the input setup module
);
  // Internal counter to keep track of the next free memory location
  reg [5:0] write_pointer;

  always @(*) begin
    if (reset) begin
      integer i;
      for (i = 0; i < 64; i = i + 1) begin
        unified_mem[i] <= 0;
      end
      write_pointer <= 0;

      // Dummy activation values
      unified_mem[16'h001E] <= 11;
      unified_mem[16'h001F] <= 12;
      unified_mem[16'h0020] <= 21;
      unified_mem[16'h0021] <= 22;

    end else if (store_acc1 && store_acc2 && write_pointer < 63) begin
        // if (write_pointer < 63) begin // changed to non blocking! probably will make performance faster? 
          unified_mem[write_pointer] <= acc1_mem_0;
          unified_mem[write_pointer + 1] <= acc1_mem_1;
          unified_mem[write_pointer + 2] <= acc2_mem_0;
          unified_mem[write_pointer + 3] <= acc2_mem_1;
        // end
    end
  end

  // Print the accumulator inputs every clock cycle
  always @(posedge clk) begin
    $display("At time %t:", $time);
    $display("store_acc1 = %0d, store_acc2 = %0d", store_acc1, store_acc2);
    $display("acc1_mem_0 = %0d, acc1_mem_1 = %0d", acc1_mem_0, acc1_mem_1);
    $display("acc2_mem_0 = %0d, acc2_mem_1 = %0d", acc2_mem_0, acc2_mem_1);
  end

endmodule
