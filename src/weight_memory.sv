`default_nettype none
`timescale 1ns/1ns

module weight_memory (
  input wire clk,
  input wire reset,
  input wire [12:0] addr,
  output reg [7:0] weight1,
  output reg [7:0] weight2,
  output reg [7:0] weight3,
  output reg [7:0] weight4
);
  reg [7:0] memory [0:31]; // Simple memory to store weights
  integer i;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      for (i = 0; i < 32; i++) begin
        memory[i] <= 8'b0;
      end
      weight1 <= 8'b0;
      weight2 <= 8'b0;
      weight3 <= 8'b0;
      weight4 <= 8'b0;
    end
  end

  // keep this the same --> combinational logic typically used for reading data to ensure immediate output when read is enabled. 
  always @(*) begin
    weight1 = memory[addr];
    weight2 = memory[addr + 1];
    weight3 = memory[addr + 2];
    weight4 = memory[addr + 3];
  end
endmodule
