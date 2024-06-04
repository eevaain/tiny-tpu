module unified_buffer (
  input clk,
  input reset,
  input store_acc1,
  input store_acc2,
  input [31:0] acc1_mem_0,
  input [31:0] acc1_mem_1,
  input [31:0] acc2_mem_0,
  input [31:0] acc2_mem_1,
  output reg [31:0] unified_mem_0,
  output reg [31:0] unified_mem_1,
  output reg [31:0] unified_mem_2,
  output reg [31:0] unified_mem_3
);

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      unified_mem_0 <= 0;
      unified_mem_1 <= 0;
      unified_mem_2 <= 0;
      unified_mem_3 <= 0;
    end else begin
      if (store_acc1) begin
        unified_mem_0 <= acc1_mem_0;
        unified_mem_1 <= acc1_mem_1;
        // $display("Storing acc1_data at time %t", $time);
      end
      if (store_acc2) begin
        unified_mem_2 <= acc2_mem_0;
        unified_mem_3 <= acc2_mem_1;
        // $display("Storing acc2_data at time %t", $time);
      end
    end
  end

endmodule
