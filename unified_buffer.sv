module unified_buffer (
  input clk,
  input reset,

  input store_acc1, // full flag from accumulator 1
  input store_acc2, // full flag from accumulator 2

  input [31:0] acc1_mem_0,
  input [31:0] acc1_mem_1,
  input [31:0] acc2_mem_0,
  input [31:0] acc2_mem_1,
  output reg [31:0] unified_mem [0:63]
);

  // Internal counter to keep track of the next free memory location
  reg [5:0] write_pointer;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      integer i;
      for (i = 0; i < 64; i = i + 1) begin
        unified_mem[i] <= 0;
      end
      write_pointer <= 0;
    end else begin
      if (store_acc1 && store_acc2 == 1) begin 
        if (write_pointer < 63) begin
          unified_mem[write_pointer] = acc1_mem_0;
          unified_mem[write_pointer + 1] = acc1_mem_1;
          unified_mem[write_pointer + 2] = acc2_mem_0;
          unified_mem[write_pointer + 3] = acc2_mem_1;
        end
      end
    end
  end

  // Print the accumulator inputs every clock cycle
  // always @(posedge clk) begin
  //   $display("At time %t:", $time);
  //   $display("store_acc1 = %0d, store_acc2 = %0d", store_acc1, store_acc2);
  //   $display("acc1_mem_0 = %0d, acc1_mem_1 = %0d", acc1_mem_0, acc1_mem_1);
  //   $display("acc2_mem_0 = %0d, acc2_mem_1 = %0d", acc2_mem_0, acc2_mem_1);
  // end

endmodule
